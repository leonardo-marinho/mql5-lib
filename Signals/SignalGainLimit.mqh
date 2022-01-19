//+------------------------------------------------------------------+
//|                                              SignalGainLimit.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL_GAIN_LIMIT__
#define __C__SIGNAL_GAIN_LIMIT__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Signals/Signal.mqh>
//+------------------------------------------------------------------+
//| A signal based on a given limit to peding gains              |
//+------------------------------------------------------------------+
class CSignalGainLimit : public CSignal
{
protected:
  //--- magic number
  int m_magic_number;
  //--- symbol name
  string m_symbol_name;
  //--- last deal count
  int m_deals_counter;

public:
  CSignalGainLimit(int, string);

  //--- routine methods
  bool Init(void);
  bool Tick(void);

  //--- method to write condition
  virtual bool CheckConditional(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalGainLimit::CSignalGainLimit(int t_magic_number, string t_symbol_name)
    : m_magic_number(t_magic_number),
      m_symbol_name(t_symbol_name),
      m_deals_counter(0)
{
}
//+------------------------------------------------------------------+
//| Tick routine                                                     |
//+------------------------------------------------------------------+
bool CSignalGainLimit::Tick()
{
  total
  if (m_deals_counter 
  return true;
}
//+------------------------------------------------------------------+
//| Conditional to be tested                                         |
//+------------------------------------------------------------------+
bool CSignalGainLimit::CheckConditional()
{
  double gain = CalculateGain();
  return gain > m_sl && gain < m_tp;
}
#endif
//+------------------------------------------------------------------+