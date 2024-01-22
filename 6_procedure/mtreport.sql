SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE mtreport (
   PV_REFCURSOR     IN OUT   PKG_REPORT.REF_CURSOR,
   PV_BRID     IN       VARCHAR2,
   PV_TLID     IN       VARCHAR2,
   PV_REPORTID     IN       VARCHAR2,
   PV_REPORTPARAM      IN       VARCHAR2

       )
IS
    l_txnum varchar2(20);
    L_COUNT  number :=0;
    pkgctx   plog.log_ctx;
    l_REPORTPARAM varchar(4000);

BEGIN


    if PV_REPORTID in ('DE083') AND INSTR(PV_REPORTPARAM,'BRID:ALL') > 0 then
        FOR REC IN (
            SELECT * FROM ALLCODE WHERE CDNAME = 'TRADEPLACE' AND CDUSER = 'Y' AND CDTYPE = 'ST'
        )
        LOOP
            l_REPORTPARAM := PV_REPORTPARAM;
            l_REPORTPARAM := REPLACE(l_REPORTPARAM,'BRID:ALL','BRID:' || REC.CDVAL);

            select systemnums.C_BATCH_PREFIXED || lpad(seq_batchtxnum.nextval, 8, '0')
            into l_txnum
            from dual;

            insert into reportmtlog (id, begindate,tlid, brid, rptid,rptinput,txnum,txdate )
            values(seq_reportmt.nextval,sysdate,PV_TLID,PV_BRID,PV_REPORTID,l_REPORTPARAM,l_txnum,getcurrdate);
            --9999 la dien sinh bao cao
            SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE VSD.TLTXCD= '9999' AND VSD.STATUS='Y' AND VSD.TYPE='REQ';

            IF L_COUNT >0 THEN
                FOR REC IN (
                    SELECT TRFCODE FROM VSDTRFCODE WHERE TLTXCD = '9999' AND STATUS='Y' AND TYPE='REQ'
                )
                LOOP
                   Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,TLID,BRID)
                   values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE, '9999',l_txnum,GETCURRDATE,'N',PV_TLID,PV_BRID);
                END LOOP;
            END IF;
        END LOOP;
    else
        select systemnums.C_BATCH_PREFIXED || lpad(seq_batchtxnum.nextval, 8, '0')
        into l_txnum
        from dual;

        insert into reportmtlog (id, begindate,tlid, brid, rptid,rptinput,txnum,txdate )
        values(seq_reportmt.nextval,sysdate,PV_TLID,PV_BRID,PV_REPORTID,PV_REPORTPARAM,l_txnum,getcurrdate);

        --9999 la dien sinh bao cao
        SELECT COUNT(*) INTO L_COUNT FROM VSDTRFCODE VSD WHERE VSD.TLTXCD= '9999' AND VSD.STATUS='Y' AND VSD.TYPE='REQ';

        IF L_COUNT >0 THEN
            FOR REC IN (
                SELECT TRFCODE FROM VSDTRFCODE WHERE TLTXCD = '9999' AND STATUS='Y' AND TYPE='REQ'
            )
            LOOP
               Insert into VSD_PROCESS_LOG(AUTOID,TRFCODE,TLTXCD,TXNUM,TXDATE,PROCESS,TLID,BRID)
               values (SEQ_VSD_PROCESS_LOG.NEXTVAL,REC.TRFCODE, '9999',l_txnum,GETCURRDATE,'N',PV_TLID,PV_BRID);
            END LOOP;
        END IF;
    end if;



    -- GET REPORT'S PARAMETERS
     OPEN PV_REFCURSOR FOR select  1 from dual;

EXCEPTION
   WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
