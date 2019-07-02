SELECT /*+  index(dm_cust_year DIM_CUST_YEAR_PK)  REWRITE */
               SUM (fid.doc_price) AS sum_doc_price,
                SUM (fid.doc_count) AS SUM_DOC_COUNT,
               LISTAGG ( fid.month_doc , ',' ) WITHIN GROUP (ORDER BY NULL )  AS month_v,
                dm_date.year AS year_v,
                NVL (dm_cust_year.main_cust_id, dm_cust_year.cust_id)
                   AS main_cust_id,
                NVL (dm_cust_year.main_cust_name, dm_cust_year.cust_name)
                   AS main_cust_name,
                dm_unit.region_id AS region_id,
                dm_unit.region_name AS region_name,
                dcc.main_region_id,
                dcc.main_region_name
           FROM dw.dim_cust_year dm_cust_year    /* AL_dm_cust_year_ Sender */
                LEFT OUTER JOIN dw.dim_cust_contract dcc
                   ON dcc.cust_id =
                         NVL (dm_cust_year.main_cust_id,
                              dm_cust_year.cust_id),
                dw.dim_month dm_date,
                 dw.fact_invoice_detail fid,
                 dw.dim_unit dm_unit
          WHERE (    dm_unit.unit_id = fid.departure_unit_id
                 AND fid.sender_cust_id = dm_cust_year.cust_id
                 AND fid.month_doc = dm_date.month
                 AND fid.year_doc = dm_cust_year.year
                 AND fid.year_doc = dm_date.year
                AND dm_date.month IN (2,3) 
                 and     dm_date.year =2016)
   GROUP BY dm_unit.region_id,
            dm_unit.region_name,
      --    dm_date.month,
            dm_date.year,
            NVL(dm_cust_year.main_cust_id, dm_cust_year.cust_id),
            NVL(dm_cust_year.main_cust_name, dm_cust_year.cust_name)
            ,dcc.main_region_id,dcc.main_region_name
