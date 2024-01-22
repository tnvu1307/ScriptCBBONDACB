SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_lockaccount_check(PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, p_txnum in varchar2, p_txdate in varchar2)
is
    l_count number;
begin
    
    SELECT COUNT(1) INTO L_COUNT FROM TLLOG WHERE TXNUM = P_TXNUM AND TXDATE = TO_DATE(P_TXDATE, 'DD/MM/RRRR') AND TXSTATUS = TXSTATUSNUMS.C_TXCOMPLETED;
    IF l_count > 0 THEN
        OPEN PV_REFCURSOR FOR
        SELECT '-930100' p_err_code from dual;
    else
        OPEN PV_REFCURSOR FOR
        SELECT '0' p_err_code from dual;
    END IF;
exception when others then
    plog.error (SQLERRM || dbms_utility.format_error_backtrace);
end;
/
