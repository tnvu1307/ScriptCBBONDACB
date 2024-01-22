SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE EMAILRPT (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   P_DATASOURCE                 IN       VARCHAR2
   )
IS

BEGIN
    OPEN PV_REFCURSOR FOR P_DATASOURCE;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('EMAILRPT: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
