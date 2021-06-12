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
   CROUND_OPEN_SHORT,
   CROUND_OPEN_LONG
  };

struct CRoundOpenParameters
  {
                     CRoundOpenParameters()
      :              Deviation(0),
                     Expiration(0),
                     Price(0),
                     Tp(0),
                     Sl(0),
                     Spread(-1),
                     Volume(1),
                     VirtualProfit(false)
     {
     }
   ulong             Deviation;
   datetime          Expiration;
   double            Price;
   double            Tp;
   double            Sl;
   double            Spread;
   double            Volume;
   bool              VirtualProfit;
   ENUM_CROUND_OPEN_TYPE OpenType;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRound
  {
protected:
   //--- start time
   datetime          TimeStart;
   //--- reset time
   datetime          TimeReset;
   //--- end time
   datetime          TimeEnd;

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
   inline double     Spread() { return SymbolInfo.Ask() - SymbolInfo.Bid(); }
   //--- get spread pips
   inline double     SpreadPips() { return Spread() / SymbolInfo.TickSize(); }

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
   //--- tick open checks
   bool              TickOpenCheck();
   //--- tick close checks
   bool              TickCloseCheck();

   //--- open
   bool              Open(ENUM_CROUND_OPEN_TYPE open_type);
   //--- close
   bool              CloseAll();

   //--- open short conditions
   virtual bool      OpenShortCondition()  { return false; }
   //--- open short conditions
   virtual bool      OpenLongCondition()   { return false; }
   //--- close conditions
   virtual bool      CloseCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread);
   //--- close short conditions
   virtual bool      CloseShortCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread) { return false; }
   //--- open short conditions
   virtual bool      CloseLongCondition(const double profitValue, const double profitPips, const double tp, const double sl, const double spread)  { return false; }

   //--- open parameters
   virtual bool      OpenParameters(CRoundOpenParameters& parameters) { return false; }
     
      //--- on init event
   virtual void OnInit() { return; }
   //--- on tick event
   virtual void OnTick() { return; }

public:
   //--- constructor
                     CRound();
   //--- destructor
                    ~CRound();

   //--- auto rearm
   bool              AutoRearm;

   //--- init routine
   bool              Init();
   //--- deinit routine
   bool              DeInit();
   //--- tick routine
   bool              Tick();

   //--- get profit
   bool              Profit(double &profit, double &pips);

  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CRound::CRound()
   :      TimeStart(TimeCurrent()),
          TimeReset(TimeCurrent()),
          TimeEnd(0),
          State(CROUND_STATE_INIT),
          AutoRearm(false)
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
bool CRound::DeInit()
  {
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
//--- init symbol info
   if(!InitSymbolInfo())
     {
#ifdef __DEBUG Print("CRound SymbolInfo could not be initialized"); #endif
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
     //--- emit event
     OnInit();
//--- update state
   State = CROUND_STATE_TICK;
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
   if(State == CROUND_STATE_ERROR)
     {
      //--- error routine
      TickError();
     }

//--- case in error
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
     
     //--- emit event
     OnTick();
//--- refresh rates
   if(!SymbolInfo.RefreshRates())
     {
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
//--- check close
   if(!TickCloseCheck())
     {
#ifdef __DEBUG Print("CRound check close routine could not be completed"); #endif
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
     }
//--- update state
   State = CROUND_STATE_DONE_BY_ERROR;
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickDone()
  {
//--- if may auto rearm
   if(AutoRearm)
     {
      //--- update state
      State = CROUND_STATE_TICK;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickOpenCheck()
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
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::TickCloseCheck()
  {
//--- check if there is any position open
   if(PositionsTotal() != 0)
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
      if(CloseCondition(profitValue, profitPips, LastOrderParameters.Tp, LastOrderParameters.Sl, SpreadPips()))
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
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRound::Profit(double &profit, double &pips)
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
//--- check state
   if(State == CROUND_STATE_TICK)
     {
      profit = PositionInfo.Profit();
     }
   else
      if(State == CROUND_STATE_DONE)
        {
         //--- update history
         HistorySelect(TimeReset, TimeCurrent());
         //--- select deal
         if(!DealInfo.SelectByIndex(HistoryDealsTotal() - 2))
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
//--- check spread
   if(parameters.Spread != -1 && SpreadPips() > parameters.Spread)
     {
      //--- operation failed
      return false;
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
                          parameters.VirtualProfit ? 0 : parameters.Price + (parameters.Sl * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? 1 : -1)),
                          parameters.VirtualProfit ? 0 : parameters.Price + (parameters.Tp * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? -1 : 1)),
                          ORDER_TIME_SPECIFIED, TimeCurrent() + parameters.Expiration))
        {
         //--- operation failed
         return false;
        }
      //--- echo
      Print("Order placed at ", SymbolInfo.Name(), " with price ", parameters.Price);
     }
//--- else will be placed by market
   else
     {
      if(!Trade.PositionOpen(SymbolInfo.Name(), type == CROUND_OPEN_SHORT ? ORDER_TYPE_SELL : ORDER_TYPE_BUY,
                             parameters.Volume, parameters.Price,
                             parameters.VirtualProfit ? 0 : parameters.Price + (parameters.Sl * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? 1 : -1)),
                             parameters.VirtualProfit ? 0 : parameters.Price + (parameters.Tp * SymbolInfo.TickSize() * (type == CROUND_OPEN_SHORT ? -1 : 1))))
        {
         //--- operation failed
         return false;
        }
      //--- echo
      Print("Position opened at ", SymbolInfo.Name(), " with market price");
     }
//--- test retcode
   if(Trade.ResultRetcode() != TRADE_RETCODE_DONE)
     {
      //--- operation failed
      return false;
     }
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
   return false;
  }

#endif
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
