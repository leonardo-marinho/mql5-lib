//--- file define
#ifndef __C__EXPERT_TRADER__
#define __C__EXPERT_TRADER__
//--- file includes
#include <mql5-lib/Expert2/ExpertBase.mqh>
#include <mql5-lib/Expert2/OrderParameters.mqh>
#include <Trade/DealInfo.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/Trade.mqh>

//--- file constants
#define CEXPERT_TRADER_EVENT_ONOPEN "onOpen"
#define CEXPERT_TRADER_EVENT_ONOPENLONG "onOpenLong"
#define CEXPERT_TRADER_EVENT_ONOPENSHORT "onOpenShort"
#define CEXPERT_TRADER_EVENT_ONCLOSE "onClose"
#define CEXPERT_TRADER_EVENT_ONCLOSELONG "onCloseLong"
#define CEXPERT_TRADER_EVENT_ONCLOSESHORT "onCloseShort"
#define CEXPERT_TRADER_EVENT_ONPROFIT "onProfit"
#define CEXPERT_TRADER_EVENT_ONPROFITLONG "onProfitLong"
#define CEXPERT_TRADER_EVENT_ONPROFITSHORT "onProfitShort"
#define CEXPERT_TRADER_EVENT_ONLOSS "onLoss"
#define CEXPERT_TRADER_EVENT_ONLOSSLONG "onLossLong"
#define CEXPERT_TRADER_EVENT_ONLOSSSHORT "onLossShort"

//--- expert trader class
class CExpertTrader : public CExpertBase
{
private:
   //--- deal info instance
   CDealInfo *m_deal;
   //--- Open parameters history
   CArrayObj *m_orders_parameters;
   //--- position info instance
   CPositionInfo *m_position;
   //--- trade instance
   CTrade *m_trade;

   COrderParameters m_lastOrderParameters;

   //--- init time
   datetime m_time_init;

   //--- position magic number
   int m_magic_number;

protected:
   //--- deal info instance
   CDealInfo *Deal();
   //--- access array of order parameters instance pointers
   CArrayObj *OrdersParameters();
   //--- position info instance
   CPositionInfo *Position();
   //--- trade instance
   CTrade *Trade();

   //--- open position
   bool Open(ENUM_ORDER_TYPE, COrderParameters &);
   //--- routine to update is position open flag
   bool UpdateIsPositionOpenFlag();

public:
   //--- position open flag
   bool m_position_open;

   //--- constructor
   CExpertTrader(int);

   //--- init routine
   bool Init(void);
   //--- deinit routine
   bool DeInit(void);
   //--- tick routine
   bool Tick(void);

   //--- open long routine
   bool OpenLong(COrderParameters &);
   //--- open short routine
   bool OpenShort(COrderParameters &);
   //--- close routine
   bool Close(void);

   //--- return if position is open
   bool IsPositionOpen();
   //--- current/last position profit
   bool Profit(double &, double &);
};

CExpertTrader::CExpertTrader(int t_magicNumber)
    : m_magic_number(t_magicNumber),
      m_time_init(TimeCurrent()),
      m_position_open(false)
{
}

CDealInfo *CExpertTrader::Deal()
{
   return m_deal;
}

CPositionInfo *CExpertTrader::Position()
{
   return m_position;
}

CTrade *CExpertTrader::Trade()
{
   return m_trade;
}

CArrayObj *CExpertTrader::OrdersParameters()
{
   return m_orders_parameters;
}

bool CExpertTrader::Init()
{
   //-- init trade instance
   m_trade = new CTrade();
   if (m_trade == NULL)
      return false;
   m_trade.SetExpertMagicNumber(m_magic_number);
   //-- init deal instance
   m_deal = new CDealInfo();
   if (m_deal == NULL)
      return false;
   //-- init orders parameters instance
   m_orders_parameters = new CArrayObj();
   if (m_orders_parameters == NULL)
      return false;
   //-- init position instance
   m_position = new CPositionInfo();
   if (m_position == NULL)
      return false;
   //--- update is position open flag
   if (!UpdateIsPositionOpenFlag())
      return false;
   //-- operation success
   return true;
}

bool CExpertTrader::DeInit()
{
   //--- close open positions
   if (IsPositionOpen() && !Close())
      return false;
   //--- operation succeed
   return true;
}

bool CExpertTrader::Tick()
{
   return true;
}

bool CExpertTrader::IsPositionOpen()
{
   return m_position_open;
   //--- try select position
   if (!Position().SelectByMagic(SymbolInfo().Name(), m_magic_number))
   {
      //--- selection failed
      return false;
   }
   //--- test volume
   if (Position().Volume() == 0)
   {
      //--- volume is zero
      return false;
   }
   //--- operation succeed
   return true;
}

bool CExpertTrader::UpdateIsPositionOpenFlag()
{
   //--- try select position
   if (!Position().SelectByMagic(SymbolInfo().Name(), m_magic_number))
   {
      //--- selection failed
      m_position_open = false;
      return true;
   }
   //--- test volume
   if (Position().Volume() == 0)
   {
      //--- volume is zero
      m_position_open = false;
      return true;
   }
   //--- position is open
   m_position_open = true;
   //--- operation succeed
   return true;
}

bool CExpertTrader::Profit(double &profit, double &pips)
{
   //--- check if any position is open
   if (IsPositionOpen())
   {
      //--- check if real profit flag is active
      if (m_lastOrderParameters.UseRealProfit())
      {
         if (m_lastOrderParameters.PositionType() == POSITION_TYPE_BUY)
         {
            //--- calculate real profit to buy position
            profit = (SymbolInfo().Bid() - Position().PriceOpen()) / SymbolInfo().TickSize() * SymbolInfo().TickValue() * Position().Volume();
         }
         else
         {
            //--- calculate real profit to sell position
            profit = -(SymbolInfo().Ask() - Position().PriceOpen()) / SymbolInfo().TickSize() * SymbolInfo().TickValue() * Position().Volume();
         }
      }
      else
      {
         //--- set profit from position calculation
         profit = Position().Profit();
      }
   }
   else
   {
      //--- update history
      HistorySelect(m_time_init, TimeCurrent());
      //--- select deal
      if (!Deal().SelectByIndex(HistoryDealsTotal() - 1))
      {
#ifdef __DEBUG Print("Could not fetch deal profit"); #endif
         //--- operation failed
         return false;
      }
      //--- move profit
      profit = Deal().Profit();
   }
   //--- move pips
   pips = profit / SymbolInfo().TickValue() / (Position().Volume() == 0 ? 1 : Position().Volume());
   //--- operation succeed
   return true;
}

//--- open long routine
bool CExpertTrader::OpenLong(COrderParameters &t_order_parameters)
{
   return Open(ORDER_TYPE_SELL, t_order_parameters);
}

//--- open short routine
bool CExpertTrader::OpenShort(COrderParameters &t_order_parameters)
{
   return Open(ORDER_TYPE_BUY, t_order_parameters);
}

//--- open routine
bool CExpertTrader::Open(ENUM_ORDER_TYPE t_order_type, COrderParameters &t_order_parameters)
{
   //--- test if position is already open
   if ((m_lastOrderParameters.OnePerBar() &&
        m_lastOrderParameters.BarIdentification() == iBars(SymbolInfo().Name(), Timeframe())))
   {
      // quit
      return true;
   }
   //--- test if order type is supported
   if (!(t_order_type == ORDER_TYPE_BUY ||
         t_order_type == ORDER_TYPE_SELL))
   {
#ifdef __DEBUG___ Print("Order ", t_order_type, " type is not supported"); #endif
      //--- order type is not supported
      return false;
   }
   //--- set order type
   t_order_parameters.OrderType(t_order_type);
   //--- set bar id
   t_order_parameters.BarIdentification(iBars(SymbolInfo().Name(), Timeframe()));
   //--- set deviation
   Trade().SetDeviationInPoints(t_order_parameters.Deviation());
   //--- check if price is valid
   if (t_order_parameters.Price() == 0)
   {
      //--- resolve price
      t_order_parameters.Price(t_order_parameters.PositionType() == POSITION_TYPE_SELL ? SymbolInfo().Bid() : SymbolInfo().Ask());
   }
   if (!Trade().PositionOpen(
           SymbolInfo().Name(), t_order_parameters.OrderType(), t_order_parameters.Volume(), 0,
           t_order_parameters.Sl() == 0 ? 0 : t_order_parameters.Price() + (MathAbs(t_order_parameters.Sl()) * SymbolInfo().TickSize() * (t_order_parameters.PositionType() == POSITION_TYPE_SELL ? 1 : -1)),
           t_order_parameters.Tp() == 0 ? 0 : t_order_parameters.Price() + (MathAbs(t_order_parameters.Tp()) * SymbolInfo().TickSize() * (t_order_parameters.PositionType() == POSITION_TYPE_SELL ? -1 : 1))))
   {
#ifdef __DEBUG__ Print("Trade open validation error"); #endif
      //--- operation failed
      return false;
   }
   //--- test retcode
   if (Trade().ResultRetcode() != TRADE_RETCODE_DONE)
   {
#ifdef __DEBUG__ Print("Return code ", Trade().ResultRetcode(), " is not valid"); #endif
      //--- operation failed
      return false;
   }
   //--- last parameters
   m_lastOrderParameters = t_order_parameters;
   //--- set position open flag
   UpdateIsPositionOpenFlag();
   //--- emit event
   Events().Emit(CEXPERT_TRADER_EVENT_ONOPEN);
   if (t_order_parameters.OrderType() == ORDER_TYPE_SELL)
   {
      Events().Emit(CEXPERT_TRADER_EVENT_ONOPENLONG);
   }
   else
   {
      Events().Emit(CEXPERT_TRADER_EVENT_ONOPENSHORT);
   }
   //--- operation succeed
   return true;
}

//--- close routine
bool CExpertTrader::Close()
{
   //--- close position
   if (!Trade().PositionClose(SymbolInfo().Name()))
   {
#ifdef __DEBUG__ Print("Trader Close validation error"); #endif
      //--- operation failed
      return false;
   }
   //--- test retcode
   if (Trade().ResultRetcode() != TRADE_RETCODE_DONE)
   {
#ifdef __DEBUG__ Print("Retcode ", Trade().ResultRetcode(), " is not valid"); #endif
      //--- operation failed
      return false;
   }
   //--- set position open flag
   UpdateIsPositionOpenFlag();
   //--- var to store profit
   double profitValue, profitPips;
   //--- store short flag
   bool shortPosition = Trade().RequestType() % 2 == 0;
   //--- emit event
   Events().Emit(CEXPERT_TRADER_EVENT_ONCLOSE);
   //--- if short
   if (shortPosition)
   {
      //--- emit event
      Events().Emit(CEXPERT_TRADER_EVENT_ONCLOSESHORT);
   }
   //--- else long
   else
   {
      //--- emit event
      Events().Emit(CEXPERT_TRADER_EVENT_ONCLOSELONG);
   }
   //--- get profit
   Profit(profitValue, profitPips);
   //--- on profit
   if (profitValue > 0)
   {
      //--- emit event
      Events().Emit(CEXPERT_TRADER_EVENT_ONPROFIT);
      //--- test loss type
      if (shortPosition)
      {
         //--- emit buy loss type
         Events().Emit(CEXPERT_TRADER_EVENT_ONPROFITSHORT);
      }
      else
      {
         //--- emit buy loss type
         Events().Emit(CEXPERT_TRADER_EVENT_ONPROFITLONG);
      }
   }
   else
       //--- on loss
       if (profitValue < 0)
   {
      //--- emit event
      Events().Emit(CEXPERT_TRADER_EVENT_ONLOSS);
      //--- test loss type
      if (shortPosition)
      {
         //--- emit buy loss type
         Events().Emit(CEXPERT_TRADER_EVENT_ONLOSSSHORT);
      }
      else
      {
         //--- emit buy loss type
         Events().Emit(CEXPERT_TRADER_EVENT_ONLOSSLONG);
      }
   }
   //--- operation succeed
   return true;
}

#endif
//+------------------------------------------------------------------+
