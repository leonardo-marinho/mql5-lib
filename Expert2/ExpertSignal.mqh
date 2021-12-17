#ifndef __C__EXPERT_SIGNAL__
#define __C__EXPERT_SIGNAL__

#include <Indicators/Indicators.mqh>
#include <mql5-lib/Expert2/ExpertBase.mqh>
#include <mql5-lib/Expert2/OrderParameters.mqh>

class CExpertSignal : public CExpertBase
{
private:
   string m_name;

protected:
   //--- indicators array
   CIndicators *m_indicators;

public:
   //--- constructor
   CExpertSignal(string);
   //--- destructor
   ~CExpertSignal();

   //--- init routine
   virtual bool Init();
   //--- tick routine
   virtual bool Tick();

   //--- access signal name
   string Name();

   // long open conditional
   virtual bool LongOpenConditional(datetime);
   // short open conditional
   virtual bool ShortOpenConditional(datetime);

   // long close conditional
   virtual bool LongCloseConditional(datetime);
   // short close conditional
   virtual bool ShortCloseConditional(datetime);
   // general close conditional
   virtual bool GeneralCloseConditional(datetime);

   //--- set order parameters
   virtual void OrderParameters(COrderParameters &) {}
};

CExpertSignal::CExpertSignal(string t_name = "")
    : m_name(t_name)
{
}

CExpertSignal::~CExpertSignal()
{
   delete m_indicators;
}

string CExpertSignal::Name()
{
   return m_name;
}

bool CExpertSignal::Init()
{
   m_indicators = new CIndicators();
   if (m_indicators == NULL)
   {
      return false;
   }
   return true;
}

bool CExpertSignal::Tick()
{
   return true;
}

bool CExpertSignal::LongOpenConditional(datetime t_datetime)
{
   return false;
}

bool CExpertSignal::ShortOpenConditional(datetime t_datetime)
{
   return false;
}

bool CExpertSignal::LongCloseConditional(datetime t_datetime)
{
   return false;
}

bool CExpertSignal::ShortCloseConditional(datetime t_datetime)
{
   return false;
}

bool CExpertSignal::GeneralCloseConditional(datetime t_datetime)
{
   return false;
}

#endif
//+------------------------------------------------------------------+
