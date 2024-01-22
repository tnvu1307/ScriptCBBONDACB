SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_unlockaccount(p_txmsg in tx.msg_rectype)
is
    p_err_code varchar2(50);
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    for rec in (
        select  distinct map.acfld, map.apptype
        from appmap map, apptx tx
        where map.apptxcd= tx.txcd and map.apptype = tx.apptype
        and fldtype ='N' and  tltxcd =p_txmsg.tltxcd
    )
    loop
        p_err_code:=0;
    end loop;
exception when others then
    ROLLBACK;
    plog.error (SQLERRM || dbms_utility.format_error_backtrace);
end;
/
