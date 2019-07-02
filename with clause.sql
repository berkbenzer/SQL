WITH ref_year_summary
     AS (  SELECT MONTH_V,
                  YEAR_V,
                  MAIN_CUST_ID,
                  MAIN_CUST_NAME,
                  REGION_ID,
                  REGION_NAME,
                  MAIN_REGION_ID,
                  MAIN_REGION_NAME,
                  SUM (SUM_DOC_PRICE) AS DOC_PRICE_SUM,
                  SUM (SUM_DOC_COUNT) as doc_cnt_count
             FROM (  SELECT /*+  index(dm_cust_year DIM_CUST_YEAR_PK) */
                           SUM (mv.doc_price_sum) AS sum_doc_price,
                            SUM (mv.doc_cnt_count) AS sum_doc_count,
                            LISTAGG (mv.month_doc,',')
                            WITHIN GROUP (ORDER BY mv.month_doc Asc)
                            OVER (PARTITION BY dm_unit.region_id,dm_date.year,NVL(dm_cust_year.main_cust_id, dm_cust_year.cust_id),dcc.main_region_id )AS month_v,
                            dm_date.year AS year_v,
                            NVL (dm_cust_year.main_cust_id, dm_cust_year.cust_id)
                               AS main_cust_id,
                            NVL (dm_cust_year.main_cust_name,
                                 dm_cust_year.cust_name)
                               AS main_cust_name,
                            dm_unit.region_id AS region_id,
                            dm_unit.region_name AS region_name,
                            dcc.main_region_id,
                            dcc.main_region_name
                       FROM dw.dim_cust_year dm_cust_year /* AL_dm_cust_year_ Sender */
                            LEFT OUTER JOIN dw.dim_cust_contract dcc
                               ON dcc.cust_id =
                                     NVL (dm_cust_year.main_cust_id,
                                          dm_cust_year.cust_id),
                            dw.dim_month dm_date,
                            (SELECT unit_id,
                                    unit_name,
                                    region_name,
                                    region_id
                               FROM dw.dim_unit
                              WHERE is_hidden <> 1) dm_unit,
                            DW.FID_PERF_SCUST_DEP_MV mv
                      WHERE     (    dm_unit.unit_id = mv.departure_unit_id
                                 AND mv.sender_cust_id = dm_cust_year.cust_id
                                 AND mv.month_doc = dm_date.month
                                 AND mv.year_doc = dm_cust_year.year
                                 AND mv.year_doc = dm_date.year
                                 AND dm_date.month IN( @{referans_ay}) 
                                 AND dm_date.year IN( @{referans_yil}))
                                GROUP BY dm_unit.region_id,
                            dm_unit.region_name,
                            dm_date.year,
                            mv.month_doc,
                            NVL (dm_cust_year.main_cust_id,
                                 dm_cust_year.cust_id),
                            NVL (dm_cust_year.main_cust_name,
                                 dm_cust_year.cust_name),
                            dcc.main_region_id,
                            dcc.main_region_name
                         having    SUM (mv.doc_price_sum)>='@{sum_doc_price}'
                                                     ) FINAL_F
         GROUP BY MONTH_V,
                  YEAR_V,
                  MAIN_CUST_ID,
                  MAIN_CUST_NAME,
                  REGION_ID,
                  REGION_NAME,
                  MAIN_REGION_ID,
                  MAIN_REGION_NAME),
     comp_month_summary
     AS (  SELECT MONTH_V,
                  YEAR_V,
                  MAIN_CUST_ID,
                  MAIN_CUST_NAME,
                  REGION_ID,
                  REGION_NAME,
                  SUM (SUM_DOC_PRICE) as DOC_PRICE_SUM,
                  SUM (SUM_DOC_COUNT) as doc_cnt_count
             FROM (  SELECT /*+  index(dm_cust_year DIM_CUST_YEAR_PK) */
                           SUM (mv.doc_price_sum) AS sum_doc_price,
                            SUM (mv.doc_cnt_count) AS SUM_DOC_COUNT,
                            LISTAGG (
                               mv.month_doc,
                               ',')
                            WITHIN GROUP (ORDER BY  mv.month_doc Asc)
                            OVER (PARTITION BY dm_unit.region_id,dm_date.year,NVL (dm_cust_year.main_cust_id,dm_cust_year.cust_id)
                            )
                               AS month_v,
                            dm_date.year AS year_v,
                            NVL (dm_cust_year.main_cust_id, dm_cust_year.cust_id)
                               AS main_cust_id,
                            NVL (dm_cust_year.main_cust_name,
                                 dm_cust_year.cust_name)
                               AS main_cust_name,
                            dm_unit.region_id AS region_id,
                            dm_unit.region_name AS region_name
                       FROM dw.dim_cust_year dm_cust_year /* AL_dm_cust_year_ Sender */
                                                         ,
                            dw.dim_month dm_date,
                            (SELECT unit_id,
                                    unit_name,
                                    region_name,
                                   region_id
                               FROM dw.dim_unit
                              WHERE is_hidden <> 1) dm_unit,
                            DW.FID_PERF_SCUST_DEP_MV mv
                      WHERE (    dm_unit.unit_id = mv.departure_unit_id
                             AND mv.sender_cust_id = dm_cust_year.cust_id
                             AND mv.month_doc = dm_date.month
                             AND mv.year_doc = dm_cust_year.year
                             AND mv.year_doc = dm_date.year
                             AND dm_date.month IN( @{esas_ay})
                             AND dm_date.year IN( @{esas_yil}))
                                             GROUP BY                               
                            dm_unit.region_id,
                            dm_unit.region_name,
                            mv.month_doc,
                            dm_date.year,
                            NVL (dm_cust_year.main_cust_id,
                                 dm_cust_year.cust_id),
                            NVL (dm_cust_year.main_cust_name,
                                 dm_cust_year.cust_name)) FINAL_S
         GROUP BY MONTH_V,
                  YEAR_V,
                  MAIN_CUST_ID,
                  MAIN_CUST_NAME,
                  REGION_ID,
                  REGION_NAME)
SELECT TO_CHAR (d1.year_v,'9999') AS ,
       d1.month_v ,
       d1.main_cust_id ,
       d1.main_cust_name ,
       d1.region_id ,
       d1.region_name ,
       d1.main_region_id ,
       d1.main_region_name ,
       d1.doc_price_sum ,
       d1.doc_cnt_count ,
       TO_CHAR (d2.year_v,'9999') ,
       d2.month_v ,
       d2.doc_price_sum ,
       d2.doc_cnt_count ,
       (CASE
           WHEN d1.doc_price_sum - NVL (d2.doc_price_sum, 0) > 0 THEN '-'
           ELSE '+'
        END)
            FROM ref_year_summary d1
       LEFT JOIN comp_month_summary d2
          ON     d1.main_cust_id = d2.main_cust_id
             AND d1.region_id = d2.region_id


