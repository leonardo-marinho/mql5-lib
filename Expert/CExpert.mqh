//+------------------------------------------------------------------+
//|                                                           CState |
//|                                 Copyright 2021, Leonardo Marinho |
//|                         https://github.com/dev-marinho/mql5-lib  |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.17"

#ifndef __C_EXPERT
#define __C_EXPERT

#include <Object.mqh>
#include <mql5-lib\States\CState.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COpenParameters : public CObject
  {
private:
   //--- Bar identification
   int                m_barIdentification;
   //--- Max price deviation
   ulong              m_deviation;
   //--- Prohibit another open at the same bar
   bool               m_onePerBar;
   //--- Suggested price
   double             m_price;
   //--- Take profit value
   double             m_tp;
   //--- Stop loss value
   double             m_sl;
   //--- Volume to operate
   double             m_volume;
   //--- Calculate real profit
   bool               m_useRealProfit;
   //--- Order type
   ENUM_ORDER_TYPE    m_orderType;
   //--- Position type
   ENUM_POSITION_TYPE m_positionType;

public:
   //--- Constructor
                     COpenParameters()
      :              m_barIdentification(0),
                     m_deviation(0),
                     m_onePerBar(false),
                     m_price(0),
                     m_tp(0),
                     m_sl(0),
                     m_volume(1),
                     m_useRealProfit(false)
     {
     }

   //--- Get bar identification
   int                BarIdentification(void) { return m_barIdentification; }
   //--- Set bar identification
   void               BarIdentification(int t_barIdentification) { m_barIdentification = t_barIdentification; }
   //--- Get max price deviation
   ulong              Deviation(void) { return m_deviation; }
   //--- Set max price deviation
   void               Deviation(ulong t_deviation) { m_deviation = t_deviation; }
   //--- Get prohibit another open at the same bar
   bool               OnePerBar(void) { return m_onePerBar; }
   //--- Set prohibit another open at the same bar
   void               OnePerBar(bool t_onePerBar) { m_onePerBar = t_onePerBar; }
   //--- Get suggested price
   double             Price(void) { return m_price; }
   //--- Set suggested price
   void               Price(double t_price) { m_price = t_price; }
   //--- Get take profit value
   double             Tp(void) { return m_tp; }
   //--- Set take profit value
   void               Tp(double t_tp) { m_tp = t_tp; }
   //--- Get stop loss value
   double             Sl(void) { return m_sl; }
   //--- Set stop loss value
   void               Sl(double t_sl) { m_sl = t_sl; }
   //--- Get volume to operate
   double             Volume(void) { return m_volume; }
   //--- Set volume to operate
   void               Volume(double t_volume) { m_volume = t_volume; }
   //--- Get calculate real profit
   bool               UseRealProfit(void) { return m_useRealProfit; }
   //--- Set calculate real profit
   void               UseRealProfit(bool t_useRealProfit) { m_useRealProfit = t_useRealProfit; }
   //--- Get order type
   ENUM_ORDER_TYPE    OrderType(void) { return m_orderType; }
   //--- Set order type
   void               OrderType(ENUM_ORDER_TYPE t_orderType) { m_orderType = t_orderType; }
   //--- Get position type
   ENUM_POSITION_TYPE                PositionType(void) { return OrderType() % 2 == 0 ? POSITION_TYPE_BUY : POSITION_TYPE_SELL; }
  };

//+------------------------------------------------------------------+
//| Expert class                                                     |
//+------------------------------------------------------------------+
class CExpert : public CObject
  {
private:
   //--- Expert states
   enum M_STATES
     {
      STATE_RUNNING,
      STATE_OUT,
      STATE_ERROR
     };

   //--- tick mode
   enum M_TICK_MODES
     {
      MODE_EVERYTICK,
      MODE_NEWBAR
     };

   //--- Operating symbol name
   const string            m_symbolName;
   //--- Operating timeseries
   const ENUM_TIMEFRAMES   m_timeframe;
   //--- Magic number
   const ulong             m_magicNumber;
   //--- Tick behavior
   const M_TICK_MODES      m_tick_mode;

   //--- Prev bar id
   int                     m_prevBarId;

   //--- init time
   datetime          m_timeInit;

   //--- Instance to access deals
   CDealInfo*        m_dealInfo;
   //--- Instance to access position
   CPositionInfo*    m_positionInfo;
   //--- Instance to open or close position
   CTrade*           m_marketTrader;
   //--- Instance to hold states
   CState<M_STATES>* m_stateHolder;
   //--- Open parameters history
   CArrayObj*        m_openParametersArray;

   //--- Return if any position is open
   bool              AnyPositionOpen();
   //--- Return profit of open positions
   bool              Profit(double &profit, double &pips);

   //--- Initializes deal info instance
   bool              InitDealInfo(void);
   //--- Initializes position info instance
   bool              InitPositionInfo(void);
   //--- Initializes symbol info instance
   bool              InitSymbolInfo(void);
   //--- Initializes trade instance
   bool              InitMarketTrader(void);
   //--- Initializes state instance
   bool              InitStateHolder(void);
   //--- Initializes open parameters array
   bool              InitOpenParametersArray(void);

   //--- Method to open a position
   bool              Open(ENUM_ORDER_TYPE t_order_type);
   //--- Method to close a position
   bool              Close();

   //--- Check open conditions
   bool              CheckOpenCondition();
   //--- Check close conditions
   bool              CheckCloseCondition();

protected:
   //--- Instance to access symbol
   CSymbolInfo*      SymbolInfo;

   //--- Timeframe of the expert
   ENUM_TIMEFRAMES   Timeframe(void) { return m_timeframe; }

   COpenParameters   dump;

   //--- Initializes indicators
   virtual bool      InitIndicators() { return true; }
   //--- Initializes vars
   virtual bool      InitVars() { return true; }
   //--- DeInitializes indicators
   virtual bool      DeInitIndicators() { return true; }
   //--- DeInitializes vars
   virtual bool      DeInitVars() { return true; }
   //--- Checks the settings
   virtual bool      ValidateSettings() { return true; }

   //--- Event called on Init method
   virtual void      OnInit(void)   { return; }
   //--- Event called on DeInit method
   virtual void      OnDeInit(void) { return; }
   //--- Event called on Open method
   virtual void      OnTick(void)   { return; }
   //--- Event called on InitIndicators method
   virtual void      OnError(void)   { return; }
   //--- Event called on CheckOpenCondition method
   virtual void      OnCheckOpenCondition(void) { return;}
   //--- Event called on Open method
   virtual void      OnOpen(void)   { return; }
   //--- Event called on CheckCloseCondition method
   virtual void      OnCheckCloseCondition(void) { return;}
   //--- Event called on Close method
   virtual void      OnClose(void)  { return; }
   //--- Event called ater Close method if profit is lower than 0
   virtual void      OnProfit(void) { return; }
   //--- Event called ater Close method if profit is higher than 0
   virtual void      OnLoss(void)   { return; }
   //--- Event called when a new bar is detected
   virtual void      OnNewBar(void) { return; }

   //--- Conditions to open a long position
   virtual bool      OpenShortCondition(void)  { return false; }
   //--- Conditions to open a short position
   virtual bool      OpenLongCondition(void)   { return false; }
   //--- Conditions to close any position
   virtual bool      CloseCondition(const double, const double)      { return false; }
   //--- Conditions to close a short position
   virtual bool      CloseShortCondition(const double, const double) { return false; }
   //--- Conditions to close a long position
   virtual bool      CloseLongCondition(const double, const double)  { return false; }
   //--- Set parameters to a new position
   virtual bool      OpenParameters(COpenParameters*) { return false; }

public:
   //--- Constructor
                     CExpert(string, ENUM_TIMEFRAMES, ulong, M_TICK_MODES);
   //--- Destructor
                    ~CExpert();

   //--- Initializes indicators
   bool              Init();
   //--- Class instance deinitialization method
   bool              DeInit();
   //--- Class instance tick method
   void              Tick();
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpert::CExpert(string t_symbolName,ENUM_TIMEFRAMES t_timeframe,ulong t_magicNumber, M_TICK_MODES t_tick_mode = MODE_EVERYTICK)
   : m_symbolName(t_symbolName),
     m_timeframe(t_timeframe),
     m_magicNumber(t_magicNumber),
     m_tick_mode(t_tick_mode),
     m_timeInit(TimeCurrent()),
     m_prevBarId(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpert::~CExpert()
  {
//--- delete pointer
   delete m_dealInfo;
//--- delete pointer
   delete m_positionInfo;
//--- delete pointer
   delete SymbolInfo;
//--- delete pointer
   delete m_marketTrader;
//--- delete pointer
   delete m_stateHolder;
//--- delete pointer
   delete m_openParametersArray;
  }


//+------------------------------------------------------------------+
//| Return if any position is open                                   |
//+------------------------------------------------------------------+
bool CExpert::AnyPositionOpen()
  {
//--- try select position
   if(!m_positionInfo.SelectByMagic(SymbolInfo.Name(), m_magicNumber))
     {
      //--- selection failed
      return false;
     }
//--- test volume
   if(m_positionInfo.Volume() == 0)
     {
      //--- volume is zero
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Return profit of open positions                                  |
//+------------------------------------------------------------------+
bool CExpert::Profit(double &profit, double &pips)
  {
//--- check if any position is open
   if(AnyPositionOpen())
     {
      //--- check if real profit flag is active
      if(dump.UseRealProfit())
        {
         if(dump.PositionType() == POSITION_TYPE_BUY)
           {
            //--- calculate real profit to buy position
            profit = (SymbolInfo.Bid() - m_positionInfo.PriceOpen()) / SymbolInfo.TickSize() * SymbolInfo.TickValue() * m_positionInfo.Volume();
           }
         else
           {
            //--- calculate real profit to sell position
            profit = -(SymbolInfo.Ask() - m_positionInfo.PriceOpen()) / SymbolInfo.TickSize() * SymbolInfo.TickValue() * m_positionInfo.Volume();
           }
        }
      else
        {
         //--- set profit from position calculation
         profit = m_positionInfo.Profit();
        }
     }
   else
     {
      //--- update history
      HistorySelect(m_timeInit, TimeCurrent());
      //--- select deal
      if(!m_dealInfo.SelectByIndex(HistoryDealsTotal() - 1))
        {
#ifdef __DEBUG Print("CRound could not fetch deal profit"); #endif
         //--- operation failed
         return false;
        }
      //--- move profit
      profit = m_dealInfo.Profit();
     }
//--- move pips
   pips = profit / SymbolInfo.TickValue() / (m_positionInfo.Volume() == 0 ? 1 : m_positionInfo.Volume());
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//| Initializes deal info instance                                   |
//+------------------------------------------------------------------+
bool CExpert::InitDealInfo()
  {
//--- set pointer
   m_dealInfo = new CDealInfo;
//--- test pointer
   if(m_dealInfo == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Initializes position info instance                               |
//+------------------------------------------------------------------+
bool CExpert::InitPositionInfo()
  {
//--- set pointer
   m_positionInfo = new CPositionInfo;
//--- test pointer
   if(m_positionInfo == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Initializes symbol info instance                                 |
//+------------------------------------------------------------------+
bool CExpert::InitSymbolInfo()
  {
//--- set pointer
   SymbolInfo = new CSymbolInfo;
//--- test pointer
   if(SymbolInfo == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- set symbol name
   if(!SymbolInfo.Name(m_symbolName))
     {
      //--- name assertion failed
      return false;
     }
//--- try refresh
   if(!SymbolInfo.Refresh())
     {
      //--- operation failed
      return false;
     }
//--- try refresh rates
   if(!SymbolInfo.RefreshRates())
     {
      //--- operation failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Initializes trade instance                                       |
//+------------------------------------------------------------------+
bool CExpert::InitMarketTrader()
  {
//--- set pointer
   m_marketTrader = new CTrade;
//--- test pointer
   if(m_marketTrader == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- set magic number
   m_marketTrader.SetExpertMagicNumber(m_magicNumber);
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Initializes state instance                                       |
//+------------------------------------------------------------------+
bool CExpert::InitStateHolder()
  {
//--- set pointer
   m_stateHolder = new CState<M_STATES>(STATE_OUT);
//--- test pointer
   if(m_stateHolder == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Initializes open parameters history                              |
//+------------------------------------------------------------------+
bool CExpert::InitOpenParametersArray()
  {
//--- set pointer
   m_openParametersArray = new CArrayObj;
//--- test pointer
   if(m_openParametersArray == NULL)
     {
      //--- pointer assertion failed
      return false;
     }
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//| Method to open a position                                        |
//+------------------------------------------------------------------+
bool              CExpert::Open(ENUM_ORDER_TYPE t_order_type)
  {
#ifdef __DEBUG_ Print("Trying to open position"); #endif
//--- test if order type is supported
   if(!(t_order_type == ORDER_TYPE_BUY ||
        t_order_type == ORDER_TYPE_SELL))
     {
#ifdef __DEBUG_ Print("Order ", t_order_type, " type is not supported"); #endif
      //--- order type is not supported
      return false;
     }
//--- initialize new instance
   COpenParameters parameters;
//--- move parameters
   if(!OpenParameters(&parameters))
     {
#ifdef __DEBUG_ Print("Failed to process parameters"); #endif
      //--- operation failed
      return true;
     }
//--- set order type
   parameters.OrderType(t_order_type);
//--- set bar id
   parameters.BarIdentification(iBars(SymbolInfo.Name(), Timeframe()));
//--- set deviation
   m_marketTrader.SetDeviationInPoints(parameters.Deviation());
//--- check if price is valid
   if(parameters.Price() == 0)
     {
      //--- resolve price
      parameters.Price(parameters.PositionType() == POSITION_TYPE_SELL ? SymbolInfo.Bid() : SymbolInfo.Ask());
     }
   if(!m_marketTrader.PositionOpen(
         SymbolInfo.Name(), parameters.OrderType(), parameters.Volume(), parameters.Price(),
         parameters.Sl() == 0 ? 0 : parameters.Price() + (
            MathAbs(parameters.Sl()) * SymbolInfo.TickSize() * (parameters.PositionType() == POSITION_TYPE_SELL ? 1 : -1)),
         parameters.Tp() == 0 ? 0 : parameters.Price() + (
            MathAbs(parameters.Tp()) * SymbolInfo.TickSize() * (parameters.PositionType() == POSITION_TYPE_SELL ? -1 : 1))))
     {
#ifdef __DEBUG_ Print("CTrader validation error"); #endif
      //--- operation failed
      return false;
     }
//--- test retcode
   if(m_marketTrader.ResultRetcode() != TRADE_RETCODE_DONE)
     {
#ifdef __DEBUG_ Print("Retcode ", m_marketTrader.ResultRetcode()," is not valid"); #endif
      //--- operation failed
      return false;
     }
//--- push parameters to history
   m_openParametersArray.Insert(&parameters, 0);
//-----------
   dump = parameters;
//-----------
//--- emit event
   OnOpen();
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Method to close a position                                       |
//+------------------------------------------------------------------+
bool              CExpert::Close(void)
  {

#ifdef __DEBUG_ Print("Trying to close by symbol"); #endif
//--- close position
   if(!m_marketTrader.PositionClose(SymbolInfo.Name()))
     {
#ifdef __DEBUG_ Print("CTrader validation error"); #endif
      //--- operation failed
      return false;
     }
//--- test retcode
   if(m_marketTrader.ResultRetcode() != TRADE_RETCODE_DONE)
     {
#ifdef __DEBUG_ Print("Retcode ", m_marketTrader.ResultRetcode()," is not valid"); #endif
      //--- operation failed
      return false;
     }
//--- emit event
   OnClose();
//--- operation succeed
   return true;
  }

//+------------------------------------------------------------------+
//| Check open conditions                                            |
//+------------------------------------------------------------------+
bool              CExpert::CheckOpenCondition()
  {
   if(AnyPositionOpen())
     {
      //--- quit
      return true;
     }
//--- store last open parameters
   COpenParameters prevOpenParameters = dump;
   /*if(prevOpenParameters != NULL)
     {*/
//--- test bar id
   if(prevOpenParameters.OnePerBar() &&
      prevOpenParameters.BarIdentification() == iBars(SymbolInfo.Name(), Timeframe()))
     {
      //--- quit
      return true;
     }
//}
//--- emit event
   OnCheckOpenCondition();
//--- test conditions
   if(OpenShortCondition())
     {
#ifdef __DEBUG_ Print("Open short condition met"); #endif
      //--- try open
      return Open(ORDER_TYPE_SELL);
     }
   else
      if(OpenLongCondition())
        {
#ifdef __DEBUG_ Print("Open long condition met"); #endif
         return Open(ORDER_TYPE_BUY);
        }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| Check close conditions                                           |
//+------------------------------------------------------------------+
bool              CExpert::CheckCloseCondition()
  {
//--- test if any position is open
   if(AnyPositionOpen())
     {
      //--- var to store profit value
      double profitValue;
      //--- var to store profit pips
      double profitPips;
      //--- get profit
      Profit(profitValue, profitPips);
      //--- emit event
      OnCheckCloseCondition();
      //--- test conditionals
      if((dump.PositionType() == POSITION_TYPE_SELL && CloseShortCondition(profitValue, profitPips)) ||
         (dump.PositionType() == POSITION_TYPE_BUY && CloseLongCondition(profitValue, profitPips)) ||
         CloseCondition(profitValue, profitPips))
        {
#ifdef __DEBUG_ Print("Close condition met"); #endif
         //--- try close
         return Close();
        }
     }
//--- initialization succeed
   return true;
  }

//+------------------------------------------------------------------+
//| Initializes indicators                                           |
//+------------------------------------------------------------------+
bool              CExpert::Init()
  {
//--- initializes symbol info instance
   if(!InitSymbolInfo())
     {
#ifdef __DEBUG_ Print("Failed to initialize Symbol Info"); #endif
      //--- operation failed
      return false;
     }
//--- initializes deal info instance
   if(!InitDealInfo())
     {
#ifdef __DEBUG_ Print("Failed to initialize Deal Info"); #endif
      //--- operation failed
      return false;
     }
//--- initializes position info instance
   if(!InitPositionInfo())
     {
#ifdef __DEBUG_ Print("Failed to initialize Position Info"); #endif
      //--- operation failed
      return false;
     }
//--- initializes trade instance
   if(!InitMarketTrader())
     {
#ifdef __DEBUG_ Print("Failed to initialize Trade"); #endif
      //--- operation failed
      return false;
     }
//--- initializes state instance
   if(!InitStateHolder())
     {
#ifdef __DEBUG_ Print("Failed to initialize State holder"); #endif
      //--- operation failed
      return false;
     }
//--- initializes open parameters array
   if(!InitOpenParametersArray())
     {
#ifdef __DEBUG_ Print("Failed to initialize open parameters array"); #endif
      //--- operation failed
      return false;
     }
//--- initializes vars
   if(!InitVars())
     {
#ifdef __DEBUG_ Print("Failed to initialize vars"); #endif
      //--- operation failed
      return false;
     }
//--- initializes indicators
   if(!InitIndicators())
     {
#ifdef __DEBUG_ Print("Failed to initialize indicators"); #endif
      //--- operation failed
      return false;
     }
//--- emit event
   OnInit();
//--- set state
   m_stateHolder.state(STATE_RUNNING);
//--- initialization succeed
   return true;
  }
//+------------------------------------------------------------------+
//| DeInitializes indicators                                         |
//+------------------------------------------------------------------+
bool              CExpert::DeInit()
  {
//--- deinitializes indicators
   if(!DeInitIndicators())
     {
#ifdef __DEBUG_ Print("Failed to deinitialize indicators"); #endif
      //--- operation failed
      return false;
     }
//--- initializes vars
   if(!DeInitVars())
     {
#ifdef __DEBUG_ Print("Failed to deinitialize vars"); #endif
      //--- operation failed
      return false;
     }
//--- emit event
   OnDeInit();
//--- deinitialization succeed
   return true;
  }

//+------------------------------------------------------------------+
//| Class instance tick method                                       |
//+------------------------------------------------------------------+
void              CExpert::Tick()
  {
//--- test state error
   if(m_stateHolder.state() == STATE_ERROR)
     {
      //--- test if any position is open
      if(AnyPositionOpen())
        {
         //--- close
         Close();
        }
      //--- quit
      return;
     }
//--- emit event
   OnTick();
//--- test state running
   if(m_stateHolder.state() == STATE_RUNNING)
     {
      //--- try conditions
      if(!CheckCloseCondition())
        {
         //--- set state
         m_stateHolder.state(STATE_ERROR);
        }
      //--- detect new bar
      if(m_prevBarId != iBars(SymbolInfo.Name(), Timeframe()))
        {
         //--- update prev bar id
         m_prevBarId = iBars(SymbolInfo.Name(), Timeframe());
         //--- emit event
         OnNewBar();
        }
      else
         //--- test if tick mode is new bar
         if(m_tick_mode == MODE_NEWBAR)
           {
            //--- exit
            return;
           }
      if(!CheckOpenCondition())
        {
         //--- set state
         m_stateHolder.state(STATE_ERROR);
        }
     }
  }
#endif
//+------------------------------------------------------------------+
