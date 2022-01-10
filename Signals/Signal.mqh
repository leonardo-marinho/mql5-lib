//+------------------------------------------------------------------+
//|                                                       Signal.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL__
#define __C__SIGNAL__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Routine.mqh>
#include <Trade/SymbolInfo.mqh>
//+------------------------------------------------------------------+
//| A signal class that trigger at given conditions                  |
//+------------------------------------------------------------------+
class CSignal : public CRoutine
{
private:
   //--- identification property
   string m_name;

protected:
   //--- symbol info instance
   CSymbolInfo *m_symbol_info;

public:
   CSignal(string);
   ~CSignal(void);

   //--- method to access properties
   string Name(void);

   virtual CSymbolInfo *SymbolInfo(void);
   virtual bool SymbolInfo(CSymbolInfo *);

   //--- methods to check open conditions
   virtual bool CheckOpenLong(void) { return false; };
   virtual bool CheckOpenShort(void) { return false; };

   //--- methods to check close conditions
   virtual bool CheckCloseLong(void) { return false; };
   virtual bool CheckCloseShort(void) { return false; };
   virtual bool CheckClose(void) { return false; };
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignal::CSignal(string t_name = "")
    : m_name(t_name),
      m_symbol_info(new CSymbolInfo())
{
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignal::~CSignal(void)
{
   delete m_symbol_info;
}
//+------------------------------------------------------------------+
//| Access signal name                                               |
//+------------------------------------------------------------------+
string CSignal::Name(void)
{
   return m_name;
}
//+------------------------------------------------------------------+
//| Access symbol info                                               |
//+------------------------------------------------------------------+
CSymbolInfo *CSignal::SymbolInfo(void)
{
   return m_symbol_info;
}
//+------------------------------------------------------------------+
//| Set symbol info                                                  |
//+------------------------------------------------------------------+
bool CSignal::SymbolInfo(CSymbolInfo *t_symbol_info)
{
   m_symbol_info = t_symbol_info;
   return m_symbol_info != NULL;
}
#endif
//+------------------------------------------------------------------+
