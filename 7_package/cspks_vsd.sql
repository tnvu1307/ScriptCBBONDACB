CREATE OR REPLACE PACKAGE cspks_vsd AS
    FUNCTION FN_GET_VSD_REQUEST(F_REQID IN NUMBER, F_PAGENO IN NUMBER) RETURN VARCHAR; --??C THONG TIN CUA YEU CAU DUA THANH XML THU VIEN
    PROCEDURE SP_AUTO_CREATE_MESSAGE; --THU TUC TAO DIEN MT TU DONG
    PROCEDURE SP_CREATE_MESSAGE(F_REQID IN NUMBER); --TAO XML MESSAGE DUA RA VSD GATEWAY
    PROCEDURE SP_RECEIVE_MESSAGE(F_MSGCONTENT IN VARCHAR); --NHAN MESSAGE
    PROCEDURE SP_PARSE_MESSAGE(F_REQID IN NUMBER); --XU LY XML MESSAGE DAU VAO
    PROCEDURE SP_AUTO_GEN_VSD_REQ;
    PROCEDURE SP_GEN_VSD_REQ(PV_AUTOID NUMBER);
    PROCEDURE PR_RECEIVE_CSV_BY_XML(PV_FILENAME IN VARCHAR2, PV_FILECONTENT IN CLOB);
    PROCEDURE PR_RECEIVE_PAR_BY_XML(PV_FILENAME IN VARCHAR2, PV_FILECONTENT IN CLOB);
    PROCEDURE PR_AUTO_PROCESS_MESSAGE;
    PROCEDURE AUTO_PROCESS_INF_MESSAGE(PV_AUTOID NUMBER, PV_FUNCNAME VARCHAR2, PV_AUTOCONF VARCHAR2, PV_REQID VARCHAR2);
    PROCEDURE AUTO_COMPLETE_CONFIRM_MSG(PV_REQID NUMBER, PV_CFTLTXCD VARCHAR2, PV_VSDTRFID NUMBER);
    PROCEDURE PRC_ODVSD_NEW(PV_REQID VARCHAR2, PV_VSDTRFLOGID NUMBER);
    PROCEDURE PRC_ODVSD_CANC(PV_REQID VARCHAR2, PV_VSDTRFLOGID NUMBER);
    FUNCTION SPLITSTRING(PV_STRING IN VARCHAR2) RETURN VARCHAR2;
END CSPKS_VSD;
/

CREATE OR REPLACE PACKAGE BODY cspks_vsd as

  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

    procedure sp_receive_message(f_msgcontent in varchar) as
        v_trflogid number;
    begin
        plog.setbeginsection(pkgctx, 'sp_receive_message');
        --Ghi nhan Log
        select seq_vsdmsglog.nextval into v_trflogid from dual;
        insert into vsdmsglog(autoid, timecreated, timeprocess, status, msgbody)
        select v_trflogid, systimestamp, null, 'P', xmltype(f_msgcontent)
        from dual;
        --Parse message XML
        sp_parse_message(v_trflogid);

        plog.setendsection(pkgctx, 'sp_receive_message');
    exception when others then
        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'sp_receive_message');
    end sp_receive_message;

    procedure sp_parse_message(f_reqid in number) as
        v_funcname         varchar2(80);
        v_sender           varchar2(60);
        v_msgtype          varchar2(60);
        v_vsdmsgid         varchar2(60);
        v_referenceid      varchar2(80);
        l_newreferenceid   varchar2(80);
        v_vsdfinfile       varchar2(1000);
        v_errdesc          varchar2(1000);
        v_msgfields        varchar2(5000);
        v_msgbody          varchar2(5000);
        v_trflogid         number;
        v_count            number;
        v_autoconf         varchar2(1);
        l_symbol           varchar2(50);
        l_symbol2           varchar2(50);
        l_quantity         number;
        l_symbol_class     varchar2(20);
        l_ref_custody_code varchar2(20);
        l_rec_custodycd    varchar2(20);
        l_vsdeffdate       varchar2(10);
        l_count            number;
        v_currdate      date;
    begin
        plog.setbeginsection(pkgctx, 'sp_parse_message');

        v_currdate := getcurrdate;

        select count(autoid)
        into v_count
        from vsdmsglog
        where autoid = f_reqid
        and status = 'P';
        if v_count > 0 then
            begin
                select trim(x.msgbody.extract('//root/txcode/@funcname').getstringval())
                into v_funcname
                from vsdmsglog x
                where autoid = f_reqid;

                v_trflogid := TO_NUMBER(TO_CHAR(v_currdate,'RRRRMMDD')||seq_vsdtrflog.nextval);

                select trim(regexp_replace(x.msgbody.extract('//root/txcode/@funcname').getstringval(),'[[:space:]]','')),
                    x.msgbody.extract('//root/txcode/@sender').getstringval(),
                    x.msgbody.extract('//root/txcode/@msgtype').getstringval(),
                    x.msgbody.extract('//root/txcode/@msgid').getstringval(),
                    x.msgbody.extract('//root/txcode/@referenceid')
                    .getstringval(),
                    x.msgbody.extract('//root/txcode/@finfile').getstringval(),
                    x.msgbody.extract('/root/txcode/detail').getstringval(),
                    x.msgbody.extract('/root/txcode/msgbody/message')
                    .getstringval(),
                    x.msgbody.extract('//root/txcode/@errdesc').getstringval()
                into v_funcname, v_sender, v_msgtype, v_vsdmsgid, v_referenceid, v_vsdfinfile, v_msgfields, v_msgbody, v_errdesc
                from vsdmsglog x
                where autoid = f_reqid;

                if instr(v_funcname, '.NAK') > 0 or instr(v_funcname, '.ACK') > 0 or instr(v_funcname, '596.') > 0 or instr(v_funcname, '996.') > 0 or instr(v_funcname, '548.') > 0  then
                    begin
                        select trf.autoconf
                        into v_autoconf
                        from vsdtrfcode trf, vsdtxreq req
                        where req.reqid = v_referenceid
                        and trf.trfcode = v_funcname
                        and trf.status = 'Y'
                        and trf.type in ('CFN')
                        and req.objname = trf.reqtltxcd;

                        update vsdtxreq
                        set vsd_err_msg = v_errdesc
                        where reqid = v_referenceid;
                    exception when no_data_found then
                        v_autoconf := 'Y';
                    end;
                else
                    select count(*)
                    into l_count
                    from vsdtrfcode
                    where status = 'Y'
                    and trfcode = v_funcname;
                    if l_count = 1 then
                        -- chi dung cho mot loai nghiep vu
                        select autoconf
                        into v_autoconf
                        from vsdtrfcode
                        where status = 'Y'
                        and trfcode = v_funcname;
                    elsif l_count = 0 then
                         v_autoconf := 'N';
                    else
                        begin
                            select trf.autoconf
                            into v_autoconf
                            from vsdtrfcode trf, vsdtxreq req
                            where req.reqid = v_referenceid
                            and trf.trfcode = v_funcname
                            and trf.status = 'Y'
                            and trf.type in ('CFO', 'CFN')
                            and req.objname = trf.reqtltxcd;
                        exception when others then
                            v_autoconf := 'Y';
                        end;
                    end if;
                end if;

                insert into vsdtrflogdtl(autoid, refautoid, fldname, fldval, caption)
                select seq_vsdtrflogdtl.nextval, v_trflogid, xt.fldname,
                    --case ra tru 598 vi 598 dang xu ly rieng cho chr(10)
                    case when instr(v_funcname,'598') > 0 then xt.fldval
                         else replace(xt.fldval,chr(10),' ') end fldval,
                    xt.flddesc
                from (select * from vsdmsglog where autoid = f_reqid) mst,
                xmltable('root/txcode/detail/field' passing mst.msgbody
                    columns fldname varchar2(200) path 'fldname',
                    fldval varchar2(500) path 'fldval',
                    flddesc varchar2(1000) path 'flddesc'
                ) xt;

                select *
                into l_symbol, l_quantity, l_symbol_class, l_ref_custody_code, l_rec_custodycd, l_vsdeffdate
                from (
                    select (CASE WHEN FLDNAME = 'QTTY' THEN REPLACE(FLDVAL,',','.') ELSE FLDVAL END) fldval, fldname
                    from vsdtrflogdtl
                    where refautoid = v_trflogid) pivot(max(nvl(fldval, 0)) as f for(fldname) in('SYMBOL' as symbol,
                                                                                              'QTTY' as qtty,
                                                                                              'CLASS' as class,
                                                                                              'RECUSTODYCD' as recustodycd,
                                                                                              'CUSTODYCD' as reccustodycd,
                                                                                              'VSDEFFDATE' vsdeffdate));
                if  LENGTH(l_vsdeffdate) <> 8 then
                    l_vsdeffdate := TO_CHAR(v_currdate,'RRRRMMDD');
                end if;


                IF NVL(v_vsdmsgid,'NULL') = 'NULL' THEN
                    BEGIN
                        SELECT FLDVAL INTO v_vsdmsgid FROM VSDTRFLOGDTL WHERE REFAUTOID = v_trflogid AND FLDNAME = 'VSDMSGID';
                    exception when others then
                        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
                    end;
                END IF;

                insert into vsdtrflog
                  (autoid,
                   sender,
                   msgtype,
                   funcname,
                   refmsgid,
                   referenceid,
                   finfilename,
                   timecreated,
                   timeprocess,
                   status,
                   autoconf,
                   errdesc,
                   symbol,
                   reclas,
                   reqtty,
                   refcustodycd,
                   reccustodycd,
                   vsdeffdate)
                select v_trflogid,
                       v_sender,
                       v_msgtype,
                       v_funcname,
                       v_vsdmsgid,
                       v_referenceid,
                       v_vsdfinfile,
                       systimestamp,
                       null,
                       'P',
                       v_autoconf,
                       v_errdesc,
                       l_symbol,
                       l_symbol_class,
                       l_quantity,
                       l_ref_custody_code,
                       l_rec_custodycd,
                       nvl(to_date(l_vsdeffdate, 'RRRRMMDD'),null)
                from dual;

                --Update status
                update vsdmsglog
                set status = 'A', timeprocess = systimestamp
                where autoid = f_reqid
                and status = 'P';
            end;
        end if;
        plog.setendsection(pkgctx, 'sp_parse_message');
    exception when others then
        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'sp_parse_message');
    end sp_parse_message;

    PROCEDURE PR_AUTO_PROCESS_MESSAGE
        --PROCESS MESSAGE RECEVED VSD
    IS
        L_SQLERRNUM  VARCHAR2(4000);
        L_COUNT      NUMBER;
        L_VSDMODE    VARCHAR2(20);
        L_VALUE     VARCHAR2(50);
        L_AUTOCONF VARCHAR2(10);
        L_PROCESS NUMBER;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PR_AUTO_PROCESS_MESSAGE');
        L_VSDMODE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDMOD');

        SELECT COUNT(*) INTO L_COUNT
        FROM SYSVAR
        WHERE GRNAME='SYSTEM' AND VARNAME='HOSTATUS' AND VARVALUE= SYSTEMNUMS.C_OPERATION_ACTIVE;
        IF L_COUNT = 0 THEN
            PLOG.SETENDSECTION(PKGCTX, 'SP_AUTO_GEN_VSD_REQ');
            RETURN;
        END IF;

        IF L_VSDMODE <>'A' THEN-- KHONG KET NOI
             RETURN;
        END IF;

        FOR REC IN (SELECT * FROM VSDTRFLOG WHERE STATUS = 'P' AND ROWNUM < 10 ORDER BY AUTOID) LOOP
            L_AUTOCONF := REC.AUTOCONF;

            SELECT COUNT(*) INTO L_COUNT FROM VSDTXREQ WHERE REQID = REC.REFERENCEID;

            IF L_COUNT > 0 THEN --CO REQ
                FOR REC_REQ IN (
                    SELECT TRF.ACKTLTXCD, TRF.REJTLTXCD, REQ.STATUS
                    FROM VSDTXREQ REQ, VSDTRFCODE TRF
                    WHERE REQ.REQID = REC.REFERENCEID
                    AND REQ.TRFCODE = TRF.TRFCODE
                    AND REQ.OBJNAME = TRF.TLTXCD
                    AND ROWNUM <= 1
                ) LOOP
                    IF REC_REQ.STATUS NOT IN ('R', 'C') THEN
                        L_PROCESS := 0;
                        FOR REC0 IN (
                            SELECT TRF.*
                            FROM VSDTRFCODE TRF, VSDTXREQ REQ
                            WHERE REQ.REQID = REC.REFERENCEID
                            AND TRF.TRFCODE = REC.FUNCNAME
                            AND TRF.STATUS = 'Y'
                            AND TRF.TYPE IN ('CFO','CFN','INF')
                            AND NVL(REQ.OBJNAME, 'A') = NVL(TRF.REQTLTXCD, 'A')
                        ) LOOP
                            L_PROCESS := 1;
                            BEGIN
                                IF REC0.TYPE IN ('CFO', 'CFN') AND REC0.TLTXCD IS NOT NULL AND L_AUTOCONF = 'Y' THEN
                                    AUTO_COMPLETE_CONFIRM_MSG(REC.REFERENCEID, REC0.TLTXCD, REC.AUTOID);
                                ELSIF REC0.TYPE = 'INF' AND L_AUTOCONF = 'Y' THEN
                                    AUTO_PROCESS_INF_MESSAGE(REC.AUTOID, REC.FUNCNAME, REC.AUTOCONF, REC.REFERENCEID);
                                END IF;

                                IF REC0.TYPE = 'CFO' THEN
                                    UPDATE VSDTXREQ SET MSGSTATUS = 'F', STATUS = 'C'
                                    WHERE REQID = REC.REFERENCEID;
                                ELSIF REC0.TYPE = 'CFN' THEN
                                    UPDATE VSDTXREQ SET MSGSTATUS = 'R', STATUS = 'R', VSD_ERR_MSG = REC.ERRDESC
                                    WHERE REQID = REC.REFERENCEID;
                                END IF;

                                UPDATE VSDTRFLOG
                                SET STATUS = 'C',
                                TIMEPROCESS = SYSTIMESTAMP
                                WHERE AUTOID = REC.AUTOID;
                            EXCEPTION WHEN OTHERS THEN
                                L_SQLERRNUM := SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                                UPDATE VSDTRFLOG
                                SET STATUS = 'E',
                                ERRDESC = ERRDESC || '[FSS: ' || L_SQLERRNUM || ']',
                                TIMEPROCESS = SYSTIMESTAMP
                                WHERE AUTOID = REC.AUTOID;

                                UPDATE VSDTXREQ SET MSGSTATUS = 'E', STATUS = 'E', VSD_ERR_MSG = L_SQLERRNUM
                                WHERE REQID = REC.REFERENCEID;
                            END;
                        END LOOP;
                        IF L_PROCESS = 0 THEN
                            BEGIN
                                IF REC.FUNCNAME LIKE '%.ACK' THEN
                                    AUTO_COMPLETE_CONFIRM_MSG(REC.REFERENCEID, REC_REQ.ACKTLTXCD, REC.AUTOID);
                                    IF NVL(REC_REQ.ACKTLTXCD, '---') = '---' THEN
                                        UPDATE VSDTXREQ SET MSGSTATUS = 'A'
                                        WHERE REQID = REC.REFERENCEID
                                        AND MSGSTATUS = 'S';
                                    ELSE
                                        UPDATE VSDTXREQ SET MSGSTATUS = 'F', STATUS = 'C'
                                        WHERE REQID = REC.REFERENCEID
                                        AND MSGSTATUS = 'S';
                                    END IF;
                                ELSIF REC.FUNCNAME LIKE '%.NAK' THEN
                                    AUTO_COMPLETE_CONFIRM_MSG(REC.REFERENCEID, REC_REQ.REJTLTXCD, REC.AUTOID);

                                    UPDATE VSDTXREQ SET MSGSTATUS = 'N', STATUS = 'R', VSD_ERR_MSG = REC.ERRDESC
                                    WHERE REQID = REC.REFERENCEID
                                    AND MSGSTATUS = 'S';
                                ELSE
                                    UPDATE VSDTRFLOG
                                    --SET STATUS = 'E',
                                    SET TIMEPROCESS = SYSTIMESTAMP,
                                    ERRDESC = ERRDESC || '[FSS: KHONG MAP DUOC NGHIEP VU CHECK VSDTRFCODE]'
                                    WHERE AUTOID = REC.AUTOID;
                                END IF;

                                UPDATE VSDTRFLOG
                                SET STATUS = 'C',
                                TIMEPROCESS = SYSTIMESTAMP
                                WHERE AUTOID = REC.AUTOID;
                            EXCEPTION WHEN OTHERS THEN
                                L_SQLERRNUM := SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                                UPDATE VSDTRFLOG
                                SET STATUS = 'E',
                                ERRDESC = ERRDESC || '[FSS: ' || L_SQLERRNUM || ']',
                                TIMEPROCESS = SYSTIMESTAMP
                                WHERE AUTOID = REC.AUTOID;
                            END;
                        END IF;
                    ELSE
                        UPDATE VSDTRFLOG
                        SET STATUS = 'C',
                        TIMEPROCESS = SYSTIMESTAMP
                        WHERE AUTOID = REC.AUTOID;
                    END IF;
                END LOOP;
            ELSE
                BEGIN
                    L_PROCESS := 0;
                    FOR REC0 IN (
                        SELECT *
                        FROM VSDTRFCODE
                        WHERE STATUS = 'Y'
                        AND TYPE = 'INF'
                        AND REQTLTXCD IS NULL
                        AND TRFCODE = REC.FUNCNAME
                    ) LOOP
                        L_PROCESS := 1;
                        AUTO_PROCESS_INF_MESSAGE(REC.AUTOID, REC.FUNCNAME, REC.AUTOCONF, REC.REFMSGID);
                        UPDATE VSDTRFLOG
                        SET STATUS = 'C',
                        TIMEPROCESS = SYSTIMESTAMP
                        WHERE AUTOID = REC.AUTOID;
                    END LOOP;
                    IF L_PROCESS = 0 THEN
                        IF REC.FUNCNAME LIKE '546.%' THEN
                            UPDATE VSDTRFLOG
                            SET STATUS = 'C',
                            TIMEPROCESS = SYSTIMESTAMP
                            WHERE AUTOID = REC.AUTOID;
                        ELSE
                            UPDATE VSDTRFLOG SET STATUS = 'E',
                            TIMEPROCESS = SYSTIMESTAMP,
                            ERRDESC = ERRDESC || '[FSS: KHONG XU LY DUOC NGHIEP VU]'
                            WHERE AUTOID = REC.AUTOID;
                        END IF;
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    L_SQLERRNUM := SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                    UPDATE VSDTRFLOG
                    SET STATUS = 'E',
                    ERRDESC = ERRDESC || '[FSS: ' || L_SQLERRNUM || ']',
                    TIMEPROCESS = SYSTIMESTAMP
                    WHERE AUTOID = REC.AUTOID;
                END;
            END IF;
        END LOOP;
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_PROCESS_MESSAGE');
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_AUTO_PROCESS_MESSAGE');
    END PR_AUTO_PROCESS_MESSAGE;

    procedure auto_process_inf_message(pv_autoid number, pv_funcname varchar2, pv_autoconf varchar2, pv_reqid varchar2) as
        v_tltxcd          varchar2(4);
        v_dt_txdate       date;
        v_reqid           number;
        v_vsdmsgid        VARCHAR2(50);
        v_VSDPROMSG       VARCHAR2(50);
        v_VSDPROMSG_value VARCHAR2(50);
        v_symbol          VARCHAR2(100);
        v_symbol2          VARCHAR2(100);
        v_rhts          VARCHAR2(100);
        v_vsdmsgdate      VARCHAR2(50);
        v_vsdmsgdate_eff  VARCHAR2(50);
        v_vsdmsgtype      VARCHAR2(50);
        v_CUSTODYCD       VARCHAR2(50);
        v_refCUSTODYCD    VARCHAR2(50);
        v_qtty            VARCHAR2(50);
        v_datetype        VARCHAR2(50);
        v_adress          VARCHAR2(200);
        v_rate            VARCHAR2(50);
        v_price           VARCHAR2(50);
        v_RIGHTOFFRATE    VARCHAR2(50);
        v_BEGINDATE       VARCHAR2(50);
        v_EXPRICE         VARCHAR2(100);
        v_FRDATETRANSFER  VARCHAR2(50);
        v_FromSE          varchar2(50);
        v_ToSE            varchar2(50);
        v_vsdReqID        varchar2(60);
        v_Sectype         varchar2(50);
        v_VSDSectype      varchar2(200);
        v_Unit            varchar2(50);
        v_tradingdate     varchar2(50);
        v_detail          varchar2(2000) DEFAULT '';
        v_detail1         varchar2(200) DEFAULT '';
        v_detail2         varchar2(200) DEFAULT '';
        v_detail3         varchar2(1000) DEFAULT '';
        v_index           number;
        v_currdate        date;
        v_link            VARCHAR2(50);
        v_trfcode         VARCHAR2(50);
        v_PlaceID         varchar2(50);
        v_PlaceID2         varchar2(50);
        v_notes           varchar2(1000);
        v_postdate        varchar2(50);
        v_round           varchar2(50);
        v_enddate         varchar2(50);
        v_TODATETRANSFER  varchar2(50);
        v_exrate          VARCHAR2(50);
        v_tax             VARCHAR2(50);
        v_QUANTITY        VARCHAR2(50);
        v_VND             VARCHAR2(50);
        v_VSDEFFDATE      VARCHAR2(50);
        l_reqid           VARCHAR2(200);
        l_countcuscd      number;
        l_VSDPROMSGID     VARCHAR2(500);
        l_refcustodycd    VARCHAR2(50);
        l_reqtltxcd       varchar2(50);
        l_referenceid     varchar2(50);
        l_custodycd       VARCHAR2(50);
        l_number          number;
        V_MT518_AUTOID    number;
        V_VSDMSGPAYDATE   VARCHAR2(20);
        V_VSDBICCODE      VARCHAR2(20);
        V_AMT             varchar2(20);
        V_VSDORDERID      varchar2(50);
        V_VSDMSGIDNEWM    varchar2(100);
        v_TXNUM           varchar2(50);
        v_VSDWFTCODE      VARCHAR2(100);
        L_DATA VARCHAR2(4000);
        L_ERR_CODE VARCHAR2(100);
    BEGIN
        plog.setbeginsection(pkgctx, 'auto_process_inf_message');


        v_currdate := getcurrdate;

        SELECT nvl(tltxcd,'0') INTO v_tltxcd FROM vsdtrfcode WHERE trfcode = pv_funcname;
        --Neu message la tu dong xu ly (cu la Y)
        select reccustodycd,refcustodycd,referenceid into l_custodycd,l_refcustodycd,l_referenceid from vsdtrflog where autoid = pv_autoid;

        IF pv_funcname like '508.%' then
        BEGIN
            SELECT *
            INTO v_vsdmsgid,
                 v_vsdReqID,
                 v_vsdmsgdate,
                 v_vsdmsgtype,
                 v_CUSTODYCD,
                 v_symbol,
                 v_FromSE,
                 v_ToSE,
                 v_Qtty,
                 v_Sectype,
                 v_VSDSectype,
                 v_Unit,
                 v_notes,
                 v_VSDEFFDATE
            FROM (SELECT fldname, fldval
                    FROM vsdtrflogdtl
                   WHERE REFAUTOID = pv_autoid) PIVOT(MAX(fldval) as F for(fldname) IN('VSDMSGID',
                                                                                        'REQID',
                                                                                        'VSDMSGDATE',
                                                                                        'VSDFUNCNAME',
                                                                                        'CUSTODYCD',
                                                                                        'SYMBOL',
                                                                                        'FROMSE',
                                                                                        'TOSE',
                                                                                        'QTTY',
                                                                                        'SECTYPE',
                                                                                        'VSDSECTYPE',
                                                                                        'UNIT',
                                                                                        'NOTES',
                                                                                        'VSDEFFDATE'));

              --Insert thong tin vao bang VSD_MT508_INF

              INSERT INTO vsd_mt508_inf(autoid, vsdmsgid,VSDPROMSG, vsdreqid, vsdmsgdate , vsdmsgtype, custodycd, symbol, fromse, tose, qtty, sectype, vsdsectype, unit,description,VSDEFFDATE)
              select seq_vsd_mt508_inf.nextval autoid, pv_autoid,pv_funcname, v_vsdmsgid,
              case when length(trim(v_vsdmsgdate)) > 0 then to_date(v_vsdmsgdate, 'RRRRMMDD') else null end , v_vsdmsgtype, v_CUSTODYCD, v_symbol, v_FromSE, v_ToSE, v_Qtty, v_Sectype,
              v_VSDSectype, v_Unit,v_notes,case when length(trim(v_VSDEFFDATE)) > 0 then to_date(v_VSDEFFDATE, 'RRRRMMDD') else null end
              from dual;
        END;
        ELSIF pv_funcname like '598.007%' then
        BEGIN

          SELECT *
            INTO v_vsdmsgid,
                 v_VSDPROMSG,
                 v_vsdmsgtype,
                 v_symbol,
                 v_vsdmsgdate,
                 v_vsdmsgdate_eff,
                 v_qtty,
                 v_tradingdate,
                 v_VSDPROMSG_value,
                 v_detail,
                 v_PlaceID,
                 v_rate,
                 l_VSDPROMSGID,
                 v_VSDWFTCODE
            FROM (SELECT fldname, decode(fldname,'NOTES',replace(fldval,chr(10),'|'),fldval) fldval
                    FROM vsdtrflogdtl
                   WHERE REFAUTOID = pv_autoid) PIVOT(MAX(fldval) as F for(fldname) IN('VSDMSGID',
                                                                                       'VSDPROMSG',
                                                                                       'VSDMSGTYPE',
                                                                                       'SYMBOL',
                                                                                       'CRDATE',
                                                                                       'VSDEFFDATE',
                                                                                       'QTTY',
                                                                                       'TRADINGDATE',
                                                                                       'CLASS',
                                                                                       'NOTES',
                                                                                       'PLACEID',
                                                                                       'RATE',
                                                                                       'VSDPROMSGID',
                                                                                       'VSDWFTCODE'
                                                                                       ));


          if length(v_detail) > 0 and v_VSDPROMSG = 'ESET' then
              select SUBSTR(v_detail,1,INSTR(v_detail,'|',1)-1), INSTR(v_detail,'|',1)  into v_detail1, v_index from dual;
              v_detail := REPLACE(v_detail,v_detail1||'|','');
              select SUBSTR(v_detail,1,INSTR(v_detail,'|',1)-1), INSTR(v_detail,'|',1)  into v_detail2, v_index from dual;
              v_detail := REPLACE(v_detail,v_detail2||'|','');
              v_detail3 := v_detail;

          ELSE
            v_detail1 := null;
            v_detail2 := null;
            v_detail3 := null;

          end if;


          /*if v_vsdmsgdate is null then
            v_vsdmsgdate := to_char(v_currdate,'RRRRMMDD');
          end if;*/

          if length(v_PlaceID) > 0 then
            select cdcontent into v_PlaceID2 from allcode a where a.cdname = 'PLACEID' and a.cdval = v_PlaceID;
          end if;


          if INSTR(v_tradingdate,'TRAD') > 0 or INSTR(v_tradingdate,'PREP') > 0 then
            v_tradingdate:= SUBSTR(v_tradingdate,6);
          else
            v_tradingdate:='';
          end if;

         --Insert thong tin vao bang VSD_MT598_INF
          INSERT INTO vsd_mt598_inf
            (AUTOID, VSDMSGID, vsdsubmsgtype, VSDPROMSG, vsdpromsg_value, SYMBOL, VSDMSGDATE, VSDMSGDATEEFF, VSDMSGTYPE, QTTY, TRADINGDATE, paymentcycle, description, PLACEID,ROOM,VSDPROMSGID)
          VALUES
            (seq_vsd_mt598_inf.nextval,
             pv_autoid,
             v_VSDPROMSG_value,
             pv_funcname||v_VSDPROMSG||'.',
             v_VSDPROMSG,
             v_symbol,
             case when length(trim(v_vsdmsgdate))>0 then to_date(v_vsdmsgdate, 'RRRRMMDD') else null end,
             case when length(trim(v_vsdmsgdate_eff))>0 then to_date(v_vsdmsgdate_eff, 'RRRRMMDD') else null end,
             v_vsdmsgtype,
             v_qtty,
             nvl(v_detail1,v_tradingdate),v_detail2,
             decode(v_VSDPROMSG,'ESET',v_detail3,v_detail),
             v_PlaceID2,
             v_rate,l_VSDPROMSGID
             );
            IF v_VSDPROMSG = 'ISSU' THEN
                INSERT INTO VSD_MT598_ISSU(AUTOID, SYMBOL, VSDWFTCODE, VSDMSGTYPE)
                VALUES(SEQ_VSD_MT598_ISSU.NEXTVAL, v_symbol, v_VSDWFTCODE ,v_vsdmsgtype);
            END IF;

          END;
        ELSIF pv_funcname like '544.%' then
        BEGIN
            SELECT *
            INTO v_vsdmsgid,
                 v_vsdReqID,
                 v_vsdmsgdate,
                 v_vsdmsgtype,
                 v_CUSTODYCD,
                 v_symbol,
                 v_symbol2,
                 v_FromSE,
                 v_ToSE,
                 v_Qtty,
                 v_Sectype,
                 v_VSDSectype,
                 v_Unit,
                 v_link,
                 v_refcustodycd,
                 v_notes,
                 v_VSDEFFDATE
            FROM (SELECT fldname, fldval
                    FROM vsdtrflogdtl
                   WHERE REFAUTOID = pv_autoid) PIVOT(MAX(fldval) as F for(fldname) IN('VSDMSGID',
                                                                                        'REQID',
                                                                                        'VSDMSGDATE',
                                                                                        'VSDFUNCNAME',
                                                                                        'CUSTODYCD',
                                                                                        'SYMBOL',
                                                                                        'SYMBOL2',
                                                                                        'SETR',
                                                                                        'STCO',
                                                                                        'QTTY',
                                                                                        'SECTYPE',
                                                                                        'VSDSECTYPE',
                                                                                        'UNIT','LINK','REFCUSTODYCD',
                                                                                        'NOTES','VSDEFFDATE'));

                --Xu ly cho dien 544
                v_rhts:= v_symbol;
                if v_FromSE is not null then
                    v_FromSE:= 'SETR//'||v_FromSE;
                end if;
                if v_ToSE is not null then
                    if INSTR(v_FromSE,v_ToSE) <= 0 then
                        v_ToSE:= 'STCO//'||v_ToSE;
                    else
                        v_ToSE:= '';
                    end if;
                end if;

                if v_link is not null then
                    v_link:= 'LINK//'||v_link;
                end if;

                if INSTR(v_rhts,'RHTS')>0 then
                    v_symbol:=v_symbol2;
                    v_trfcode:= '544.'||v_vsdmsgtype||'.'||v_link||'.'||v_FromSE||'.'||v_ToSE||'.RHTS';
                else
                    v_trfcode:= pv_funcname;
                end if;
                begin
                 v_VSDSectype:=TO_NUMBER(v_VSDSectype);
                exception
                 when others then
                 v_notes:=v_VSDSectype;
                 v_VSDSectype:='0';
                end;

              --Insert thong tin vao bang VSD_MT508_INF

              INSERT INTO vsd_mt508_inf(autoid, vsdmsgid,VSDPROMSG, vsdreqid, vsdmsgdate , vsdmsgtype, custodycd, symbol, fromse, tose, qtty, sectype, vsdsectype, unit,refcustodycd,description,VSDEFFDATE)
              select seq_vsd_mt508_inf.nextval autoid, pv_autoid,v_trfcode, v_vsdmsgid,
              case when length(trim(v_vsdmsgdate)) > 0 then to_date(v_vsdmsgdate, 'RRRRMMDD') else null end ,
              v_vsdmsgtype, v_CUSTODYCD, v_symbol, v_FromSE, v_ToSE, v_Qtty, v_Sectype, v_VSDSectype,
              v_Unit,v_refcustodycd,v_notes, case when length(trim(v_VSDEFFDATE)) > 0 then to_date(v_VSDEFFDATE, 'RRRRMMDD') else null end
              from dual;

            BEGIN
                IF pv_funcname = '544.NEWM.LINK//518.SETR//TRAD.STCO//NPAR' THEN
                    FOR REC_TPRL IN (
                        SELECT * FROM VSDTRFLOGDTL WHERE FLDNAME = 'VSDORDERID' AND REFAUTOID = PV_AUTOID
                    )
                    LOOP
                        L_DATA := '{';
                        L_DATA := L_DATA || '"VSDORDERID":"' || REC_TPRL.FLDVAL || '"';
                        L_DATA := L_DATA || '}';

                        CBACB.CSPKS_VSTP.PRC_VSDCONFIRM_MT544(L_DATA, L_ERR_CODE);
                        IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                        END IF;
                    END LOOP;
                END IF;
            EXCEPTION WHEN OTHERS THEN
                PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            END;
        END;
        ELSIF pv_funcname like '546.%' then
        BEGIN
            SELECT *
            INTO v_vsdmsgid,
                 v_vsdReqID,
                 v_vsdmsgdate,
                 v_vsdmsgtype,
                 v_CUSTODYCD,
                 v_symbol,
                 v_FromSE,
                 v_ToSE,
                 v_Qtty,
                 v_Sectype,
                 v_VSDSectype,
                 v_Unit,
                 v_notes,
                 v_VSDEFFDATE
            FROM (SELECT fldname, fldval
                    FROM vsdtrflogdtl
                   WHERE REFAUTOID = pv_autoid) PIVOT(MAX(fldval) as F for(fldname) IN('VSDMSGID',
                                                                                        'REQID',
                                                                                        'VSDMSGDATE',
                                                                                        'VSDFUNCNAME',
                                                                                        'CUSTODYCD',
                                                                                        'SYMBOL',
                                                                                        'FROMSE',
                                                                                        'TOSE',
                                                                                        'QTTY',
                                                                                        'SECTYPE',
                                                                                        'VSDSECTYPE',
                                                                                        'UNIT','NOTES','VSDEFFDATE'));

              --Insert thong tin vao bang VSD_MT508_INF

              INSERT INTO vsd_mt508_inf(autoid, vsdmsgid,VSDPROMSG, vsdreqid, vsdmsgdate , vsdmsgtype, custodycd, symbol, fromse, tose, qtty, sectype, vsdsectype, unit, description,VSDEFFDATE)
              select seq_vsd_mt508_inf.nextval autoid, pv_autoid,pv_funcname, v_vsdmsgid, to_date(v_vsdmsgdate, 'RRRRMMDD') , v_vsdmsgtype, v_CUSTODYCD, v_symbol, v_FromSE, v_ToSE, v_Qtty, v_Sectype,
              v_VSDSectype, v_Unit, v_notes,to_date(v_VSDEFFDATE, 'RRRRMMDD')
              from dual;

            BEGIN
                IF pv_funcname = '546.NEWM.LINK//518.SETR//TRAD.STCO//NPAR' THEN
                    FOR REC_TPRL IN (
                        SELECT * FROM VSDTRFLOGDTL WHERE FLDNAME = 'VSDORDERID' AND REFAUTOID = PV_AUTOID
                    )
                    LOOP
                        L_DATA := '{';
                        L_DATA := L_DATA || '"VSDORDERID":"' || REC_TPRL.FLDVAL || '"';
                        L_DATA := L_DATA || '}';

                        CBACB.CSPKS_VSTP.PRC_VSDCONFIRM_MT546(L_DATA, L_ERR_CODE);
                        IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN
                            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                        END IF;
                    END LOOP;
                END IF;
            EXCEPTION WHEN OTHERS THEN
                PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            END;

        END;
        ELSIF pv_funcname like '564.%' then
        BEGIN
          SELECT *
            INTO v_vsdmsgid,
                 v_VSDPROMSG,
                 v_VSDPROMSG_value,
                 v_symbol,
                 v_vsdmsgdate,
                 v_vsdmsgdate_eff,
                 v_vsdmsgtype,
                 v_qtty,
                 v_CUSTODYCD,
                 v_refCUSTODYCD,
                 v_datetype,
                 v_adress,
                 v_rate,
                 v_price,
                 v_BEGINDATE,
                 v_EXPRICE,
                 v_FRDATETRANSFER,v_TODATETRANSFER,
                 v_symbol2,v_postdate, v_round,
                 v_enddate,v_notes,v_QUANTITY
            FROM (SELECT fldname, fldval
                    FROM vsdtrflogdtl
                   WHERE REFAUTOID = pv_autoid) PIVOT(MAX(fldval) as F for(fldname) IN('VSDMSGID',
                                                                                       'VSDPROMSG',
                                                                                       'VSDPROMSGDTL',
                                                                                       'SYMBOL',
                                                                                       'TXDATE',
                                                                                       'VSDEFFDATE',
                                                                                       'CATYPE',
                                                                                       'QTTY',
                                                                                       'CUSTODYCD',
                                                                                       'REFCUSTODYCD',
                                                                                       'DATETYPE',
                                                                                       'ADDRESSMEET',
                                                                                       'EXRATE',
                                                                                       'PRICE',
                                                                                       'BEGINDATE',
                                                                                       'EXPRICE',
                                                                                       'FRDATE','TODATE','REFSYMBOL','POSTDATE','ROUND',
                                                                                       'ENDDATE','NOTES','QUANTITY'));

          --Insert thong tin vao bang VSD_MT598_INF
          /*if INSTR(pv_funcname, '544') > 0 then
            v_vsdmsgtype := 'DLWM';
          end if;*/
          if v_RIGHTOFFRATE is not null then
            v_RIGHTOFFRATE:= SUBSTR(v_RIGHTOFFRATE,6);
          end if;

          --92A
          if v_rate is not null then
            v_exrate:= SUBSTR(v_rate,6);
            v_tax:=SUBSTR(v_rate,1,4);
            if INSTR(v_exrate,'/')>0 then
                v_exrate:=SUBSTR(v_exrate,1,INSTR(v_exrate,'/')-1);
            end if;

            if INSTR(v_exrate,'%')>0 then
                v_RIGHTOFFRATE:=REPLACE(v_exrate,'%');
                v_exrate:='100/'||REPLACE(v_exrate,'%');
            elsif INSTR(v_exrate,':')>0 then
                v_exrate:=REPLACE(v_exrate,':','/');
                BEGIN
                  v_RIGHTOFFRATE:=ROUND((SUBSTR(v_exrate,1,INSTR(v_exrate,'/') -1) / SUBSTR(v_exrate,INSTR(v_exrate,'/') + 1) *100),4);
                EXCEPTION
                  WHEN OTHERS THEN
                    plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                    v_RIGHTOFFRATE := 0;
                END;
            end if;

            if v_exrate is null then
                v_tax:='';
            end if;

          end if;

          if v_BEGINDATE is not null then
            v_enddate:=SUBSTR(v_BEGINDATE,15);
            v_BEGINDATE:=SUBSTR(v_BEGINDATE,6,8);
          end if;
          if v_FRDATETRANSFER is not null then
            v_TODATETRANSFER:=SUBSTR(v_FRDATETRANSFER,15);
            v_FRDATETRANSFER:=SUBSTR(v_FRDATETRANSFER,6,8);
          end if;
          if v_EXPRICE is not null then
            v_VND:=SUBSTR(v_EXPRICE,1,3);
            v_EXPRICE:=SUBSTR(v_EXPRICE,4);
          end if;

          --so luong
          if v_QUANTITY is null then
             v_QUANTITY:=v_qtty;
          end if;
          --price
          v_price:=REPLACE(
                        SUBSTR(v_price,1, (
                                          case when INSTR(v_price,' ') > 0 then INSTR(v_price,' ') -1
                                               else LENGTH(v_price) end
                                          )
                        ),'.');

          if v_symbol2 is null then
            v_symbol2:=v_symbol;
          end if;

            select count(1) into l_number from vsd_mt564_inf where camastid = v_vsdmsgid;
            if l_number > 0 then
                   update vsd_mt564_inf set msgstatus = 'C' where camastid = v_vsdmsgid;
            end if;

          INSERT INTO vsd_mt564_inf
            (autoid,
             VSDMSGID,
             VSDPROMSG,
             VSDPROMSG_VALUE,
             SYMBOL,
             VSDMSGDATE,
             VSDMSGDATEEFF,
             VSDMSGTYPE,
             QTTY,
             custodycd,
             refcustodycd,
             datetype,
             adress,
             exrate,
             price,
             RIGHTOFFRATE,
             BEGINDATE,
             ENDDATE,
             EXPRICE,
             FRDATETRANSFER,REFSYMBOL,POSTDATE,ROUND,
             TODATETRANSFER,DESCRIPTION,TAX,EXPRICETYPE
             )
          VALUES
            (seq_vsd_mt564_inf.nextval,
             pv_autoid,
             pv_funcname,
             v_VSDPROMSG_value,
             v_symbol,
             case when length(trim(v_vsdmsgdate))>0 then to_date(v_vsdmsgdate, 'RRRRMMDD') else null end,
             case when length(trim(v_vsdmsgdate_eff))>0 then to_date(v_vsdmsgdate_eff, 'RRRRMMDD') else null end,
             v_vsdmsgtype,
             to_number(v_QUANTITY),
             v_CUSTODYCD,
             v_refCUSTODYCD,
             case when length(trim(v_datetype))>0 then to_date(v_datetype, 'RRRRMMDD') else null end,
             v_adress,
             v_exrate,
             to_number(v_price),
             v_RIGHTOFFRATE,
             case when length(trim(v_BEGINDATE))>0 then to_date(v_BEGINDATE, 'RRRRMMDD') else null end,
             case when length(trim(v_enddate))>0 then to_date(v_enddate, 'RRRRMMDD') else null end,
             v_EXPRICE,
             case when length(trim(v_FRDATETRANSFER))>0 then to_date(v_FRDATETRANSFER, 'RRRRMMDD') else null end,
             v_symbol2,
             case when length(trim(v_postdate))>0 then to_date(v_postdate, 'RRRRMMDD') else null end,
             v_round,
             case when length(trim(v_TODATETRANSFER))>0 then to_date(v_TODATETRANSFER, 'RRRRMMDD') else null end,
             v_notes,v_tax,v_VND
             );
        END;

        ELSIF pv_funcname like '518.%' then
        BEGIN
            FOR REC518 IN
            (
                SELECT *
                --INTO V_VSDMSGID, V_REQID, V_VSDMSGDATE, V_VSDMSGPAYDATE, V_CUSTODYCD, V_SYMBOL, V_VSDBICCODE, V_QTTY, V_PRICE, V_AMT, V_VSDORDERID, V_NOTES, V_VSDMSGIDNEWM, V_TXNUM
                FROM (
                    SELECT FLDVAL, FLDNAME
                    FROM VSDTRFLOGDTL
                    WHERE REFAUTOID = PV_AUTOID) TTT
                PIVOT (MAX(FLDVAL)
                FOR FLDNAME IN (
                    'VSDMSGID' as VSDMSGID,
                    'REQID' as REQID,
                    'VSDMSGDATE' as VSDMSGDATE,
                    'VSDMSGPAYDATE' as VSDMSGPAYDATE,
                    'VSDCUSTODYCD' as VSDCUSTODYCD,
                    'VSDSYMBOL' as VSDSYMBOL,
                    'VSDBICCODE' as VSDBICCODE,
                    'VSDQUANTIY' as VSDQUANTIY,
                    'VSDPRICE' as VSDPRICE,
                    'VSDAMT' as VSDAMT,
                    'VSDORDERID' as VSDORDERID,
                    'NOTES' as NOTES,
                    'VSDMSGIDNEWM' as VSDMSGIDNEWM,
                    'VSDTXNUM' as VSDTXNUM
                ))  PVTTABLE
            )
            LOOP
                SELECT COUNT(1) INTO L_NUMBER FROM VSD_MT518_INF WHERE VSDTXNUM = VSDMSGID AND VSDPROMSG = PV_FUNCNAME;
                IF L_NUMBER = 0 THEN
                    V_MT518_AUTOID := SEQ_VSD_MT518_INF.NEXTVAL;
                    /*INSERT THONG TIN VAO BANG VSD_MT518_INF*/


                    INSERT INTO VSD_MT518_INF (AUTOID, VSDMSGID, VSDPROMSG, VSDREQID, VSDMSGDATE, VSDMSGPAYDATE, VSDMSGTYPE, VSDCUSTODYCD, VSDSYMBOL, VSDBICCODE, VSDQUANTIY, VSDPRICE, VSDAMT, VSDORDERID, VSDTXNUM, DESCRIPTION)
                    SELECT V_MT518_AUTOID, PV_AUTOID, PV_FUNCNAME, NVL(REC518.VSDMSGIDNEWM, REC518.VSDMSGID), TO_DATE(SUBSTR(REC518.VSDMSGDATE,1,8), 'RRRRMMDD'), TO_DATE(SUBSTR(REC518.VSDMSGPAYDATE,1,8), 'RRRRMMDD'), 'MT518',
                    REC518.VSDCUSTODYCD, REC518.VSDSYMBOL, REC518.VSDBICCODE, REC518.VSDQUANTIY, REC518.VSDPRICE, REC518.VSDAMT, REC518.VSDORDERID, REC518.VSDMSGID, REC518.NOTES FROM DUAL;

                    IF PV_FUNCNAME LIKE '518.NEWM%' THEN
                        IF NVL(REC518.VSDMSGIDNEWM, '') = '' THEN
                            UPDATE VSD_MT518_INF SET STATUS = 'NEWM' WHERE AUTOID = V_MT518_AUTOID;
                            CSPKS_VSD.PRC_ODVSD_NEW('0', PV_AUTOID);
                        ELSE
                            UPDATE VSD_MT518_INF SET STATUS = 'REPL', STATUSTRANSACTION = 'P' WHERE VSDORDERID = REC518.VSDORDERID AND VSDPROMSG = PV_FUNCNAME;
                            UPDATE VSD_MT518_INF_HIST SET STATUS = 'REPL', STATUSTRANSACTION = 'P' WHERE VSDORDERID = REC518.VSDORDERID AND VSDPROMSG = PV_FUNCNAME;
                            UPDATE VSD_MT518_INF SET STATUS = 'NEWM' WHERE AUTOID = V_MT518_AUTOID;
                            CSPKS_VSD.PRC_ODVSD_CANC('0', PV_AUTOID);
                            CSPKS_VSD.PRC_ODVSD_NEW('0', PV_AUTOID);
                        END IF;
                    ELSIF PV_FUNCNAME LIKE '518.CANC%' THEN
                        UPDATE VSD_MT518_INF SET STATUS = 'CANC', VSDID518CANC = REC518.VSDTXNUM, DESCRIPTION = REC518.NOTES WHERE VSDORDERID = REC518.VSDORDERID;
                        UPDATE VSD_MT518_INF_HIST SET STATUS = 'CANC', VSDID518CANC = REC518.VSDTXNUM, DESCRIPTION = REC518.NOTES WHERE VSDORDERID = REC518.VSDORDERID;
                        CSPKS_VSD.PRC_ODVSD_CANC('0', PV_AUTOID);
                    END IF;
                END IF;
            END LOOP;
        END;
        end if; -- end case function
        --Neu message la tu dong xu ly (cu la Y)
        /*
        IF PV_AUTOCONF = 'Y' THEN
            IF V_TLTXCD = '2278' THEN
                AUTO_CALL_TXPKS_2278(PV_REQID, PV_AUTOID);
            ELSIF V_TLTXCD = '3309' THEN
                AUTO_CALL_TXPKS_3309(PV_REQID, PV_AUTOID);
            END IF;
        END IF;
        */

        plog.setendsection(pkgctx, 'auto_process_inf_message');
    end auto_process_inf_message;

    PROCEDURE SP_AUTO_CREATE_MESSAGE AS
        V_TRFLOGID NUMBER;
        V_COUNT NUMBER;
        CURSOR V_CURSOR IS
        SELECT REQID, OBJNAME, TRFCODE, TXDATE, OBJKEY
        FROM VSDTXREQ
        WHERE STATUS = 'P'
        --AND ADTXPROCESS = 'N'
        AND TRFCODE IN (
            SELECT TRFCODE
            FROM VSDTRFCODE
            WHERE STATUS = 'Y'
            AND TYPE IN ('REQ', 'EXREQ')
        );
        V_ROW V_CURSOR%ROWTYPE;
    BEGIN
        OPEN V_CURSOR;
        LOOP
            FETCH V_CURSOR
            INTO V_ROW;
            EXIT WHEN V_CURSOR%NOTFOUND;

            --CREATE MESSAGE
            SP_CREATE_MESSAGE(V_ROW.REQID);
        END LOOP;
    END SP_AUTO_CREATE_MESSAGE;

    PROCEDURE SP_CREATE_MESSAGE(F_REQID IN NUMBER) AS
        V_REQUEST   VARCHAR2(4000);
        V_COUNT     NUMBER;
        L_SQLERRNUM VARCHAR2(200);
        L_NUMPAGE   NUMBER;
        L_REQID NUMBER;
    BEGIN
        --NEU MESSAGE DA TAO HOAC KHOI LUONG BANG 0 (NGOAI TRU MSG MO TAI KHOAN TH? KO TAO MESSAGE)
        SELECT COUNT(*)
        INTO V_COUNT
        FROM VSDTXREQ
        WHERE REQID = F_REQID
        AND MSGSTATUS = 'P';

        IF V_COUNT = 0 THEN
            RETURN;
        END IF;
        SELECT NUMPAGE INTO L_NUMPAGE FROM  VSDTXREQ WHERE REQID = F_REQID;
        FOR I IN 1..L_NUMPAGE LOOP
            --GET MESSAGE
            V_REQUEST := FN_GET_VSD_REQUEST(F_REQID, I);

            L_REQID := F_REQID;

            IF I > 1 THEN
                L_REQID := TO_NUMBER(TO_CHAR(L_REQID) || TO_CHAR(I));
            END IF;

            INSERT INTO VSDMSGFROMFLEX(REQID, MSGBODY, STATUS)
            VALUES(L_REQID, V_REQUEST, 'P');

        END LOOP;
        --UPDATE STATUS
        UPDATE VSDTXREQ
        SET STATUS = 'S', MSGSTATUS = 'S' --, ADTXPROCESS = 'Y'
        WHERE REQID = F_REQID
        AND STATUS = 'P';

        BEGIN
            CSPKS_ESB.SP_SET_MESSAGE_QUEUE(V_REQUEST, 'TXAQS_FLEX2VSD');
        EXCEPTION WHEN OTHERS THEN
            PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        END;
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END SP_CREATE_MESSAGE;

    function fn_get_vsd_request(f_reqid in number, f_pageNo IN NUMBER) return varchar as
        v_trfcode varchar2(60);
        v_refval  varchar2(180);
        v_field   varchar2(3000);
        v_request varchar2(30000);
        v_sysbol  varchar2(20);
        v_msgtype varchar2(10);
        v_murid varchar2(20);
        v_objname varchar2(50);
        v_reqtime varchar2(50);
        cursor v_cursor is

        select fldname,
             (case when (nval <> 0) then REPLACE(TO_CHAR(nval, 'FM999999999999990.999999'),'.',',')
                   when instr(cval, '{$') > 0 and  instr(cval, '$}') > 0 then cval
                   else translate(cval, 'A$', 'A')
             end) fldval,
             xmlelement("fldval",(
                case when (nval <> 0) then REPLACE(TO_CHAR(nval, 'FM999999999999990.999999'),'.',',')
                     when instr(cval, '{$') > 0 and  instr(cval, '$}') > 0 then cval
                     else translate(cval, 'A$', 'A')
                end)).getstringval() xmlval,
                convert,maxlength
        from vsdtxreqdtl
        where reqid = f_reqid
        AND (pageNo = 0 OR pageNo = f_pageNo);
        v_row v_cursor%rowtype;
    begin
        plog.setbeginsection(pkgctx, 'fn_get_vsd_request');
        --read header
        select trfcode, objname into v_trfcode, v_objname from vsdtxreq where reqid = f_reqid;
        --read body
        open v_cursor;
        loop
        fetch v_cursor
        into v_row;
        exit when v_cursor%notfound;
            if v_row.fldname = 'SYMBOL' then
                begin
                    v_field := '<field><fldname convert="">' || v_row.fldname || '</fldname><fldval>' || replace(v_row.fldval, '_WFT', '') || '</fldval></field>';
                end;
            else
                if (v_row.maxlength is null) then
                    v_field := '<field><fldname convert="' || v_row.convert || '">' || v_row.fldname || '</fldname>' || v_row.xmlval || '</field>';
                else
                    v_field := '<field><fldname convert="' || v_row.convert || '" maxlength="' || v_row.maxlength ||'">' || v_row.fldname || '</fldname>' || v_row.xmlval || '</field>';
                end if;
            end if;
            v_request := v_request || v_field;
            plog.setendsection(pkgctx, 'fn_get_vsd_request');
        end loop;
        -- Gen req id
        v_request := v_request || '<field><fldname convert="">REQID</fldname><fldval>' || f_reqid || '</fldval></field>';

        -- Gen req time
        SELECT to_char(SYSDATE, 'RRRRMMDDHH24MISS') INTO v_reqtime FROM dual;
        v_request := v_request || '<field><fldname convert="">REQTIME</fldname><fldval>' || v_reqtime || '</fldval></field>';

        --- locpt tao them gia tri loai dien de xu ly cho SHB
        begin
            select vsdmt into v_msgtype from vsdtrfcode where trfcode = v_trfcode and tltxcd = v_objname;
        exception
        when others then
            select vsdmt into v_msgtype from vsdtrfcode where trfcode = v_trfcode;
        end;
        --murid danh cho swiftnet --> key duy nhat
        --select to_char(sysdate,'RRRRMMDD')||LPAD(seq_swiftmur.nextval,4,'0') into v_murid from dual;


        plog.setEndSection(pkgctx, 'fn_get_vsd_request');
        return '<root><txcode funcname="' || v_trfcode || '" murid="' || v_murid ||'" referenceid="' || f_reqid || '" msgtype="'||v_msgtype||'"><detail>' || v_request || '</detail></txcode></root>';

        plog.setendsection(pkgctx, 'fn_get_vsd_request');
    exception when others then
        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'fn_get_vsd_request');
        return '';
    end fn_get_vsd_request;

    PROCEDURE SP_AUTO_GEN_VSD_REQ AS
        V_TRFLOGID NUMBER;
        L_COUNT NUMBER;
        CURSOR V_CURSOR IS
        SELECT VSD1.AUTOID
        FROM VSD_PROCESS_LOG VSD1
        WHERE VSD1.PROCESS = 'N'
        AND VSD1.TRFCODE IN (SELECT TRFCODE FROM VSDTRFCODE WHERE STATUS = 'Y' AND TYPE IN ('REQ', 'EXREQ'));
        V_ROW V_CURSOR%ROWTYPE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'SP_AUTO_GEN_VSD_REQ');

        SELECT COUNT(*) INTO L_COUNT
        FROM SYSVAR
        WHERE GRNAME='SYSTEM' AND VARNAME='HOSTATUS'  AND VARVALUE= SYSTEMNUMS.C_OPERATION_ACTIVE;
        IF L_COUNT = 0 THEN
            PLOG.SETENDSECTION(PKGCTX, 'SP_AUTO_GEN_VSD_REQ');
            RETURN ;
        END IF;
        --SINH REQUEST VAO VSDTXREQ
        OPEN V_CURSOR;
        LOOP
        FETCH V_CURSOR
        INTO V_ROW;
        EXIT WHEN V_CURSOR%NOTFOUND;

            --SINH VAO VSDTXREQ, VSDTXREQDTL
            SP_GEN_VSD_REQ(V_ROW.AUTOID);

            UPDATE VSD_PROCESS_LOG SET PROCESS = 'Y' WHERE AUTOID = V_ROW.AUTOID;
        END LOOP;

        -- GOI HAM TU DONG GEN MESSAGE DAY LEN VSD
        SP_AUTO_CREATE_MESSAGE;
        PLOG.SETENDSECTION(PKGCTX, 'SP_AUTO_GEN_VSD_REQ');
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'SP_AUTO_GEN_VSD_REQ');
    END SP_AUTO_GEN_VSD_REQ;

    procedure sp_gen_vsd_req(pv_autoid number) as
        type v_curtyp is ref cursor;
        v_trfcode            varchar2(100);
        v_tltxcd             varchar2(50);
        v_txnum              varchar2(10);
        v_custid             varchar2(10);
        l_vsdmode            varchar2(10);
        l_vsdtxreq           number;
        v_dt_txdate          date;
        v_notes              varchar2(1000);
        v_afacctno_field     varchar2(100);
        v_afacctno           varchar2(30);
        v_txamt_field        varchar2(100);
        v_txamt              number(20, 4);
        v_custodycd          varchar2(10);
        v_value              varchar2(3000);
        v_ovalue              varchar2(3000);
        v_chartxdate         varchar2(50);
        v_extcmdsql          varchar2(2000);
        v_notes_field        varchar2(10);
        v_msgacct_field      varchar2(20);
        v_msgacct            varchar2(30);
        c0                   v_curtyp;
        l_sqlerrnum          varchar2(200);
        v_log_msgacct        varchar2(50);
        v_fldrefcode_field   varchar2(50);
        v_refcode            varchar2(100);
        v_brid               varchar2(4);
        v_tlid               varchar2(4);
        l_vsdbiccode         varchar2(11);
        l_biccode            varchar2(11);
        l_count2247          number;
        l_custodycd2247      varchar2(10);
        l_count2255          number;
        l_custodycd2255      varchar2(10);
        l_count_vsdrxreq     NUMBER;
        l_count_vsdtxreq2255 NUMBER;
        l_vsdmessage_type    VARCHAR2(10);
        l_sendtovsd0059      VARCHAR2(1);
        v_refobj             VARCHAR2(50);
        l_last               VARCHAR2(2) := 'N';
        l_pageNo             NUMBER := 0;
        l_60M                NUMBER := 0;
        v_trftype            varchar2(2);
        v_objtype            VARCHAR2(1);
        v_fldkeysend         VARCHAR2(50);
        v_valuesend          VARCHAR2(50);
        v_vsdmt              varchar2(4);
        l_refreq             varchar(20);
    begin
        plog.setbeginsection(pkgctx, 'sp_gen_vsd_req');
        l_vsdmode := cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');

        select vsd.trfcode, vsd.tltxcd, vsd.txnum, vsd.txdate, vsd.msgacct, vsd.brid, vsd.tlid, vsd.refobj, vc.trftype, vc.vsdmt
        into v_trfcode, v_tltxcd, v_txnum, v_dt_txdate, v_log_msgacct, v_brid, v_tlid, v_refobj, v_trftype, v_vsdmt
        from vsd_process_log vsd, vsdtrfcode vc
        where vsd.trfcode = vc.trfcode
        AND vsd.tltxcd = vc.tltxcd
        AND vc.Type ='REQ'
        and autoid = pv_autoid;

        select biccode, vsdbiccode
        into l_biccode, l_vsdbiccode
        from vsdbiccode
        where trftype = v_trftype;

        if l_vsdmode = 'A' then
            -- ket noi tu dong
            v_chartxdate := to_char(v_dt_txdate, 'DD/MM/RRRR');

            begin
                select nvl(map.fldacctno,'a'),
                map.amtexp,
                map.fldnotes,
                nvl(map.fldrefcode, 'a'),
                map.objtype,
                map.fldkeysend,
                map.valuesend
                into v_afacctno_field,
                v_txamt_field,
                v_notes_field,
                v_fldrefcode_field,
                v_objtype,
                v_fldkeysend,
                v_valuesend
                from vsdtxmap map
                where map.objname = v_tltxcd
                and map.trfcode = v_trfcode;
            exception when no_data_found then

                plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                return;
            end;

            --Giao dich co lua chon khong sinh dien
            IF NOT instr(fn_eval_amtexp(v_txnum, v_chartxdate, v_fldkeysend, 'C'),v_valuesend) > 0 THEN

                plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                RETURN;
            END IF;

            --Dien ko can check khoi luong khai bao vsdtxmap.objtype = I
            if v_objtype = 'T' then
                v_txamt := fn_eval_amtexp(v_txnum, v_chartxdate, v_txamt_field, 'C');
                if v_txamt = 0 then
                    -- neu so luong bang 0, khong sinh request len VSD

                    plog.setendsection(pkgctx, 'sp_gen_vsd_req');
                    return;
                end if;
            end if;
            if v_afacctno_field <> 'a' then
                v_afacctno := fn_eval_amtexp(v_txnum, v_chartxdate, v_afacctno_field, 'C');
            else
                v_afacctno := '';
            end if;

            v_txamt    := fn_eval_amtexp(v_txnum, v_chartxdate, v_txamt_field, 'N');
            v_notes    := fn_eval_amtexp(v_txnum, v_chartxdate, v_notes_field, 'C');
            if v_fldrefcode_field = 'a' then
                v_refcode := v_chartxdate || v_txnum;
            else
                v_refcode := fn_eval_amtexp(v_txnum, v_chartxdate, v_fldrefcode_field, 'C');
            end if;

            -- insert vao VSDTXREQ\
            SELECT TO_NUMBER('407' || TO_CHAR(GETCURRDATE,'RRMMDD') || SEQ_VSDTXREQ.NEXTVAL) INTO L_VSDTXREQ FROM DUAL;

            insert into vsdtxreq
            (reqid,
            objtype,
            objname,
            objkey,
            trfcode,
            refcode,
            txdate,
            affectdate,
            afacctno,
            txamt,
            msgstatus,
            notes,
            /*swprocess, boprocess, adtxprocess,*/
            rqtype,
            status,
            msgacct,
            process_id,
            brid,
            tlid,CREATEDATE)
            values
            (l_vsdtxreq,
            'T',
            v_tltxcd,
            v_txnum,
            v_trfcode,
            v_refcode,
            v_dt_txdate,
            v_dt_txdate,
            v_afacctno,
            v_txamt,
            'P',
            v_notes,
            /*'P', 'N', 'N',*/
            'A',
            'P',
            v_log_msgacct,
            pv_autoid,
            v_brid,
            v_tlid, sysdate);

            -- insert vao VSDTXREQDTL
            -- Header
            -- Biccode
            insert into vsdtxreqdtl (autoid, reqid, fldname, cval, nval)
            values (seq_crbtxreqdtl.nextval, l_vsdtxreq, 'BICCODE', l_biccode, 0);
            -- VSD Biccode or SHV Biccode
            insert into vsdtxreqdtl (autoid, reqid, fldname, cval, nval)
            values (seq_crbtxreqdtl.nextval, l_vsdtxreq, 'VSDCODE', l_vsdbiccode, 0);
            -- Detail


            for rc in (
                select objname, trfcode, fldname, fldtype, amtexp, cmdsql, SPLIT, convert, maxlength
                from vsdtxmapext mst
                where mst.objname = v_tltxcd
                and mst.trfcode = v_trfcode
                order by mst.odrnum asc
            )
            loop
            begin
                if not rc.amtexp is null AND rc.amtexp != 'LOOPDETAIL' then
                    v_value := fn_eval_amtexp(v_txnum, v_chartxdate, rc.amtexp, rc.fldtype);

                end if;
                if not rc.cmdsql is null then
                begin

                    v_extcmdsql := replace(rc.cmdsql, '<$FILTERID>', v_value);
                    v_extcmdsql := replace(v_extcmdsql, '<$REQID>', l_vsdtxreq);
                    v_extcmdsql := replace(v_extcmdsql, '<$REFOBJ>', v_refobj);
                    v_extcmdsql := replace(v_extcmdsql, '<$REFCODE>', v_refcode);
                    begin
                        open c0 for v_extcmdsql;
                        fetch c0 into v_value;
                        close c0;
                    exception when others then
                        v_value := '';

                    end;
                end;
                end if;

                --luu gia tri goc chua convert font
                v_ovalue:=v_value;
                --- split chuoi theo do dai toi da cua dien MT
                -- neu split thi phai convert sang tieng viet kieu telex truoc khi split
                IF RC.FLDTYPE = 'C' THEN
                    V_VALUE := V_VALUE; --FN_CONVERTUTF8TOTELEX(V_VALUE);
                ELSIF RC.FLDTYPE = 'D' THEN
                    BEGIN
                        V_VALUE := TO_CHAR(TO_DATE(V_VALUE, 'DD/MM/RRRR'), 'YYYYMMDD');
                    EXCEPTION WHEN OTHERS THEN
                        V_VALUE := V_VALUE;
                    END;
                ELSIF RC.FLDTYPE = 'F' THEN
                    V_VALUE := TO_CHAR(TO_DATE(V_VALUE, 'DD/MM/RRRR'), 'YYMMDD');
                END IF;

                IF RC.convert = 'F' THEN
                    V_VALUE := FN_CONVERTUTF8TOTELEX(V_VALUE);
                END IF;

                IF RC.SPLIT = 'Y' THEN
                    V_VALUE := SPLITSTRING(V_VALUE);
                END IF;

                if( rc.fldname = 'VSDCODE') then
                    update vsdtxreqdtl set cval = v_value, ocval=v_ovalue
                    where reqid = l_vsdtxreq and fldname = rc.fldname;
                else
                    insert into vsdtxreqdtl (autoid, reqid, fldname, cval, nval, ocval, convert, maxlength)
                    select seq_crbtxreqdtl.nextval,
                       l_vsdtxreq,
                       rc.fldname,
                       decode(rc.fldtype, 'N', null, v_value),
                       decode(rc.fldtype, 'N', v_value, 0),
                       decode(rc.fldtype, 'N', null, v_ovalue),
                       rc.convert,
                       rc.maxlength
                    from dual;
                end if;
            end;
            end loop;
        end if;
        plog.setendsection(pkgctx, 'sp_gen_vsd_req');
    exception when others then
        plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection(pkgctx, 'sp_gen_vsd_req');
    end sp_gen_vsd_req;

    PROCEDURE AUTO_COMPLETE_CONFIRM_MSG(PV_REQID NUMBER, PV_CFTLTXCD VARCHAR2, PV_VSDTRFID NUMBER) AS
        L_DATA VARCHAR2(4000);
        L_ERR_CODE VARCHAR2(100);
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'AUTO_COMPLETE_CONFIRM_MSG');

        CASE PV_CFTLTXCD
        WHEN 'CFO1704' THEN
            BEGIN
            FOR REC IN (
                SELECT MT.*
                FROM VSDTXREQ REQ, VSD_MT518_INF MT
                WHERE REQ.REFCODE = TO_CHAR(MT.AUTOID)
                AND REQ.REQID = PV_REQID
            )
            LOOP
                UPDATE VSD_MT518_INF SET CONFREQSTATUS = 'F' WHERE VSDORDERID = REC.VSDORDERID;
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"VSDORDERID":"' || REC.VSDORDERID || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_8821_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2303_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
            END;
        WHEN 'CFN1704' THEN
            BEGIN
            FOR REC IN (
                SELECT MT.*
                FROM VSDTXREQ REQ, VSD_MT518_INF MT
                WHERE REQ.REFCODE = TO_CHAR(MT.AUTOID)
                AND REQ.REQID = PV_REQID
            )
            LOOP
                UPDATE VSD_MT518_INF SET CONFREQSTATUS = 'N' WHERE VSDORDERID = REC.VSDORDERID;

                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"VSDORDERID":"' || REC.VSDORDERID || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_8821_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2303_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
            END;
        WHEN 'CFO1701' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                UPDATE CFMAST_TPRL SET STATUS = 'A', PSTATUS = PSTATUS || STATUS  WHERE CUSTODYCD = REC.REFCODE;
            END LOOP;
        WHEN 'CFN1701' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                UPDATE CFMAST_TPRL SET STATUS = 'P', PSTATUS = PSTATUS || STATUS  WHERE CUSTODYCD = REC.REFCODE;
            END LOOP;
        WHEN 'CFO1702' THEN
            BEGIN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                FOR REC2 IN (
                    SELECT "'FULLNAME'" FULLNAME, "'ADTXINFO'" ADTXINFO, "'ADTXFTYPE'" ADTXFTYPE, "'ACCTYPE'" ACCTYPE, "'BEGIN_STRATEGY_DATE'" BEGIN_STRATEGY_DATE, "'END_STRATEGY_DATE'" END_STRATEGY_DATE, "'ITYP'" ITYP
                    FROM (
                        SELECT FLDNAME, OCVAL
                        FROM VSDTXREQDTL
                        WHERE REQID = PV_REQID
                    ) TT
                    PIVOT (MAX(OCVAL)
                    FOR FLDNAME IN ('FULLNAME', 'ADTXINFO', 'ADTXFTYPE', 'ACCTYPE', 'BEGIN_STRATEGY_DATE', 'END_STRATEGY_DATE', 'ITYP')) PVTTABLE
                )
                LOOP
                    UPDATE CFMAST_TPRL SET
                    STATUS = 'A',
                    PSTATUS = PSTATUS || STATUS,
                    ADTXINFO = REC2.ADTXINFO,
                    ADTXFTYPE = REC2.ADTXFTYPE,
                    ACCTYPE = REC2.ACCTYPE,
                    BEGINSTRATEGYDATE = (CASE WHEN NVL(REC2.ACCTYPE, '---') NOT IN ('PINV') THEN NULL
                                              ELSE (CASE WHEN REC2.END_STRATEGY_DATE IS NULL THEN BEGINSTRATEGYDATE ELSE TO_DATE(REC2.END_STRATEGY_DATE, 'DD/MM/RRRR') END)
                                         END),
                    ENDSTRATEGYDATE = (CASE WHEN NVL(REC2.ACCTYPE, '---') NOT IN ('PINV') THEN NULL
                                            ELSE (CASE WHEN REC2.BEGIN_STRATEGY_DATE IS NULL THEN ENDSTRATEGYDATE ELSE TO_DATE(REC2.BEGIN_STRATEGY_DATE, 'DD/MM/RRRR') END)
                                       END),
                    ITYP = (CASE WHEN NVL(REC2.ACCTYPE, '---') NOT IN ('PINV') THEN NULL
                                 ELSE (CASE WHEN NVL(REC2.ITYP, '---') = '---' THEN ITYP ELSE REC2.ITYP END)
                            END)
                    WHERE CUSTODYCD = REC.REFCODE;
                END LOOP;
            END LOOP;
            END;
        WHEN 'CFO1703' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                UPDATE CFMAST_TPRL SET STATUS = 'C', PSTATUS = PSTATUS || STATUS  WHERE CUSTODYCD = REC.REFCODE;
            END LOOP;
        WHEN 'CFN1703' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                UPDATE CFMAST_TPRL SET STATUS = 'A', PSTATUS = PSTATUS || STATUS  WHERE CUSTODYCD = REC.REFCODE;
            END LOOP;
        WHEN 'CFO1511' THEN
            FOR REC IN (
                SELECT "'VSDMSGID'" VSDMSGID, "'REQID'" REQID, "'VSDMSGDATE'" VSDMSGDATE
                FROM (
                    SELECT FLDVAL, FLDNAME
                    FROM VSDTRFLOGDTL
                    WHERE REFAUTOID = PV_VSDTRFID
                ) TTT
                PIVOT (MAX(FLDVAL)
                FOR FLDNAME IN ('VSDMSGID', 'REQID', 'VSDMSGDATE')) PVTTABLE
            )
            LOOP
                FOR REC2 IN (
                    SELECT "'CUSTODYCD'" CUSTODYCD, "'SYMBOL'" SYMBOL, "'QTTY'" QTTY, "'PLACEID'" PLACEID, "'CONTRACTNO'" CONTRACTNO, "'CONTRACTDATE'" CONTRACTDATE, "'VSDSTOCKTYPE'" VSDSTOCKTYPE
                    FROM (
                        SELECT CVAL FLDVAL, FLDNAME
                        FROM VSDTXREQDTL
                        WHERE REQID = PV_REQID
                    ) TTT
                    PIVOT (MAX(FLDVAL)
                    FOR FLDNAME IN ('CUSTODYCD', 'SYMBOL', 'QTTY', 'PLACEID', 'CONTRACTNO', 'CONTRACTDATE', 'VSDSTOCKTYPE')) PVTTABLE
                )
                LOOP
                    INSERT INTO MT508_SEBLOCK(AUTOID,VSDMSGID,REQID,SYMBOL,QTTY,CUSTODYCD,VSDDEFDATE,VSDSTOCKTYPE,CONTRACTNO,CONTRACTDATE,PLACEID,STATUS)
                    VALUES(SEQ_MT508_SEBLOCK.NEXTVAL,REC.VSDMSGID,REC.REQID,REC2.SYMBOL,REC2.QTTY,REC2.CUSTODYCD,REC.VSDMSGDATE,REC2.VSDSTOCKTYPE,REC2.CONTRACTNO,REC2.CONTRACTDATE,REC2.PLACEID,'P');
                END LOOP;

                FOR REC3 IN (
                    SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
                )
                LOOP
                    BEGIN
                        L_DATA := '{';
                        L_DATA := L_DATA || '"CBREF":"' || REC3.REFCODE || '",';
                        L_DATA := L_DATA || '"REFVSDID":"' || REC.VSDMSGID || '",';
                        L_DATA := L_DATA || '"STATUS":"C"';
                        L_DATA := L_DATA || '}';

                        CBACB.CSPKS_VSTP.PRC_2318_CALLBACK(L_DATA, L_ERR_CODE);
                        IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                            RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2318_CALLBACK ERROR: ' || L_ERR_CODE);
                        END IF;
                    EXCEPTION WHEN OTHERS THEN
                        PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                    END;
                END LOOP;
            END LOOP;
        WHEN 'CFN1511' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2318_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2318_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1512' THEN
            FOR REC IN (
                SELECT "'REFREQID'" REFREQID
                FROM (
                    SELECT FLDNAME, OCVAL
                    FROM VSDTXREQDTL
                    WHERE REQID = PV_REQID
                ) TT
                PIVOT (MAX(OCVAL)
                FOR FLDNAME IN ('REFREQID')) PVTTABLE
            )
            LOOP
                UPDATE MT508_SEBLOCK SET STATUS = 'C' WHERE VSDMSGID = REC.REFREQID;
            END LOOP;

            FOR REC2 IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC2.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2323_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2323_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFN1512' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2323_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2323_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFN1503' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2303_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2303_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1503' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2303_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2303_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFN1504' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2308_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2308_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1504' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2308_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2308_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFN1505' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2313_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2313_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1505' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_2313_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_2313_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1510' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_3401_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_3401_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFN1705' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"R"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_3403_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_3403_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        WHEN 'CFO1705' THEN
            FOR REC IN (
                SELECT * FROM VSDTXREQ WHERE REQID = PV_REQID
            )
            LOOP
                BEGIN
                    L_DATA := '{';
                    L_DATA := L_DATA || '"CBREF":"' || REC.REFCODE || '",';
                    L_DATA := L_DATA || '"STATUS":"C"';
                    L_DATA := L_DATA || '}';

                    CBACB.CSPKS_VSTP.PRC_3403_CALLBACK(L_DATA, L_ERR_CODE);
                    IF L_ERR_CODE <> SYSTEMNUMS.C_SUCCESS THEN


                        RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_3403_CALLBACK ERROR: ' || L_ERR_CODE);
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                END;
            END LOOP;
        ELSE
            NULL;
        END CASE;
        PLOG.SETENDSECTION(PKGCTX, 'AUTO_COMPLETE_CONFIRM_MSG');
    END AUTO_COMPLETE_CONFIRM_MSG;

    PROCEDURE pr_receive_csv_by_xml(pv_filename IN VARCHAR2, pv_filecontent IN CLOB)
    IS
        v_contentlog_id NUMBER;
        v_rptid varchar2(50);
        v_vsdid varchar2(100);
        v_symbol varchar2(50);
        v_settdate date;
    BEGIN
        plog.setbeginsection(pkgctx, 'pr_receive_csv_by_xml');
        BEGIN
            SELECT NVL(autoid,-1)
            INTO v_contentlog_id
            FROM vsd_csvcontent_log
            WHERE fileName = pv_filename;
        EXCEPTION WHEN OTHERS THEN
            v_contentlog_id := -1;
        END;
        IF v_contentlog_id >= 0 THEN
            UPDATE vsd_csvcontent_log
            SET msgbody = xmltype(pv_filecontent),
            status='P'
            WHERE autoid = v_contentlog_id;

        ELSE
            BEGIN
                v_rptid := substr(pv_filename, instr(pv_filename, '''') + 1, instr(pv_filename, '''', 1, 2) - (instr(pv_filename, '''') + 1));
            EXCEPTION WHEN OTHERS THEN
                v_rptid := '';
            END;

            IF v_rptid LIKE 'CA%' THEN
                BEGIN
                    v_symbol := substr(pv_filename, instr(pv_filename, '+', 1, 2) + 1, instr(pv_filename, '-', 1, 2) - (instr(pv_filename, '+', 1, 2) + 1));
                EXCEPTION WHEN OTHERS THEN
                    v_symbol := '';
                END;
            END IF;

            BEGIN
                v_settdate := to_date(substr(pv_filename, instr(pv_filename, '+') + 1, 8),'DDMMRRRR');
            EXCEPTION WHEN OTHERS THEN
                v_vsdid := substr(pv_filename, instr(pv_filename, '+') + 1, instr(pv_filename, '-') - (instr(pv_filename, '+') + 1));
                BEGIN
                    v_settdate := to_date(substr(pv_filename, INSTR(pv_filename, '+', 1, 4) + 1, 8),'DDMMRRRR');
                EXCEPTION WHEN OTHERS THEN
                    v_settdate := NULL;
                END;
            END;

            select seq_vsd_csvcontent_log.nextval into v_contentlog_id from dual;
            insert into vsd_csvcontent_log (autoid, filename, timecreated, timeprocess, status, msgbody, txdate, rptid, settdate, vsdid, symbol)
            select v_contentlog_id, pv_filename, systimestamp, null, 'P', xmltype(pv_filecontent), getcurrdate, v_rptid, v_settdate, v_vsdid, v_symbol
            from dual;
        END IF;

        plog.setendsection(pkgctx, 'pr_receive_csv_by_xml');
    EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm||DBMS_UTILITY.format_error_backtrace);
        plog.setendsection(pkgctx, 'pr_receive_csv_by_xml');
    END;

    PROCEDURE pr_receive_par_by_xml(pv_filename IN VARCHAR2, pv_filecontent IN clob)
    IS
        v_contentlog_id NUMBER;
        v_vsdid         varchar2(100);
        v_csvfilename   varchar2(500);
        v_creationtime varchar2(20);
        v_RequestRef varchar2(100);
    BEGIN
        plog.setbeginsection(pkgctx, 'pr_receive_par_by_xml');
        BEGIN
            SELECT NVL(autoid,-1)
            INTO v_contentlog_id
            FROM vsd_parcontent_log
            WHERE fileName = pv_filename;
        EXCEPTION WHEN OTHERS THEN
            v_contentlog_id := -1;
        END;
        IF v_contentlog_id >= 0 THEN
            UPDATE vsd_parcontent_log
            SET msgbody = xmltype(pv_filecontent)
            WHERE autoid = v_contentlog_id;
        ELSE
            select seq_vsd_parcontent_log.nextval into v_contentlog_id from dual;
            insert into vsd_parcontent_log (autoid, filename, timecreated, timeprocess, status, msgbody,txdate)
            select v_contentlog_id, pv_filename, TO_DATE(TO_CHAR(SYSTIMESTAMP,systemnums.C_DATE_FORMAT),systemnums.C_DATE_FORMAT),
            TO_CHAR(systimestamp,systemnums.C_TIME_FORMAT), 'P', xmltype(pv_filecontent), getcurrdate
            from dual;

        END IF;

        SELECT xt.vsdid, xt.csvfilename,creationtime,RequestRef
        INTO v_vsdid, v_csvfilename,v_creationtime,v_RequestRef
        FROM (SELECT * FROM vsd_parcontent_log WHERE autoid = v_contentlog_id) mst,
            xmltable('XMLCreators/par' passing mst.msgbody
            columns vsdid varchar2(100) path 'OrigTransferRef',
            csvfilename varchar2(500) path 'LogicalName',
            creationtime varchar2(20) path 'Creationtime',
            RequestRef varchar2(100) path 'RequestRef') xt
        WHERE 0 = 0;--xt.vsdid is not NULL;

        UPDATE vsd_parcontent_log
        SET vsdid = v_vsdid,
            csvfilename = v_csvfilename,
            txdate = to_date(substr(v_creationtime,1,8),'RRRRMMdd'),
            reqid = v_RequestRef
        WHERE autoid = v_contentlog_id;

        /*
        if length(trim(v_vsdid)) > 0 then
            prc_update_vsdid(v_csvfilename, v_vsdid);
        end if;
        */

        plog.setendsection(pkgctx, 'pr_receive_par_by_xml');
    EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm||DBMS_UTILITY.format_error_backtrace);
        plog.setendsection(pkgctx, 'pr_receive_par_by_xml');
    END;

    FUNCTION SPLITSTRING(PV_STRING IN VARCHAR2) RETURN VARCHAR2
    IS
        L_IN_STRING VARCHAR2(2000);
        L_OUT_STRING VARCHAR2(2000);
        L_QTTY_CHAR NUMBER;
    BEGIN
        L_QTTY_CHAR := 0;
        FOR REC IN(
            SELECT REGEXP_SUBSTR (PV_STRING, '[^ ]+', 1, LEVEL) AS STR_CHAR
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR (PV_STRING, '[^ ]+', 1, LEVEL) IS NOT NULL
        )LOOP
            IF L_OUT_STRING IS NULL THEN
                IF LENGTH(REC.STR_CHAR) > ERRNUMS.C_MAX_CHAR_PER_ROW THEN
                    L_IN_STRING := REC.STR_CHAR;
                    WHILE LENGTH(L_IN_STRING) > ERRNUMS.C_MAX_CHAR_PER_ROW LOOP
                        L_OUT_STRING := L_OUT_STRING || SUBSTR(L_IN_STRING, 1, ERRNUMS.C_MAX_CHAR_PER_ROW) || CHR(13) || CHR(10);
                        L_IN_STRING := SUBSTR(L_IN_STRING, ERRNUMS.C_MAX_CHAR_PER_ROW + 1);
                        L_QTTY_CHAR := LENGTH(L_IN_STRING);
                    END LOOP;
                ELSE
                    L_OUT_STRING := REC.STR_CHAR;
                    L_QTTY_CHAR := LENGTH(REC.STR_CHAR);
                END IF;
            ELSE
                IF (L_QTTY_CHAR + LENGTH(' ' || REC.STR_CHAR)) > ERRNUMS.C_MAX_CHAR_PER_ROW THEN
                    L_OUT_STRING := L_OUT_STRING || CHR(13) || CHR(10) || ' ' || REC.STR_CHAR;
                    L_QTTY_CHAR := LENGTH(REC.STR_CHAR);
                ELSE
                    L_OUT_STRING := L_OUT_STRING || ' ' || REC.STR_CHAR;
                    L_QTTY_CHAR := L_QTTY_CHAR + LENGTH(' ' || REC.STR_CHAR);
                END IF;
            END IF;
        END LOOP;

        RETURN L_OUT_STRING;
    EXCEPTION WHEN OTHERS THEN
        PLOG.ERROR(PKGCTX, SQLERRM);
        PLOG.SETENDSECTION(PKGCTX, 'SPLITSTRING');
    END SPLITSTRING;

    PROCEDURE PRC_ODVSD_NEW(PV_REQID VARCHAR2, PV_VSDTRFLOGID NUMBER)
    IS
        L_DATA VARCHAR2(4000);
        L_ERRCODE VARCHAR2(100);
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_ODVSD_NEW');

        FOR REC IN(
            SELECT MT518.VSDCUSTODYCD CUSTODYCD, SB.CODEID, SB.SYMBOL, MT518.VSDQUANTIY QTTY,
                ROUND(REPLACE(MT518.VSDPRICE,'VND',''),0) PRICE,
                ROUND(REPLACE(MT518.VSDAMT,'VND',''),0) NETAMT,
                ROUND(REPLACE(MT518.VSDAMT,'VND',''),0) GROSSAMT,
                TO_CHAR(MT518.VSDMSGDATE, 'DD/MM/RRRR') TRADEDATE,
                TO_CHAR(MT518.VSDMSGPAYDATE, 'DD/MM/RRRR') SETTLEDATE,
                (CASE WHEN MT518.VSDPROMSG like '%//SELL%' THEN 'NS' ELSE 'NB' END) EXECTYPE,
                MT518.VSDORDERID,
                NVL(DM.DEPOSITID, '407') DEPOSITID

            FROM VSD_MT518_INF MT518, SBSECURITIES SB, DEPOSIT_MEMBER DM
            WHERE MT518.VSDSYMBOL = SB.SYMBOL
            AND MT518.VSDBICCODE = DM.BICCODE(+)
            AND MT518.VSDMSGID = PV_VSDTRFLOGID
        ) LOOP
            L_DATA := '{';
            L_DATA := L_DATA || '"CUSTODYCD":"' || REC.CUSTODYCD || '",';
            L_DATA := L_DATA || '"CODEID":"' || REC.CODEID || '",';
            L_DATA := L_DATA || '"SYMBOL":"' || REC.SYMBOL || '",';
            L_DATA := L_DATA || '"QTTY":"' || REC.QTTY || '",';
            L_DATA := L_DATA || '"PRICE":"' || REC.PRICE || '",';
            L_DATA := L_DATA || '"NETAMT":"' || REC.NETAMT || '",';
            L_DATA := L_DATA || '"GROSSAMT":"' || REC.GROSSAMT || '",';
            L_DATA := L_DATA || '"TRADEDATE":"' || REC.TRADEDATE || '",';
            L_DATA := L_DATA || '"SETTLEDATE":"' || REC.SETTLEDATE || '",';
            L_DATA := L_DATA || '"EXECTYPE":"' || REC.EXECTYPE || '",';
            L_DATA := L_DATA || '"VSDORDERID":"' || REC.VSDORDERID || '",';
            L_DATA := L_DATA || '"DEPOSITID":"' || REC.DEPOSITID || '"';
            L_DATA := L_DATA || '}';
            CBACB.CSPKS_VSTP.PRC_ODVSTP_NEW(L_DATA, L_ERRCODE);
            IF L_ERRCODE <> SYSTEMNUMS.C_SUCCESS THEN
                RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_CALL_8864 ERROR: ' || L_ERRCODE);
            END IF;
        END LOOP;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSD_NEW');
    EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm||DBMS_UTILITY.format_error_backtrace);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSD_NEW');
        RAISE_APPLICATION_ERROR(-20001, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END PRC_ODVSD_NEW;

    PROCEDURE PRC_ODVSD_CANC(PV_REQID VARCHAR2, PV_VSDTRFLOGID NUMBER)
    IS
        L_DATA VARCHAR2(4000);
        L_ERRCODE VARCHAR2(100);
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_ODVSD_CANC');

        FOR REC IN(
            SELECT MT518.VSDCUSTODYCD CUSTODYCD, SB.CODEID, SB.SYMBOL, MT518.VSDQUANTIY QTTY,
                ROUND(REPLACE(MT518.VSDPRICE,'VND',''),0) PRICE,
                ROUND(REPLACE(MT518.VSDAMT,'VND',''),0) NETAMT,
                ROUND(REPLACE(MT518.VSDAMT,'VND',''),0) GROSSAMT,
                TO_CHAR(MT518.VSDMSGDATE, 'DD/MM/RRRR') TRADEDATE,
                TO_CHAR(MT518.VSDMSGPAYDATE, 'DD/MM/RRRR') SETTLEDATE,
                (CASE WHEN MT518.VSDPROMSG like '%//SELL%' THEN 'NS' ELSE 'NB' END) EXECTYPE,
                MT518.VSDORDERID,
                NVL(DM.DEPOSITID, '407') DEPOSITID

            FROM VSD_MT518_INF MT518, SBSECURITIES SB, DEPOSIT_MEMBER DM
            WHERE MT518.VSDSYMBOL = SB.SYMBOL
            AND MT518.VSDBICCODE = DM.BICCODE(+)
            AND MT518.VSDMSGID = PV_VSDTRFLOGID
        ) LOOP
            L_DATA := '{';
            L_DATA := L_DATA || '"VSDORDERID":"' || REC.VSDORDERID || '"';
            L_DATA := L_DATA || '}';

            CBACB.CSPKS_VSTP.PRC_ODVSTP_CANC(L_DATA, L_ERRCODE);
            IF L_ERRCODE <> SYSTEMNUMS.C_SUCCESS THEN
                RAISE_APPLICATION_ERROR(-20001, 'CALL PRC_ODVSD_CANC ERROR: ' || L_ERRCODE);
            END IF;
        END LOOP;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSD_CANC');
    EXCEPTION WHEN OTHERS THEN
        plog.error(pkgctx, sqlerrm||DBMS_UTILITY.format_error_backtrace);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSD_CANC');
        RAISE_APPLICATION_ERROR(-20001, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END PRC_ODVSD_CANC;
begin
  -- Initialization
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('cspks_vsd',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end cspks_vsd;
/
