//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "CRound.mqh"

input double SCORE_RESET = 0;
input double SCORE_TARGET = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Strategy : public CRound
  {
private:

protected:
   //--- on init event
   virtual void      OnInit();
   //--- on tick event
   virtual void      OnTick();

public:
   //--- open short conditions
   virtual bool      OpenShortCondition(void);
   //--- open short conditions
   virtual bool      OpenLongCondition(void);

   //--- open parameters
   virtual bool      OpenParameters(CRoundOpenParameters& parameters);
  };
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::OnInit(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::OnTick(void)
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::OpenShortCondition(void)
  {
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::OpenLongCondition(void)
  {
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool      Strategy::OpenParameters(CRoundOpenParameters& parameters)
  {
   return false;
  }
//+------------------------------------------------------------------+
