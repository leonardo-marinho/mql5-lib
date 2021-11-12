//+------------------------------------------------------------------+
//|                                                          Bar.mqh |
//|                                                 Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_BAR
#define __C_BAR

#include <Object.mqh>

//+------------------------------------------------------------------+
//| Bollinger Bands Reader                                           |
//+------------------------------------------------------------------+
class CBar : public CObject
  {
private:
   //--- Timeframe
   ENUM_TIMEFRAMES   m_timeframe;

   //--- Symbol name
   string            m_symbolName;

public:
   //--- Constructor
                     CBar(string, ENUM_TIMEFRAMES);
   //--- Destructor
                    ~CBar();

   //--- Get id
   int               Id(int);

   //--- Get close value
   double            Close(int);
   //--- Get high value
   double            High(int);
   //--- Get low value
   double            Low(int);
   //--- Get open value
   double            Open(int);

   //--- Get price change
   double            PriceChange(int);

   //--- Get volume
   long              Volume(int);
   //--- Get tick volume
   long              TickVolume(int);
   //--- Get real volume
   long              RealVolume(int);

   //--- Get spread
   long              Spread(int);

   //--- Get time
   datetime          Time(int);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBar::CBar(string t_symbolName, ENUM_TIMEFRAMES t_timeframe)
   : m_symbolName(t_symbolName),
     m_timeframe(t_timeframe)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBar::~CBar(void)
  {
  }

//+------------------------------------------------------------------+
//| Get id                                                           |
//+------------------------------------------------------------------+
int              CBar::Id(int t_shift)
  {
   return iBars(m_symbolName, m_timeframe) - t_shift;
  }
//+------------------------------------------------------------------+
//| Get close value                                                  |
//+------------------------------------------------------------------+
double            CBar::Close(int t_shift)
  {
//--- return close value
   return iClose(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get high value                                                   |
//+------------------------------------------------------------------+
double            CBar::High(int t_shift)
  {
//--- return high value
   return iHigh(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get low value                                                    |
//+------------------------------------------------------------------+
double            CBar::Low(int t_shift)
  {
//--- return low value
   return iLow(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get open value                                                   |
//+------------------------------------------------------------------+
double            CBar::Open(int t_shift)
  {
//--- return open value
   return iOpen(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get price change                                                 |
//+------------------------------------------------------------------+
double            CBar::PriceChange(int t_shift)
  {
//--- calculate price change
   return Close(t_shift) - Open(t_shift);
  }
//+------------------------------------------------------------------+
//| Get volume                                                       |
//+------------------------------------------------------------------+
long              CBar::Volume(int t_shift)
  {
//--- return volume value
   return iVolume(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get tick volume                                                  |
//+------------------------------------------------------------------+
long              CBar::TickVolume(int t_shift)
  {
//--- return tick volume value
   return iTickVolume(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get real volume                                                  |
//+------------------------------------------------------------------+
long              CBar::RealVolume(int t_shift)
  {
//--- return real volume value
   return iRealVolume(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get spread                                                       |
//+------------------------------------------------------------------+
long              CBar::Spread(int t_shift)
  {
//--- return spread value
   return iSpread(m_symbolName, m_timeframe, t_shift);
  }
//+------------------------------------------------------------------+
//| Get time                                                         |
//+------------------------------------------------------------------+
datetime          CBar::Time(int t_shift)
  {
//--- return open time
   return iTime(m_symbolName, m_timeframe, t_shift);
  }
#endif
//+------------------------------------------------------------------+
