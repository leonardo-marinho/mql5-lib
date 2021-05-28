//+------------------------------------------------------------------+
//|                                                        Robot.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#define __DEBUG
#define CONTEXT_TEST

#ifdef CONTEXT_TEST
#include "Tests.mq5"
CUnitTest Context;
#else 
#include "TickReset.mq5"
TickReset Context;
#endif 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Context.Init();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Context.DeInit();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   Context.Tick();
  }
//+------------------------------------------------------------------+