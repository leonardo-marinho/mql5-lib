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
   //--- check if event exists
   int Search(string);
};

CEvents::CEvents()
    : m_events(new CArrayString())
{
}

bool CEvents::Clear(string t_eventName)
{
   int eventIndex = Search(t_eventName);
   if (eventIndex == -1)
      return false;
   return m_events.Delete(eventIndex);
}

bool CEvents::ClearAll()
{
   m_events.Clear();
   return m_events.Total() == 0;
}

bool CEvents::Emit(string t_eventName)
{
   return m_events.Add(t_eventName);
}

bool CEvents::Exists(string t_eventName)
{
   return m_events.Search(t_eventName) != -1;
}

int CEvents::Search(string t_eventName)
{
   return m_events.Search(t_eventName);
}

#endif
//+------------------------------------------------------------------+
