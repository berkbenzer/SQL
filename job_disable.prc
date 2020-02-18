/*  
Create Log table in order to find which job's take offline
*/

CREATE TABLE BESPROD.KVKK_JOB_LOG
(
   JOB_NAME      VARCHAR2 (255) ,
   STATE         VARCHAR2 (255),
   CHANGE_DATE   DATE
)



CREATE OR REPLACE PROCEDURE XXX.JOB_DISABLE
IS
/* dbms job disable  */
BEGIN
   FOR x IN (SELECT *
               FROM user_jobs  where 1=1 and SCHEMA_USER ='XXX')
   LOOP
      DBMS_JOB.broken (x.job, FALSE);
      INSERT INTO XXX.JOB_LOG (JOB_NAME,STATE,CHANGE_DATE) VALUES (X.JOB,X.BROKEN,SYSDATE);
       COMMIT;
   END LOOP;
END;


DECLARE
   CURSOR c_job
   IS
      SELECT JOB_NAME,ENABLED
        FROM ALL_SCHEDULER_JOBS
       WHERE     1 = 1
             AND REPEAT_INTERVAL LIKE '%DAILY%'
             AND NEXT_RUN_DATE > SYSDATE + 3
             AND owner = 'XXX'
      UNION
      SELECT JOB_NAME,ENABLED
        FROM ALL_SCHEDULER_JOBS ASJ
       WHERE     1 = 1
             AND ASJ.owner = 'XXX'
             AND ASJ.NEXT_RUN_DATE > SYSDATE + 3;
                          
/*Schedular Job Disable*/             
BEGIN
   FOR c_sch_job IN c_job
   LOOP
      EXECUTE IMMEDIATE
            'begin DBMS_SCHEDULER.disable('''
         || c_sch_job.job_name
         || ''');end;';
         INSERT INTO XXX.JOB_LOG (JOB_NAME,STATE,CHANGE_DATE) VALUES (c_sch_job.JOB_NAME,c_sch_job.ENABLED,SYSDATE);
         COMMIT;
   END LOOP;
END;

