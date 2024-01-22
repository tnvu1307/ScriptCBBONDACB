SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_getlist_exportscript(P_REFCURSOR OUT PKG_REPORT.REF_CURSOR, P_OPTION IN VARCHAR2, P_ERR_CODE IN OUT VARCHAR2, P_ERR_PARAM IN OUT VARCHAR2)

AS

BEGIN
    OPEN P_REFCURSOR FOR
    SELECT *
    FROM EXPORT_SCRIPT_LOG
    WHERE STATUS IN ('P','D');
EXCEPTION WHEN OTHERS THEN
    P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
    PLOG.ERROR('ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
END PRC_GETLIST_EXPORTSCRIPT;
/