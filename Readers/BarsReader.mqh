//+------------------------------------------------------------------+
//|                                                   BarsReader.mqh |
//|                                                 Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_BARS_READER
#define __C_BARS_READER

#include <mql5-lib\Readers\ReaderBase.mqh>

//+------------------------------------------------------------------+
//| Bollinger Bands Reader                                           |
//+------------------------------------------------------------------+
class CBarsReader : public CReaderBase
  {
private:
public:
   //--- Constructor
                     CBarsReader(string, ENUM_TIMEFRAMES);
   //--- Destructor
                    ~CBarsReader();

   //--- Detect bars in row
   int               BarsInRow(int, int);

   //--- Resolve bar growing rate
   double              GrowingRate(int, int);
   //--- Resolve bar reduce rate
   double              ReduceRate(int, int);

   //--- Resolve if bar is bullish
   bool              Bullish(int, int);
   //--- Resolve if bar is bearish
   bool              Bearish(int, int);

   //--- Detect reversion
   bool              Reversion(int);
   //--- Resolve if is bullish reversion
   bool              ReversionBullish(int);
   //--- Resolve if is bearish reversion
   bool              ReversionBearish(int);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBarsReader::CBarsReader(string t_symbolName, ENUM_TIMEFRAMES t_timeframe)
   : CReaderBase(t_symbolName, t_timeframe)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBarsReader::~CBarsReader(void)
  {
  }
//+------------------------------------------------------------------+
//| Detect bars in row                                               |
//+------------------------------------------------------------------+
int CBarsReader::BarsInRow(int t_shift, int t_shiftMax = 99)
  {
   Print("Shift Max: ", t_shiftMax);
// test shift max
   if(t_shiftMax < 2)
     {
      return 0;
     }
//--- current shift
   int shift = 0;
// test shift arg
   if(shift == 0)
     {
      shift++;
     }
//--- bars in row counter
   int barsInRow = 0;
//--- looking for bull
   bool bull = Bar.PriceChange(shift) > 0;

   Print("PriceChange: ", Bar.PriceChange(t_shift));
//--- loop through bars
   while(shift < t_shiftMax)
     {
      //--- store current shift price change
      double currentShiftPriceChange = Bar.PriceChange(shift);
      // test if price change is same signal as first
      if((bull && currentShiftPriceChange > 0) ||
         (!bull && currentShiftPriceChange < 0))
        {
         //--- increase bars in row counter
         barsInRow++;
         //--- increase shift
         shift++;
        }
      else
        {
         //--- exit
         break;
        }
     }
//--- return
   return barsInRow;
  }
//+------------------------------------------------------------------+
//| Resolve bar growing rate                                         |
//+------------------------------------------------------------------+
double            CBarsReader::GrowingRate(int t_shiftEnd, int t_shift = 0)
  {
//--- var to store rate
   double rate = 0;
//--- need to check flag
   bool needToCheck = true;
   /*
   //--- loop through bars
   for(int shift = t_shift, shift <= t_shiftEnd; shift++)
     {
      //--- var to store current price change
      double priceChange = Bar.PriceChange(shift);
      // test if need to check
      if(needToCheck)
        {
         if(priceChange > 0 && Bar.PriceChange(shift + 1))
           {

           }
        }
     }*/
   return rate;
  }
//+------------------------------------------------------------------+
//| Resolve bar reduce rate                                          |
//+------------------------------------------------------------------+
double            CBarsReader::ReduceRate(int t_shiftEnd, int t_shift = 0)
  {
   return 0;
  }
//+------------------------------------------------------------------+
//| Resolve if bar is bullish                                        |
//+------------------------------------------------------------------+
bool              CBarsReader::Bullish(int t_shiftEnd, int t_shift = 0)
  {
   /*for(int shift = t_shift, shift <= t_shiftEnd; shift++)
     {
      Bar.PriceChange(shift);
     }
   */
   return Bar.Close(t_shift) > Bar.Open(t_shift);
  }
//+------------------------------------------------------------------+
//| Resolve if bar is bearish                                        |
//+------------------------------------------------------------------+
bool              CBarsReader::Bearish(int t_shiftEnd, int t_shift = 0)
  {
//--- test if is bullish
   return Bar.Close(t_shift) < Bar.Open(t_shift);
  }
//+------------------------------------------------------------------+
//| Detect reversion                                                 |
//+------------------------------------------------------------------+
bool              CBarsReader::Reversion(int t_shift)
  {
//--- check for reversion
   return ReversionBullish(t_shift) || ReversionBearish(t_shift);
  }
//+------------------------------------------------------------------+
//| Resolve if is bullish reversion                                  |
//+------------------------------------------------------------------+
bool              CBarsReader::ReversionBullish(int t_shift)
  {
//--- check for bullish reversion
   return Bearish(t_shift + 1) && Bullish(t_shift);
  }
//+------------------------------------------------------------------+
//| Resolve if is bearish reversion                                  |
//+------------------------------------------------------------------+
bool              CBarsReader::ReversionBearish(int t_shift)
  {
//--- check for bearish reversion
   return Bullish(t_shift + 1) && Bearish(t_shift);
  }
#endif
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
