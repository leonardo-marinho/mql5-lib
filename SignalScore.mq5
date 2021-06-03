//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "CStrategy.mqh"

input double PRICE_RESET = 0;
input double PRICE_TARGET = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SignalScore : public CStrategy
  {
private:
   double            PriceScore;
   uint InterfacePriceScoreLabelIndex;

public:
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              OnInit(void)
     {
      InterfacePriceScoreLabelIndex = Interface.AddLabel("Score");
      PriceScore = 0;
     }

   void              OnValidTick(void)
     {
      PriceScore += Round.PriceChange() / Round.TickSize();

      if(MathAbs(PriceScore) >= PRICE_RESET)
         PriceScore = 0;
         
      Interface.SetLabelData(DoubleToString(PriceScore, 0), InterfacePriceScoreLabelIndex);   
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              OnIdleTick(void)
     {
      if(PriceScore >= PRICE_TARGET)
         Round.OpenOrder(true, VOLUMES, TP_TICK, SL_TICK);
         
      if(PriceScore <= -PRICE_TARGET)
         Round.OpenOrder(false, VOLUMES, TP_TICK, SL_TICK);   
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              OnPositionTick(void)
     {
     }

   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   void              OnDealTick(void)
     {
     }
   //+------------------------------------------------------------------+
  };
//+------------------------------------------------------------------+
