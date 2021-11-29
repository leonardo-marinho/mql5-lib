#ifndef __C__EXPERT_TRADER__
#define __C__EXPERT_TRADER__

#include <mql5-lib/Expert2/ExpertBase.mqh>

class CExpertTrader : public CExpertBase
{
public:
   //--- constructor
   CExpertTrader();

   //--- init routine
   bool Init();
   //--- tick routine
   bool Tick();
};

CExpertTrader::CExpertTrader()
{
}

bool CExpertTrader::Init()
{
   return true;
}

bool CExpertTrader::Tick()
{
   return true;
}

#endif
//+------------------------------------------------------------------+
