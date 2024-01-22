SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE compile_all
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
        SELECT OBJECT_TYPE,OBJECT_NAME
        FROM USER_OBJECTS
        WHERE object_type in ('FUNCTION','PROCEDURE','VIEW','TRIGGER','PACKAGE BODY','PACKAGE') and status = 'INVALID'
    )
    LOOP
        IF (REC.OBJECT_TYPE = 'PACKAGE BODY') THEN
            v_strSQL := 'ALTER PACKAGE ' || REC.OBJECT_NAME || ' COMPILE BODY';
        ELSE
            v_strSQL := 'ALTER ' || REC.OBJECT_TYPE || ' ' || REC.OBJECT_NAME || ' COMPILE';
        END IF;

        BEGIN
            EXECUTE IMMEDIATE v_strSQL;
        EXCEPTION
        WHEN others THEN -- caution handles all exceptions
            PLOG.ERROR('Compile: '||REC.OBJECT_NAME||' Error: ' || SQLERRM);
        END;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
    PLOG.ERROR('Error: ' || SQLERRM || ' LINE: '|| dbms_utility.format_error_backtrace);
    RETURN;
END; -- Procedure
/
