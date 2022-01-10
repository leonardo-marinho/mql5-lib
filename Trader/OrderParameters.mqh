//--- file define
#ifndef __C__ORDER_PARAMETERS__
#define __C__ORDER_PARAMETERS__
//--- file includes
#include <Object.mqh>

//--- expert order parameters class
class COrderParameters : public CObject
{
private:
   //--- Bar identification
   int m_bar_identification;
   //--- Max price deviation
   long m_deviation;
   //--- Prohibit another open at the same bar
   bool m_one_per_bar;
   //--- Suggested price
   double m_price;
   //--- Take profit value
   double m_tp;
   //--- Stop loss value
   double m_sl;
   //--- Volume to operate
   double m_volume;
   //--- Calculate real profit
   bool m_useRealProfit;
   //--- Order type
   ENUM_ORDER_TYPE m_orderType;
   //--- Position type
   ENUM_POSITION_TYPE m_positionType;

public:
   //--- Constructor
   COrderParameters()
       : m_bar_identification(0),
         m_deviation(0),
         m_one_per_bar(false),
         m_price(0),
         m_tp(0),
         m_sl(0),
         m_volume(1),
         m_useRealProfit(false)
   {
   }

   //--- Get bar identification
   int BarIdentification(void) { return m_bar_identification; }
   //--- Set bar identification
   void BarIdentification(int t_bar_identification) { m_bar_identification = t_bar_identification; }
   //--- Get max price deviation
   long Deviation(void) { return m_deviation; }
   //--- Set max price deviation
   void Deviation(long t_deviation) { m_deviation = t_deviation; }
   //--- Get prohibit another open at the same bar
   bool OnePerBar(void) { return m_one_per_bar; }
   //--- Set prohibit another open at the same bar
   void OnePerBar(bool t_one_per_bar) { m_one_per_bar = t_one_per_bar; }
   //--- Get suggested price
   double Price(void) { return m_price; }
   //--- Set suggested price
   void Price(double t_price) { m_price = t_price; }
   //--- Get take profit value
   double Tp(void) { return m_tp; }
   //--- Set take profit value
   void Tp(double t_tp) { m_tp = t_tp; }
   //--- Get stop loss value
   double Sl(void) { return m_sl; }
   //--- Set stop loss value
   void Sl(double t_sl) { m_sl = t_sl; }
   //--- Get volume to operate
   double Volume(void) { return m_volume; }
   //--- Set volume to operate
   void Volume(double t_volume) { m_volume = t_volume; }
   //--- Get calculate real profit
   bool UseRealProfit(void) { return m_useRealProfit; }
   //--- Set calculate real profit
   void UseRealProfit(bool t_use_real_profit) { m_useRealProfit = t_use_real_profit; }
   //--- Get order type
   ENUM_ORDER_TYPE OrderType(void) { return m_orderType; }
   //--- Set order type
   void OrderType(ENUM_ORDER_TYPE t_order_type) { m_orderType = t_order_type; }
   //--- Get position type
   ENUM_POSITION_TYPE PositionType(void) { return OrderType() % 2 == 0 ? POSITION_TYPE_BUY : POSITION_TYPE_SELL; }
};

#endif
//+------------------------------------------------------------------+
