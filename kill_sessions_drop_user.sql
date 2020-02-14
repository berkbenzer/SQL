#!/bin/bash     

export ORACLE_SID=xxxx
sqlplus / as sysdba  << EOF


BEGIN
   FOR r
      IN (SELECT    'alter system kill session '''
                 || s.sid
                 || ','
                 || s.serial#
                 || ''';'
            FROM v$session s, v$process p
           WHERE     s.username IN ('xxx', 'xxxx', 'xxxxx')
                 AND p.addr(+) = s.paddr)
   LOOP
      EXECUTE IMMEDIATE
            'alter system kill session '''
         || r.sid
         || ','
         || r.serial#
         || ''' immediate';
   END LOOP;
END;




drop user xxx  CASCADE;
drop user xxxx  CASCADE;
drop user xxxxx  CASCADE;  
EOF
