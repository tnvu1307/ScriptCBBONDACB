SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_CHECKCOREBANKTRADINGTIME (PV_BANKCODE VARCHAR2) RETURN VARCHAR2
AS
    -- HAM NAY TRA VE 'N' LA CHO DI TIEP.
    -- TRA VE 'Y' THI LA NGOAI GIO GIAO DICH CUA NGAN HANG.
    L_BIDV_ODTIMELIMIT_START VARCHAR2(6);
    L_BIDV_ODTIMELIMIT_END VARCHAR2(6);
    L_CURRTIME VARCHAR2(6);
BEGIN

    SELECT TO_CHAR(SYSDATE,'HH24MISS') INTO L_CURRTIME FROM DUAL;
    -- CHECK CHO NGAN HANG BIDV.
    IF INSTR(PV_BANKCODE, 'BIDV') > 0 THEN
        SELECT VARVALUE INTO L_BIDV_ODTIMELIMIT_START FROM SYSVAR WHERE VARNAME = 'BIDV_ODTIMELIMIT_START';
        SELECT VARVALUE INTO L_BIDV_ODTIMELIMIT_END FROM SYSVAR WHERE VARNAME = 'BIDV_ODTIMELIMIT_END';
        IF NOT L_CURRTIME BETWEEN L_BIDV_ODTIMELIMIT_START AND L_BIDV_ODTIMELIMIT_END THEN
            RETURN 'Y';
        END IF;
    END IF;
    RETURN 'N';
EXCEPTION WHEN OTHERS THEN
    RETURN 'N';
END;
 
 
/