//+------------------------------------------------------------------+
//|                                                            Robot |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_HISTORY__
#define __C_HISTORY__

#define DEFAULT_HISTORY 5000

template <typename T>
class CHistory
  {
private:
   T                 m_history[];
   const int               m_compress_depth;
   const int         m_history_length;
   int               m_index;
   int               m_compress_success_count;
   int               m_history_pushed_count;

   inline void       CompressHistory(void)
     {
      int depth = (m_index + 1) - (m_compress_depth * 2) >= 0 ? m_compress_depth : MathFloor((m_index + 1) / 2);
      for(int shift = depth; shift > 0; shift--)
        {
         bool equal = true;
         for(int level = 0; level < shift; level++)
           {
            if(m_history[m_index - level] != m_history[m_index - shift - level])
              {

               equal = false;
               break;
              }
           }

         if(equal)
           {
            m_compress_success_count += shift;
            m_index -= shift;
            break;
           }
        }
     }

public:
                     CHistory(const int t_compress_depth = 0, const int t_history_length = DEFAULT_HISTORY)
      :              m_history_length(t_history_length),
                     m_compress_depth(t_compress_depth),
                     m_index(-1)
     {
      ArrayResize(m_history, m_history_length);
     }

   inline double     CompressRatio(void) const
     {
      return (double)m_compress_success_count / (double)m_history_pushed_count;
     }

   inline int        Length(void) const
     {
      return m_index + 1;
     }

   /*inline bool       Match(T &t_to_match[], const int t_size, const bool t_absolute)
     {
      bool matched = true;
      if(t_size - 1 <= m_index && t_size >= 0)
        {
         for(int index = 0; index < t_size; index++)
           {
            const T value = Value(m_index - t_size + index + 1);

            Print("Testing: ", Value(m_index - t_size + index + 1),
                  " != ", t_to_match[index],
                  " = ", (t_absolute ? MathAbs(value) : MathAbs(value) != t_to_match[index]));

            if(t_absolute ? MathAbs(value) : MathAbs(value) != t_to_match[index])
              {
               Print("Not passed");
               matched = false;
               break;
              }

            Print("Passed");

           }
        }
      else
         matched = false;

      return matched;
     }*/

   inline bool       Push(T t_value)
     {
      if(m_index < m_history_length)
        {
         m_history[++m_index] = t_value;
         m_history_pushed_count++;

         if(m_compress_depth > 0)
            CompressHistory();

         return true;
        }
      else
        {
         Print("Max tick history reached");
        }

      return false;
     }

   inline T          Value(const int t_index)
     {
      return t_index <= m_index && t_index >= 0 ? m_history[t_index] : 0;
     }
  };

#endif
//+------------------------------------------------------------------+
