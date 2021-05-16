//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_CAMPAIGN__
#define __C_CAMPAIGN__

#include "CRound.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CCampaign
  {
private:
   double            m_earns;
   double            m_fees;
   double            m_limit_loss;
   double            m_limit_gain;
   double            m_profit_lowest;
   double            m_profit_highest;
   double            m_total;
   int               m_time_start;
   int               m_time_end;
   ulong             m_rounds;
   ulong             m_profit_rounds;

protected:
   CRound*            Round;

   inline void       NewRound()
     {
      Round = new CRound();
     }

   inline double      Earns() const
     {
      return m_earns;
     }

   inline void       CalculateEarns()
     {
      m_earns += HistoryDealGetDouble(HistoryDealGetTicket(HistoryDealsTotal()-1), DEAL_PROFIT);
     }

   inline void       LimitLoss(double t_limit_loss)
     {
      m_limit_loss = t_limit_loss;
     }

   inline bool       CalculateLimitLoss() const
     {
      return Total() < m_limit_loss;
     }

   inline void       LimitGain(double t_limit_gain)
     {
      m_limit_gain = t_limit_gain;
     }

   inline bool       CalculateLimitGain() const
     {
      return Total() > m_limit_gain;
     }

   inline bool       LimitReached() const
     {
      return CalculateLimitLoss() || CalculateLimitGain();
     }

   inline double     ProfitRounds() const
     {
      return m_profit_rounds;
     }

   inline void       CalculateProfitRounds(void)
     {
      m_profit_rounds += HistoryDealGetDouble(HistoryDealGetTicket(HistoryDealsTotal()-1), DEAL_PROFIT) > 0;
     }

   inline double     Fees() const
     {
      return m_fees;
     }

   inline void       CalculateFees(const double t_fees)
     {
      m_fees += t_fees;
     }

   inline double     LowestProfit() const
     {
      return m_profit_lowest;
     }

   inline void       CalculateLowestProfit(void)
     {
      m_profit_lowest = m_total < m_profit_lowest ? m_total : m_profit_lowest;
     }

   inline double     HighestProfit() const
     {
      return m_profit_highest;
     }

   inline void       CalculateHighestProfit()
     {
      m_profit_highest = m_total > m_profit_highest ? m_total : m_profit_highest;
     }

   inline ulong      Rounds() const
     {
      return m_rounds;
     }

   inline void       CalculateRounds(void)
     {
      m_rounds++;
     }

   inline double      Total() const
     {
      return m_earns - m_fees;
     }

   inline void       StartTime(const int t_hour, const int t_minute)
     {
      m_time_start = t_hour * 60 + t_minute;
     }

   inline bool       CalculateStartTime(void) const
     {
      MqlDateTime dt;
      TimeCurrent(dt);
      int minutes = dt.hour*60+dt.min+(dt.sec / 60);
      return minutes >= m_time_start;
     }

   inline void       EndTime(const int t_hour, const int t_minute)
     {
      m_time_end = t_hour * 60 + t_minute;
     }

   inline bool CalculateEndTime(void) const
     {
      MqlDateTime dt;
      TimeCurrent(dt);
      int minutes = dt.hour*60+dt.min+(dt.sec / 60);
      
      return minutes < m_time_end;
     }
     
   inline bool OutOfTime() {
      return !CalculateStartTime() || !CalculateEndTime(); 
   }  

   inline string     State() const
     {
      if (!CalculateStartTime())
         return "Waiting to Start";
         
      if (!CalculateEndTime())
         return "Time up";   
      
      if(CalculateLimitLoss())
         return "Limit Loss";

      if(CalculateLimitGain())
         return "Limit Gain";

      return "Running";
     }

public:
                     CCampaign(void)
     {
     }

                    ~CCampaign(void)
     {
      delete Round;
     }

  };
#endif
//+------------------------------------------------------------------+
