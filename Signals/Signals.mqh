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
//+------------------------------------------------------------------+
//| Solution types                                                   |
//+------------------------------------------------------------------+
enum ENUM_SIGNALS_SOLUTION_TYPE
{
  SOLUTION_DISABLED,
  SOLUTION_OPEN_LONG,
  SOLUTION_OPEN_SHORT,
  SOLUTION_CLOSE_LONG,
  SOLUTION_CLOSE_SHORT,
  SOLUTION_CLOSE,
  SOLUTION_GLOBAL
};
//+------------------------------------------------------------------+
//| A signals solution struct                                        |
//+------------------------------------------------------------------+
class CSignalsSolution : public CObject
{
public:
  //--- signals
  CArrayObj *signals;
  //--- inverted logic solution
  bool inverted;

  CSignalsSolution()
      : signals(new CArrayObj),
        inverted(false)
  {
  }

  ~CSignalsSolution()
  {
    delete signals;
  }
};
//+------------------------------------------------------------------+
//| A many signal manager class                                      |
//+------------------------------------------------------------------+
class CSignals : public CRoutine
{
protected:
  //--- signal array
  CArrayObj *m_signals;

  //---- solutions array
  CArrayObj *m_solutions_global;
  CArrayObj *m_solutions_open_long;
  CArrayObj *m_solutions_open_short;
  CArrayObj *m_solutions_close_long;
  CArrayObj *m_solutions_close_short;
  CArrayObj *m_solutions_close;

  //--- method to test solutions
  bool TestSolutions(CArrayObj *, bool);

public:
  CSignals(void);
  ~CSignals(void);

  //--- methods to access members
  void RegisterSignal(CSignal *);
  void RegisterSolution(CSignalsSolution *, ENUM_SIGNALS_SOLUTION_TYPE);

  //--- routine methods
  virtual bool Init(void);
  virtual bool Deinit(void);
  virtual bool Tick(void);

  //--- methods to open/close positions
  virtual bool GetOrderParameters(COrderParameters &t_parameters) { return true; }
  virtual bool CheckGlobal(void);
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
    : m_signals(new CArrayObj),
      m_solutions_global(new CArrayObj),
      m_solutions_open_long(new CArrayObj),
      m_solutions_open_short(new CArrayObj),
      m_solutions_close_long(new CArrayObj),
      m_solutions_close_short(new CArrayObj),
      m_solutions_close(new CArrayObj)
{
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignals::~CSignals(void)
{
  delete m_signals;
  delete m_solutions_global;
  delete m_solutions_open_long;
  delete m_solutions_open_short;
  delete m_solutions_close_long;
  delete m_solutions_close_short;
  delete m_solutions_close;
}
//+------------------------------------------------------------------+
//| Method to test solutions                                         |
//+------------------------------------------------------------------+
bool CSignals::TestSolutions(CArrayObj *t_solutions, bool t_or = false)
{
  int total_solutions = t_solutions.Total();
  for (int index = 0; index < total_solutions; index++)
  {
    CSignalsSolution *solution = t_solutions.At(index);
    bool state = !solution.inverted;
    int total_signals = solution.signals.Total();
    for (int signal_index = 0; signal_index < total_signals; signal_index++)
    {
      CSignal *signal = solution.signals.At(signal_index);
      state = signal.CheckConditional();
      if (state != !solution.inverted && !t_or)
        break;
    }
    if (state == !solution.inverted)
      return true;
  }
  return false;
}
//+------------------------------------------------------------------+
//| Method to register signal to have its routines called            |
//+------------------------------------------------------------------+
void CSignals::RegisterSignal(CSignal *t_signal)
{
  m_signals.Add(t_signal);
}
//+------------------------------------------------------------------+
//| Method to push solution to solution array                        |
//+------------------------------------------------------------------+
void CSignals::RegisterSolution(CSignalsSolution *t_solution, ENUM_SIGNALS_SOLUTION_TYPE t_type)
{
  if (t_type == SOLUTION_GLOBAL)
    m_solutions_global.Add(t_solution);
  else if (t_type == SOLUTION_OPEN_LONG)
    m_solutions_open_long.Add(t_solution);
  else if (t_type == SOLUTION_OPEN_SHORT)
    m_solutions_open_short.Add(t_solution);
  else if (t_type == SOLUTION_CLOSE_LONG)
    m_solutions_close_long.Add(t_solution);
  else if (t_type == SOLUTION_CLOSE_SHORT)
    m_solutions_close_short.Add(t_solution);
  else if (t_type == SOLUTION_CLOSE)
    m_solutions_close.Add(t_solution);
}
//+------------------------------------------------------------------+
//| Init routine                                                     |
//+------------------------------------------------------------------+
bool CSignals::Init(void)
{
  bool return_state = true;
  for (int index = 0; index < m_signals.Total(); index++)
  {
    CSignal *signal = m_signals.At(index);
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
  for (int index = 0; index < m_signals.Total(); index++)
  {
    CSignal *signal = m_signals.At(index);
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
  for (int index = 0; index < m_signals.Total(); index++)
  {
    CSignal *signal = m_signals.At(index);
    return_state = return_state && signal.Deinit();
  }
  return return_state;
}
//+------------------------------------------------------------------+
//| Check global conditionals                                        |
//+------------------------------------------------------------------+
bool CSignals::CheckGlobal(void)
{
  if (m_solutions_global.Total() == 0)
    return true;
  return TestSolutions(m_solutions_global);
}
//+------------------------------------------------------------------+
//| Check long open conditionals                                     |
//+------------------------------------------------------------------+
bool CSignals::CheckOpenLong(void)
{
  if (m_solutions_open_long.Total() == 0)
    return false;
  return TestSolutions(m_solutions_open_long);
}
//+------------------------------------------------------------------+
//| Check short open conditionals                                    |
//+------------------------------------------------------------------+
bool CSignals::CheckOpenShort(void)
{
  if (m_solutions_open_short.Total() == 0)
    return false;
  return TestSolutions(m_solutions_open_short);
}
//+------------------------------------------------------------------+
//| Check long close conditionals                                    |
//+------------------------------------------------------------------+
bool CSignals::CheckCloseLong(void)
{
  if (m_solutions_close_long.Total() == 0)
    return false;
  return TestSolutions(m_solutions_close_long, true);
}
//+------------------------------------------------------------------+
//| Check short close conditionals                                   |
//+------------------------------------------------------------------+
bool CSignals::CheckCloseShort(void)
{
  if (m_solutions_close_short.Total() == 0)
    return false;
  return TestSolutions(m_solutions_close_short, true);
}
//+------------------------------------------------------------------+
//| Check general close conditionals                                 |
//+------------------------------------------------------------------+
bool CSignals::CheckClose(void)
{
  if (m_solutions_close.Total() == 0)
    return false;
  return TestSolutions(m_solutions_close, true);
}
#endif
//+------------------------------------------------------------------+
