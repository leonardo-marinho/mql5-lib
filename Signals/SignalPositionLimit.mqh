//+------------------------------------------------------------------+
//|                                          SignalPositionLimit.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL_POSITION_LIMIT__
#define __C__SIGNAL_POSITION_LIMIT__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Signals/Signal.mqh>
//+------------------------------------------------------------------+
//| A signal based on a given limit to peding positions              |
//+------------------------------------------------------------------+
class CSignalPositionLimit : public CSignal
{
protected:
  //--- limit of positions volume
  double m_limit_positions_volume;

public:
  CSignalPositionLimit(double);
  //--- method to write condition
  virtual bool CheckConditional(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalPositionLimit::CSignalPositionLimit(double t_limit_positions_volume)
    : m_limit_positions_volume(t_limit_positions_volume)
{
}
//+------------------------------------------------------------------+
//| Conditional to be tested                                         |
//+------------------------------------------------------------------+
bool CSignalPositionLimit::CheckConditional()
{
  return PositionsTotal() < m_limit_positions_volume;
}
#endif
//+------------------------------------------------------------------+