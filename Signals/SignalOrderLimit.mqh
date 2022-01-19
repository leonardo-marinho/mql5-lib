//+------------------------------------------------------------------+
//|                                             SignalOrderLimit.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL_ORDER_LIMIT__
#define __C__SIGNAL_ORDER_LIMIT__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Signals/Signal.mqh>
//+------------------------------------------------------------------+
//| A signal based on a given limit to peding orders                 |
//+------------------------------------------------------------------+
class CSignalOrderLimit : public CSignal
{
protected:
  //--- limit of orders volume
  double m_limit_orders_volume;

public:
  CSignalOrderLimit(double);
  //--- method to write condition
  virtual bool CheckConditional(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalOrderLimit::CSignalOrderLimit(double t_limit_orders_volume)
    : m_limit_orders_volume(t_limit_orders_volume)
{
}
//+------------------------------------------------------------------+
//| Conditional to be tested                                         |
//+------------------------------------------------------------------+
bool CSignalOrderLimit::CheckConditional()
{
  return OrdersTotal() < m_limit_orders_volume;
}
#endif
//+------------------------------------------------------------------+