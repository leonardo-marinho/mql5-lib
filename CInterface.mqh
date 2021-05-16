//+------------------------------------------------------------------+
//|                                                           Marino |
//|                                                 Leonardo Marinho |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#ifndef __C_INTERFACE__
#define __C_INTERFACE__

#include <ChartObjects\ChartObjectsTxtControls.mqh>

#define LABEL_COLOR (color)(0xffff00)
#define MAX_LABELS 25
#define FONT_SIZE 10
#define LABELS_CORD_X 250
#define LABELS_DATA_CORD_X LABELS_CORD_X - 150
#define LABELS_CORD_Y 50
#define LABELS_CORD_PADDING 15

/**
 * @brief Base class for strategy creation
 *
 */
class CInterface
  {
private:

   /**
    * @brief Chat Object
    *
    */
   CChartObject      m_chart;

   /**
    * @brief Labels
    *
    */
   CChartObjectLabel m_label[MAX_LABELS];

   /**
    * @brief Labels data
    *
    */
   CChartObjectLabel m_label_data[MAX_LABELS];

   /**
    * @brief Labels count
    *
    */
   int               m_labels_rows;

public:
                     CInterface()
      :              m_labels_rows(0)

     {
     }

   /**
    * @brief Init
    *
    */
   inline void       Init()
     {
      Draw();
     }

   /**
    * @brief Draw
    *
    */
   inline void       Draw()
     {
      ChartRedraw();
     }

   /**
    * @brief Add label
    *
    */
   inline void       AddLabel(const string t_label, string t_start_value = "", int t_index = -1, color t_label_color = LABEL_COLOR, color t_label_data_color = LABEL_COLOR)
     {
      t_index = t_index < 0 ? m_labels_rows : t_index;
      m_label[t_index].Create(0, "Label"+IntegerToString(m_labels_rows), 0, LABELS_CORD_X, LABELS_CORD_Y + (LABELS_CORD_PADDING * (m_labels_rows + 1)));
      m_label[t_index].Corner(CORNER_RIGHT_UPPER);
      m_label[t_index].Description(t_label);
      m_label[t_index].Color(t_label_color);
      m_label[t_index].FontSize(FONT_SIZE);

      m_label_data[t_index].Create(0, "LabelInfo"+IntegerToString(m_labels_rows), 0, LABELS_DATA_CORD_X, LABELS_CORD_Y + (LABELS_CORD_PADDING * (m_labels_rows + 1)));
      m_label_data[t_index].Corner(CORNER_RIGHT_UPPER);
      m_label_data[t_index].Description(t_start_value);
      m_label_data[t_index].Color(t_label_data_color);
      m_label_data[t_index].FontSize(FONT_SIZE);
      m_labels_rows++;
     }

   /**
    * @brief Add label
    *
    */
   inline void       SetLabelData(const string t_data, const int t_labels_rows)
     {
      m_label_data[t_labels_rows].Description(t_data);
     }
  };

#endif
//+------------------------------------------------------------------+
