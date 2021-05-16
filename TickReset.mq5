//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_TICK_RESET__
#define __C_TICK_RESET__

#include "CStrategy.mqh"
#include "CInterface.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TickReset : public CStrategy
  {
private:
   CInterface        Interface;

   inline int        Strategy()
     {
      return 0;
     }

   void              OnInit()
     {
      Interface.AddLabel("Campaign");
      Interface.AddLabel("Total", "0.0");
      Interface.AddLabel("Earns", "0.0");
      Interface.AddLabel("Fees", "0.0");
      Interface.AddLabel("Rounds", "0");
      Interface.AddLabel("Lowest Profit", "0.0");
      Interface.AddLabel("Highest Profit", "0.0");
      Interface.AddLabel("Start Time", "--:--:--");
      Interface.AddLabel("Actual Time", "--:--:--");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Round");
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
      Interface.SetLabelData(State(), 9);
     }

   inline void       OnTick()
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 8);
      Interface.SetLabelData(State(), 9);
      Interface.SetLabelData(Round.Price(), 12);
      Interface.SetLabelData(Round.Ask(), 13);
      Interface.SetLabelData(Round.Bid(), 14);
      Interface.SetLabelData(Round.State(), 15);
     }

   inline void       OnFirstIdleTick(void)
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 7);
      Round.OpenOrder(true, 1, Round.Ask(), 1, 1);
     }

   inline void       OnIdleTick(void)
     {
     }

   inline void       OnPositionTick(void)
     {
     }

   inline void       OnDealTick(void)
     {
     }
  };
#endif
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
