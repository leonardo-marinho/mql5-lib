//--- file define
#ifndef __C__EXPERT__
#define __C__EXPERT__
//--- file includes
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Expert2/ExpertBase.mqh>
#include <mql5-lib/Expert2/ExpertCalendar.mqh>
#include <mql5-lib/Expert2/ExpertSignal.mqh>
#include <mql5-lib/Expert2/ExpertTrader.mqh>
#include <mql5-lib/Expert2/OrderParameters.mqh>

//--- timer periods
enum EExpertStates
{
   EXPERT_ERROR_INIT,
   EXPERT_ERROR_DEINIT,
   EXPERT_ERROR_TICK,
   EXPERT_ERROR_TIMER,
};

//--- expert class
class CExpert : public CExpertBase
{
private:
   //--- expert calendar instance pointer
   CExpertCalendar *m_expert_calendar;
   //--- array of signal instance pointers
   CArrayObj *m_expert_signals;
   //--- expert trader instance pointers
   CExpertTrader *m_expert_trader;

protected:
   //--- access expert calendar instance pointer
   CExpertCalendar *Calendar();
   //--- access array of expert signal instance pointers
   CArrayObj *Signals();
   //--- access expert trader instance pointer
   CExpertTrader *Trader();

   //--- test signal conditions
   bool TestSignalConditions(CExpertSignal *);

public:
   //--- constructor
   CExpert(void);
   //--- destructor
   ~CExpert(void);

   //--- init routine
   bool Init(void);
   //--- init routine
   bool DeInit(void);
   //--- tick routine
   bool Tick(void);
   //--- timer routine
   bool Timer(void);

   //--- set expert calendar instance pointer
   bool Calendar(CExpertCalendar *);
   //--- set events instance pointer
   bool Events(CEvents *);
   //--- set expert signals element instance pointer
   bool Signals(CExpertSignal *);
   //--- set expert trader instance pointer
   bool Trader(CExpertTrader *);
   //--- set symbol info instance pointer
   bool SymbolInfo(CSymbolInfo *);
};

CExpert::CExpert()
    : m_expert_calendar(NULL),
      m_expert_signals(new CArrayObj()),
      m_expert_trader(NULL)
{
}

CExpert::~CExpert()
{
   delete m_expert_calendar;
   delete m_expert_signals;
   delete m_expert_trader;
}

bool CExpert::TestSignalConditions(CExpertSignal *t_signal)
{
   if (t_signal.LongCloseConditional() || t_signal.LongCloseConditional() || t_signal.ShortCloseConditional())
   {
      Trader().Close();
   }
   if (t_signal.LongOpenConditional())
   {
      Trader().OpenLong();
   }
   else if (t_signal.ShortOpenConditional())
   {
      Trader().OpenShort();
   }
   return true;
}

CExpertCalendar *CExpert::Calendar()
{
   return m_expert_calendar;
}

CArrayObj *CExpert::Signals()
{
   return m_expert_signals;
}

CExpertTrader *CExpert::Trader()
{
   return m_expert_trader;
}

bool CExpert::Init()
{
   //--- set symbol info
   if (!InitSymbolInfo())
      return false;
   //--- set timeframe
   m_timeframe = _Period;
   //--- init expert calendar and trader
   if (!Calendar().Init() || !Trader().Init())
   {
      State().state(EXPERT_ERROR_INIT);
      return false;
   }
   //--- init expert signals
   CArrayObj *signals = Signals();
   if (signals.Total() == 0)
   {
      Print("No signals added. Trader will never be triggered");
   }
   for (int index = 0; index < signals.Total(); index++)
   {
      CExpertSignal *signal = signals.At(index);
      if (!signal.Init())
      {
         State().state(EXPERT_ERROR_INIT);
         return false;
      }
   }
   //--- operation succeed
   return true;
}

bool CExpert::DeInit()
{
   //--- deinit expert calendar and trader
   if (!Calendar().DeInit() || !Trader().DeInit())
   {
      State().state(EXPERT_ERROR_DEINIT);
      return false;
   }
   //--- deinit expert signals
   CArrayObj *signals = Signals();
   for (int index = 0; index < signals.Total(); index++)
   {
      CExpertSignal *signal = signals.At(index);
      if (!signal.DeInit())
      {
         State().state(EXPERT_ERROR_DEINIT);
         return false;
      }
   }
   //--- operation succeed
   return true;
}

bool CExpert::Tick()
{
   //--- refresh symbol info
   // SymbolInfo().RefreshRates();
   //--- tick expert calendar and trader
   if (!Calendar().Tick() || !Trader().Tick())
   {
      State().state(EXPERT_ERROR_TICK);
      return false;
   }
   //--- tick expert signals
   CArrayObj *signals = Signals();
   for (int index = 0; index < signals.Total(); index++)
   {
      CExpertSignal *signal = signals.At(index);
      if (!signal.Tick())
      {
         State().state(EXPERT_ERROR_TICK);
         return false;
      }
      TestSignalConditions(signal);
   }
   //--- clear events queue
   Events().ClearAll();
   //--- operation succeed
   return true;
}

bool CExpert::Timer()
{
   //--- timer expert calendar
   if (!Calendar().Timer())
   {
      Events().Emit(CEXPERT_BASE_EVENT_ONERROR);
      return false;
   }
   // emit event
   Events().Emit(CEXPERT_BASE_EVENT_ONTIMER);
   //--- operation succeed
   return true;
}

bool CExpert::Calendar(CExpertCalendar *t_expert_calendar)
{
   m_expert_calendar = t_expert_calendar;
   return m_expert_calendar != NULL;
}

bool CExpert::Events(CEvents *t_events)
{
   //--- set expert calendar and trader event instance
   if (!Calendar().Events(t_events) || !Trader().Events(t_events))
   {
      return false;
   }
   //--- set expert signal event instance
   CArrayObj *signals = Signals();
   for (int index = 0; index < signals.Total(); index++)
   {
      CExpertSignal *signal = signals.At(index);
      if (!signal.Events(t_events))
      {
         return false;
      }
   }
   m_events = t_events;
   //--- operation succeed
   return Events() != NULL;
}

bool CExpert::Signals(CExpertSignal *t_expert_signal)
{
   return m_expert_signals.Add(t_expert_signal);
}

bool CExpert::Trader(CExpertTrader *t_expert_trader)
{
   m_expert_trader = t_expert_trader;
   return m_expert_trader != NULL;
}

bool CExpert::SymbolInfo(CSymbolInfo *t_symbol_info)
{
   //--- set expert calendar and trader event instance
   if (!Calendar().SymbolInfo(t_symbol_info) || !Trader().SymbolInfo(t_symbol_info))
   {
      return false;
   }
   //--- set expert signal event instance
   CArrayObj *signals = Signals();
   for (int index = 0; index < signals.Total(); index++)
   {
      CExpertSignal *signal = signals.At(index);
      if (!signal.SymbolInfo(t_symbol_info))
      {
         return false;
      }
   }
   m_symbol_info = t_symbol_info;
   //--- operation succeed
   return SymbolInfo() != NULL;
}

#endif
//+------------------------------------------------------------------+
