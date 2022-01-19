//+------------------------------------------------------------------+
//|                                          SignalProfitLimit.mq5 |
//|                                 Copyright 2021, Leonardo Marinho |
//|                          https://github.com/dev-marinho/mql5-lib |
//+------------------------------------------------------------------+
#ifndef __C__SIGNAL_PROFIT_LIMIT__
#define __C__SIGNAL_PROFIT_LIMIT__
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <mql5-lib/Signals/Signal.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>
//+------------------------------------------------------------------+
//| A signal based on a given limit to peding profits              |
//+------------------------------------------------------------------+
class CSignalProfitLimit : public CSignal
{
protected:
  //--- magic number
  int m_magic_number;
  //--- symbol name
  string m_symbol_name;
  //--- symbol info
  CSymbolInfo *m_symbol_info;
  //--- profit info instance
  CPositionInfo *m_position_info;
  //--- take profit value
  double m_tp;
  //--- stop loss value
  double m_sl;

  //--- method to calculate profit
  double CalculateProfit();

  //--- methods for conversion
  double ConvertPipsToCurrencyValue(double);

public:
  CSignalProfitLimit(int, string, CPositionInfo *);

  //--- routine methods
  bool Init(void);
  bool Tick(void);

  //--- method to set limits
  void SetTp(double t_tp) { m_tp = t_tp; }
  void SetSl(double t_sl) { m_sl = t_sl; }
  void SetTpInPips(double t_tp) { SetTp(ConvertPipsToCurrencyValue(t_tp)); }
  void SetSlInPips(double t_sl) { SetSl(ConvertPipsToCurrencyValue(t_sl > 0 ? -t_sl : t_sl)); }

  //--- method to write condition
  virtual bool CheckConditional(void);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalProfitLimit::CSignalProfitLimit(int t_magic_number, string t_symbol_name, CPositionInfo *t_position_info)
    : m_magic_number(t_magic_number),
      m_symbol_name(t_symbol_name),
      m_position_info(t_position_info),
      m_symbol_info(new CSymbolInfo)
{
  Init();
}
//+------------------------------------------------------------------+
//| Calculate profit of open position                                |
//+------------------------------------------------------------------+
double CSignalProfitLimit::CalculateProfit()
{
  if (!m_position_info.SelectByMagic(m_symbol_name, m_magic_number) || m_position_info.Volume() == 0)
    return 0;
  if (m_position_info.PositionType() == POSITION_TYPE_BUY)
    return (m_symbol_info.Bid() - m_position_info.PriceOpen()) / m_symbol_info.TickSize() * m_symbol_info.TickValue() * m_position_info.Volume();
  else
    return -(m_symbol_info.Ask() - m_position_info.PriceOpen()) / m_symbol_info.TickSize() * m_symbol_info.TickValue() * m_position_info.Volume();
}
//+------------------------------------------------------------------+
//| Convert value from pips to currency value                        |
//+------------------------------------------------------------------+
double CSignalProfitLimit::ConvertPipsToCurrencyValue(double t_pips)
{
  return t_pips * m_symbol_info.TickValue();
}
//+------------------------------------------------------------------+
//| Init routine                                                     |
//+------------------------------------------------------------------+
bool CSignalProfitLimit::Init()
{
  if (!m_symbol_info.Name(m_symbol_name) || !m_symbol_info.RefreshRates() || !m_symbol_info.Refresh())
    return false;
  return true;
}
//+------------------------------------------------------------------+
//| Tick routine                                                     |
//+------------------------------------------------------------------+
bool CSignalProfitLimit::Tick()
{
  m_symbol_info.RefreshRates();
  return true;
}
//+------------------------------------------------------------------+
//| Conditional to be tested                                         |
//+------------------------------------------------------------------+
bool CSignalProfitLimit::CheckConditional()
{
  double profit = CalculateProfit();
  return profit > m_sl && profit < m_tp;
}
#endif
//+------------------------------------------------------------------+