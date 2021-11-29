#ifndef __C__EXPERT_SIGNAL__
#define __C__EXPERT_SIGNAL__

#include <mql5-lib/Expert2/ExpertBase.mqh>

class CExpertSignal : public CExpertBase
{
public:
   //--- constructor
   CExpertSignal();

   //--- init routine
   bool Init();
   //--- tick routine
   bool Tick();
};

CExpertSignal::CExpertSignal()
{
}

bool CExpertSignal::Init()
{
   return true;
}

bool CExpertSignal::Tick()
{
   return true;
}

#endif
//+------------------------------------------------------------------+
