//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_TRAILING__
#define __C_TRAILING__

struct TrailingSample
  {
                     TrailingSample(const ulong id = 0, const double profitPips = 0)
      :              Id(id),
                     HighestProfit(0),
                     LowestProfit(0),
                     ProfitPips(profitPips),
                     Tp(0),
                     Sl(0)
     {}
   ulong             Id;
   double            HighestProfit;
   double            LowestProfit;
   double            ProfitPips;
   double            Tp;
   double            Sl;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrailing
  {
protected:
   //--- trailing last sample
   TrailingSample    LastSample;
   //--- trailing current sample
   TrailingSample    Sample;

   //--- trailing algorithm
   virtual void      Calculation(TrailingSample& current, const TrailingSample& last) { return; }

public:
   //--- refresh with new sample
   bool              Refresh(const double profitValue, const double profitPips, const double tp, const double sl, const double spread);
   //--- trailing algorith
   bool              Result();
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailing::Refresh(const double profitValue, const double profitPips, const double tp, const double sl, const double spread)
  {
//--- test if it is first refresh
   if(Sample.Id > 0)
      //--- move current to last
      LastSample = Sample;
   else
     {
      //--- set initial tp
      Sample.Tp = tp;
      //--- set initial sl
      Sample.Sl = sl;
     }
//--- update sample profit
   Sample.ProfitPips = profitPips;
//--- update sample id
   Sample.Id++;
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CTrailing::Result(void)
  {
//--- test if it is first refresh
   if(Sample.Id > 0)
      //--- make calculations
      Calculation(Sample, LastSample);
//---- return result
   return Sample.ProfitPips <= Sample.Sl;
  }

#endif
//+------------------------------------------------------------------+
