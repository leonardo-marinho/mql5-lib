//+------------------------------------------------------------------+
//|                                                       CStateTest |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+

#include <mql5-lib\CUnitTest.mqh>
#include <mql5-lib\Expert\CExpert.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CExpertTestScene1()
  {
   CExpert* Expert = new CExpert(_Symbol, _Period, 444);
   return CTEST_EXITCODE_SUCCESS;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CExpertTestScene2()
  {
   CExpert* Expert = new CExpert(_Symbol, _Period, 444);
   if(!Expert.Init() || !Expert.DeInit())
     {
      return CTEST_EXITCODE_FAIL;
     }
   return CTEST_EXITCODE_SUCCESS;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CExpertTest()
  {
//--- unit test instance
   CUnitTest Tester("CState class");
//--- add sub test
   Tester.describe(new CTest("Constructor", CExpertTestScene1));
//--- add sub test
   Tester.describe(new CTest("Init/Deinit method", CExpertTestScene2));
//--- test all
   Tester.testAll();
  }

//+------------------------------------------------------------------+
