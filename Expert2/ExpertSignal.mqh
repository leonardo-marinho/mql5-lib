#ifndef __C__EXPERT_SIGNAL__
#define __C__EXPERT_SIGNAL__

#include <Indicators/Indicators.mqh>
#include <mql5-lib/Expert2/ExpertBase.mqh>

class CExpertSignal : public CExpertBase
{
protected:
   //--- indicators array
   CIndicators *m_indicators;

public:
   //--- constructor
   CExpertSignal();
   //--- destructor
   ~CExpertSignal();

   //--- init routine
   virtual bool Init();
   //--- tick routine
   virtual bool Tick();

   // long open conditional
   virtual bool LongOpenConditional();
   // short open conditional
   virtual bool ShortOpenConditional();

   // long close conditional
   virtual bool LongCloseConditional();
   // short close conditional
   virtual bool ShortCloseConditional();
   // general close conditional
   virtual bool GeneralCloseConditional();
};

CExpertSignal::CExpertSignal()
{
}

CExpertSignal::~CExpertSignal()
{
   delete m_indicators;
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

bool CExpertSignal::LongOpenConditional()
{
   return false;
}

bool CExpertSignal::ShortOpenConditional()
{
   return false;
}

bool CExpertSignal::LongCloseConditional()
{
   return false;
}

bool CExpertSignal::ShortCloseConditional()
{
   return false;
}

bool CExpertSignal::GeneralCloseConditional()
{
   return false;
}

#endif
//+------------------------------------------------------------------+
