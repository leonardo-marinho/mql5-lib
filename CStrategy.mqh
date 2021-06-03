//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_STRATEGY__
#define __C_STRATEGY__

#include "CCampaign.mqh"
#include "CInterface.mqh"

#define _DEBUG_VIRTUAL_METHODS false

input double         VOLUMES = 2;
input double         TP_TICK = 1;
input double         SL_TICK = 3;
input double         GAIN_LIMIT = 125;
input double         LOSS_LIMIT = 50;
input double         FEES = 2.68;
input int            HOUR_START = 10;
input double         MINUTE_START = 0;
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
   CInterface        Interface;
   virtual void      OnInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnInit"); }
   virtual void      OnDeInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDeInit"); }
   virtual void      OnDone(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDone"); }
   virtual void      OnOrderError(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnOrderError"); }
   virtual void      OnRoundInit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnRoundInit"); }
   virtual void      OnTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnTick"); }
   virtual void      OnValidTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnValidTick"); }
   virtual void      OnFirstIdleTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnFirstIdleTick"); }
   virtual void      OnIdleTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnIdleTick"); }
   virtual void      OnPositionTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnPositionTick"); }
   virtual void      OnDealTick(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnDealTick"); }
   virtual void      OnProfit(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnProfit"); }
   virtual void      OnLoss(void) { if(_DEBUG_VIRTUAL_METHODS) Print("Event OnLoss"); }
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
      Interface.AddLabel("Campaign");
      Interface.AddLabel("Total", "0.0");
      Interface.AddLabel("Earns", "0.0");
      Interface.AddLabel("Fees", "0.0");
      Interface.AddLabel("Rounds", "0");
      Interface.AddLabel("Highest Profit", "0.0");
      Interface.AddLabel("Lowest Profit", "0.0");
      Interface.AddLabel("Start Time", "--:--:--");
      Interface.AddLabel("Actual Time", "--:--:--");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Round");
      Interface.AddLabel("Profit", "0.0");
      Interface.AddLabel("Price", "0.0");
      Interface.AddLabel("Ask", "0.0");
      Interface.AddLabel("Bid", "0.0");
      Interface.AddLabel("State", "----");
      Interface.AddLabel("");
      Interface.AddLabel("Strategy");
      Interface.AddLabel("Rate", "0.0");
      OnInit();
      RoundInit();
     }

   inline void       DeInit(void)
     {
      OnDeInit();
     }

   inline void       Tick(void)
     {
      const bool out_of_time = OutOfTime();
      const bool order_is_open = Round.OrderIsOpen();
      const bool order_is_closed = Round.OrderIsClosed();
      const bool order_is_done = LimitReached();
      const bool order_is_error = Round.OrderError();

      Round.CalculateValues();

      OnTick();
      Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 8);
      Interface.SetLabelData(State(), 9);

      if(!out_of_time)
        {
         OnValidTick();
         Interface.SetLabelData(State(), 9);
         Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
         Interface.SetLabelData("R$ " + DoubleToString(Round.Price(), 2), 13);
         Interface.SetLabelData("R$ " + DoubleToString(Round.Ask(), 2), 14);
         Interface.SetLabelData("R$ " + DoubleToString(Round.Bid(), 2), 15);
         Interface.SetLabelData(Round.State(), 16);
        }

      if(!order_is_open && !order_is_closed && !order_is_error && !order_is_done && !out_of_time)
        {
         if(m_first_idle_tick)
           {
            m_first_idle_tick = false;
            OnFirstIdleTick();
            Interface.SetLabelData(TimeToString(TimeCurrent(), TIME_SECONDS), 7);
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
               Round.SetExpertMagicNumber(4444);
               Round.SetDeviationInPoints(0);
               Round.SetTypeFilling(ORDER_FILLING_FOK);
               Round.SetMarginMode();
               Round.LogLevel(0);
               Interface.SetLabelData(State(), 9);
              }
            else
               if(order_is_open)
                 {
                  OnPositionTick();
                  Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
                  Round.ResolveClose();
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

                     if(LastWasProfit())
                        OnProfit();
                     else
                        OnLoss();

                     OnDealTick();
                     Interface.SetLabelData("R$ " + DoubleToString(Total(), 2), 1);
                     Interface.SetLabelData("R$ " + DoubleToString(Earns(), 2), 2);
                     Interface.SetLabelData("R$ " + DoubleToString(Fees(), 2), 3);
                     Interface.SetLabelData(Rounds(), 4);
                     Interface.SetLabelData("R$ " + DoubleToString(HighestProfit(), 2), 5);
                     Interface.SetLabelData("R$ " + DoubleToString(LowestProfit(), 2), 6);
                     Interface.SetLabelData("R$ " + DoubleToString(Round.Profit(), 2), 12);
                     Interface.SetLabelData(DoubleToString(ProfitRounds() / (double)Rounds() * 100, 2) + "%", 19);
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
