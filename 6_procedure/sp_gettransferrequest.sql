SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_gettransferrequest(pv_refCursor IN OUT PKG_REPORT.REF_CURSOR)
as
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
begin

    plog.setBeginSection(pkgctx, 'prc_get_cfmast_approve');

    OPEN pv_refCursor FOR
    SELECT *
    FROM CIREMITTANCE
    WHERE status = 'P';

    update CIREMITTANCE
    set status='B'
    where status='P';

    commit;
    plog.setEndSection(pkgctx, 'sp_getTransferRequest');
exception when others then
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'sp_getTransferRequest');
end sp_getTransferRequest;
/
