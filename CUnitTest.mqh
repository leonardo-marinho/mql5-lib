//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#ifndef __C_UNIT_TEST__
#define __C_UNIT_TEST__

#define MAX_TEST 25
#define MAX_TEST_FUNC 25

typedef           int (*TestFunction)();

struct Test
  {
   string            name;
   TestFunction      test_func;
  };

struct UnitTest
  {
   string            name;
   Test              tests[MAX_TEST_FUNC];
   uint              test_count;
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUnitTest
  {
protected:
   uint              m_unit_test_count;
   UnitTest          m_unit_tests[MAX_TEST];

   bool              RunTest(const uint t_unit_test_index, const uint t_test_index)
     {
      //--- get start time in ms
      long start_ms = (long) PositionGetInteger(POSITION_TIME_MSC) * 1000;
      //--- test return code, expected 1
      int test_retcode = m_unit_tests[t_unit_test_index].tests[t_test_index].test_func();
      //--- get end time in ms
      long end_ms = PositionGetInteger(POSITION_TIME_MSC) * 1000;
      //--- testing test return code
      if(test_retcode == 0)
        {
         //--- print success message
         printf("   ✓   %s (%l ms)", m_unit_tests[t_unit_test_index].tests[t_test_index].name, end_ms - start_ms);
         //--- operation succeed
         return true;
        }
      //--- print fail message
      printf("   ✗   %s (1 ms) 0d%d", m_unit_tests[t_unit_test_index].tests[t_test_index].name, test_retcode);
      //--- operation failed
      return false;
     }

public:
   virtual void      Init();
   virtual void      DeInit() {}
   virtual void      Tick() {}

   bool              Add(UnitTest& t__unit_test)
     {
      //--- check if there is any index available to the new element
      if(m_unit_test_count < MAX_TEST_FUNC)
        {
         //--- moving value to array
         m_unit_tests[m_unit_test_count++] = t__unit_test;
         //--- operation succeed
         return true;
        }
      else
        {
#ifdef __DEBUG printf(__FUNCTION__, " (", __LINE__, "): no index available to add new test. Try increase const MAX_TEST"); #endif
         //--- operation failed, no index available
         return false;
        }
     }

   bool              Run(const int t_index = -1)
     {
      //--- array of booleans that will hold the result of each test
      bool passed[MAX_TEST];
      //--- check if index was passed by argument
      if(t_index < 0)
        {
#ifdef __DEBUG printf(__FUNCTION__, " (", __LINE__, "): index %d  is out of range", t_index); #endif
         //--- operation failed, index is out of range
         return false;
        }
      else
        {
         //--- test if index is a valid index
         if((uint)t_index >= m_unit_test_count)
           {
#ifdef __DEBUG printf(__FUNCTION__, " (", __LINE__, "): index %d  is out of range", t_index); #endif
            //--- operation failed, index is out of range
            return false;
           }
        }
      //--- printing unit test summaries
      printf("  %s #%d", m_unit_tests[t_index].name, t_index);
      //--- test success counter
      uint test_success_count = 0;
      //--- looping through test funcs
      for(uint test_index = 0; test_index < m_unit_tests[t_index].test_count; test_index++)
        {
         //--- run test and check for success
         if(RunTest(t_index, test_index))
           {
            //--- increase test success count
            test_success_count++;
           }
        }
      //--- print unit test result
      printf("  End of tests. %u of %d passed!", test_success_count, m_unit_tests[t_index].test_count);

      //--- operation succeed
      return true;
     }

   void              RunAll()
     {
      //--- check if at least a unit test was added
      if(!(m_unit_test_count > 0))
        {
#ifdef __DEBUG printf(__FUNCTION__, " (", __LINE__, "): no unit test was added. There is nothing to run"); #endif
         return;
        }
      //--- loop through unit tests
      for(uint index = 0; index < m_unit_test_count; index++)
        {
         //--- run unit test
         Run(index);
        }
     }
  };
//+------------------------------------------------------------------+
#endif
//+------------------------------------------------------------------+
