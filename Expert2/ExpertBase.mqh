//--- file define
#ifndef __C__EXPERT_BASE__
#define __C__EXPERT_BASE__
//--- file includes
#include <Object.mqh>
#include <Indicators/Indicators.mqh>
#include <mql5-lib/Events/Events.mqh>
#include <mql5-lib/States/State.mqh>
#include <Trade/SymbolInfo.mqh>

//--- file constants
#define CEXPERT_BASE_EVENT_ONERROR "onError"
#define CEXPERT_BASE_EVENT_ONTIMER "onTimer"

//--- expert base class
class CExpertBase : public CObject
{
private:
   //--- state instance
   CState<int> *m_state;

protected:
   //--- events instance
   CEvents *m_events;
   //--- symbol info instance
   CSymbolInfo *m_symbol_info;
   //--- indicators object
   CIndicators *m_indicators;

   //--- timeframe
   ENUM_TIMEFRAMES m_timeframe;

   //--- Timeframe of the expert
   ENUM_TIMEFRAMES Timeframe(void) { return m_timeframe; }

   bool InitSymbolInfo();

public:
   //--- constructor
   CExpertBase();
   //--- destructor
   ~CExpertBase();

   //--- init routine
   virtual bool Init();
   //--- deinit routine
   virtual bool DeInit();
   //--- tick routine
   virtual bool Tick();
   //--- timer routine
   virtual bool Timer();

   //--- set events instance pointer
   virtual bool Events(CEvents *);
   //--- access events instance pointer
   CEvents *Events();
   //--- set indicators instance pointer
   virtual bool Indicators(CIndicators *);
   //--- access indicators instance pointer
   CIndicators *Indicators();
   //--- set state instance pointer
   virtual bool State(CState<int> *);
   //--- access state instance pointer
   CState<int> *State();
   //--- set symbol info instance pointer
   virtual bool SymbolInfo(CSymbolInfo *);
   //--- access symbol info instance pointer
   CSymbolInfo *SymbolInfo();
};

CExpertBase::CExpertBase()
    : m_events(new CEvents),
      m_indicators(new CIndicators),
      m_timeframe(_Period),
      m_state(new CState<int>)
{
}

CExpertBase::~CExpertBase()
{
   delete m_events;
   delete m_indicators;
   delete m_state;
   delete m_symbol_info;
}

bool CExpertBase::InitSymbolInfo()
{
   //--- try refresh
   if (!SymbolInfo().Refresh())
   {
      //--- operation failed
      return false;
   }
   //--- try refresh rates
   if (!SymbolInfo().RefreshRates())
   {
      //--- operation failed
      return false;
   }
   //--- operation succeed
   return true;
}

bool CExpertBase::Events(CEvents *t_events)
{
   m_events = t_events;
   return m_events != NULL;
}

CEvents *CExpertBase::Events()
{
   return m_events;
}

bool CExpertBase::Indicators(CIndicators *t_indicators)
{
   m_indicators = t_indicators;
   return m_indicators != NULL;
}

CIndicators *CExpertBase::Indicators()
{
   return m_indicators;
}

bool CExpertBase::State(CState<int> *t_state)
{
   m_state = t_state;
   return m_state != NULL;
}

CState<int> *CExpertBase::State()
{
   return m_state;
}

bool CExpertBase::SymbolInfo(CSymbolInfo *t_symbol_info)
{
   m_symbol_info = t_symbol_info;
   return m_symbol_info != NULL;
}

CSymbolInfo *CExpertBase::SymbolInfo()
{
   return m_symbol_info;
}

bool CExpertBase::Init()
{
   //--- operation success
   return true;
}

bool CExpertBase::DeInit()
{
   //--- operation success
   return true;
}

bool CExpertBase::Tick()
{
   //--- operation success
   return true;
}

bool CExpertBase::Timer()
{
   //--- operation success
   return true;
}

#endif
//+------------------------------------------------------------------+
