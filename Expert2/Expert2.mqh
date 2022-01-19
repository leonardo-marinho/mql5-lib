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
   int m_magic_number;
   //--- symbol name
   string m_symbol_name;
   //--- array of signals
   CSignals *m_signals;
   //---- trader
   CTrader *m_trader;

protected:
   //--- methods to manage position
   virtual bool CheckGlobalConditions(void);
   virtual void CheckOpenConditions(void);
   virtual void CheckCloseConditions(void);

public:
   CExpert2(int, string, ENUM_TIMEFRAMES);
   ~CExpert2(void);

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
CExpert2::CExpert2(int t_magic_number, string t_symbol_name, ENUM_TIMEFRAMES t_timeframe)
    : m_magic_number(t_magic_number),
      m_symbol_name(t_symbol_name),
      m_signals(new CSignals),
      m_trader(new CTrader(t_magic_number, m_symbol_name, t_timeframe))
{
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpert2::~CExpert2(void)
{
   delete m_signals;
   delete m_trader;
}
//+------------------------------------------------------------------+
//| Method to check global conditions                                |
//+------------------------------------------------------------------+
bool CExpert2::CheckGlobalConditions(void)
{
   return m_signals.CheckGlobal();
}
//+------------------------------------------------------------------+
//| Method to open position                                          |
//+------------------------------------------------------------------+
void CExpert2::CheckOpenConditions(void)
{
   COrderParameters order_parameters;
   m_signals.GetOrderParameters(order_parameters);

   if (m_signals.CheckOpenLong())
      m_trader.SendOrder(0, order_parameters);
   else if (m_signals.CheckOpenShort())
      m_trader.SendOrder(1, order_parameters);
}
//+------------------------------------------------------------------+
//| Method to close position                                         |
//+------------------------------------------------------------------+
void CExpert2::CheckCloseConditions(void)
{

   if (m_signals.CheckClose() || m_signals.CheckCloseLong() || m_signals.CheckCloseShort())
   {
      m_trader.CloseAllPositions();
   }
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
   return m_trader.Init() && m_signals.Init();
}
//+------------------------------------------------------------------+
//| Tick routine                                                     |
//+------------------------------------------------------------------+
bool CExpert2::Tick()
{
   if (!m_trader.Tick())
      return false;
   bool return_state = true;
   return_state = m_signals.Tick();

   if (PositionsTotal() > 0)
      CheckCloseConditions();

   if (PositionsTotal() == 0)
      if (CheckGlobalConditions())
         CheckOpenConditions();
   return return_state;
}
//+------------------------------------------------------------------+
//| Deinit routine                                                     |
//+------------------------------------------------------------------+
bool CExpert2::Deinit()
{
   return m_trader.Deinit() && m_signals.Deinit();
}
#endif