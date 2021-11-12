//+------------------------------------------------------------------+
//|                                                       Reader.mq5 |
//|                                                 Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_READER_BASE
#define __C_READER_BASE

#include <mql5-lib\Bar\Bar.mqh>
#include <Object.mqh>

//+------------------------------------------------------------------+
//| Bollinger Bands Reader                                           |
//+------------------------------------------------------------------+
class CReaderBase : public CObject
  {
protected:
   //--- Timeframe
   ENUM_TIMEFRAMES   m_timeframe;
   
   //--- CBar instance
   CBar              Bar;

   //--- Symbol name
   string            m_symbolName;

public:
   //--- Constructor
                     CReaderBase(string, ENUM_TIMEFRAMES);
   //--- Destructor
                    ~CReaderBase();

  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CReaderBase::CReaderBase(string t_symbolName, ENUM_TIMEFRAMES t_timeframe)
   : m_symbolName(t_symbolName),
     m_timeframe(t_timeframe),
     Bar(t_symbolName, t_timeframe)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CReaderBase::~CReaderBase(void)
  {
  }
#endif
//+------------------------------------------------------------------+
