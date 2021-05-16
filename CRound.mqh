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
   bool              m_error;
   double            m_ask;
   double            m_ask_last;
   double            m_bid;
   double            m_bid_last;
   double            m_price;
   double            m_price_last;

public:
                     CRound()
     {
     }

   inline void       OpenOrder(const bool t_buy, const double t_volume, const double t_price, const double t_tp, const double t_sl)
     {
      const double  sl =  t_sl * SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
      const double  tp = t_tp * SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);

      if(t_buy)
        {
         if(BuyLimit(t_volume, t_price, Symbol(), t_price - sl, t_price + tp, ORDER_TIME_SPECIFIED, TimeTradeServer()+PeriodSeconds(2),
                      "EA " + t_price + " - " + (t_price + sl) + " - " + (t_price - tp)))
           {
            if(ResultRetcode() == TRADE_RETCODE_DONE)
               OrderIsOpen(true);
           }
         else
            m_error = true;
        }
      else
         if(SellLimit(t_volume, t_price, Symbol(), t_price + sl, t_price - tp, ORDER_TIME_SPECIFIED, TimeTradeServer()+PeriodSeconds(2),
                      "EA " + t_price + " - " + (t_price + sl) + " - " + (t_price - tp)))
           {
            if(ResultRetcode() == TRADE_RETCODE_DONE)
               OrderIsOpen(true);
           }
         else
            m_error = true;
     }

   inline void       OrderIsOpen(const bool t_opened)
     {
      m_opened = t_opened;
     }

   inline bool       OrderIsOpen(void)  const
     {
      return m_opened && !OrderIsClosed();
     }

   inline bool       OrderIsClosed() const
     {
      HistorySelect(0, TimeCurrent());
      return ResultOrder() != 0 && HistoryOrdersTotal() > 1 && ResultOrder() == HistoryOrderGetTicket(HistoryOrdersTotal() - 2);
     }

   inline bool       OrderError(void) const
     {
      return m_error;
     }

   inline double     Ask(void) const
     {
      return m_ask;
     }

   inline void       CalculateAsk()
     {
      m_ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
     }

   inline double     LastAsk(void)
     {
      return m_ask_last;
     }

   inline void       CalculateLastAsk(void)
     {
      m_ask_last = m_ask;
     }

   inline double     Bid(void) const
     {
      return m_bid;
     }

   inline void       CalculateBid(void)
     {
      m_bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
     }

   inline double     LastBid(void) const
     {
      return m_bid_last;
     }

   inline void       CalculateLastBid()
     {
      m_bid_last = m_bid;
     }

   inline double     Price(void) const
     {
      return m_price;
     }

   inline void       CalculatePrice()
     {
      m_price = SymbolInfoDouble(Symbol(), SYMBOL_LAST);
     }

   inline double     LastPrice(void) const
     {
      return m_price_last;
     }

   inline void       CalculateLastPrice()
     {
      m_price_last = m_price;
     }
     
     inline double PriceLastChange() const  {
      return SymbolInfoDouble(Symbol(), SYMBOL_PRICE_CHANGE);
     }
     
     inline double PriceLastVolatility() const {
      return SymbolInfoDouble(Symbol(), SYMBOL_PRICE_VOLATILITY);
     }
     
     inline string State() const {
      if (OrderError())
         return "Error";
      
      if (OrderIsOpen())
         return "Open";
         
      if (OrderIsClosed())
         return "Closed";  
         
      return "Standy-By";    
     }
  };

#endif
//+------------------------------------------------------------------+
