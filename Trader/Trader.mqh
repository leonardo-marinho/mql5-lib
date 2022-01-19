//+------------------------------------------------------------------+
//|                                                       Trader.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__TRADER__
#define __C__TRADER__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Trader/OrderParameters.mqh>
#include <mql5-lib/Routine.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/Trade.mqh>
//+------------------------------------------------------------------+
//| A class to operate orders and positions                          |
//+------------------------------------------------------------------+
class CTrader : public CRoutine
{
protected:
   //--- symbol name
   string m_symbol_name;
   //--- working timefra
   ENUM_TIMEFRAMES m_timeframe;
   //--- Open parameters history
   CArrayObj *m_orders_parameters;
   //--- position info instance
   CPositionInfo *m_position;
   //--- symbol info instance
   CSymbolInfo *m_symbol_info;
   //--- trade instance
   CTrade *m_trade;

   //--- position magic number
   int m_magic_number;

public:
   CTrader(int, string, ENUM_TIMEFRAMES);
   ~CTrader(void);

   //--- routine methods
   bool Init(void);
   bool Deinit(void);

   //--- methods to manage orders
   bool SendOrder(ENUM_ORDER_TYPE, COrderParameters &);

   //--- methods to manage positions
   bool CloseAllPositions(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrader::CTrader(int t_magicNumber, string t_symbol_name, ENUM_TIMEFRAMES t_timeframe)
    : m_magic_number(t_magicNumber),
      m_timeframe(t_timeframe),
      m_symbol_name(t_symbol_name),
      m_position(new CPositionInfo()),
      m_symbol_info(new CSymbolInfo()),
      m_trade(new CTrade()),
      m_orders_parameters(new CArrayObj())

{
   m_trade.SetExpertMagicNumber(m_magic_number);
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrader::~CTrader()
{
   delete m_trade;
   delete m_position;
   delete m_orders_parameters;
}
//+------------------------------------------------------------------+
//| Init routine                                                     |
//+------------------------------------------------------------------+
bool CTrader::Init()
{
   if (!m_symbol_info.Name(m_symbol_name) || !m_symbol_info.RefreshRates())
      return false;
   m_symbol_info.Refresh();
   return true;
}
//+------------------------------------------------------------------+
//| Deinit routine                                                   |
//+------------------------------------------------------------------+
bool CTrader::Deinit()
{
   if (m_position.SelectByMagic(m_symbol_name, m_magic_number) && m_position.Volume() > 0 && !CloseAllPositions())
      return false;
   return true;
}
//+------------------------------------------------------------------+
//| Method to send a new order                                       |
//+------------------------------------------------------------------+
bool CTrader::SendOrder(ENUM_ORDER_TYPE t_order_type, COrderParameters &t_order_parameters)
{
   //--- set order type
   t_order_parameters.OrderType(t_order_type);
   //--- set bar id
   t_order_parameters.BarIdentification(iBars(m_symbol_info.Name(), m_timeframe));
   //--- resolve price
   t_order_parameters.Price(t_order_parameters.PositionType() == POSITION_TYPE_SELL ? m_symbol_info.Bid() : m_symbol_info.Ask());
   //--- set deviation
   m_trade.SetDeviationInPoints(t_order_parameters.Deviation());
   //--- open position
   if (!m_trade.PositionOpen(
           m_symbol_info.Name(), t_order_parameters.OrderType(), t_order_parameters.Volume(), 0,
           t_order_parameters.Sl() == 0 ? 0 : t_order_parameters.Price() + (MathAbs(t_order_parameters.Sl()) * m_symbol_info.TickSize() * (t_order_parameters.PositionType() == POSITION_TYPE_SELL ? 1 : -1)),
           t_order_parameters.Tp() == 0 ? 0 : t_order_parameters.Price() + (MathAbs(t_order_parameters.Tp()) * m_symbol_info.TickSize() * (t_order_parameters.PositionType() == POSITION_TYPE_SELL ? -1 : 1))))
   {
#ifdef __DEBUG__ Print("Trade open validation error"); #endif
      //--- operation failed
      return false;
   }
   //--- test retcode
   if (m_trade.ResultRetcode() != TRADE_RETCODE_DONE)
   {
#ifdef __DEBUG__ Print("Return code ", m_trade.ResultRetcode(), " is not valid"); #endif
      //--- operation failed
      return false;
   }
   //--- operation succeed
   return true;
}
//+------------------------------------------------------------------+
//| Method to close all positions                                    |
//+------------------------------------------------------------------+
bool CTrader::CloseAllPositions()
{
   //--- test if is any position open
   if (!m_position.SelectByMagic(m_symbol_name, m_magic_number) || m_position.Volume() == 0)
      return true;
   //--- close position
   if (!m_trade.PositionClose(m_symbol_info.Name()))
   {
#ifdef __DEBUG__ Print("Trader Close validation error"); #endif
      //--- operation failed
      return false;
   }
   //--- test retcode
   if (m_trade.ResultRetcode() != TRADE_RETCODE_DONE)
   {
#ifdef __DEBUG__ Print("Retcode ", m_trade.ResultRetcode(), " is not valid"); #endif
      //--- operation failed
      return false;
   }
   //--- operation succeed
   return true;
}
#endif
//+------------------------------------------------------------------+
