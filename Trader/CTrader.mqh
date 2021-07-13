//+------------------------------------------------------------------+
//|                                                          CTrader |
//|                                 Copyright 2021, Leonardo Marinho |
//|                         https://github.com/dev-marinho/mql5-lib  |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_TRADER
#define __C_TRADER

#include <Object.mqh>

//+------------------------------------------------------------------+
//| Trader class                                                     |
//+------------------------------------------------------------------+
class CTrader : public CObject
  {
public:
   //--- Constructor
                     CTrader();
   //--- Destructor
                    ~CTrader();
  };
  
#endif
//+------------------------------------------------------------------+
