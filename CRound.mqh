//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_ROUND__
#define __C_ROUND__

#include <Trade\SymbolInfo.mqh>
#include <Trade\Trade.mqh>

enum ENUM_CROUND_STATE
  {
   CROUND_STATE_INIT,
   CROUND_STATE_TICK,
   CROUND_STATE_DONE,
   CROUND_STATE_DONE_BY_ERROR,
   CROUND_STATE_ERROR,
  };

enum ENUM_CROUND_OPEN_TYPE
  {
   CROUND_OPEN_UNKNOWN,
   CROUND_OPEN_SHORT,
   CROUND_OPEN_LONG
  };

enum ENUM_CROUND_TIMER_STATE
  {
   CROUND_TIMER_OPERATING,
   CROUND_TIMER_COOLDOW,
   CROUND_TIMER_NO_OPERATION
  };

struct CRoundOpenParameters
  {
                     CRoundOpenParameters()
      :              BarId(0),
                     Deviation(0),
                     Expiration(0),
                     OnePerBar(false),
                     Opened(false),
                     Price(0),
                     Tp(0),
                     Sl(0),
                     Spread(-1),
                     Volume(1),
                     RealProfit(false),
                     VirtualClose(false)
     {
     }
   int               BarId;
   ulong             Deviation;
   datetime          Expiration;
   bool              OnePerBar;
   bool              Opened;
   double            Price;
   double            Tp;
   double            Sl;
   double            Spread;
   double            Volume;
   bool              RealProfit;
   bool              VirtualClose;
   ENUM_CROUND_OPEN_TYPE OpenType;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRound
  {
protected:
   //--- last open bar id
   int               LastOpenBarId;
   //--- last deals counter
   int               PositionsCounterOnOpen;
   //--- last deals counter
   int               DealsCounterOnOpen;

   //--- timeframe
   ENUM_TIMEFRAMES   Timeframe;

   //--- init time
   datetime          TimeInit;
   //--- reinit time
   datetime          TimeReInit;

   //--- timer start
   datetime          TimerStart;
   //--- timer duration
   datetime          TimerCooldown;
   //--- timer duration
   datetime          TimerEnd;
   //--- timer state
   ENUM_CROUND_TIMER_STATE TimerOperating;
   //--- timer reinit
   bool              TimerReInitDone;

   //--- state
   ENUM_CROUND_STATE State;

   //--- open parameters buffer
   CRoundOpenParameters         LastOrderParameters;

   //--- deal info
   CDealInfo*        DealInfo;
   //--- position info
   CPositionInfo*    PositionInfo;
   //--- symbol info
   CSymbolInfo*      SymbolInfo;
   //--- ctrade instance
   CTrade*           Trade;

   //--- get spread
   double            Spread() { return SymbolInfo.Ask() - SymbolInfo.Bid(); }
   //--- get spread pips
   double            SpreadPips() { return Spread() / SymbolInfo.TickSize(); }

   //--- try reinit routine
   bool              TryReInit();

   //--- init deal
   bool              InitDealInfo();
   //--- init position
   bool              InitPositionInfo();
   //--- init symbol
   bool              InitSymbolInfo();
   //--- init ctrade instance
   bool              InitTrade();

   //--- tick error
   bool              TickError();
   //--- tick done
   bool              TickDone();
   //--- tick timer
   bool              TickTimer();
   //--- tick open checks
   bool              TickOpenCheck();
   //--- tick close checks
   bool              TickCloseCheck();

   //--- open
   bool              Open(ENUM_CROUND_OPEN_TYPE open_type);
   //--- close
   bool              CloseAll();

   //--- validate parameters routine
   virtual bool      ValidateParameters()       { return true; }

   //--- open short conditions
   virtual bool      OpenShortCondition()  { return false; }
   //--- open long conditions
   virtual bool      OpenLongCondition()   { return false; }
   //--- close conditions
   virtual bool      CloseCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread);
   //--- close short conditions
   virtual bool      CloseShortCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread) { return false; }
   //--- open long conditions
   virtual bool      CloseLongCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread)  { return false; }

   //--- open parameters
   virtual bool      OpenParameters(CRoundOpenParameters& parameters) { return false; }

   //--- on init event
   virtual void      OnInit() { return; }
   //--- on deinit event
   virtual void      OnDeInit() { return; }
   //--- on reinit event
   virtual void      OnReInit() { return; }
   //--- on tick event
   virtual void      OnTick() { return; }
   //--- on done event
   virtual void      OnDone() { return; }
   //--- on profit event
   virtual void      OnProfit() { return; }
   //--- on loss event
   virtual void      OnLoss() { return; }

public:
   //--- constructor
                     CRound(ENUM_TIMEFRAMES timeframe);
   //--- destructor
                    ~CRound();

   //--- auto rearm
   bool              AutoReInit;

   //--- init routine
   bool              Init();
   //--- reinit routine
   bool              ReInit();
   //--- deinit routine
   bool              DeInit();
   //--- tick routine
   bool              Tick();

   //--- get profit
   bool              Profit(double &profit);
   //--- get profit
   bool              Profit(double &profit, double &pips);

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRound::CRound(ENUM_TIMEFRAMES timeframe)
   :      TimeInit(TimeCurrent()),
          State(CROUND_STATE_INIT),
          Timeframe(timeframe),
          TimerStart(0),
          TimerCooldown(86400),
          TimerEnd(86400),
          TimerReInitDone(true),
          LastOpenBarId(0),
          DealsCounterOnOpen(0),
          AutoReInit(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRound::~CRound()
  {
//--- delete pointer
   delete DealInfo;
//--- reset mem value
   DealInfo = NULL;
//--- delete pointer
   delete PositionInfo;
//--- reset mem value
   PositionInfo = NULL;
//--- delete pointer
   delete SymbolInfo;
//--- reset mem value
   SymbolInfo = NULL;
//--- delete pointer
   delete Trade;
//--- reset mem value
   Trade = NULL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TryReInit()
  {
//--- reinit
   if(AutoReInit)
     {
      //--- reinit
      if(!ReInit())
        {
         //--- operation failed
         return false;
        }
     }
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::DeInit()
  {
//--- emit event
   OnDeInit();
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Init()
  {
//--- test state
   if(State != CROUND_STATE_INIT)
     {
#ifdef __DEBUG Print("CRound init routined called at wrong state"); #endif
      //--- update state
      State = CROUND_STATE_ERROR;
      //--- operation failed
      return false;
     }
//--- test parameters
   if(!ValidateParameters())
     {
#ifdef __DEBUG Print("Parameters could not be validated"); #endif
      //--- update state
      State = CROUND_STATE_ERROR;
      //--- operation failed
      return false;
     }
//--- init symbol info
   if(!InitSymbolInfo())
     {
#ifdef __DEBUG Print("CRound SymbolInfo could not be initialized"); #endif
      //--- operation failed
      return false;
     }
//--- emit event
   OnInit();
//--- reinit
   if(!ReInit())
     {
#ifdef __DEBUG Print("CRound Reinit could not be executed"); #endif
      //--- operation failed
      return false;
     }
//--- update state
   State = CROUND_STATE_TICK;
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::ReInit()
  {
//--- update reinit time
   TimeReInit = TimeCurrent();
//--- init deal info
   if(!InitDealInfo())
     {
#ifdef __DEBUG Print("CRound DealInfo could not be initialized"); #endif
      //--- operation failed
      return false;
     }
//--- init position info
   if(!InitPositionInfo())
     {
#ifdef __DEBUG Print("CRound PositionInfo could not be initialized"); #endif
      //--- operation failed
      return false;
     }
//--- init trade
   if(!InitTrade())
     {
#ifdef __DEBUG Print("CRound CTrade instance could not be initialized"); #endif
      //--- operation failed
      return false;
     }
//--- reset last open parameters var
   LastOrderParameters = CRoundOpenParameters();
//--- update state
   State = CROUND_STATE_TICK;
//--- emit event
   OnReInit();
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound:: InitDealInfo()
  {
//--- set pointer
   DealInfo = new CDealInfo;
//--- test pointer
   if(DealInfo == NULL)
     {
      //--- operation failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound:: InitPositionInfo()
  {
//--- set pointer
   PositionInfo = new CPositionInfo;
//--- test pointer
   if(PositionInfo == NULL)
     {
      //--- operation failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::InitSymbolInfo()
  {
//--- set pointer
   SymbolInfo = new CSymbolInfo;
//--- test pointer
   if(SymbolInfo == NULL)
     {
      //--- operation failed
      return false;
     }
//--- set symbol name
   if(!SymbolInfo.Name(_Symbol))
     {
      //--- operation failed
      return false;
     }
//--- refresh
   if(!SymbolInfo.Refresh())
     {
      //--- operation failed
      return false;
     }
//--- refresh rates
   if(!SymbolInfo.RefreshRates())
     {
      //--- operation failed
      return false;
     }
//--- todo detect if profit currency is pip
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              CRound::InitTrade()
  {
//--- set pointer
   Trade = new CTrade;
//--- test pointer
   if(Trade == NULL)
     {
      //--- operation failed
      return false;
     }
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Tick()
  {
//--- case in error
   if(State == CROUND_STATE_ERROR || State == CROUND_STATE_DONE_BY_ERROR)
     {
      //--- error routine
      TickError();
     }
//--- case in done
   if(State == CROUND_STATE_DONE)
     {
      //--- done routine
      TickDone();
     }
//--- test state
   if(State != CROUND_STATE_TICK)
     {
      //--- operation failed
      return false;
     }
//--- update timer state
   if(!TickTimer())
     {
#ifdef __DEBUG Print("CRound timer routine could not be completed"); #endif
      //--- operation failed
      return false;
     }
//--- emit event
   OnTick();
//--- refresh rates
   if(!SymbolInfo.RefreshRates())
     {
      //--- operation failed
      return false;
     }
//--- check close
   if(!TickCloseCheck())
     {
#ifdef __DEBUG Print("CRound check close routine could not be completed"); #endif
      //--- operation failed
      return false;
     }
//--- check open
   if(!TickOpenCheck())
     {
#ifdef __DEBUG Print("CRound check open routine could not be completed"); #endif
      //--- operation failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickError()
  {
//--- check if there is any position open
   if(PositionsTotal() != 0)
     {
      //--- try close all
      if(!CloseAll())
        {
         //--- operation failed
         return false;
        }
      //--- update state
      State = CROUND_STATE_DONE_BY_ERROR;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickDone()
  {
//--- emit event
   OnDone();
//--- var to store profit
   double profit;
//--- store profit
   Profit(profit);
//--- test if is profit
   if(profit > 0)
     {
      //--- emit event
      OnProfit();
     }
   else
      if(profit < 0)
        {
         ///--- emit event
         OnLoss();
        }
//--- try reinit
   if(!TryReInit())
     {
#ifdef __DEBUG Print("CRound try Reinit could not be executed"); #endif
      //--- operation failed
      State = CROUND_STATE_ERROR;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickTimer()
  {
//--- store current time
   datetime currentTimeSeconds = TimeCurrent() % 86400;
//--- set as operating
   TimerOperating = CROUND_TIMER_NO_OPERATION;
//--- set timer operating or not
   if(currentTimeSeconds >= TimerStart && currentTimeSeconds < TimerEnd)
     {
      //--- set as operating
      TimerOperating = CROUND_TIMER_OPERATING;
      //--- set timer reinit flag
      TimerReInitDone = false;
      //--- check for cooldown
      if(currentTimeSeconds >= TimerCooldown && currentTimeSeconds < TimerEnd &&
         TimerCooldown > TimerStart && TimerCooldown < TimerEnd)
        {
         TimerOperating = CROUND_TIMER_COOLDOW;
        }
     }
   else
      if(!TimerReInitDone)
        {
         //--- try reinit
         if(!TryReInit())
           {
#ifdef __DEBUG Print("CRound try Reinit could not be executed"); #endif
            //--- operation failed
            State = CROUND_STATE_ERROR;
            //--- operation failed
            return false;
           }
         //--- reset flag
         TimerReInitDone = true;
        }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickOpenCheck()
  {
//--- check if timer is ok
   if(TimerOperating == CROUND_TIMER_OPERATING)
     {
      //--- check if there is any position open
      if(PositionsTotal() == 0)
        {
         //--- test open short condition
         if(OpenShortCondition())
           {
            //--- open short
            if(!Open(CROUND_OPEN_SHORT))
              {
#ifdef __DEBUG Print("CRound open short could not be executed"); #endif
               //--- operation failed
               return false;
              }
           }
         //--- test open short condition
         if(OpenLongCondition())
           {
            //--- open short
            if(!Open(CROUND_OPEN_LONG))
              {
#ifdef __DEBUG Print("CRound open long could not be executed"); #endif
               //--- operation failed
               return false;
              }
           }
        }
     }
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickCloseCheck()
  {
   if(PositionsTotal() != 0)
     {
      if(TimerOperating == CROUND_TIMER_NO_OPERATION)
        {
         //--- close all
         if(!CloseAll())
           {
#ifdef __DEBUG Print("CRound close position could not be executed"); #endif
            //--- operation failed
            return false;
           }
        }
      //--- check if there is any position open
      if(LastOrderParameters.Opened)
        {
         if(LastOrderParameters.VirtualClose)
           {
            //--- var to store profit value
            double profitValue = 0;
            //--- var to store profit pips
            double profitPips = 0;
            //--- get profit
            if(!Profit(profitValue, profitPips))
              {
               //--- operation failed
               return false;
              }
            //--- test open short condition
            if(CloseShortCondition(profitValue, profitPips, LastOrderParameters.Tp, LastOrderParameters.Sl, SpreadPips()))
              {
               //--- open all
               if(!CloseAll())
                 {
#ifdef __DEBUG Print("CRound close short could not be executed"); #endif
                  //--- operation failed
                  return false;
                 }
              }
            //--- test open short condition
            if(CloseLongCondition(profitValue, profitPips, LastOrderParameters.Tp, LastOrderParameters.Sl, SpreadPips()))
              {
               //--- open all
               if(!CloseAll())
                 {
#ifdef __DEBUG Print("CRound close long could not be executed"); #endif
                  //--- operation failed
                  return false;
                 }
              }
            //--- test general condition
            if(CloseCondition(profitValue, profitPips, LastOrderParameters.Tp, LastOrderParameters.Sl, SpreadPips()) || TimerOperating == CROUND_TIMER_NO_OPERATION)
              {
               //--- close all
               if(!CloseAll())
                 {
#ifdef __DEBUG Print("CRound close position could not be executed"); #endif
                  //--- operation failed
                  return false;
                 }
              }
           }
         //--- update deals history
         HistorySelect(TimeReInit, TimeCurrent());
         //--- check if there is any position open and is not virtual profit
         if(!LastOrderParameters.VirtualClose)
           {

            //--- set deals counter
            if(HistoryDealsTotal() > DealsCounterOnOpen)
              {
               //--- set state as done
               State = CROUND_STATE_DONE;
              }
           }
         //--- case in done
         if(State == CROUND_STATE_DONE)
           {
            //--- done routine
            TickDone();
           }
        }
      //--- has positions open but not open flag is checked
      else
        {
         //--- set state error
         State = CROUND_STATE_ERROR;
        }
     }
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Profit(double &profit)
  {
//--- dump var for pips arg
   double dump;
//--- profit
   Profit(profit, dump);
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Profit(double &profit, double &pips)
  {
//--- check state
   if(State == CROUND_STATE_TICK)
     {
      //--- select position
      if(!PositionInfo.Select(SymbolInfo.Name()))
        {
#ifdef __DEBUG Print("CRound could not fetch position profit"); #endif
         //--- update state
         State = CROUND_STATE_ERROR;
         //--- operation failed
         return false;
        }
      //--- check if real profit flag is active
      if(LastOrderParameters.RealProfit)
        {
         if(LastOrderParameters.OpenType == CROUND_OPEN_LONG)
           {
            //--- calculate real profit to buy position
            profit = (SymbolInfo.Bid() - PositionInfo.PriceOpen()) / SymbolInfo.TickSize() * SymbolInfo.TickValue() * PositionInfo.Volume();
           }
         else
           {
            //--- calculate real profit to sell position
            profit = -(SymbolInfo.Ask() - PositionInfo.PriceOpen()) / SymbolInfo.TickSize() * SymbolInfo.TickValue() * PositionInfo.Volume();
           }
        }
      else
        {
         //--- set profit from position calculation
         profit = PositionInfo.Profit();
        }
     }
   else
      if(State == CROUND_STATE_DONE)
        {
         //--- update history
         HistorySelect(TimeReInit, TimeCurrent());
         //--- select deal
         if(!DealInfo.SelectByIndex(HistoryDealsTotal() - 1))
           {
#ifdef __DEBUG Print("CRound could not fetch deal profit"); #endif
            //--- update state
            State = CROUND_STATE_ERROR;
            //--- operation failed
            return false;
           }
         //--- move profit
         profit = DealInfo.Profit();
        }
//--- move pips
   pips = profit / SymbolInfo.TickValue() / (LastOrderParameters.Volume == 0 ? 1 : LastOrderParameters.Volume);
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Open(ENUM_CROUND_OPEN_TYPE type)
  {
//--- open parameters var
   CRoundOpenParameters parameters;
//--- move parameters
   if(!OpenParameters(parameters))
     {
      //--- operation failed
      return false;
     }
//--- check if any is open
   if(LastOrderParameters.Opened)
     {
      TickCloseCheck();
      //--- recheck if any is open
      if(LastOrderParameters.Opened)
         //--- operation failed
         return false;
     }
//--- set bar id
   parameters.BarId = iBars(SymbolInfo.Name(), Timeframe);
//--- test bar id
   if(parameters.OnePerBar && LastOpenBarId == parameters.BarId)
     {
      //--- operation failed
      return true;
     }
//--- check spread
   if(parameters.Spread != -1 && SpreadPips() > parameters.Spread)
     {
      //--- operation failed
      return true;
     }
//--- set deviation
   Trade.SetDeviationInPoints(parameters.Deviation);
//--- check if price was passed
   if(parameters.Price == 0)
     {
      //--- resolve price
      parameters.Price = type == CROUND_OPEN_SHORT ? SymbolInfo.Bid() : SymbolInfo.Ask();
     }
//--- check if must be placed with a price
   if(parameters.Expiration != 0)
     {
      //--- try place order
      if(!Trade.OrderOpen(SymbolInfo.Name(), type == CROUND_OPEN_SHORT ? ORDER_TYPE_SELL_LIMIT : ORDER_TYPE_BUY_LIMIT,
                          parameters.Volume, 0, parameters.Price,
                          parameters.VirtualClose || parameters.Sl == 0 ? 0 : parameters.Price + (MathAbs(parameters.Sl) * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? 1 : -1)),
                          parameters.VirtualClose || parameters.Tp == 0 ? 0 : parameters.Price + (MathAbs(parameters.Tp) * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? -1 : 1)),
                          ORDER_TIME_SPECIFIED, TimeCurrent() + parameters.Expiration))
        {
         //--- operation failed
         return false;
        }
      //--- echo
#ifdef __DEBUG Print("Order placed at ", SymbolInfo.Name(), " with price ", parameters.Price); #endif
     }
//--- else will be placed by market
   else
     {
      if(!Trade.PositionOpen(SymbolInfo.Name(), type == CROUND_OPEN_SHORT ? ORDER_TYPE_SELL : ORDER_TYPE_BUY,
                             parameters.Volume, parameters.Price,
                             parameters.VirtualClose || parameters.Sl == 0 ? 0 : parameters.Price + (MathAbs(parameters.Sl) * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? 1 : -1)),
                             parameters.VirtualClose || parameters.Tp == 0 ? 0 : parameters.Price + (MathAbs(parameters.Tp) * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? -1 : 1))))
        {
         //--- operation failed
         return false;
        }
      //--- echo
#ifdef __DEBUG Print("Position opened at ", SymbolInfo.Name(), " with market price"); #endif
     }
//--- test retcode
   if(Trade.ResultRetcode() != TRADE_RETCODE_DONE)
     {
      //--- operation failed
      return false;
     }
//--- update deals history
   HistorySelect(TimeReInit, TimeCurrent());
//--- set deals counter
   DealsCounterOnOpen = HistoryDealsTotal();
//--- set position counter
   PositionsCounterOnOpen = PositionsTotal();
//--- set last open bar
   LastOpenBarId = parameters.BarId;
//--- set opened flag
   parameters.Opened = true;
//--- insert open paramenters to buffer
   LastOrderParameters = parameters;
//--- store open type
   LastOrderParameters.OpenType = type;
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::CloseAll()
  {
//--- close all
   if(!Trade.PositionClose(SymbolInfo.Name(), 0))
     {
      //--- operation failed
      return false;
     }
//--- test retcode
   if(Trade.ResultRetcode() != TRADE_RETCODE_DONE)
     {
      //--- operation failed
      return false;
     }
//--- update state
   State = CROUND_STATE_DONE;
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool      CRound::CloseCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread)
  {
   return profitPips >= tp || profitPips <= sl;
  }

#endif
//+------------------------------------------------------------------+
