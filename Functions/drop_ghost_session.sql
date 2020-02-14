/*
Run Function

DECLARE 
  RetVal NUMBER;

BEGIN 
  RetVal := SYS.DROP_USER_DMP;
  COMMIT; 
END; 


*/




CREATE OR REPLACE FUNCTION SYS.DROP_USER_DMP
RETURN NUMBER
AS 
PRAGMA AUTONOMOUS_TRANSACTION;

CURSOR c_get_cursor IS

SELECT    'alter system kill session '''
                 || s.sid
                 || ','
                 || s.serial#
                 || ''';' AS DROP_SESSION
            FROM v$session s, v$process p
           WHERE     s.username IN ('XXX', 'XXX', 'XXX')
                 AND p.addr(+) = s.paddr;
                 
 BEGIN
    BEGIN
       FOR object_rec IN c_get_cursor
        LOOP
            EXECUTE IMMEDIATE
                ( object_rec.DROP_SESSION );
                END LOOP;
                END;
                RETURN 0;
                END DROP_USER_DMP;
                /
