//+------------------------------------------------------------------+
//|                                                      Routine.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__ROUTINE__
#define __C__ROUTINE__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| A routine class                                                  |
//+------------------------------------------------------------------+
class CRoutine : public CObject
{
public:
  //--- routine methods
  virtual bool Init(void) { return true; };
  virtual bool Deinit(void) { return true; };
  virtual bool Tick(void) { return true; };
};
#endif
//+------------------------------------------------------------------+