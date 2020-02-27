	   
	   CREATE OR REPLACE PROCEDURE XXX.JOB_DISABLE
IS
BEGIN
   FOR x
      IN (SELECT *
            FROM user_jobs
           WHERE 1 = 1 AND SCHEMA_USER = 'XXX' AND NEXT_DATE = SYSDATE)
   LOOP
      DBMS_JOB.broken (x.job, TRUE);

      COMMIT;
   END LOOP;
END;
/

BEGIN
   FOR LOG_DBMS_JOB
      IN (SELECT JOB, BROKEN
            FROM user_jobs
           WHERE 1 = 1 AND SCHEMA_USER = 'XXX' AND BROKEN = 'N')
   LOOP
      INSERT INTO XXX.JOB_LOG (JOB_NAME, CHANGE_DATE)
           VALUES (LOG_DBMS_JOB.JOB, SYSDATE);

      COMMIT;
   END LOOP;
END;

DECLARE
   CURSOR c_job
   IS
      SELECT *
        FROM ALL_SCHEDULER_JOBS
       WHERE     1 = 1
             AND REPEAT_INTERVAL LIKE '%DAILY%'
             AND NEXT_RUN_DATE > SYSDATE
             AND owner = 'XXX'
             AND state = 'SCHEDULED'
      UNION
      SELECT *
        FROM ALL_SCHEDULER_JOBS
       WHERE     1 = 1
             AND owner = 'XXX'
             AND state = 'SCHEDULED'
             AND NEXT_RUN_DATE > SYSDATE;
BEGIN
   FOR c_sch_job IN c_job
   LOOP
      EXECUTE IMMEDIATE
            'begin DBMS_SCHEDULER.disable('''
         || c_sch_job.job_name
         || ''');end;';

      INSERT INTO XXX.JOB_LOG (JOB_NAME, CHANGE_DATE)
           VALUES (c_sch_job.JOB_NAME, SYSDATE);


      COMMIT;
   END LOOP;
END;

