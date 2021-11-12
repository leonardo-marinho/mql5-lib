//+------------------------------------------------------------------+
//|                                                  BandsReader.mqh |
//|                                                 Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_BANDS_READER
#define __C_BANDS_READER

#include <Indicators\Trend.mqh>
#include <mql5-lib\Readers\Reader.mqh>

//+------------------------------------------------------------------+
//| Bollinger Bands Reader                                           |
//+------------------------------------------------------------------+
class CBandsReader : public CReader<CiBands>
  {
public:
   //--- Constructor
                     CBandsReader(string, ENUM_TIMEFRAMES);
   //--- Destructor
                    ~CBandsReader();

   //--- Resolve if crossed base line
   bool              Crossed(int);
   //--- Resolve if is bullish cross
   bool              CrossBullish(int);
   //--- Resolve if is bearish cross
   bool              CrossBearish(int);

   //--- Check if bar is overbought
   bool              Overbought(int);
   //--- Check if bar is oversold
   bool              Oversold(int);
   //--- Get close position in bands
   double            Position(int);

   //--- Check if bar base line
   bool              TouchedBase(int);
   //--- Check if bar lower line
   bool              TouchedExtremeLower(int);
   //--- Check if bar upper line
   bool              TouchedExtremeUpper(int);

   //--- Total spread
   double            Width(int);
   //--- Lower spread
   double            WidthLower(int);
   //--- Upper spread
   double            WidthUpper(int);

   //--- Zone lower
   double            ZoneLower(int);
   //--- Zone Upper
   double            ZoneUpper(int);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBandsReader::CBandsReader(string t_symbolName, ENUM_TIMEFRAMES t_timeframe)
   : CReader(t_symbolName, t_timeframe)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBandsReader::~CBandsReader(void)
  {
  }
//+------------------------------------------------------------------+
//| Resolve if crossed base line                                     |
//+------------------------------------------------------------------+
bool              CBandsReader::Crossed(int t_index)
  {
//--- test if crossed
   return CrossBullish(t_index) || CrossBearish(t_index);
  }
//+------------------------------------------------------------------+
//| Resolve if is bullish cross                                      |
//+------------------------------------------------------------------+
bool              CBandsReader::CrossBullish(int t_index)
  {
   return Bar.Open(t_index) != Bar.Close(t_index) &&
          Bar.Open(t_index) < m_indicator.Base(t_index) &&
          Bar.Close(t_index) > m_indicator.Base(t_index);
  }
//+------------------------------------------------------------------+
//| Resolve if is bearish cross                                      |
//+------------------------------------------------------------------+
bool              CBandsReader::CrossBearish(int t_index)
  {
   return Bar.Open(t_index) != Bar.Close(t_index) &&
          Bar.Open(t_index) > m_indicator.Base(t_index) &&
          Bar.Close(t_index) < m_indicator.Base(t_index);
  }
//+------------------------------------------------------------------+
//| Check if bar is overbought                                       |
//+------------------------------------------------------------------+
bool CBandsReader::Overbought(int t_index)
  {
//--- test if is overbought
   return Bar.Close(t_index) > m_indicator.Upper(t_index);
  }
//+------------------------------------------------------------------+
//| Check if bar is oversold                                         |
//+------------------------------------------------------------------+
bool CBandsReader::Oversold(int t_index)
  {
//--- test if is oversold
   return Bar.Close(t_index) < m_indicator.Lower(t_index);
  }
//+------------------------------------------------------------------+
//| Get close position in bands                                      |
//+------------------------------------------------------------------+
double CBandsReader::Position(int t_index)
  {
//--- var to store position
   double position = 0;
//--- test if position is lower zone
   if(ZoneLower(t_index))
      //--- calculate position
      position = -(m_indicator.Base(t_index) - Bar.Close(t_index)) / WidthLower(t_index);
//--- test if position is upper zone
   if(ZoneUpper(t_index))
      //--- calculate position
      position = (Bar.Close(t_index) - m_indicator.Base(t_index)) / WidthUpper(t_index);
//--- return position
   return position;
  }
//+------------------------------------------------------------------+
//| Check if bar base line                                           |
//+------------------------------------------------------------------+
bool              CBandsReader::TouchedBase(int t_index)
  {
   return (Bar.Open(t_index) < m_indicator.Base(t_index) && Bar.High(t_index) > m_indicator.Base(t_index)) ||
          (Bar.Open(t_index) > m_indicator.Base(t_index) && Bar.Low(t_index) < m_indicator.Base(t_index));
  }
//--- Check if bar lower line
bool              CBandsReader::TouchedExtremeLower(int t_index)
  {
   return (Bar.Open(t_index) < m_indicator.Lower(t_index) && Bar.High(t_index) > m_indicator.Lower(t_index)) ||
          (Bar.Open(t_index) > m_indicator.Lower(t_index) && Bar.Low(t_index) < m_indicator.Lower(t_index));
  }
//--- Check if bar upper line
bool              CBandsReader::TouchedExtremeUpper(int t_index)
  {
   return (Bar.Open(t_index) < m_indicator.Upper(t_index) && Bar.High(t_index) > m_indicator.Upper(t_index)) ||
          (Bar.Open(t_index) > m_indicator.Upper(t_index) && Bar.Low(t_index) < m_indicator.Upper(t_index));
  }
//+------------------------------------------------------------------+
//| Total spread                                                     |
//+------------------------------------------------------------------+
double CBandsReader::Width(int t_index)
  {
//--- calculate total spread
   return m_indicator.Upper(t_index) - m_indicator.Lower(t_index);
  }
//+------------------------------------------------------------------+
//| Lower spread                                                     |
//+------------------------------------------------------------------+
double CBandsReader::WidthLower(int t_index)
  {
//--- calculate lower spread
   return m_indicator.Base(t_index) - m_indicator.Lower(t_index);
  }
//+------------------------------------------------------------------+
//| Upper spread                                                     |
//+------------------------------------------------------------------+
double CBandsReader::WidthUpper(int t_index)
  {
//--- calculate upper spread
   return m_indicator.Upper(t_index) - m_indicator.Base(t_index);
  }
//+------------------------------------------------------------------+
//| Zone lower                                                       |
//+------------------------------------------------------------------+
double CBandsReader::ZoneLower(int t_index)
  {
//--- resolve if is lower zone
   return Bar.Close(t_index) < m_indicator.Base(t_index);
  }
//+------------------------------------------------------------------+
//| Zone upper                                                       |
//+------------------------------------------------------------------+
double CBandsReader::ZoneUpper(int t_index)
  {
//--- resolve if is upper zone
   return Bar.Close(t_index) > m_indicator.Base(t_index);
  }
#endif
//+------------------------------------------------------------------+
