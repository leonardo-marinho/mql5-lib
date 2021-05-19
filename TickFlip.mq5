//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_TICK_FLIP__
#define __C_TICK_FLIP__

#include <Indicators\Trend.mqh>
#include "CStrategy.mqh"
#include "CInterface.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TickFlip : public CStrategy
  {
private:
   CInterface        Interface;
   CiMA              m_ima_3;
   CiMA              m_ima_8;
   CiMA              m_ima_20;
   double            tick_score;
   double            ask_score;
   double            bid_score;   
   
   inline int        Strategy()
     {
      int mux = REVERSE_DECISION ? -1 : 1;

      if(tick_score > 0 || tick_score == 0)
      {
         return -1 * mux;
         }
      else
         if(tick_score < 0)
         {
            return 1 * mux;
            }
            
      return 0;
     }

   void              OnProfit()
     {
      tick_score = Round.Type() == 2  ? 1 : -1;
      Sleep(2000);
     }

   void              OnLoss()
     {
      tick_score = Round.Type() == 2  ? -1 : 1;
      Sleep(5000);
     }

   void              OnInit()
     {
      Interface.AddLabel("Campaign");
      Interface.AddLabel("Total", "0.0");
      Interface.AddLabel("Earns", "0.0");
      Interface.AddLabel("Fees", "0.0");
      Interface.AddLabel("Rounds", "0");
      Interface.AddLabel("Highest Profit", "0.0");
      Interface.AddLabel("Lowest Profit", "0.0");
      Interface.AddLabel("Start Time", "--:--:--");
      Interface.AddLabel("Actual Time", "--:--:--");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Round");
      Interface.AddLabel("Profit", "0.0");
      Interface.AddLabel("Price", "0.0");
      Interface.AddLabel("Ask", "0.0");
      Interface.AddLabel("Bid", "0.0");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Strategy");
      Interface.AddLabel("Score", "0");
      Interface.AddLabel("Rate", "0.0");
     }

   inline void       OnRoundInit(void)
     {
      Round.SetExpertMagicNumber(4444);
      Round.SetDeviationInPoints(0);
      Round.SetTypeFilling(ORDER_FILLING_FOK);
      Round.SetMarginMode();
      Round.LogLevel(0);
      Interface.SetLabelData(State(), 9);
     }

   inline void       OnValidTick()
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 8);
      Interface.SetLabelData(State(), 9);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Price(), 2), 13);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Ask(), 2), 14);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Bid(), 2), 15);
      Interface.SetLabelData(Round.State(), 16);
      Interface.SetLabelData(tick_score, 19);
     }

   inline void       OnFirstIdleTick(void)
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 7);
     }

   inline void       OnIdleTick(void)
     {
      int decision = Strategy();
      if(decision == 1)
        {
         Round.OpenOrder(true, VOLUMES, Round.Ask(), TP_TICK, SL_TICK);
        }
      else
         if(decision == -1)
            Round.OpenOrder(false, VOLUMES, Round.Bid(), TP_TICK, SL_TICK);
     }

   inline void       OnPositionTick(void)
     {
      Round.ResolveClose();
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
     }

   inline void       OnDealTick(void)
     {
      Interface.SetLabelData("R$ " + DoubleToString(Total(), 2), 1);
      Interface.SetLabelData("R$ " + DoubleToString(Earns(), 2), 2);
      Interface.SetLabelData("R$ " + DoubleToString(Fees(), 2), 3);
      Interface.SetLabelData(Rounds(), 4);
      Interface.SetLabelData("R$ " + DoubleToString(HighestProfit(), 2), 5);
      Interface.SetLabelData("R$ " + DoubleToString(LowestProfit(), 2), 6);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
      Interface.SetLabelData(tick_score, 19);
      Interface.SetLabelData(DoubleToString(ProfitRounds() / (double)Rounds() * 100, 2) + "%", 20);
     }
  };
#endif
//+------------------------------------------------------------------+
