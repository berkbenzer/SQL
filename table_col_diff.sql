select 'ALTER TABLE ' ||s1OWNER ||'.'|| 'IKINCI_SELECT_TABLO_ADI' || ' ADD ' || s1COL , s1DT || ' (' || s1DL ||  ');' from  
(SELECT *
  FROM (SELECT S1.COLUMN_NAME AS s1COL
               ,S1.DATA_TYPE AS s1DT
               ,S1.DATA_LENGTH AS s1DL
               ,S1.OWNER AS s1OWNER
           --  ,S1.TABLE_NAME AS s1TABLE_NAME
          FROM all_tab_columns S1
         WHERE     1 = 1
               AND owner = 'XXX'
               AND table_name = 'XXX')
MINUS
SELECT *
  FROM (SELECT S2.COLUMN_NAME AS s2COL
               ,S2.DATA_TYPE AS s2DT
               ,S2.DATA_LENGTH AS s2DL
               ,S2.OWNER AS s2OWNER
          --   ,S2.TABLE_NAME AS s2TABLE_NAME
          FROM all_tab_columns S2
         WHERE 1 = 1 AND OWNER = 'XXX' AND table_name = 'XXX'))
