SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE UPDATE_VERSION
   ( RPT_VERSION IN VARCHAR2 DEFAULT NULL,
     FLEX_VERSION IN VARCHAR2 DEFAULT NULL)
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: DUNG DE CAP NHAT VERSION CHO FLEX VA REPORT
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- SONLT    05-12-2014 CREATE
-- ---------   ------  -------------------------------------------
   V_RPT VARCHAR2(50);
   V_FLEX VARCHAR2(50);
   -- Declare program variables as shown above
BEGIN
    SELECT NVL(RPT_VERSION, REPORTVERSION), NVL(FLEX_VERSION, ACTUALVERSION) INTO V_RPT,V_FLEX FROM VERSION;

    UPDATE VERSION
    SET REPORTVERSION = V_RPT,
        ACTUALVERSION = V_FLEX;
EXCEPTION
    WHEN OTHERS THEN
    PLOG.ERROR('Error UPDATE_VERSION: ' || SQLERRM || ' LINE: '|| dbms_utility.format_error_backtrace);
END; -- Procedure
/
