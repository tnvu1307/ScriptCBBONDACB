SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_errortransferrequest (pv_transactionNo varchar2,
                                pv_bank_errcode varchar2,
                                pv_bank_errmsg varchar2,
                                p_err_code in out varchar2,
                                p_err_message  in out varchar2
)
as
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_count number;
    l_count1 number;
begin

    plog.setBeginSection(pkgctx, 'sp_errorTransferRequest');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';

    select count(1)
    into l_count
    from CIREMITTANCE
    where TRANSACTIONNO = pv_transactionNo;

    if l_count=0 then
        p_err_code  := '-4201002';
        p_err_message := fn_get_errmsg_en(p_err_code);
        return;
    else
        update ciremittance
        set status = 'X',
            msgfeedback = pv_bank_errmsg,
            msgerrorcode = pv_bank_errcode,
            completetime = CURRENT_TIMESTAMP
        where transactionno = pv_transactionNo;
    end if;

    commit;
    plog.setEndSection(pkgctx, 'sp_errorTransferRequest ');
exception when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'sp_errorTransferRequest ');
end sp_errorTransferRequest ;
/
