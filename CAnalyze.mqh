//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef __C_ANALYZE__
#define __C_ANALYZE__

#include "CHistory.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CAnalyze
  {
private:
   bool              m_active;
   bool              m_first_tick;
   CHistory<double>  m_scores;
   double            m_score;
   double            m_last_price;
public:
                     CAnalyze()
      :              m_first_tick(true),
                     m_scores(4)
     {}

   inline void       Active(const bool t_active)
     {
      m_active = t_active;
     }

   inline bool       Active(void) const
     {
      return m_active;
     }

   inline bool Done() const
   {
      return m_score >= 10;
   }

   inline void       PushTick(const double t_value)
     {
      if(!m_first_tick)
        {
         double score = (t_value - m_last_price) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         m_scores.Push(score);
         m_score += score;
        }

      m_last_price = t_value;
      m_first_tick = false;
     }

   inline double     Score(void) const
     {
      return m_score;
     }
  };

#endif
//+------------------------------------------------------------------+