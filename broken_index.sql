/* Formatted on 8/2/2022 4:19:19 PM (QP5 v5.269.14213.34769) */
SELECT DISTINCT file#,
                segment_name,
                segment_type,
                tablespace_name,
                partition_name
  FROM dba_extents a, v$database_block_corruption b
 WHERE     a.file_id = b.file#
       AND a.block_id <= b.block#
       AND a.block_id + a.blocks >= b.block#;
