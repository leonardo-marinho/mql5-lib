//--- file define
#ifndef __C__EXPERT_BASE__
#define __C__EXPERT_BASE__
//--- file includes
#include <Object.mqh>
#include <mql5-lib/Events/Events.mqh>
#include <mql5-lib/States/State.mqh>

//--- file constants
#define CEXPERT_BASE_EVENT_ONERROR "onError"
#define CEXPERT_BASE_EVENT_ONTIMER "onTimer"

//--- expert base class
class CExpertBase : public CObject
{
private:
   //--- events instance
   CEvents *m_events;
   //--- state instance
   CState<int> *m_state;

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
   //--- set state instance pointer
   virtual bool State(CState<int> *);
   //--- access state instance pointer
   CState<int> *State();
};

CExpertBase::CExpertBase()
    : m_events(new CEvents),
      m_state(new CState<int>)
{
}

CExpertBase::~CExpertBase()
{
   delete m_events;
   delete m_state;
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

bool CExpertBase::State(CState<int> *t_state)
{
   m_state = t_state;
   return m_state != NULL;
}

CState<int> *CExpertBase::State()
{
   return m_state;
}

bool CExpertBase::Init()
{
   return true;
}

bool CExpertBase::DeInit()
{
   return true;
}

bool CExpertBase::Tick()
{
   return true;
}

bool CExpertBase::Timer()
{
   return true;
}

#endif
//+------------------------------------------------------------------+
