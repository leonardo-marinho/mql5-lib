//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "CRound.mqh"
#include "CTrailing.mqh"

#include <Indicators\Trend.mqh>
#include "Indicators/CiZigZag.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CustomTrailing : public CTrailing
  {
protected:
   //--- tend score
   long              TendencyScore;
   //--- highest score
   long              TendencyHighestScore;
public:
                     CustomTrailing()
      :              TendencyScore(0),
                     TendencyHighestScore(0)
     {}

   //--- trailing algorith
   virtual void      Calculation(TrailingSample& current, const TrailingSample& last);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Strategy : public CRound
  {
protected:
   //--- ma20 indicator
   CiMA*             MA20;
   //--- ma50 indicator
   CiMA*             MA50;
   //--- ma150 indicator
   CiMA*             MA150;

   //--- ma condition 1
   bool              MAConditional1;
   //--- ma condition 2
   bool              MAConditional2;

   //--- ma spread on order send
   double            MASpread;

   //--- bar checkpoint
   int               Conditional1Checkpoint;

   //--- coinditional pendent type
   ENUM_CROUND_OPEN_TYPE ConditionalPendentType;

   //--- trailing
   CustomTrailing*   Trailing;

   //--- on init event
   virtual void      OnInit();
   //--- on deinit event
   virtual void      OnDeInit();
   //--- on init event
   virtual void      OnReInit();
   //--- on tick event
   virtual void      OnTick();
   //--- on profit event
   virtual void      OnProfit();
   //--- on loss event
   virtual void      OnLoss();

public:
   //--- constructor
                     Strategy() : CRound(PERIOD_M1) {}

   //--- open short conditions
   virtual bool      OpenShortCondition(void);
   //--- open short conditions
   virtual bool      OpenLongCondition(void);
   //--- close conditions
   virtual bool      CloseCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread);

   //--- open parameters
   virtual bool      OpenParameters(CRoundOpenParameters& parameters);
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::OnInit(void)
  {
//--- set auto reinit
   AutoReInit = true;
//--- set timer start
   TimerStart = 9.5 * 3600;
//--- set timer end
   TimerEnd = 17 * 3600;
//--- set pointer
   MA20 = new CiMA;
//--- create pointer
   if(MA20 == NULL || !MA20.Create(SymbolInfo.Name(), Timeframe, 20, 0, MODE_SMA, PRICE_CLOSE))
     {
      // set error
      State = CROUND_STATE_ERROR;
     }
//--- set pointer
   MA50 = new CiMA;
//--- create pointer
   if(MA50 == NULL || !MA50.Create(SymbolInfo.Name(), Timeframe, 50, 0, MODE_SMA, PRICE_CLOSE))
     {
      // set error
      State = CROUND_STATE_ERROR;
     }
//--- set pointer
   MA150 = new CiMA;
//--- create pointer
   if(MA150 == NULL || !MA150.Create(SymbolInfo.Name(), Timeframe, 150, 0, MODE_SMA, PRICE_CLOSE))
     {
      // set error
      State = CROUND_STATE_ERROR;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::OnReInit(void)
  {
//--- set pointer
   Trailing = new CustomTrailing;
//--- test pointer
   if(Trailing == NULL)
     {
      //--- set error
      State = CROUND_STATE_ERROR;
     }
//--- ma conditional 1 reset
   MAConditional1 = false;
//--- ma conditional 2 reset
   MAConditional2 = false;
//--- condition 1 checkpoint reset
   Conditional1Checkpoint = 0;
//--- reset conditional pendent type
   ConditionalPendentType = CROUND_OPEN_UNKNOWN;
//--- reset ma spread
   MASpread = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::OnTick(void)
  {
//--- ma20 refresh
   MA20.Refresh();
//--- ma50 refresh
   MA50.Refresh();
//--- ma150 refresh
   MA150.Refresh();
//--- test for rest
   if(!MAConditional2 && MAConditional1 && iBars(SymbolInfo.Name(), Timeframe) - Conditional1Checkpoint > 25)
     {
      ReInit();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void      Strategy::OnDeInit()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void      Strategy::OnLoss()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void      Strategy::OnProfit()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::OpenShortCondition(void)
  {
   if(!MAConditional1)
     {
      MAConditional1 = MA20.Main(1) > MA150.Main(1) &&
                       MA20.Main(0) < MA150.Main(0);
      Conditional1Checkpoint = iBars(SymbolInfo.Name(), Timeframe);
      ConditionalPendentType = CROUND_OPEN_SHORT;
     }

   if(MAConditional1 && ConditionalPendentType == CROUND_OPEN_SHORT)
     {
      MAConditional2 = MA50.Main(1) > MA150.Main(1) &&
                       MA50.Main(0) < MA150.Main(0);
      MASpread = MathAbs(MA150.Main(1) - MA20.Main(1));
     }
//--- return condition
   return MAConditional1 && MAConditional2;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::OpenLongCondition(void)
  {
   if(!MAConditional1)
     {
      MAConditional1 = MA150.Main(1) > MA20.Main(1) &&
                       MA150.Main(0) < MA20.Main(0);
      Conditional1Checkpoint = iBars(SymbolInfo.Name(), Timeframe);
      ConditionalPendentType = CROUND_OPEN_LONG;
     }

   if(MAConditional1 && ConditionalPendentType == CROUND_OPEN_LONG)
     {
      MAConditional2 = MA150.Main(1) > MA50.Main(1) &&
                       MA150.Main(0) < MA50.Main(0);
      MASpread = MathAbs(MA150.Main(1) - MA20.Main(1));
     }
//--- return condition
   return MAConditional1 && MAConditional2;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::OpenParameters(CRoundOpenParameters& parameters)
  {
   parameters.OnePerBar = true;
   parameters.Tp = 999;
   parameters.Sl = -40;
   parameters.VirtualClose = true;
   parameters.RealProfit = true;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::CloseCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread)
  {
//--- refresh trailing
   Trailing.Refresh(profitValue, profitPips, tp, sl, spread);
//--- return result
   return Trailing.Result();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CustomTrailing::Calculation(TrailingSample& current, const TrailingSample& last)
  {
   current.Sl = last.Sl == -40 && current.ProfitPips == 20 ? 5 : current.Sl;
   for(int index = 0; index <= 250; index += 5)
     {
      current.Sl = last.Sl == index && current.ProfitPips == index + 30 ? index + 20 : current.Sl;
     }

   /*TendencyScore += current.ProfitPips > 0 ? 1 : 0;
   TendencyScore += current.ProfitPips < 0 ? -1 : 0;
   TendencyHighestScore = TendencyScore > TendencyHighestScore ? TendencyScore : TendencyHighestScore;

   current.Sl = TendencyHighestScore > 10000 && current.ProfitPips < 0 ? 999 : current.Sl;*/
  }
//+------------------------------------------------------------------+
