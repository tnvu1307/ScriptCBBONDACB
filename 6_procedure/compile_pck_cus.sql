SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE compile_pck_cus
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- SONLT    21-10-2014 CREATED
-- ---------   ------  -------------------------------------------
   v_strSQL                varchar2(500);
   -- Declare program variables as shown above
BEGIN
    FOR REC IN
    (
        SELECT *FROM (SELECT OBJECT_TYPE,OBJECT_NAME FROM USER_OBJECTS WHERE object_type in ('PACKAGE BODY','PACKAGE') and object_name ='TXPKS_PRCHK' ORDER BY OBJECT_TYPE DESC)
        union all
        SELECT *FROM (SELECT OBJECT_TYPE,OBJECT_NAME FROM USER_OBJECTS WHERE object_type in ('PACKAGE BODY','PACKAGE') and object_name ='TXPKS_#8800EX' ORDER BY OBJECT_TYPE DESC)
        union all
        SELECT *FROM (SELECT OBJECT_TYPE,OBJECT_NAME FROM USER_OBJECTS WHERE object_type in ('PACKAGE BODY','PACKAGE') and object_name ='TXPKS_#8800' ORDER BY OBJECT_TYPE DESC)
        union all
        SELECT *FROM (  SELECT OBJECT_TYPE,OBJECT_NAME FROM USER_OBJECTS WHERE object_type in ('PACKAGE BODY','PACKAGE') and object_name ='CSPKS_FILEMASTER' ORDER BY OBJECT_TYPE DESC)
    )
    LOOP
        IF (REC.OBJECT_TYPE = 'PACKAGE BODY') THEN
            v_strSQL := 'ALTER PACKAGE ' || REC.OBJECT_NAME || ' COMPILE BODY';
        ELSE
            v_strSQL := 'ALTER ' || REC.OBJECT_TYPE || ' ' || REC.OBJECT_NAME || ' COMPILE';
        END IF;

        BEGIN
            EXECUTE IMMEDIATE v_strSQL;
            EXECUTE IMMEDIATE v_strSQL;
        EXCEPTION
        WHEN others THEN -- caution handles all exceptions
            PLOG.DEBUG('COMPILE_ALL ERR Compile: ' || REC.OBJECT_NAME || ' Error: ' || SQLERRM || ' LINE: '|| dbms_utility.format_error_backtrace);
        END;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    PLOG.DEBUG('Error: ' || SQLERRM || ' LINE: '|| dbms_utility.format_error_backtrace);
    RETURN;
END; -- Procedure
/
