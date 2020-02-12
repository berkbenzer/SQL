/* Formatted on 20.01.2020 10:58:25 (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FUNCTION SYS.DELETED
   RETURN NUMBER
AS
   PRAGMA AUTONOMOUS_TRANSACTION;



   CURSOR c_get_objects
   IS

 SELECT UO.object_type,   UO.OWNER, object_name|| DECODE (object_type, 'TABLE', ' cascade constraints', NULL) obj_name
    FROM ALL_objects UO, BESPROD.SILINECEK SL
   WHERE     1 = 1
         AND UO.object_name = SL.ADI
         AND UO.OBJECT_TYPE = SL.TIP
         AND UO.OWNER = SL.OWNER
         AND object_type IN ('TABLE',
                             'VIEW',
                             'PACKAGE',
                             'SEQUENCE',
                             'PROCEDURE',
                             'SYNONYM',
                             'FUNCTION',
                             'MATERIALIZED VIEW')
ORDER BY object_type;



BEGIN
   BEGIN
      FOR object_rec IN c_get_objects
      LOOP
         EXECUTE IMMEDIATE
            ('drop ' || object_rec.object_type  || ' ' || object_rec.owner || '.' ||object_rec.obj_name);
      END LOOP;
   END;

   RETURN 0;
END DELETED;
/







--OBJECT DELETE FUNCTION


--RUN FUNCTION
DECLARE 
  RetVal NUMBER;

BEGIN 
  RetVal := SYS.DELETED_OB;
  COMMIT; 
END; 





CREATE OR REPLACE FUNCTION SYS.DELETED_OB
   RETURN NUMBER
AS
   PRAGMA AUTONOMOUS_TRANSACTION;



   CURSOR c_get_objects
   IS

 SELECT OBJECT_TYPE,
             OWNER,
                OBJECT_NAME
             || DECODE (object_type, 'TABLE', ' cascade constraints', NULL)
                obj_name
        FROM all_objects
       WHERE     OWNER = 'SYS'
             AND OBJECT_TYPE = 'TABLE'
             AND OBJECT_NAME = 'TEST_1234';




BEGIN
   BEGIN
      FOR object_rec IN c_get_objects
      LOOP
         EXECUTE IMMEDIATE
            ('drop ' || object_rec.OBJECT_TYPE  || ' ' || object_rec.OWNER || '.' ||object_rec.obj_name);
      END LOOP;
   END;

   RETURN 0;
END DELETED_OB;
/



