//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_SCORE__
#define __C_SCORE__

#define SCORE_BUFFER_MAX_LENGTH 2
#define SCORE_TRIGGER_MAX_LENGTH 5

enum ENUM_SCORE_RANGE
  {
   SCORE_RANGE_HIGHER_MAX,
   SCORE_RANGE_EQUAL_MAX,
   SCORE_RANGE_LOWER_MIN,
   SCORE_RANGE_EQUAL_MIN,
   SCORE_INSIDE_RANGE
  };

enum ENUM_SCORE_TRIGGER_TYPE
  {
   SCORE_RANGE_HIGHER_EQUAL,
   SCORE_RANGE_HIGHER,
   SCORE_RANGE_EQUAL,
   SCORE_RANGE_LOWER,
   SCORE_RANGE_LOWER_EQUAL,
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CScore
  {
protected:
   struct ScoreTrigger
     {
                     ScoreTrigger(double t_value, ENUM_SCORE_TRIGGER_TYPE t_type)
         :           value(t_value),
                     type(t_type)
        {
        }
      double              value;
      ENUM_SCORE_TRIGGER_TYPE type;
     };

   double                 m_buffer[SCORE_BUFFER_MAX_LENGTH];
   ScoreTrigger           m_trigger[SCORE_TRIGGER_MAX_LENGTH];
   uint                   m_trigger_length;
   double                 m_min;
   double                 m_max;

   void              InitializeBufferArray()
     {
      //--- loop through buffer array
      for(int index = 0; index < SCORE_BUFFER_MAX_LENGTH; index++)
         //--- set index value to 0
         m_buffer[index] = 0;
     }

   void              InitializeTriggerArray()
     {
      //--- loop through trigger array
      for(int index = 0; index < SCORE_TRIGGER_MAX_LENGTH; index++)
         //--- set index value to 0
         m_trigger[index] = ScoreTrigger(0, 0);
     }

   void              ResolveEvents()
     {
      //--- current buffer value
      double current_value = Buffer(0);
      //--- loop through trigger array
      for(uint index = 0; index < m_trigger_length; index++)
        {
         //--- trigger value
         double trigger_value = m_trigger[index].value;
         //--- test triggers
         switch(m_trigger[index].type)
           {
            //--- test if current value is higher or equal than trigger value
            case SCORE_RANGE_HIGHER_EQUAL:
               if(current_value >= trigger_value)
                  //--- event emit
                  OnTrigger(trigger_value, SCORE_RANGE_HIGHER_EQUAL);
               break;
            //--- test if current value is higher than trigger value
            case SCORE_RANGE_HIGHER:
               if(current_value > trigger_value)
                  //--- event emit
                  OnTrigger(trigger_value, SCORE_RANGE_HIGHER);
               break;
            //--- test if current value is equal than trigger value
            case SCORE_RANGE_EQUAL:
               if(current_value == trigger_value)
                  //--- event emit
                  OnTrigger(trigger_value, SCORE_RANGE_EQUAL);
               break;
            //--- test if current value is lower than trigger value
            case SCORE_RANGE_LOWER:
               if(current_value < trigger_value)
                  //--- event emit
                  OnTrigger(trigger_value, SCORE_RANGE_LOWER);
               break;
            //--- test if current value is lower or equal than trigger value
            case SCORE_RANGE_LOWER_EQUAL:
               if(current_value <= trigger_value)
                  //--- event emit
                  OnTrigger(trigger_value, SCORE_RANGE_LOWER_EQUAL);
               break;
           }
        }
      //--- test if current value has changed from prev value
      if(Buffer(0) != Buffer(1))
         //--- event emit
         OnChange(Buffer(0), Buffer(1));
      //--- test if current value is higher or equal than max value
      if(current_value >= m_max && m_max > 0 && m_max != m_min)
        {
         //--- event emit
         OnMax();
         //--- reset score
         Reset();
        }
      //--- test if current value is lower or equal than min value
      if(current_value <= m_min && m_min < 0 && m_min != m_max)
        {
         //--- event emit
         OnMin();
         //--- reset score
         Reset();
        }
     }

   ENUM_SCORE_RANGE  ValueRange(const double t_value)
     {
      //--- test if value is higher than max value
      if(t_value > m_max)
         return SCORE_RANGE_HIGHER_MAX;
      //--- test if value is equal than max value
      if(t_value == m_max)
         return SCORE_RANGE_EQUAL_MAX;
      //--- test if value is higher than min value
      if(t_value < m_min)
         return SCORE_RANGE_LOWER_MIN;
      //--- test if value is equal than min value
      if(t_value == m_max)
         return SCORE_RANGE_EQUAL_MIN;
      //--- value is inside range
      return SCORE_INSIDE_RANGE;
     }

public:
   virtual void              OnChange(double current, double prev);
   virtual void              OnMax();
   virtual void              OnMin();
   virtual void              OnTrigger(double value, ENUM_SCORE_TRIGGER_TYPE type);
   virtual void              OnReset();

                     CScore()
      :              m_trigger_length(0),
                     m_max(0),
                     m_min(0)
     {
      InitializeBufferArray();
      InitializeTriggerArray();
     }

   inline double          Buffer(const uint t_index)
     {
      //--- test if index exists in buffer
      if(t_index >= SCORE_BUFFER_MAX_LENGTH)
        {
#ifdef __DEBUG Print(__FUNCTION__, " (", __LINE__, "): trying to access an index that doesn't exists. Max index available is ", SCORE_BUFFER_MAX_LENGTH); #endif
         //--- operation failed, no index available
         return 0;
        }
      //--- return buffer value
      return m_buffer[t_index];
     }

   inline bool       PushTrigger(const double t_value, const ENUM_SCORE_TRIGGER_TYPE t_trigger_type)
     {
      //--- test if there are any space for one more trigger
      if(!(m_trigger_length < SCORE_TRIGGER_MAX_LENGTH))
        {
#ifdef __DEBUG Print(__FUNCTION__, " (", __LINE__, "): max number of triggers reached. Max is ", SCORE_TRIGGER_MAX_LENGTH); #endif
         //--- operation failed, no space left
         return false;
        }
      //--- added trigger to triggers array
      m_trigger[m_trigger_length++] = ScoreTrigger(t_value, t_trigger_type);
      //--- operation succeed
      return true;
     }

   inline bool       Reset(bool t_validate_min_max = true)
     {
      //--- testing if value is already reseted
      if(Buffer(0) == 0)
        {
         //--- operation succeed
         return true;
        }
      //--- testing min and max to avoid stack overflow
      if(m_min == 0 || m_max == 0)
        {
#ifdef __DEBUG if (t_validate_min_max) Print(__FUNCTION__, " (", __LINE__, "): min or max values are equal to 0, this may cause stack overflow. No reset will be applied"); #endif
         //--- operation failed, no space left
         return false;
        }
      //--- making buffer 0 equal to 0
      Sum(-Buffer(0));
      //--- event emit
      OnReset();
      //--- operation succeed
      return true;
     }

   inline double          Sum(const int t_value)
     {
      //--- new buffer that will receive the old buffer reallocated to fit the new value
      double new_buffer[SCORE_BUFFER_MAX_LENGTH];
      //-- test if reallocating is possible
      if(!(SCORE_BUFFER_MAX_LENGTH > 1))
        {
#ifdef __DEBUG
         Print(__FUNCTION__, " (", __LINE__, "): max length of score's buffer should be higher than 0");
#endif
         //--- operation failed, reallocating was not possible
         return 0;
        }
      //--- trying to realocate
      if(ArrayCopy(new_buffer, m_buffer, 1, 0, SCORE_BUFFER_MAX_LENGTH - 1) < SCORE_BUFFER_MAX_LENGTH - 1)
        {
#ifdef __DEBUG
         Print(__FUNCTION__, " (", __LINE__, "): copied the wrong number of elements from instance buffer to new buffer");
#endif
         //--- operation failed, failed to move
         return 0;
        }
      //---  summing new value
      new_buffer[0] = new_buffer[1] + t_value;
      //--- moving new buffer to instance buffer
      if(ArrayCopy(m_buffer, new_buffer) < SCORE_BUFFER_MAX_LENGTH)
        {
#ifdef __DEBUG
         Print(__FUNCTION__, " (", __LINE__, "): copied the wrong number of elements from tried to move new buffer to instance buffer but no element was copied");
#endif
         //--- operation failed, failed to move
         return 0;
        }
      //--- validate events
      ResolveEvents();
      //--- operation succeed, returning the sum
      return m_buffer[0];
     }

   bool              SetMax(double t_value)
     {
      if(t_value < m_min)
        {
#ifdef __DEBUG
         Print(__FUNCTION__, " (", __LINE__, "): max value must be higher than min value");
#endif
         //--- operation failed, value is lower than min
         return false;
        }
      //--- move value to instance max
      m_max = t_value;
      //--- operation succeed
      return true;
     }

   bool              SetMin(double t_value)
     {
      if(t_value > m_max)
        {
#ifdef __DEBUG
         Print(__FUNCTION__, " (", __LINE__, "): min value must be lower than max value");
#endif
         //--- operation failed, value is higher than max
         return false;
        }
      //--- move value to instance max
      m_min = t_value;
      //--- operation succeed
      return true;
     }
  };

#endif
//+------------------------------------------------------------------+
