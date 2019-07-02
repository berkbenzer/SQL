SELECT *
  FROM (SELECT d.year AS "Yıl",
               d.month AS "Ay",
               pe.entity_code AS "x1",
               pe.entity_name AS "x2",
               e.entity_code AS  "x3",
               e.entity_name AS  "x3",
               t.data_code,
               d.VALUE
          FROM misport2.msp_entity_datas D,
               misport2.msp_data_types_b T,
               misport2.MSP_ENTITY E
               LEFT JOIN misport2.msp_entity_relations er
                  ON er.entity_id = e.entity_id AND er.parent_type_id = '2'
               LEFT JOIN misport2.MSP_ENTITY PE
                  ON pe.entity_id = er.parent_entity_id
         WHERE     d.entity_id = e.entity_id
               AND d.year >= 2016
               AND d.day = 0
               --   and t.data_code in ('HANDHELD_USAGE_RATIO')

               AND t.data_code IN ('SUM_HAND_CNT', 'HANDHELD_USAGE_RATIO')
               AND t.data_type_id = d.data_type_id
               AND d.month > 0
               AND e.entity_type_id IN ('4', '5')) PIVOT (SUM (
                                                             ROUND (VALUE, 2)) AS CNT
                                                   FOR (data_code)
                                                   IN  ('SUM_HAND_CNT' AS TERMINAL,
                                                       'HANDHELD_USAGE_RATIO' AS KULLANIM_ORANI))
