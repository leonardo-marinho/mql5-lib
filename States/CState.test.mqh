//+------------------------------------------------------------------+
//|                                                       CStateTest |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+

#include <mql5-lib\UnitTest\CUnitTest.mqh>
#include <mql5-lib\States\CState.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CStateTestScene1()
  {
   CState<int> StateHolder;
   return CTEST_EXITCODE_SUCCESS;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CStateTestScene2()
  {
   CState<ENUM_APPLIED_PRICE> StateHolder(PRICE_CLOSE);
   if(StateHolder.state() != PRICE_CLOSE)
      return CTEST_EXITCODE_FAIL;
   return CTEST_EXITCODE_SUCCESS;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CStateTestScene3()
  {
   CState<ENUM_POSITION_TYPE> StateHolder();
   StateHolder.state(POSITION_TYPE_BUY);
   if(StateHolder.state() != POSITION_TYPE_BUY)
      return CTEST_EXITCODE_FAIL;
   return CTEST_EXITCODE_SUCCESS;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CStateTest()
  {
//--- unit test instance
   CUnitTest Tester("CState class");
//--- add sub test
   Tester.describe(new CTest("Constructor", CStateTestScene1));
//--- add sub test
   Tester.describe(new CTest("Initial state", CStateTestScene2));
//--- add sub test
   Tester.describe(new CTest("Set and get state", CStateTestScene2));
//--- test all
   Tester.testAll();
  }
//+------------------------------------------------------------------+
