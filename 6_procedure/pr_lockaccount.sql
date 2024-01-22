SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_lockaccount(p_txmsg in tx.msg_rectype, p_err_code in out varchar2)
is
    l_listacctno varchar2 (1000);
    l_count number;
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    l_listacctno:='|';
    for rec in (
        select  distinct map.acfld, map.apptype
        from appmap map, apptx tx, tltx
        where map.apptxcd= tx.txcd and map.apptype = tx.apptype
        and fldtype ='N' and  map.tltxcd =p_txmsg.tltxcd
        and map.tltxcd = tltx.tltxcd and nvl(chksingle,'N') ='Y'

    )
    loop
        p_err_code:=0;
    end loop;

exception when others then
    ROLLBACK;
    plog.error (SQLERRM || dbms_utility.format_error_backtrace);
end;
/
