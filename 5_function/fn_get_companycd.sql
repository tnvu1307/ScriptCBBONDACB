SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_companycd RETURN VARCHAR2
IS
   RETURN_VAL VARCHAR2(20) := 'SHV';
BEGIN
    SELECT VARVALUE INTO RETURN_VAL
    FROM SYSVAR
    WHERE VARNAME='COMPANYCD'
    AND GRNAME='SYSTEM';

    RETURN RETURN_VAL;
EXCEPTION WHEN OTHERS THEN
    RETURN 'SHV';
END;
/
