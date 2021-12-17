//--- file define
#ifndef __C__EXPERT_BASE_WRAP__
#define __C__EXPERT_BASE_WRAP__
//--- file includes
#include <Arrays/ArrayObj.mqh>
#include <mql5-lib/Expert2/ExpertBase.mqh>

//--- expert base wrap class
class CExpertBaseWrap : CExpertBase
{
protected:
  //--- array of experts
  CArrayObj *m_experts;

public:
  //--- constructor
  CExpertBaseWrap();
  //--- destructor
  ~CExpertBaseWrap();

  //--- access experts
  CArrayObj *Experts();

  //--- init routine
  virtual bool Init(void);
  //--- init routine
  virtual bool DeInit(void);
  //--- tick routine
  virtual bool Tick(void);

  //--- set events instance pointer
  bool Events(CEvents *);
  //--- set indicators instance pointer
  bool Indicators(CIndicators *);
  //--- set symbol info instance pointer
  bool SymbolInfo(CSymbolInfo *);
};

CExpertBaseWrap::CExpertBaseWrap()
    : m_experts(new CArrayObj)
{
}

CExpertBaseWrap::~CExpertBaseWrap()
{
  delete m_experts;
}

CArrayObj *CExpertBaseWrap::Experts()
{
  return m_experts;
}

bool CExpertBaseWrap::Init()
{
  //--- loop through experts array
  for (int index = 0; index < m_experts.Total(); index++)
  {
    //--- init expert
    CExpertBase *expert = m_experts.At(index);
    if (!expert.Init())
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertBaseWrap::DeInit()
{
  //--- loop through experts array
  for (int index = 0; index < m_experts.Total(); index++)
  {
    //--- init expert
    CExpertBase *expert = m_experts.At(index);
    if (!expert.DeInit())
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertBaseWrap::Tick()
{
  //--- loop through experts array
  for (int index = 0; index < m_experts.Total(); index++)
  {
    //--- init expert
    CExpertBase *expert = m_experts.At(index);
    if (!expert.Tick())
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertBaseWrap::Events(CEvents *t_events)
{
  //--- set expert signal event instance
  for (int index = 0; index < m_experts.Total(); index++)
  {
    CExpertBase *expert = m_experts.At(index);
    if (!expert.Events(t_events))
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertBaseWrap::Indicators(CIndicators *t_indicators)
{
  //--- set expert indicators event instance
  for (int index = 0; index < m_experts.Total(); index++)
  {
    CExpertBase *expert = m_experts.At(index);
    if (!expert.Indicators(t_indicators))
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

bool CExpertBaseWrap::SymbolInfo(CSymbolInfo *t_symbol_info)
{
  //--- set expert calendar and trader event instance
  for (int index = 0; index < m_experts.Total(); index++)
  {
    Print(t_symbol_info.Name());
    CExpertBase expert = m_experts.At(index);
    if (!expert.SymbolInfo(t_symbol_info))
    {
      return false;
    }
  }
  //--- operation succeed
  return true;
}

#endif