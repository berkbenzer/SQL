BEGIN
   EXECUTE IMMEDIATE
      '

CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED "calcsha"
   AS import java.security.MessageDigest; 
public class calcsha2 
    {
        static public String fncsha(String inputVal) throws Exception
        {           
            MessageDigest myDigest = MessageDigest.getInstance("SHA-256");        
            myDigest.update(inputVal.getBytes());
            byte[] dataBytes = myDigest.digest();
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < dataBytes.length; i++) {
             sb.append(Integer.toString((dataBytes[i])).substring(1));
            }        
            StringBuffer hexString = new StringBuffer();
            for (int i=0;i<dataBytes.length;i++) {
                String hex=Integer.toHexString(0xff '|| chr(38) ||' dataBytes[i]);
                    if(hex.length()==1) hexString.append(''0'');
                    hexString.append(hex);
            }
            String retParam = hexString.toString();
            return retParam;           
        }    
    }';
END;


CREATE OR REPLACE FUNCTION test.hash_sha256 (txt varchar2)
RETURN VARCHAR2
AS
LANGUAGE JAVA
NAME 'calcsha2.fncsha(java.lang.String) return String';


select * from  xxxx.xxxxxx where hash_sha256(table_coloumn)='hash_number' AND (table_coloumn) IS NOT NULL ;

