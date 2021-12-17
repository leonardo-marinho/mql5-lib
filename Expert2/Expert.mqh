//--- file define
#ifndef __C__EXPERT__
#define __C__EXPERT__
//--- file includes
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Expert2/ExpertBase.mqh>
#include <mql5-lib/Expert2/ExpertCalendar.mqh>
#include <mql5-lib/Expert2/ExpertSignals.mqh>
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
   //--- expert signals instance pointers
   CExpertSignals *m_expert_signals;
   //--- expert trader instance pointers
   CExpertTrader *m_expert_trader;

protected:
   //--- access expert calendar instance pointer
   CExpertCalendar *Calendar();
   //--- access expert trader instance pointer
   CExpertTrader *Trader();

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

   //--- access wrap of expert signal instance pointers
   CExpertSignals *Signals();

   //--- set expert calendar instance pointer
   bool Calendar(CExpertCalendar *);
   //--- set events instance pointer
   bool Events(CEvents *);
   //--- set indicators instance pointer
   bool Indicators(CIndicators *);
   //--- set expert trader instance pointer
   bool Trader(CExpertTrader *);
   //--- set symbol info instance pointer
   bool SymbolInfo(CSymbolInfo *);
};

CExpert::CExpert()
    : m_expert_calendar(NULL),
      m_expert_signals(new CExpertSignals),
      m_expert_trader(NULL)
{
}

CExpert::~CExpert()
{
   delete m_expert_calendar;
   delete m_expert_signals;
   delete m_expert_trader;
}

CExpertCalendar *CExpert::Calendar()
{
   return m_expert_calendar;
}

CExpertSignals *CExpert::Signals()
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
   if (!Calendar().Init() || !Signals().Init(Trader()) || !Trader().Init())
   {
      State().state(EXPERT_ERROR_INIT);
      return false;
   }
   //--- operation succeed
   return true;
}

bool CExpert::DeInit()
{
   //--- deinit expert calendar and trader
   if (!Calendar().DeInit() || !Signals().DeInit() || !Trader().DeInit())
   {
      State().state(EXPERT_ERROR_DEINIT);
      return false;
   }
   //--- operation succeed
   return true;
}

bool CExpert::Tick()
{
   //--- refresh indicators
   Indicators().Refresh();
   //--- tick expert calendar and trader
   if (!Calendar().Tick() || !Signals().Tick(Calendar().TimerCheckpoint()) || !Trader().Tick())
   {
      State().state(EXPERT_ERROR_TICK);
      return false;
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
   if (!Calendar().Events(t_events) || !Trader().Events(t_events) || !Signals().Events(t_events))
   {
      return false;
   }
   m_events = t_events;
   //--- operation succeed
   return Events() != NULL;
}

bool CExpert::Indicators(CIndicators *t_indicators)
{
   //--- set expert calendar and trader event instance
   if (!Calendar().Indicators(t_indicators) || !Signals().Indicators(t_indicators) || !Trader().Indicators(t_indicators))
   {
      return false;
   }
   m_indicators = t_indicators;
   return m_indicators != NULL;
}

bool CExpert::SymbolInfo(CSymbolInfo *t_symbol_info)
{
   //--- set expert calendar and trader event instance
   if (!Calendar().SymbolInfo(t_symbol_info) || !Trader().SymbolInfo(t_symbol_info))
   {
      return false;
   }
   m_symbol_info = t_symbol_info;
   //--- operation succeed
   return SymbolInfo() != NULL;
}

bool CExpert::Trader(CExpertTrader *t_expert_trader)
{
   m_expert_trader = t_expert_trader;
   return m_expert_trader != NULL;
}

#endif
//+------------------------------------------------------------------+
