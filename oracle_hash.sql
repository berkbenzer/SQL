select * from  winsure.C037POLICYDEVICEINFO where  rawtohex(
    DBMS_CRYPTO.Hash (
        UTL_I18N.STRING_TO_RAW (imei, 'AL32UTF8'),
        2)
    ) = '31B0BA5F41FFA8E13BBF9BF89966BB46';
