//--- file define
#ifndef __C_EVENTS__
#define __C_EVENTS__

//--- file includes
#include <Arrays/ArrayString.mqh>
#include <Object.mqh>

//--- events class
class CEvents : CObject
{
private:
   //--- array of event names
   CArrayString *m_events;

public:
   //--- constructor
   CEvents();

   //--- clear single event
   bool Clear(string);
   //--- clear events queue
   bool ClearAll();
   //--- emit event
   bool Emit(string);
   //--- check if exists
   bool Exists(string);
   //--- get total emits in queue
   int QueueLength(void);
   //--- check if event exists
   int Search(string);
};

CEvents::CEvents()
    : m_events(new CArrayString())
{
}

bool CEvents::Clear(string t_event_name)
{
   int eventIndex = Search(t_event_name);
   if (eventIndex == -1)
      return false;
   return m_events.Delete(eventIndex);
}

bool CEvents::ClearAll()
{
   m_events.Clear();
   return m_events.Total() == 0;
}

bool CEvents::Emit(string t_event_name)
{
   m_events.Add("Acacoss");
   return m_events.Add(t_event_name);
}

bool CEvents::Exists(string t_event_name)
{
   return m_events.Search(t_event_name) > -1;
}

int CEvents::QueueLength(void)
{
   return m_events.Total();
}

int CEvents::Search(string t_event_name)
{
   return m_events.SearchLinear(t_event_name);
}

#endif
//+------------------------------------------------------------------+
