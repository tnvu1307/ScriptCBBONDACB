SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_completetransferrequest  (
                                pv_transactionNo varchar2,
                                pv_refbankcode varchar2,
                                pv_msgfeedback varchar2,
                                pv_status  varchar2,
                                p_err_code in out varchar2,
                                p_err_message  in out varchar2
)
as
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_count number;
    l_count1 number;
    l_err varchar2(100);
    L_DATA VARCHAR2(4000);
begin

    plog.setBeginSection(pkgctx, 'sp_completeTransferRequest');

    p_err_code  := systemnums.C_SUCCESS;
    p_err_message := 'SUCCESS';


    select count(1)
    into l_count
    from CIREMITTANCE
    where TRANSACTIONNO = pv_transactionNo
    and refbankcode =pv_refbankcode;

    if l_count=0 then
        p_err_code  := '-4201002';
        p_err_message := fn_get_errmsg_en(p_err_code);
        return;
    else
        select count(1)
        into l_count1
        from CIREMITTANCE
        where TRANSACTIONNO  = pv_transactionNo
        and refbankcode =pv_refbankcode
        and status='S';

        if l_count1=0 then
            p_err_code  := '-4201003';
            p_err_message := fn_get_errmsg_en(p_err_code);
            return;
        else
            if pv_status='0' then
                update ciremittance
                set status='E',
                msgfeedback = pv_msgfeedback,
                completetime = CURRENT_TIMESTAMP
                where TRANSACTIONNO = pv_transactionNo
                and refbankcode =pv_refbankcode;
            elsif pv_status='4' then
                update ciremittance
                set status='C',
                completetime = CURRENT_TIMESTAMP
                where TRANSACTIONNO = pv_transactionNo
                and refbankcode =pv_refbankcode;
            else
                update ciremittance
                set processnum = processnum + 1,
                lastchange = CURRENT_TIMESTAMP
                where TRANSACTIONNO = pv_transactionNo
                and refbankcode =pv_refbankcode;
            end if;
            IF pv_status IN ('0', '4') THEN
                BEGIN
                    FOR REC IN (
                        SELECT * FROM CIREMITTANCE WHERE TRANSACTIONNO = PV_TRANSACTIONNO AND REFBANKCODE =PV_REFBANKCODE AND VSDORDERID IS NOT NULL
                    )
                    LOOP
                        L_DATA := '{';
                        L_DATA := L_DATA || '"VSDORDERID":"' || REC.VSDORDERID || '",';
                        L_DATA := L_DATA || '"STATUS":"' || REC.STATUS || '"';
                        L_DATA := L_DATA || '}';
                        HOSTCB.CSPKS_VSTP.PRC_8822_8823_CALLBACK(L_DATA, l_err);
                        if l_err <> systemnums.C_SUCCESS then
                            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                        end if;
                    END LOOP;
                EXCEPTION WHEN OTHERS THEN
                    NULL;
                END;
            END IF;
        end if;
    end if;

    commit;
    plog.setEndSection(pkgctx, 'sp_completeTransferRequest ');
exception when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'sp_completeTransferRequest ');
end sp_completeTransferRequest ;
/
