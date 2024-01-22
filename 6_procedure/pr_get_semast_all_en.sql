SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_get_semast_all_en (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
TellerId varchar2, BranchId varchar2, SearchFilter varchar2)
is
v_sql clob;
begin

    if TellerId='0001' THEN --Admin he thong
        v_sql:='SELECT SYMBOL,TOTAL,TRADE,HOLD,EMKQTTY,MORTAGE,BLOCKED,RECEIVING_T1,RECEIVING_T2
                FROM ( select se.*,(CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T0,
                           (CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T1,
                           (CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T2 ,
                           0 RECEIVING_CA, 0 TOTAL
from  vw_semast_custodycd se,
        (select ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY,sb.codeid, SB.SYMBOL,SP_BD_GETCLEARDAY(ST.CLEARCD, MAX(SB.TRADEPLACE), ST.TXDATE, TO_DATE(MAX(SYSVAR.VARVALUE),''DD/MM/RRRR'')) TDAY, SUM(ST.QTTY) ST_QTTY
        FROM STSCHD ST, SYSVAR, SBSECURITIES SB
        WHERE SYSVAR.VARNAME=''CURRDATE'' AND ST.CODEID=SB.CODEID
           and  ST.status = ''N'' AND st.deltd = ''N''
        and    ST.DUETYPE=''RS''
        GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY, SB.SYMBOL, sb.codeid) st
where se.afacctno = st.AFACCTno(+)
and se.codeid = st.codeid(+))  WHERE 0=0 ';
    else --User thong thuong
        v_sql:='SELECT SYMBOL,TOTAL,TRADE,HOLD,EMKQTTY,MORTAGE,BLOCKED,RECEIVING_T1,RECEIVING_T2
                FROM ( select se.*,(CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=0 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T0,
                           (CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=1 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T1,
                           (CASE WHEN ST.DUETYPE=''RS'' AND ST.TDAY=2 THEN ST.ST_QTTY ELSE 0 END) RECEIVING_T2 ,
                           0 RECEIVING_CA, 0 TOTAL
from  vw_semast_custodycd se,
        (select ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY,sb.codeid, SB.SYMBOL,SP_BD_GETCLEARDAY(ST.CLEARCD, MAX(SB.TRADEPLACE), ST.TXDATE, TO_DATE(MAX(SYSVAR.VARVALUE),''DD/MM/RRRR'')) TDAY, SUM(ST.QTTY) ST_QTTY
        FROM STSCHD ST, SYSVAR, SBSECURITIES SB
        WHERE SYSVAR.VARNAME=''CURRDATE'' AND ST.CODEID=SB.CODEID
           and  ST.status = ''N'' AND st.deltd = ''N''
        and    ST.DUETYPE=''RS''
        GROUP BY ST.AFACCTNO, ST.DUETYPE, ST.TXDATE, ST.CLEARCD, ST.CLEARDAY, SB.SYMBOL, sb.codeid) st
where se.afacctno = st.AFACCTno(+)
and se.codeid = st.codeid(+))  WHERE 0=0';
    end if;
    dbms_output.put_line('v_sql:' || v_sql);
    if length(SearchFilter)>0 then
        v_sql := v_sql || ' AND ' || SearchFilter;
    end if;
    open PV_REFCURSOR for v_sql;
EXCEPTION
  WHEN others THEN -- caution handles all exceptions
   plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
end;
/
