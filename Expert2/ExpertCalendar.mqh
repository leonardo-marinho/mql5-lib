#ifndef __C__EXPERT_CALENDAR__
#define __C__EXPERT_CALENDAR__

#include <mql5-lib/Expert2/ExpertBase.mqh>

class CExpertCalendar : public CExpertBase
{
private:
   bool m_updateTimer;

public:
   //--- constructor
   CExpertCalendar();

   //--- init routine
   bool Init();
   //--- deinit routine
   bool DeInit();
   //--- tick routine
   bool Tick();
   //--- timer routine
   bool Timer(datetime t_datetime);
};

CExpertCalendar::CExpertCalendar()
: m_updateTimer(true)
{
}

bool CExpertCalendar::Init()
{
   return EventSetTimer(60 - (uint)TimeTradeServer() % 60);
}

bool CExpertCalendar::DeInit()
{
   EventKillTimer();
   return true;
}

bool CExpertCalendar::Tick()
{
   return true;
}

bool CExpertCalendar::Timer(datetime t_datetime)
{
   Print("Novo minuto");
   return EventSetTimer(60 - (uint)TimeTradeServer() % 60);
}

#endif
//+------------------------------------------------------------------+
