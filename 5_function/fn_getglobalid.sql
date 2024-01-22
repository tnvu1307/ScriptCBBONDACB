SET DEFINE OFF;
CREATE OR REPLACE function fn_getglobalid(pv_txdate in date, pv_txnum in varchar2)
    return varchar2
is
    v_result  varchar2(500);
    v_txdate  date;
    v_txnum   varchar2(100);
begin

    v_txnum     := pv_txnum;
    v_txdate    := pv_txdate;
    v_result    := 'CB.' || to_char(v_txdate,'yyyymmdd') || '.' || v_txnum;
    return v_result;
exception
   when others then
   dbms_output.put_line(sqlerrm || dbms_utility.format_error_backtrace);
    return 'CB.' || pv_txnum;
end;
/
