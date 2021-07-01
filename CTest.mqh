//+------------------------------------------------------------------+
//|                                                            CTest |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "1.0"

#ifndef __C_TEST__
#define __C_TEST__

#include <Object.mqh>

//--- enum ctest class exit codes
enum ENUM_CTEST_EXITCODE
  {
   CTEST_EXITCODE_UNKNOWN = 10001,
   CTEST_EXITCODE_SUCCESS,
   CTEST_EXITCODE_FAIL,
   CTEST_EXITCODE_TIMEOUT
  };

//+------------------------------------------------------------------+
//| Test class                                                       |
//+------------------------------------------------------------------+
class CTest : public CObject
  {
protected:
   //--- test function type
   typedef             ENUM_CTEST_EXITCODE(*Func)();

   //--- name
   string              m_name;
   //--- function
   Func                m_function;
   //--- timeout in ms
   ulong               m_timeout;
   //--- test duration
   ulong               m_duration;
   //--- exit code
   ENUM_CTEST_EXITCODE m_exitCode;

public:
   //--- constructor
                     CTest(string, Func, ulong);

   //--- test
   bool              run();

   //--- get name
   string            name();
   //--- get test duration
   ulong             duration();
   //--- get timeout
   ulong               timeout();
   //--- get was tested
   bool              tested();
   //--- get result of test
   bool              result();
   //--- get exit code
   ENUM_CTEST_EXITCODE               exitCode();

  };

//+------------------------------------------------------------------+
//| constructor                                                      |
//+------------------------------------------------------------------+
CTest::CTest(string t_name, Func t_function, ulong t_timeout = 0)
   : m_name(t_name),
     m_function(t_function),
     m_timeout(t_timeout),
     m_duration(0),
     m_exitCode(CTEST_EXITCODE_UNKNOWN)
  {
  }
//+------------------------------------------------------------------+
//| test                                                             |
//+------------------------------------------------------------------+
bool              CTest::run()
  {
//--- start counter
   ulong startTimeMs = GetMicrosecondCount();
//--- store exit code
   m_exitCode = m_function();
//--- set duration
   m_duration = GetMicrosecondCount() - startTimeMs;
//--- test if timed out
   if(m_timeout != 0 && m_duration > m_timeout)
     {
      //--- set exit code
      m_exitCode = CTEST_EXITCODE_TIMEOUT;
     }
//--- operation succeed
   return true;
  }
//+------------------------------------------------------------------+
//| get name                                                         |
//+------------------------------------------------------------------+
string            CTest::name()
  {
//--- return name
   return m_name;
  }
//+------------------------------------------------------------------+
//| get test duration                                                |
//+------------------------------------------------------------------+
ulong             CTest::duration()
  {
//--- return duration
   return m_duration;
  }
//+------------------------------------------------------------------+
//| get timeout                                                      |
//+------------------------------------------------------------------+
ulong               CTest::timeout()
  {
//--- return timeout value
   return m_timeout;
  }
//+------------------------------------------------------------------+
//| get was tested                                                   |
//+------------------------------------------------------------------+
bool              CTest::tested()
  {
//--- return if test succeed or not
   return m_exitCode != CTEST_EXITCODE_UNKNOWN;
  }
//+------------------------------------------------------------------+
//| get result of test                                               |
//+------------------------------------------------------------------+
bool              CTest::result()
  {
//--- return if test succeed or not
   return m_exitCode == CTEST_EXITCODE_SUCCESS;
  }
//+------------------------------------------------------------------+
//| get exit code                                                    |
//+------------------------------------------------------------------+
ENUM_CTEST_EXITCODE CTest::exitCode()
  {
//--- return exit code
   return m_exitCode;
  }

#endif
//+------------------------------------------------------------------+
