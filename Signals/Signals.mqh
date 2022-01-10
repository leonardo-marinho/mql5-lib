//+------------------------------------------------------------------+
//|                                                      Signals.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNALS__
#define __C__SIGNALS__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Signals/Signal.mqh>
#include <mql5-lib/Trader/OrderParameters.mqh>
//+------------------------------------------------------------------+
//| Constants                                                        |
//+------------------------------------------------------------------+
#define C_SIGNALS_EVENT_ONCONDITIONOPENMET "onConditionOpenMet"
#define C_SIGNALS_EVENT_ONCONDITIONOPENLONGMET "onConditionOpenLongMet"
#define C_SIGNALS_EVENT_ONCONDITIONOPENSHORTMET "onConditionOpenShortMet"
#define C_SIGNALS_EVENT_ONCONDITIONCLOSEMET "onConditionCloseMet"
//+------------------------------------------------------------------+
//| A many signal manager class                                      |
//+------------------------------------------------------------------+
class CSignals : public CSignal
{
protected:
  //--- Array of signal
  CArrayObj *m_signal_array;

public:
  CSignals(void);
  ~CSignals(void);

  //--- methods to access members
  CArrayObj *Signals(void);
  bool Signals(CArrayObj *);
  virtual CSymbolInfo *SymbolInfo();
  virtual bool SymbolInfo(CSymbolInfo *);

  //--- routine methods
  virtual bool Init(void);
  virtual bool Deinit(void);
  virtual bool Tick(void);

  //--- methods to open/close positions
  virtual COrderParameters GetOrderParameters(void) { return COrderParameters; };
  virtual bool CheckOpenLong(void);
  virtual bool CheckOpenShort(void);
  virtual bool CheckCloseLong(void);
  virtual bool CheckCloseShort(void);
  virtual bool CheckClose(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignals::CSignals(void)
    : m_signal_array(new CArrayObj)
{
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignals::~CSignals(void)
{
  delete m_signal_array;
}
//+------------------------------------------------------------------+
//| Access signal array                                              |
//+------------------------------------------------------------------+
CArrayObj *CSignals::Signals(void)
{
  return m_signal_array;
}
//+------------------------------------------------------------------+
//| Set signal array                                                 |
//+------------------------------------------------------------------+
bool CSignals::Signals(CArrayObj *t_signal_array)
{
  m_signal_array = t_signal_array;
  return m_signal_array != NULL;
}
//+------------------------------------------------------------------+
//| Access symbol info                                               |
//+------------------------------------------------------------------+
CSymbolInfo *CSignals::SymbolInfo(void)
{
  return m_symbol_info;
}
//+------------------------------------------------------------------+
//| Set symbol info                                                  |
//+------------------------------------------------------------------+
bool CSignals::SymbolInfo(CSymbolInfo *t_symbol_info)
{
  m_symbol_info = t_symbol_info;
  bool return_state = true;
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    return_state = return_state && signal.SymbolInfo(m_symbol_info);
  }
  return m_symbol_info != NULL && return_state;
}
//+------------------------------------------------------------------+
//| Init routine                                                     |
//+------------------------------------------------------------------+
bool CSignals::Init(void)
{
  bool return_state = true;
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    return_state = return_state && signal.Init();
  }
  return return_state;
}
//+------------------------------------------------------------------+
//| Tick routine                                                     |
//+------------------------------------------------------------------+
bool CSignals::Tick(void)
{
  bool return_state = true;
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    return_state = return_state && signal.Tick();
  }
  return return_state;
}
//+------------------------------------------------------------------+
//| Deinit routine                                                   |
//+------------------------------------------------------------------+
bool CSignals::Deinit(void)
{
  bool return_state = true;
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    return_state = return_state && signal.Deinit();
  }
  return return_state;
}
//+------------------------------------------------------------------+
//| Check long open conditionals                                     |
//+------------------------------------------------------------------+
bool CSignals::CheckOpenLong(void)
{
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    if (!signal.CheckOpenLong())
      return false;
  }
  return true;
}
//+------------------------------------------------------------------+
//| Check short open conditionals                                    |
//+------------------------------------------------------------------+
bool CSignals::CheckOpenShort(void)
{
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    if (!signal.CheckOpenShort())
      return false;
  }
  return true;
}
//+------------------------------------------------------------------+
//| Check long close conditionals                                    |
//+------------------------------------------------------------------+
bool CSignals::CheckCloseLong(void)
{
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    if (signal.CheckCloseLong())
      return true;
  }
  return false;
}
//+------------------------------------------------------------------+
//| Check short close conditionals                                   |
//+------------------------------------------------------------------+
bool CSignals::CheckCloseShort(void)
{
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    if (signal.CheckCloseShort())
      return true;
  }
  return false;
}
//+------------------------------------------------------------------+
//| Check general close conditionals                                 |
//+------------------------------------------------------------------+
bool CSignals::CheckClose(void)
{
  for (int index = 0; m_signal_array.Total(); index++)
  {
    CSignal signal = m_signal_array.At(index);
    if (signal.CheckClose())
      return true;
  }
  return false;
}
#endif
//+------------------------------------------------------------------+
