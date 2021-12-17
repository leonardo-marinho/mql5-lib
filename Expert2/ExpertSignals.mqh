//--- file define
#ifndef __C__EXPERT_SIGNALS__
#define __C__EXPERT_SIGNALS__
//--- file includes
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Expert2/ExpertBaseWrap.mqh>
#include <mql5-lib/Expert2/ExpertSignal.mqh>
#include <mql5-lib/Expert2/ExpertTrader.mqh>

//--- expert sinals class
class CExpertSignals : public CExpertBaseWrap
{
protected:
  //--- trader pointer
  CExpertTrader *m_trader;

  //--- test close conditions
  bool CheckCloseConditionals(datetime);
  //--- test open conditions
  bool CheckOpenConditionals(datetime);

public:
  //--- init routine
  virtual bool Init(CExpertTrader *t_trader);
  //--- tick routine
  virtual bool Tick(datetime);
};

bool CExpertSignals::CheckCloseConditionals(datetime t_calendar_timer_checkpoint)
{
  //--- test if is position open
  if (!m_trader.IsPositionOpen())
    return false;
  //--- loop through experts
  for (int index = 0; index < Experts().Total(); index++)
  {
    CExpertSignal *signal = Experts().At(index);
    //--- test close conditions
    if (signal.GeneralCloseConditional(t_calendar_timer_checkpoint) || signal.LongCloseConditional(t_calendar_timer_checkpoint) || signal.ShortCloseConditional(t_calendar_timer_checkpoint))
    {
#ifdef __DEBUG_ Print("Close condition met"); #endif
      //--- close position
      m_trader.Close();
      //-- conditional check met
      return true;
    }
  }
  //-- conditional check failed
  return false;
}

bool CExpertSignals::CheckOpenConditionals(datetime t_calendar_timer_checkpoint)
{
  //--- test if is position open
  if (m_trader.IsPositionOpen())
    return false;
  //--- loop through experts
  for (int index = 0; index < Experts().Total(); index++)
  {
    CExpertSignal *signal = Experts().At(index);
    //--- test long open conditional
    if (signal.LongOpenConditional(t_calendar_timer_checkpoint))
    {
      //-- conditional check met
#ifdef __DEBUG_ Print("Open long condition met"); #endif
      //--- get order parameters
      COrderParameters order_parameters;
      signal.OrderParameters(order_parameters);
      m_trader.OpenLong(order_parameters);
      return true;
    }
    //--- test short open conditional
    else if (signal.ShortOpenConditional(t_calendar_timer_checkpoint))
    {
      //-- conditional check met
#ifdef __DEBUG_ Print("Open short condition met"); #endif
      //--- get order parameters
      COrderParameters order_parameters;
      signal.OrderParameters(order_parameters);
      m_trader.OpenShort(order_parameters);
      return true;
    }
  }
  //-- conditional check failed
  return false;
}

bool CExpertSignals::Init(CExpertTrader *t_trader)
{
  //--- set trader pointer
  m_trader = t_trader;
  if (m_trader == NULL)
    return false;
  //--- init signals
  for (int index = 0; index < Experts().Total(); index++)
  {
    CExpertSignal *signal = Experts().At(index);
    if (!signal.Init())
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertSignals::Tick(datetime t_calendar_timer_checkpoint)
{
  //--- check conditionals
  CheckCloseConditionals(t_calendar_timer_checkpoint);
  CheckOpenConditionals(t_calendar_timer_checkpoint);
  //--- tick signals
  for (int index = 0; index < Experts().Total(); index++)
  {
    CExpertSignal *signal = Experts().At(index);
    if (!signal.Tick())
      return false;
  }
  //--- operation succeed
  return true;
}

#endif
//+------------------------------------------------------------------+
