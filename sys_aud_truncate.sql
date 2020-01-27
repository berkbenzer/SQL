CREATE OR REPLACE PROCEDURE TRUNCATE_AUD_TABLE  IS
BEGIN
EXECUTE IMMEDIATE 'truncate table sys.AUD$';
END TRUNCATE_AUD_TABLE;
/



BEGIN
dbms_scheduler.create_job(
job_name => 'SYS_AUDIT_TRUNC'
,job_type => 'PLSQL_BLOCK'
,job_action =>  'begin TRUNCATE_AUD_TABLE; end;'
,repeat_interval => 'FREQ=MONTHLY; BYMONTHDAY=-1;'
,enabled => TRUE);
END;
