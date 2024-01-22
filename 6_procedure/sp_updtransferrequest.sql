SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_updtransferrequest (pv_transactionNo varchar2,
                                pv_transactionType varchar2,
                                pv_transactionDate date,
                                pv_refbankcode varchar2,
                                p_err_code in out varchar2,
                                p_err_message  in out varchar2
)
as
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_count number;
    l_count1 number;
begin

    plog.setBeginSection(pkgctx, 'sp_updTransferRequest');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';

    select count(1)
    into l_count
    from CIREMITTANCE
    where TRANSACTIONNO = pv_transactionNo
    --and transtype = pv_transactionType
    --and txdate = pv_transactionDate
    ;

    if l_count=0 then
        p_err_code  := '-4201002';
        p_err_message := fn_get_errmsg_en(p_err_code);
        return;
    else
        select count(1)
        into l_count1
        from CIREMITTANCE
        where TRANSACTIONNO = pv_transactionNo
        --and transtype = pv_transactionType
        --and txdate = pv_transactionDate
        and status='B';

        if l_count1=0 then
            --[-4201003] Tr?ng thái yêu c?u không h?p l?
            p_err_code  := '-4201003';
            p_err_message := fn_get_errmsg_en(p_err_code);
            return;
        else
            update ciremittance
            set status='S',
            refbankcode = pv_refbankcode,
            sendtime = CURRENT_TIMESTAMP
            where TRANSACTIONNO = pv_transactionNo
            --and transtype = pv_transactionType
            --and txdate = pv_transactionDate
            ;
        end if;
    end if;

    commit;
    plog.setEndSection(pkgctx, 'sp_updTransferRequest ');
exception when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'sp_updTransferRequest ');
end sp_updTransferRequest ;
/
