SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_get_ddmast_all_en (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
TellerId varchar2, BranchId varchar2, SearchFilter varchar2)
is
v_sql clob;
begin

    if TellerId='0001' THEN --Admin he thong
        v_sql:='SELECT REFCASAACCT,CCYCD, TOTAL,BALANCE,HOLDBALANCE,EXCHANGERATE, MARKETVALUE
        FROM ( select  D.CUSTODYCD, REFCASAACCT,CCYCD,BALANCE+HOLDBALANCE TOTAL,BALANCE,HOLDBALANCE,nvl(e.VND,0) EXCHANGERATE,nvl(e.VND,0)*(BALANCE+HOLDBALANCE) MARKETVALUE
               from  vw_ddmast_all d, exchangerate e
               where d.ccycd = e.currency(+)
              )  WHERE 0=0 ';
    else --User thong thuong
        v_sql:='SELECT REFCASAACCT,CCYCD, TOTAL,BALANCE,HOLDBALANCE,EXCHANGERATE, MARKETVALUE
          FROM ( select  REFCASAACCT,CCYCD,BALANCE+HOLDBALANCE TOTAL,BALANCE,HOLDBALANCE,nvl(e.VND,0) EXCHANGERATE,nvl(e.VND,0)*(BALANCE+HOLDBALANCE) MARKETVALUE
               from  vw_ddmast_all d, exchangerate e
               where d.ccycd = e.currency(+)
             )  WHERE 0=0 ';
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
