//+------------------------------------------------------------------+
//|                                                           CState |
//|                                 Copyright 2021, Leonardo Marinho |
//|                         https://github.com/dev-marinho/mql5-lib  |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "1.0"

#ifndef __C_STATE__
#define __C_STATE__

#include <Arrays\ArrayObj.mqh>

//+------------------------------------------------------------------+
//| State class                                                      |
//+------------------------------------------------------------------+
template <typename T>
class CState : CObject
  {
protected:
   //--- state
   T                 m_state;

public:
   //--- constructor
                     CState();
   //--- constructor
                     CState(T &);

   //--- get state
   virtual T         state();
   //--- set state
   virtual void      state(T);
   //--- set state
   virtual void      state(T&);
  };


//+------------------------------------------------------------------+
//| constructor                                                      |
//+------------------------------------------------------------------+
template <typename T> CState::CState()
  {
  }
//+------------------------------------------------------------------+
//| constructor                                                      |
//+------------------------------------------------------------------+
template <typename T> CState::CState(T t_initial_state)
   :  m_state(t_initial_state)
  {
  }
//+------------------------------------------------------------------+
//| get state                                                        |
//+------------------------------------------------------------------+
template <typename T> T CState::state()
  {
//--- return state
   return m_state;
  }
//+------------------------------------------------------------------+
//| set state                                                        |
//+------------------------------------------------------------------+
template <typename T> void CState::state(T t_state)
  {
//--- move new state
   m_state = t_state;
  }
//+------------------------------------------------------------------+
//| set state                                                        |
//+------------------------------------------------------------------+
template <typename T> void CState::state(T& t_state)
  {
//--- move new state
   m_state = t_state;
  }

#endif
//+------------------------------------------------------------------+
