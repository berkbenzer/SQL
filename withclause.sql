WITH genel
     AS (  SELECT /*+ REWRITE */
                 T104723.REASON_NAME AS ERRORTYPE,
                  T109654.MONTH AS MOUNT,
                  T109654.YEAR AS YEAR,
                  ID.REC_ADR_NEW_WA_FLAG AS ADDRTYPE,
                  COUNT (T118206.doc_id) AS CNT
             FROM dw.DIM_DISCREPANCY_REASON T104723,
                  dw.DIM_MONTH T109654,
                  dw.FACT_DISCREPANCY_DETAIL T118206,
                  DW.FACT_INVOICE_DETAIL fid,
                  STAGE.INV_DOCUMENT id
            WHERE     1 = 1
                  AND ID.DOC_ID = T118206.doc_id
                  AND T118206.doc_id = FID.DOC_ID(+)
                  AND FID.DOC_COUNT(+) = 1
                  AND T104723.REASON_ID = T118206.REASON_ID
                  AND T104723.REASON_NAME = 'xx'
                  AND T109654.MONTH = T118206.MONTH_DOC
                  AND T109654.MONTH = 11
                  AND T109654.YEAR = T118206.YEAR_DOC
                  AND T109654.YEAR = 2016
         GROUP BY T104723.REASON_NAME,
                  T109654.MONTH,
                  T109654.YEAR,
                  ID.REC_ADR_NEW_WA_FLAG),
     SUM_ADDPARS
     AS (  SELECT /*+ REWRITE */
                 T104723.REASON_NAME AS ERRORTYPE,
                  T109654.MONTH AS MOUNT,
                  T109654.YEAR AS YEAR,
                  ID.REC_ADR_NEW_WA_FLAG AS ADDRTYPE,
                  COUNT (T118206.doc_id) AS CNT
             FROM dw.DIM_DISCREPANCY_REASON T104723,
                  dw.DIM_MONTH T109654,
                  dw.FACT_DISCREPANCY_DETAIL T118206,
                  DW.FACT_INVOICE_DETAIL fid,
                  STAGE.INV_DOCUMENT id
            WHERE     1 = 1
                  AND ID.DOC_ID = T118206.doc_id
                  AND T118206.doc_id = FID.DOC_ID(+)
                  AND FID.DOC_COUNT(+) = 1
                  AND T104723.REASON_ID = T118206.REASON_ID
                  AND T104723.REASON_NAME = 'xx'
                  AND T109654.MONTH = T118206.MONTH_DOC
                  AND T109654.MONTH = 11
                  AND T109654.YEAR = T118206.YEAR_DOC
                  AND T109654.YEAR = 2016
                  AND id.REC_ADR_WA_UPD_EMP_ID = 725257
         GROUP BY T104723.REASON_NAME,
                  T109654.MONTH,
                  T109654.YEAR,
                  ID.REC_ADR_NEW_WA_FLAG) 
SELECT g.ERRORTYPE,
g.MOUNT,
g.YEAR,
G.ADDRTYPE,
G.CNT,
SA.CNT
  FROM genel g, SUM_ADDPARS sa
 WHERE 1 = 1 
 AND sa.ERRORTYPE = g.ERRORTYPE
