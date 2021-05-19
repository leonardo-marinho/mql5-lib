//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_TICK_PATTERN__
#define __C_TICK_PATTERN__

#include "CAnalyze.mqh"
#include "CStrategy.mqh"
#include "CInterface.mqh"

#define MAX_ANALYZERS 200

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TickPattern : public CStrategy
  {
private:
   CAnalyze*          Analyzers[MAX_ANALYZERS];
   CInterface        Interface;

   int               m_analyzer_count;

   inline void       CreateAnalyzer(void)
     {
      if(m_analyzer_count < MAX_ANALYZERS)
        {
         Analyzers[m_analyzer_count] = new CAnalyze();
         Analyzers[m_analyzer_count].Active(true);
         m_analyzer_count++;
        }
      else
         Print("Max analyzers reached");
     }

   inline void       OnAnalyzerTick(void)
     {
      for(int index = 0; index < m_analyzer_count; index++)
      {
         if(Analyzers[index].Active() && !Analyzers[index].Done())
         {
            Analyzers[index].PushTick(Round.Price());
            Print("Score[", index, "]: ", Analyzers[index].Score());
         }
         
         if (Analyzers[index].Done())
         {
            Analyzers[index].Active(false);
            CreateAnalyzer();
         }
      }      
     }

public:
                     TickPattern()
      :              m_analyzer_count(0)
     {}

                    ~TickPattern()
     {
      for(int index = 0; index < m_analyzer_count; index++)
         delete Analyzers[index];
     }

   inline void       OnRoundInit(void)
     {
      Interface.SetLabelData(State(), 3);
     }

   void              OnInit()
     {
      Interface.AddLabel("Campaign");
      Interface.AddLabel("Start Time", "--:--:--");
      Interface.AddLabel("Actual Time", "--:--:--");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Round");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Strategy");
      Interface.AddLabel("Analyzers", "0");
      Interface.AddLabel("Score", "0");
     }

   inline void       OnFirstIdleTick(void)
     {
      CreateAnalyzer();
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 1);
     }

   inline void       OnValidTick()
     {
      OnAnalyzerTick();
      Interface.SetLabelData(m_analyzer_count, 9);
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 2);
      Interface.SetLabelData(State(), 3);
      Interface.SetLabelData(Round.State(), 6);
     }
  };

#endif
//+------------------------------------------------------------------+
