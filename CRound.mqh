//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_ROUND__
#define __C_ROUND__

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRound: public CTrade
  {
private:
   bool              m_opened;
   bool              m_closed;
   bool              m_error;
   double            m_ask;
   double            m_ask_last;
   double            m_bid;
   double            m_bid_last;
   double            m_price;
   double            m_price_last;
   double            m_profit;
   double            m_volume;
   double            m_tp;
   double            m_sl;
   ENUM_ORDER_TYPE   m_type;

public:
                     CRound()
     {
     }

   inline void       OpenOrder(const bool t_buy, const double t_volume, const double t_price, const double t_tp, const double t_sl)
     {
      if(PositionOpen(
            _Symbol,
            t_buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL,
            t_volume, t_buy ? Ask() : Bid(), 0, 0,
            "EA " + t_price + " - " + (t_tp) + " - " + (t_sl)))
        {
         if(ResultRetcode() == TRADE_RETCODE_DONE)
           {
            m_volume = t_volume;
            m_type = t_buy ? ORDER_TYPE_BUY_LIMIT : ORDER_TYPE_SELL_LIMIT;
            m_sl = t_sl;
            m_tp = t_tp;
            m_opened  = true;
           }
         else
            m_error = true;
        }
      else
         m_error  = true;
     }

   inline bool       OrderIsOpen(void)  const
     {
      return m_opened && !OrderIsClosed();
     }

   inline bool       OrderIsClosed(void) const
     {
      return m_closed;
     }

   inline bool       OrderError(void) const
     {
      return m_error;
     }

   inline double     Ask(void) const
     {
      return m_ask;
     }

   inline void       CalculateAsk(void)
     {
      m_ask_last = m_ask;
      m_ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
     }

   inline double     AskChange(void) const
     {
      return LastAsk() - Ask();
     }

   inline double     LastAsk(void) const
     {
      return m_ask_last;
     }

   inline double     Bid(void) const
     {
      return m_bid;
     }

   inline void       CalculateBid(void)
     {
      m_bid_last = m_bid;
      m_bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
     }

   inline double     LastBid(void) const
     {
      return m_bid_last;
     }

   inline double     BidChange(void) const
     {
      return LastBid() - Bid();
     }

   inline double     Profit(void) const
     {

      if(OrderIsOpen())
        {
         HistorySelect(0, TimeCurrent());
         ulong ticket = HistoryOrderGetTicket(HistoryOrdersTotal() - 1);

         if(m_type == 2)
           {
            //return (Price() - HistoryOrderGetDouble(ticket, ORDER_PRICE_OPEN)) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) * m_volume;
            return (Bid() - HistoryOrderGetDouble(ticket, ORDER_PRICE_OPEN)) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) * m_volume;
           }

         if(m_type == 3)
           {
            //return (HistoryOrderGetDouble(ticket, ORDER_PRICE_OPEN) - Price()) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) * m_volume;
            return -(Ask() - HistoryOrderGetDouble(ticket, ORDER_PRICE_OPEN)) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) * m_volume;
           }
        }

      if(OrderIsClosed())
         return m_profit;

      return 0;
     }

   inline void       ResolveClose(void)
     {
      if(OrderIsOpen())
        {
         double profit = Profit();
         
         double profit_ticks = profit / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE) / m_volume;
         bool tp = profit_ticks >= m_tp;
         bool sl = profit_ticks <= -m_sl;

         m_profit = profit;

         if(tp || sl)
           {
            HistorySelect(0, TimeCurrent());

            if(PositionClose(HistoryOrderGetTicket(HistoryOrdersTotal() - 1), 0))
              {
               if(ResultRetcode() == TRADE_RETCODE_DONE)
                 {
                  m_profit = profit;
                  m_closed  = true;
                 }
              }
           }
        }
     }

   inline double     Price(void) const
     {
      return m_price;
     }

   inline void       CalculatePrice()
     {
      m_price_last = m_price;
      m_price = SymbolInfoDouble(Symbol(), SYMBOL_LAST);
     }

   inline double     LastPrice(void) const
     {
      return m_price_last;
     }

   inline double     PriceChange() const
     {
      return m_price - m_price_last;
     }

   inline string     State() const
     {
      if(OrderError())
         return "Error";

      if(OrderIsOpen())
         return "Open";

      if(OrderIsClosed())
         return "Closed";

      return "Standy-By";
     }

   inline ENUM_ORDER_TYPE type() const
     {
      return m_type;
     }
  };

#endif
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
