//+------------------------------------------------------------------+
//|                                                           CTrade |
//|                                 Copyright 2021, Leonardo Marinho |
//|                         https://github.com/dev-marinho/mql5-lib  |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_TRADE
#define __C_TRADE

#include <Object.mqh>

//+------------------------------------------------------------------+
//| Trader class                                                     |
//+------------------------------------------------------------------+
class CTrade : public CObject
  {
public:
   //--- Constructor
                     CTrade();
   //--- Destructor
                    ~CTrade();
  };
  
#endif
//+------------------------------------------------------------------+
