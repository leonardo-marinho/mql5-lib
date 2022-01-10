//+------------------------------------------------------------------+
//|                                                      Expert2.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__EXPERT2__
#define __C__EXPERT2__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Routine.mqh>
#include <mql5-lib/Signals/Signals.mqh>
#include <mql5-lib/Trader/Trader.mqh>
//+------------------------------------------------------------------+
//| A specialized class send positions triggered by signals          |
//+------------------------------------------------------------------+
class CExpert2 : public CRoutine
{
private:
   //--- array of signals
   CSignals *m_signals;
   //---- trader
   CTrader *m_trader;

protected:
   //--- methods to manage position
   virtual void OpenPosition(void);
   virtual void ClosePosition(void);

public:
   CExpert2();
   ~CExpert2();

   //--- methods to access members
   bool Signals(CSignals *);
   CSignals *Signals();
   bool Trader(CTrader *);
   CTrader *Trader();

   //--- routine methods
   virtual bool Init(void);
   virtual bool Deinit(void);
   virtual bool Tick(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpert2::CExpert2(int t_magic_number)
    : m_signals(new CSignals),
      m_trader(new CTrader(t_magic_number))
{
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpert2::~CExpert2()
{
   delete m_signals;
   delete m_trader;
}
//+------------------------------------------------------------------+
//| Method to open position                                          |
//+------------------------------------------------------------------+
void CExpert2::OpenPosition(void)
{
   if (m_signals.CheckOpenLong())
      m_trader.OpenLong(m_signals.GetOrderParameters());
   else if (m_signals.CheckOpenShort())
      m_trader.OpenShort(m_signals.GetOrderParameters());
}
//+------------------------------------------------------------------+
//| Method to close position                                         |
//+------------------------------------------------------------------+
void CExpert2::ClosePosition(void)
{
   if (m_signals.CheckClose() || m_signals.CheckCloseLong() || m_signals.CheckCloseShort())
      m_trader.Close();
}
//+------------------------------------------------------------------+
//| Access signals                                                   |
//+------------------------------------------------------------------+
CSignals *CExpert2::Signals(void)
{
   return m_signals;
}
//+------------------------------------------------------------------+
//| Set signals                                                      |
//+------------------------------------------------------------------+
bool CExpert2::Signals(CSignals *t_signals)
{
   m_signals = t_signals;
   return m_signals != NULL;
}
//+------------------------------------------------------------------+
//| Access trader                                                    |
//+------------------------------------------------------------------+
CTrader *CExpert2::Trader(void)
{
   return m_trader;
}
//+------------------------------------------------------------------+
//| Set trader                                                       |
//+------------------------------------------------------------------+
bool CExpert2::Trader(CTrader *t_trader)
{
   m_trader = t_trader;
   return m_trader != NULL;
}
//+------------------------------------------------------------------+
//| Init routine                                                     |
//+------------------------------------------------------------------+
bool CExpert2::Init()
{
   return m_signals.Init();
}
//+------------------------------------------------------------------+
//| Tick routine                                                     |
//+------------------------------------------------------------------+
bool CExpert2::Tick()
{
   bool return_state = true;
   return_state = m_signals.Tick();
   ClosePosition();
   OpenPosition();
   return return_state;
}
//+------------------------------------------------------------------+
//| Deinit routine                                                     |
//+------------------------------------------------------------------+
bool CExpert2::Deinit()
{
   return m_signals.Deinit();
}
#endif