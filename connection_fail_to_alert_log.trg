CREATE OR REPLACE TRIGGER logon_denied_write_alertlog AFTER SERVERERROR ON DATABASE
DECLARE
 l_message varchar2(2000);
BEGIN
 -- ORA-1017: invalid username/password; logon denied
 IF (IS_SERVERERROR(1017)) THEN
 select 'Failed login attempt to the "'|| sys_context('USERENV' ,'AUTHENTICATED_IDENTITY') ||'" schema'
 || ' using ' || sys_context ('USERENV', 'AUTHENTICATION_TYPE') ||' authentication'
 || ' at ' || to_char(logon_time,'dd-MON-yy hh24:mi:ss' )
 || ' from ' || osuser ||'@'||machine ||' ['||nvl(sys_context ('USERENV', 'IP_ADDRESS'),'Unknown IP')||']'
 || ' via the "' ||program||'" program.'
 into l_message
 from sys .v_$session
 where sid = to_number(substr(dbms_session.unique_session_id,1 ,4), 'xxxx')
 and serial# = to_number(substr(dbms_session.unique_session_id,5 ,4), 'xxxx');
 
 -- write to alert log
 sys.dbms_system .ksdwrt( 2,l_message );
 END IF;
END;
/
