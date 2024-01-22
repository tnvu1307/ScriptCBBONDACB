SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CREATE_REPORT_REQ
   (
        PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
        pv_rptid IN VARCHAR2,
        pv_rptparams IN VARCHAR2,
        pv_rptstore IN VARCHAR2
   )
IS
    --pv_rptparams : (:l_refcursor,tlid=>'0001',brid=>'000001',pv_tradingid=>'ALL')
    l_sql VARCHAR2(4000);
    l_cursor_number NUMBER;
    pkgctx   plog.log_ctx;
BEGIN
    plog.setbeginsection (pkgctx, 'CREATE_REPORT_REQ');
    l_sql :='BEGIN ' || pv_rptstore || pv_rptparams || '; END;';
    EXECUTE IMMEDIATE l_sql USING IN OUT PV_REFCURSOR;
    plog.setendsection (pkgctx, 'CREATE_REPORT_REQ');
EXCEPTION
   WHEN OTHERS THEN
   plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
   plog.setendsection (pkgctx, 'CREATE_REPORT_REQ');
END;
/
