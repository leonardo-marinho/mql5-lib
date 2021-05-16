//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_STRATEGY__
#define __C_STRATEGY__

#include "CCampaign.mqh"

#define _DEBUG_VIRTUAL_METHODS false

input int            TICK_RESET = 4;
input double         VOLUMES = 2;
input double         TP_TICK = 1;
input double         SL_TICK = 3;
input double         GAIN_LIMIT = 125;
input double         LOSS_LIMIT = 50;
input double         FEES = 2.68;
input int            HOUR_START = 9;
input double         MINUTE_START = 1;
input int            HOUR_END = 17;
input double         MINUTE_END = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStrategy: protected CCampaign
  {
private:
   bool              m_first_idle_tick;

   inline void       RoundInit(void)
     {
      NewRound();
      OnRoundInit();
     }

protected:
   virtual void      OnInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnInit"); }
   virtual void      OnDeInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDeInit"); }
   virtual void      OnDone(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDone"); }
   virtual void      OnOrderError(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnOrderError"); }
   virtual void      OnRoundInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnRoundInit"); }
   virtual void      OnTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnTick"); }
   virtual void      OnFirstIdleTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnFirstIdleTick"); }
   virtual void      OnIdleTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnIdleTick"); }
   virtual void      OnPositionTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnPositionTick"); }
   virtual void      OnDealTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDealTick"); }
   virtual void      OnTimeWaiting(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnTimeWaiting"); }
   virtual void      OnTimeUp(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnTimeUp"); }


public:

                     CStrategy()
      :              m_first_idle_tick(true)
     {
     }

   inline void       Init(void)
     {
      LimitLoss(LOSS_LIMIT > 0 ? -LOSS_LIMIT : LOSS_LIMIT);
      LimitGain(GAIN_LIMIT);
      StartTime(HOUR_START, MINUTE_START);
      EndTime(HOUR_END, MINUTE_END);
      OnInit();
      RoundInit();
     }

   inline void       DeInit(void)
     {
      OnDeInit();
     }

   inline void       Tick(void)
     {
      OnTick();

      const bool out_of_time = OutOfTime();
      const bool order_is_open = Round.OrderIsOpen();
      const bool order_is_closed = Round.OrderIsClosed();
      const bool order_is_done = LimitReached();
      const bool order_is_error = Round.OrderError();

      Round.CalculateAsk();
      Round.CalculateLastAsk();
      Round.CalculateBid();
      Round.CalculateLastBid();
      Round.CalculatePrice();
      Round.CalculateLastPrice();

      if(!order_is_open && !order_is_closed && !order_is_error && !order_is_done && !out_of_time)
        {
         if(m_first_idle_tick)
           {
            m_first_idle_tick = false;
            OnFirstIdleTick();
           }

         OnIdleTick();
        }
      else
         if(order_is_done)
           {
            OnDone();
           }
         else
            if(order_is_error)
              {
               OnOrderError();
               RoundInit();
              }
            else
               if(order_is_open)
                 {
                  OnPositionTick();
                 }
               else
                  if(order_is_closed)
                    {
                     CalculateEarns();
                     CalculateFees(FEES);
                     CalculateRounds();
                     CalculateProfitRounds();
                     CalculateLowestProfit();
                     CalculateHighestProfit();
                     OnDealTick();
                     RoundInit();
                    }
                  else
                     if(out_of_time)
                       {
                        if(!CalculateStartTime())
                           OnTimeWaiting();
                        else
                           if(!CalculateEndTime())
                              OnTimeUp();
                       }
     }
  };

#endif
//+------------------------------------------------------------------+
