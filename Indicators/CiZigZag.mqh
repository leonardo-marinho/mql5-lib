//+------------------------------------------------------------------+
//|                                                           Expert |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CiZigZag : public CIndicator
  {
protected:
   int               m_backstep; //--- backstep parameter
   int               m_depth; //--- depth parameter
   int               m_deviation; //--- deviation parameter

public:
   //--- constructor
                     CiZigZag(void);
   //--- destructor
                    ~CiZigZag(void);

   //--- methods of access to protected data
   int               Backstep(void)    const { return m_backstep;  }
   int               Depth(void)       const { return m_depth;     }
   int               Deviation(void)   const { return m_deviation; }

   //--- method of creation
   bool              Create(const string symbol, const ENUM_TIMEFRAMES period, const int deviation, const int depth, const int backstep);
   //--- methods of access to indicator data
   double            Main(const int index) const;

protected:
   //--- methods of tuning
   bool              Initialize(const string symbol, const ENUM_TIMEFRAMES period, const int deviation, const int depth, const int backstep);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CiZigZag::CiZigZag(void)
   : m_backstep(-1), m_depth(-1), m_deviation(-1)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CiZigZag::~CiZigZag(void)
  {
  }
//+------------------------------------------------------------------+
//| Create the "Zig Zag" indicator                                   |
//+------------------------------------------------------------------+
bool CiZigZag::Create(const string symbol, const ENUM_TIMEFRAMES period, const int deviation, const int depth, const int backstep)
  {
//--- check history
   if(!SetSymbolPeriod(symbol, period))
      return(false);
//--- create
   m_handle=iCustom(symbol, period, "Examples/ZigZag", depth, deviation, backstep);
//--- check result
   if(m_handle==INVALID_HANDLE)
      return(false);
//--- indicator successfully created
   if(!Initialize(symbol, period, deviation, depth, backstep))
     {
      //--- initialization failed
      IndicatorRelease(m_handle);
      m_handle=INVALID_HANDLE;
      return(false);
     }
//--- operation succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialize the indicator with special parameters                 |
//+------------------------------------------------------------------+
bool CiZigZag::Initialize(const string symbol, const ENUM_TIMEFRAMES period, const int deviation, const int depth, const int backstep)
  {
   if(CreateBuffers(symbol,period,1))
     {
      //--- string of status of drawing
      m_name  ="ZigZag";
      m_status="("+symbol+","+PeriodDescription()+","+IntegerToString(deviation)+","
               +IntegerToString(depth)+","+IntegerToString(backstep)+") H="+IntegerToString(m_handle);
      //--- save settings
      m_backstep = backstep;
      m_depth = depth;
      m_deviation = deviation;
      //--- create buffers
      ((CIndicatorBuffer*)At(0)).Name("MAIN_LINE");
      //--- ok
      return(true);
     }
//--- error
   return(false);
  }
//+------------------------------------------------------------------+
//| Access to buffer of "Average True Range"                         |
//+------------------------------------------------------------------+
double CiZigZag::Main(const int index) const
  {
   CIndicatorBuffer *buffer=At(0);
//--- check
   if(buffer==NULL)
      return(EMPTY_VALUE);
//--- 
   return(buffer.At(index));
  }
//+------------------------------------------------------------------+