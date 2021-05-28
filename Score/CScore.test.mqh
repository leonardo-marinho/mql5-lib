//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "CScore.mqh"
#include "../CUnitTest.mqh"

int on_change_count;
int on_max_count;
int on_min_count;
int on_reset_count;
int score_trigger_value;
ENUM_SCORE_TRIGGER_TYPE score_trigger_type;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CScore::OnChange(double current, double prev)
  {
   on_change_count++;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CScore::OnMax()
  {
   on_max_count++;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CScore::OnMin()
  {
   on_min_count++;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CScore::OnTrigger(double value, ENUM_SCORE_TRIGGER_TYPE type)
  {
   score_trigger_value = value;
   score_trigger_type = type;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CScore::OnReset()
  {
   on_reset_count++;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest1()
  {
//--- test 1: constructor
   CScore Score;
//--- expected: nothing
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest2()
  {
//--- test 2: sum new score
//--- expected: returns value passed by argument
//--- CScore instance with typename int as template
   CScore Score;
//--- value that will be passed to sum
   int new_score = 6;
//--- passing new score
   int sum_result = Score.Sum(new_score);
//--- test if sum result is the same that new_score
   return sum_result == new_score ? 0 : 1;
  }

//+------------------------------------------------------------------+
//| test 3: buffer access                                            |
//| expected: returns buffer 0 equal to new_score_1 + new_score_2    |
//| and buffer 1 equal to new_score_1                                |
//+------------------------------------------------------------------+
int CScoreTest3()
  {
//--- CScore instance with typename int as template
   CScore Score;
//--- firs tvalue that will be passed to sum
   int new_score_1 = 6;
//--- passing new score 1
   Score.Sum(new_score_1);
//--- second value that will be passed to sum
   int new_score_2 = 18;
//--- passing new score 2
   Score.Sum(new_score_2);
//--- test buffer values
   if(Score.Buffer(0) == new_score_2 + new_score_1 && Score.Buffer(1) == new_score_1)
      //--- operation succeed, buffer values are ok
      return 0;
//--- operation failed, buffer values are wrong
   return 1;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest4()
  {
//--- CScore instance with typename int as template
   CScore Score;
//--- save old change counter value
   double old_change_counter = on_change_count;
//--- passing new score -10, result -10
   Score.Sum(-10);
//--- testing
   if(old_change_counter + 1 != on_change_count)
      //--- operation failed, buffer values are wrong
      return 1;
//--- operation succeed
   return 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest5()
  {
//--- CScore instance with typename int as template
   CScore Score;
//--- save old min counter value
   double old_min_counter = on_min_count;
//--- save old max counter value
   double old_max_counter = on_max_count;
//--- passing new score -10, result -10
   Score.Sum(-10);
//--- testing
   if(old_min_counter != on_min_count)
      //--- operation failed, buffer values are wrong
      return 1;
//--- passing new score 20, result 10
   Score.Sum(20);
//--- testing
   if(old_max_counter != on_max_count)
      //--- operation failed, buffer values are wrong
      return 2;
//--- passing new score -10, result 0
   Score.Sum(-10);
//--- set score max
   Score.SetMax(10);
//--- set score min
   Score.SetMin(-10);
//--- save old max counter value
   old_max_counter = on_max_count;
//--- save old min counter value
   old_min_counter = on_min_count;
//--- passing new score -10, result -10
   Score.Sum(-10);
//--- testing
   if(old_min_counter + 1 != on_min_count && old_max_counter == on_max_count)
      //--- operation failed, buffer values are wrong
      return 3;
//--- save old max counter value
   old_max_counter = on_max_count;
//--- save old min counter value
   old_min_counter = on_min_count;
//--- passing new score 20, result 10
   Score.Sum(20);
//--- testing
   if(old_max_counter + 1 != on_max_count && old_min_counter == on_min_count)
      //--- operation failed, buffer values are wrong
      return 4;
//--- save old max counter value
   old_max_counter = on_max_count;
//--- save old min counter value
   old_min_counter = on_min_count;
//--- passing new score -5, result 5
   Score.Sum(-5);
//--- testing
   if(old_max_counter != on_max_count || old_min_counter != on_min_count)
      //--- operation failed, buffer values are wrong
      return 5;
//--- operation succeed
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest6()
  {
//--- CScore instance with typename int as template
   CScore Score;
//--- push trigger 2, equal
   Score.PushTrigger(2, SCORE_RANGE_EQUAL);
//--- passing new score 2
   Score.Sum(2);
//--- testing
   if(!(score_trigger_value == 2 && score_trigger_type == SCORE_RANGE_EQUAL))
     {
      //--- operation failed, buffer values are wrong
      return 1;
     }
//--- push trigger 5, equal or higher
   Score.PushTrigger(5, SCORE_RANGE_HIGHER_EQUAL);
//--- passing new score 3, result 5
   Score.Sum(3);
//--- testing
   if(!(score_trigger_value == 5 && score_trigger_type == SCORE_RANGE_HIGHER_EQUAL))
      //--- operation failed, buffer values are wrong
      return 2;
//--- passing new score 1, result 6
   Score.Sum(1);
//--- testing
   if(!(score_trigger_value == 5 && score_trigger_type == SCORE_RANGE_HIGHER_EQUAL))
      //--- operation failed, buffer values are wrong
      return 3;
//--- push trigger 6, higher
   Score.PushTrigger(6, SCORE_RANGE_HIGHER);
//--- passing new score 1, result 7
   Score.Sum(1);
//--- testing
   if(!(score_trigger_value == 6 && score_trigger_type == SCORE_RANGE_HIGHER))
      //--- operation failed, buffer values are wrong
      return 4;
//--- push trigger 0, lower or equal
   Score.PushTrigger(0, SCORE_RANGE_LOWER_EQUAL);
//--- passing new score -7, result 0
   Score.Sum(-7);
//--- testing
   if(!(score_trigger_value == 0 && score_trigger_type == SCORE_RANGE_LOWER_EQUAL))
      //--- operation failed, buffer values are wrong
      return 5;
//--- passing new score -1, result -1
   Score.Sum(-1);
//--- testing
   if(!(score_trigger_value == 0 && score_trigger_type == SCORE_RANGE_LOWER_EQUAL))
      //--- operation failed, buffer values are wrong
      return 6;
//--- push trigger -1, lower
   Score.PushTrigger(-1, SCORE_RANGE_LOWER);
//--- passing new score -1, result -2
   Score.Sum(-1);
//--- testing
   if(!(score_trigger_value == -1 && score_trigger_type == SCORE_RANGE_LOWER))
      //--- operation failed, buffer values are wrong
      return 7;
//--- operation succeed
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CScoreTest7()
  {
//--- CScore instance with typename int as template
   CScore Score;
//--- set score max
   Score.SetMax(10);
//--- set score min
   Score.SetMin(-10);
//--- save old reset counter value
   double old_reset_counter = on_reset_count;
//--- passing new score 10, result 10
   Score.Sum(10);
//--- testing
   if(old_reset_counter + 1 != on_reset_count)
      //--- operation failed, buffer values are wrong
      return 1;
//--- save old reset counter value
   old_reset_counter = on_reset_count;
//--- passing new score -10, result 0
   Score.Sum(-5);
//--- testing
   if(old_reset_counter != on_reset_count)
      //--- operation failed, buffer values are wrong
      return 2;
//--- save old reset counter value
   old_reset_counter = on_reset_count;
//--- passing new score -10, result -10
   Score.Sum(-5);
//--- testing
   if(old_reset_counter + 1 != on_reset_count)
      //--- operation failed, buffer values are wrong
      return 3;
//--- operation succeed
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UnitTest CScoreTest()
  {
//--- unit test to return
   UnitTest unit_test;
//--- set unit test name
   unit_test.name = "CScore class unit test";
//--- reset unit test count
   unit_test.test_count = 0;

//--- test object
   Test test1;
//--- set test name
   test1.name = "Constructor";
//--- set test function
   test1.test_func = CScoreTest1;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test1;

//--- test object
   Test test2;
//--- set test name
   test2.name = "Sum new score";
//--- set test function
   test2.test_func = CScoreTest2;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test2;

//--- test object
   Test test3;
//--- set test name
   test3.name = "Buffer access";
//--- set test function
   test3.test_func = CScoreTest3;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test3;

//--- test object
   Test test4;
//--- set test name
   test4.name = "OnChange event";
//--- set test function
   test4.test_func = CScoreTest4;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test4;

//--- test object
   Test test5;
//--- set test name
   test5.name = "Max and Min events";
//--- set test function
   test5.test_func = CScoreTest5;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test5;

//--- test object
   Test test6;
//--- set test name
   test6.name = "OnTrigger events";
//--- set test function
   test6.test_func = CScoreTest6;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test6;

//--- test object
   Test test7;
//--- set test name
   test7.name = "OnReset event";
//--- set test function
   test7.test_func = CScoreTest7;
//--- push to unit test array of tests
   unit_test.tests[unit_test.test_count++] = test7;

//--- return unit test object
   return unit_test;
  }
//+------------------------------------------------------------------+
