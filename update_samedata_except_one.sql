

-- it updates the kolon3 column to "DELETED" in row which has same data except one

update orders.test7 T  set T.KOLON3 = 'DELETED'
where ROWID NOT IN
(
select MIN(ROWID) from
 ORDERS.TEST7
GROUP BY KOLON1 
)





delete from $table_name where rowid in
  (
  select "rowid" from
     (select "rowid", rank_n from
         (select rank() over (partition by $primary_key order by rowid) rank_n, rowid as "rowid"
             from $table_name
             where $primary_key in
                (select $primary_key from $table_name
                  group by $all_columns
                  having count(*) > 1
                )
             )
         )
     where rank_n > 1
  )
One of th
