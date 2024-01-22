SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_inqtransferrequest (pv_refCursor IN OUT PKG_REPORT.REF_CURSOR)
as
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_max number;
begin

    plog.setBeginSection(pkgctx, 'prc_get_cfmast_approve');
    begin
        select max(to_number(varvalue))
        into l_max
        from sysvar where grname = 'VMONEY'
        and varname = 'MAXPROCESS';
    exception when others then
        l_max:=nvl(l_max,5);
    end;

    OPEN pv_refCursor FOR
    SELECT *
    FROM CIREMITTANCE
    WHERE status = 'S'
    and processnum <l_max;

    plog.setEndSection(pkgctx, 'sp_inqTransferRequest ');
exception when others then
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'sp_inqTransferRequest ');
end sp_inqTransferRequest ;
/
