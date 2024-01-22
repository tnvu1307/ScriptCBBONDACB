SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PRC_HOLD_ESCROW 
is
  v_srcmrkdata varchar2(50);
  pkgctx   plog.log_ctx;
begin
    plog.setbeginsection(pkgctx, 'PRC_HOLD_ESCROW');

    v_srcmrkdata := 'STX';
   
    commit;
    plog.setendsection(pkgctx, 'PRC_HOLD_ESCROW');
exception
when others then
plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
return;
end;
/
