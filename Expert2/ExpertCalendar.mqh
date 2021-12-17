//--- file define
#ifndef __C__EXPERT_CALENDAR__
#define __C__EXPERT_CALENDAR__
//--- file includes
#include <mql5-lib/Expert2/ExpertBase.mqh>

//--- timer periods
enum EExpertCalendarTimer_periods
{
   CEXPERT_CALENDAR_TIMER_PERIOD_1_SECOND = 1,
   CEXPERT_CALENDAR_TIMER_PERIOD_10_SECONDS = 10,
   CEXPERT_CALENDAR_TIMER_PERIOD_15_SECONDS = 15,
   CEXPERT_CALENDAR_TIMER_PERIOD_30_SECONDS = 30,
   CEXPERT_CALENDAR_TIMER_PERIOD_1_MINUTE = 60,
   CEXPERT_CALENDAR_TIMER_PERIOD_10_MINUTES = 600,
   CEXPERT_CALENDAR_TIMER_PERIOD_15_MINUTES = 900,
   CEXPERT_CALENDAR_TIMER_PERIOD_30_MINUTES = 1800,
   CEXPERT_CALENDAR_TIMER_PERIOD_1_HOUR = 3600,
   CEXPERT_CALENDAR_TIMER_PERIOD_6_HOUR = 21600,
   CEXPERT_CALENDAR_TIMER_PERIOD_12_HOUR = 43200,
   CEXPERT_CALENDAR_TIMER_PERIOD_1_DAY = 86400
};

//--- expert calendar class
class CExpertCalendar : public CExpertBase
{
private:
   //--- timer period
   int m_timer_period;

   //--- timer checkpoint
   datetime m_timer_checkpoint;

   //--- set timer
   bool SetTimer();

public:
   //--- constructor
   CExpertCalendar(int);

   //--- init routine
   bool Init();
   //--- deinit routine
   bool DeInit();
   //--- timer routine
   bool Timer();

   //--- access timer checkpoint
   datetime TimerCheckpoint();
};

CExpertCalendar::CExpertCalendar(int t_timer_period)
    : m_timer_period(t_timer_period)
{
}

bool CExpertCalendar::SetTimer()
{
   return SetTimer();
}

bool CExpertCalendar::Init()
{
   return EventSetTimer(m_timer_period - (uint)TimeTradeServer() % m_timer_period);
}

bool CExpertCalendar::DeInit()
{
   EventKillTimer();
   return true;
}

bool CExpertCalendar::Timer()
{
   m_timer_checkpoint = TimeTradeServer();
   return SetTimer();
}

datetime CExpertCalendar::TimerCheckpoint()
{
   return m_timer_checkpoint;
}

#endif
//+------------------------------------------------------------------+
