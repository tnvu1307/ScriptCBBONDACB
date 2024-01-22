SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_getinventory (
          PV_REFCURSOR  IN OUT PKG_REPORT.REF_CURSOR,
          CLAUSE        IN VARCHAR2,
          BRID          IN VARCHAR2,
          SSYSVAR       IN VARCHAR2,
          RefLength     IN NUMBER,
          REFERENCE     IN VARCHAR2

       )
IS
          V_CLAUSE          VARCHAR2(100);
          V_BRID            VARCHAR2(100);
          V_SSYSVAR         VARCHAR2(100);
          V_iRefLength      NUMBER(20);
          V_REFERENCE       VARCHAR2(100);
          v_startnumtemp  number;
          v_endnumtemp    number;

          v_prefix          varchar2(4);
          v_AUTOINV         varchar2(6);
          v_AUTOINVTEMP     varchar2(6);
          v_startnum    number;
          v_endnum      number;
          pkgctx   plog.log_ctx;
          logrow   tlogdebug%ROWTYPE;
BEGIN
        V_CLAUSE          := UPPER(CLAUSE);
        V_BRID            := UPPER(BRID);
        V_SSYSVAR         := SSYSVAR;
        V_iRefLength      := RefLength;
        V_REFERENCE       := REFERENCE;
        

        IF (V_CLAUSE = 'ISSUERID') THEN
            OPEN PV_REFCURSOR FOR
            SELECT (MAX(TO_NUMBER(ISSUERID)) + 1) AUTOINV
            FROM ISSUERS;
        ELSIF (V_CLAUSE = 'CODEID') THEN
            OPEN PV_REFCURSOR FOR
            SELECT (MAX(TO_NUMBER(INVACCT)) + 1) AUTOINV
            FROM
            (
                SELECT ROWNUM ODR, INVACCT
                FROM (
                    SELECT CODEID INVACCT FROM SBSECURITIES WHERE SUBSTR(CODEID, 1, 1) <> 9 ORDER BY CODEID
                ) DAT
            ) INVTAB;
        END IF;


EXCEPTION
   WHEN OTHERS
   THEN
    plog.error ('sp_getinventory. Error:'|| SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
