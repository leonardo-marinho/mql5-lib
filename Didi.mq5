//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_DIDI__
#define __C_DIDI__

#include <Indicators\Trend.mqh>

#include "CStrategy.mqh"
#include "CInterface.mqh"

input double            BUY_MARGIN = -0.2;
input double            BUY_CONFIRMATION_MARGIN = -0.3;

input double            SELL_MARGIN = 0.2;
input double            SELL_CONFIRMATION_MARGIN = 0.3;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Didi : public CStrategy
  {
private:
   CInterface        Interface;
   double            tick_score;
   CiMA              m_ima_3;
   CiMA              m_ima_8;
   CiMA              m_ima_20;

   inline bool       InRange(const double t_val, const double t_min, const double t_max)
     {
      return t_val >= t_min && t_val <= t_max;
     }

   inline int        Strategy()
     {
      m_ima_3.Refresh();
      m_ima_8.Refresh();
      m_ima_20.Refresh();

      double blue_line = m_ima_3.Main(0) - m_ima_8.Main(0);
      double yellow_line = m_ima_20.Main(0) - m_ima_8.Main(0);

      double diff_3 = (m_ima_3.Main(1) - m_ima_3.Main(2)) / 3.195;
      double diff_8 = (m_ima_8.Main(1) - m_ima_8.Main(2)) / 3.195;
      double diff_20 = (m_ima_20.Main(1) - m_ima_20.Main(2)) / 3.195;
      
      Print("MA3: ", diff_3, " | MA8: ", diff_8, " | MA20: ", diff_20);   

      if(diff_3 > 0.1 && diff_8 > 0.0 && m_ima_3.Main(0) < m_ima_8.Main(0))
         return 1;

      /*if(diff_3 < -0.5 && diff_8 < 0.0 && diff_20 < 0.0 && m_ima_3.Main(0) > m_ima_8.Main(0) && m_ima_8.Main(0) > m_ima_20.Main(0))
         return -1;*/

      Interface.SetLabelData(DoubleToString(blue_line, 2), 20);
      Interface.SetLabelData(DoubleToString(yellow_line, 2), 21);


      return 0;
     }

   void              OnProfit()
     {
     }

   void              OnLoss()
     {
     }

   void              OnInit()
     {
      m_ima_3.Create(_Symbol, PERIOD_M1, 3, 0, MODE_SMA, PRICE_CLOSE);
      m_ima_8.Create(_Symbol, PERIOD_M1, 8, 0, MODE_SMA, PRICE_CLOSE);
      m_ima_20.Create(_Symbol, PERIOD_M1, 20, 0, MODE_SMA, PRICE_CLOSE);

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
      Interface.AddLabel("State", "---");
      Interface.AddLabel("Blue Line", 0);
      Interface.AddLabel("Yellow Line", 0);
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

   inline void       OnValidTick()
     {

      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 8);
      Interface.SetLabelData(State(), 9);
      Interface.SetLabelData("R$ " + DoubleToString(Round.PriceChange(), 2), 12);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Price(), 2), 13);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Ask(), 2), 14);
      Interface.SetLabelData("R$ " + DoubleToString(Round.Bid(), 2), 15);
      Interface.SetLabelData(Round.State(), 16);
     }

   inline void       OnFirstIdleTick(void)
     {
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 7);
     }

   inline void       OnIdleTick(void)
     {
      int decision = Strategy();
      if(decision == 1)
         Round.OpenOrder(true, VOLUMES, Round.Price(), TP_TICK, SL_TICK);
      else
         if(decision == -1)
            Round.OpenOrder(false, VOLUMES, Round.Price(), TP_TICK, SL_TICK);
     }

   inline void       OnPositionTick(void)
     {
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
      Interface.SetLabelData(DoubleToString(ProfitRounds() / Rounds() * 100, 2) + "%", 22);
     }
  };
#endif
//+------------------------------------------------------------------+
