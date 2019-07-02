SELECT 1 --trupper (      xxyk_appssecurityprivate.decrypt ('CHOPPER', user_password))    AS passwd 
     , emp.* 
     , xxyk_appssecurityprivate.createhash ( 
          NVL ( 
             trupper ( 
                xxyk_appssecurityprivate.decrypt ('CHOPPER' 
                                                , user_password)) 
           , 'x')) 
  FROM xxyk_current_emp_v emp 
 WHERE     1 = 1 
       AND user_name LIKE 'john'
