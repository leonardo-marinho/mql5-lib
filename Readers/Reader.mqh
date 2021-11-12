//+------------------------------------------------------------------+
//|                                                       Reader.mq5 |
//|                                                 Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#property copyright "Leonardo Marinho"
#property link      "https://github.com/dev-marinho/mql5-lib"
#property version   "0.01"

#ifndef __C_READER
#define __C_READER

#include <Indicators\Indicator.mqh>
#include <mql5-lib\Readers\ReaderBase.mqh>

//+------------------------------------------------------------------+
//| Bollinger Bands Reader                                           |
//+------------------------------------------------------------------+
template <typename T>
class CReader : public CReaderBase
  {
protected:
   //--- Indicator to be readed
   T        *m_indicator;

public:
   //--- Constructor
                     CReader(string, ENUM_TIMEFRAMES);
   //--- Destructor
                    ~CReader();
   //--- Store indicator pointer that may be use by the reader
   bool              UseIndicator(T*);

  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
template <typename T> CReader::CReader(string t_symbolName, ENUM_TIMEFRAMES t_timeframe)
   : CReaderBase(t_symbolName, t_timeframe)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
template <typename T> CReader::~CReader(void)
  {
  }
//+------------------------------------------------------------------+
//| Store indicator pointer that may be use by the reader            |
//+------------------------------------------------------------------+
template <typename T> bool CReader::UseIndicator(T *t_indicator)
  {
//--- test pointer
   if(t_indicator == NULL)
      //--- operation failed
      return false;
//--- move pointer indicator
   m_indicator = t_indicator;
//--- operation succeed
   return true;
  }
#endif
//+------------------------------------------------------------------+
