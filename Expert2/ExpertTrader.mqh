//--- file define
#ifndef __C__EXPERT_TRADER__
#define __C__EXPERT_TRADER__
//--- file includes
#include <mql5-lib/Expert2/ExpertBase.mqh>
#include <mql5-lib/Expert2/OrderParameters.mqh>
#include <Trade/DealInfo.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/Trade.mqh>

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

protected:
   //--- deal info instance
   CDealInfo *Deal();
   //--- access array of order parameters instance pointers
   CArrayObj *OrdersParameters();
   //--- position info instance
   CPositionInfo *Position();
   //--- trade instance
   CTrade *Trade();

   bool Open(ENUM_ORDER_TYPE);

public:
   //--- constructor
   CExpertTrader(void);

   //--- init routine
   bool Init(void);
   //--- tick routine
   bool Tick(void);

   //--- open long routine
   bool OpenLong(void);
   //--- open short routine
   bool OpenShort(void);
   //--- close routine
   bool Close(void);
};

CExpertTrader::CExpertTrader()
{
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
   //-- operation success
   return true;
}

bool CExpertTrader::Tick()
{
   return true;
}

//--- open long routine
bool CExpertTrader::OpenLong()
{
   return Open(ORDER_TYPE_SELL);
}

//--- open short routine
bool CExpertTrader::OpenShort()
{
   return Open(ORDER_TYPE_BUY);
}

//--- open routine
bool CExpertTrader::Open(ENUM_ORDER_TYPE t_order_type)
{
   //--- test if order type is supported
   if (!(t_order_type == ORDER_TYPE_BUY ||
         t_order_type == ORDER_TYPE_SELL))
   {
#ifdef __DEBUG__ Print("Order ", t_order_type, " type is not supported"); #endif
      //--- order type is not supported
      return false;
   }
   //--- initialize new instance
   COrderParameters *parameters = new COrderParameters();
   //--- set order type
   parameters.OrderType(t_order_type);
   //--- set bar id
   parameters.BarIdentification(iBars(SymbolInfo().Name(), Timeframe()));
   //--- set deviation
   Trade().SetDeviationInPoints(parameters.Deviation());
   //--- check if price is valid
   if (parameters.Price() == 0)
   {
      //--- resolve price
      parameters.Price(parameters.PositionType() == POSITION_TYPE_SELL ? SymbolInfo().Bid() : SymbolInfo().Ask());
   }
   if (!Trade().PositionOpen(
           SymbolInfo().Name(), parameters.OrderType(), parameters.Volume(), 0,
           parameters.Sl() == 0 ? 0 : parameters.Price() + (MathAbs(parameters.Sl()) * SymbolInfo().TickSize() * (parameters.PositionType() == POSITION_TYPE_SELL ? 1 : -1)),
           parameters.Tp() == 0 ? 0 : parameters.Price() + (MathAbs(parameters.Tp()) * SymbolInfo().TickSize() * (parameters.PositionType() == POSITION_TYPE_SELL ? -1 : 1))))
   {
#ifdef __DEBUG_ Print("Trade validation error"); #endif
      //--- operation failed
      return false;
   }
   //--- test retcode
   if (Trade().ResultRetcode() != TRADE_RETCODE_DONE)
   {
#ifdef __DEBUG_ Print("Return code ", Trade().ResultRetcode(), " is not valid"); #endif
      //--- operation failed
      return false;
   }
   return true;
}

//--- close routine
bool CExpertTrader::Close()
{
   return true;
}

#endif
//+------------------------------------------------------------------+
