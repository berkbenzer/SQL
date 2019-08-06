

-- it updates the kolon3 column to "DELETED" in row which has same data except one

update orders.test7 T  set T.KOLON3 = 'DELETED'
where ROWID NOT IN
(
select MIN(ROWID) from
 ORDERS.TEST7
GROUP BY KOLON1 
)
