SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_batch
 /*----------------------------------------------------------------------------------------------------
     ** Module   : COMMODITY SYSTEM
     ** and is copyrighted by FSS.
     **
     **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
     **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
     **    graphic, optic recording or otherwise, translated in any language or computer language,
     **    without the prior written permission of Financial Software Solutions. JSC.
     **

     **  MODIFICATION HISTORY
     **  Person      Date           Comments
     **  Fsser      09-JUNE-2009   dbms_output.put_line(''); Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
 IS
  PROCEDURE pr_batch(p_apptype varchar2, p_bchmdl varchar,p_err_code  OUT varchar2,p_lastRun OUT VARCHAR2);
  PROCEDURE pr_saExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2);
  PROCEDURE pr_SABackupData(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SABeforeBatch(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAAfterBatch(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAChangeWorkingDate(P_ERR_CODE OUT VARCHAR2);
  PROCEDURE pr_SAGeneralWorking(P_ERR_CODE OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_batch IS
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;
-------------------------------------pr_batch--------------------------------------------
  PROCEDURE pr_batch(p_apptype varchar2, p_bchmdl varchar,p_err_code  OUT varchar2,p_lastRun OUT VARCHAR2)
  IS
    l_count NUMBER(10,0);
    l_CurrExecRow  NUMBER(10,0);
    l_RowPerPage NUMBER(10,0);
    l_action varchar2(50);
    l_CurrRow  NUMBER(10,0);
    l_FromRow   varchar2(20);
    l_ToRow   varchar2(20);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_batch');
    p_lastRun:='Y';
    --Lay ra trang se thuc hien tiep
    begin
        SELECT B.ROWPERPAGE,A.BCHSUCPAGE,B.ACTION
        Into l_RowPerPage,l_CurrExecRow, l_action
        FROM SBBATCHSTS A, SBBATCHCTL B
        WHERE A.BCHMDL = B.BCHMDL AND A.BCHSTS = ' ' AND A.BCHMDL=p_bchmdl ORDER BY B.BCHSQN;
    exception
    when others then
        p_err_code := errnums.C_SYSTEM_ERROR;
        return;
    end;
    IF l_RowPerPage>0 THEN
        l_CurrRow:=l_CurrExecRow + l_RowPerPage;
        l_FromRow:=l_CurrExecRow;
        l_ToRow:=l_CurrExecRow + l_RowPerPage-1;

        plog.debug(pkgctx,'Begin Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to row ' || l_ToRow);
    ELSE
        l_FromRow:=0;
        l_ToRow:=9000000000;
        plog.debug(pkgctx,'Begin Run batch for ' || p_bchmdl);
    END IF;

    --kIEM TRA XEM HOST CO O TRANG THAI ACTIVE HAY KHONG
    /*SELECT count(*) INTO l_count
    FROM SYSVAR
    WHERE GRNAME='SYSTEM'
    AND VARNAME='HOSTATUS'
    AND VARVALUE= systemnums.C_OPERATION_INACTIVE;
    IF l_count = 0 and l_action <> 'BF' THEN
        p_err_code:= errnums.C_HOST_OPERATION_STILL_ACTIVE;
        RETURN;
    END IF;*/
    
    IF P_APPTYPE = 'SA' THEN
      PR_SAEXECUTEROUTER(p_bchmdl,
                         p_err_code,
                         l_FromRow,
                         l_ToRow,
                         p_lastRun);
    end if;



    if p_err_code <> 0 then
        return;
    end if;
    if l_RowPerPage<=0 Then
        plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl);
        UPDATE SBBATCHSTS SET BCHSTS = 'Y', CMPLTIME = SYSDATE,BCHSUCPAGE=-1 WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
    else
        If p_lastRun='Y' Then
            plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to last row');
            UPDATE SBBATCHSTS SET BCHSTS = 'Y', CMPLTIME = SYSDATE,BCHSUCPAGE=l_CurrRow WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
        Else
            plog.Debug(pkgctx,'End Run batch for ' || p_bchmdl || 'from row ' || l_FromRow || ' to row ' || l_ToRow);
            UPDATE SBBATCHSTS SET BCHSUCPAGE=l_CurrRow WHERE UPPER(BCHMDL) = p_bchmdl AND BCHDATE=(SELECT MAX(BCHDATE) FROM SBBATCHSTS);
        End If;
    end if;
    plog.setendsection(pkgctx, 'pr_batch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_batch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_batch;

  -------------------------------------pr_saExecuteRouter--------------------------------------------
  PROCEDURE pr_saExecuteRouter(p_bchmdl varchar,p_err_code  OUT varchar2,p_FromRow number,p_ToRow number, p_lastRun OUT varchar2)
  IS

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_saExecuteRouter');
    p_lastRun:='Y';
    if p_bchmdl ='SABKDT' then
        txpks_batch.pr_SABackupData(p_err_code);
    elsif p_bchmdl ='SABFB' then
        txpks_batch.pr_SABeforeBatch(p_err_code);
    elsif p_bchmdl ='SAAFB' then
        txpks_batch.pr_SAAfterBatch(p_err_code);
    elsif p_bchmdl ='SACWD' then
        txpks_batch.pr_SAChangeWorkingDate(p_err_code);
    elsif p_bchmdl ='SAGNWK' then
        txpks_batch.pr_SAGeneralWorking(p_err_code);
    end if;
    plog.setendsection(pkgctx, 'pr_saExecuteRouter');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_saExecuteRouter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_saExecuteRouter;

  ---------------------------------pr_SABackupData------------------------------------------------
  PROCEDURE pr_SABackupData(P_ERR_CODE OUT VARCHAR2) IS
    V_NEXTDATE   VARCHAR2(10);
    V_CURRDATE   VARCHAR2(10);
    V_STRFRTABLE VARCHAR2(100);
    V_STRTOTABLE VARCHAR2(100);
    V_STRSQL     VARCHAR2(2000);
    V_SQL1       VARCHAR2(1000);
    V_SQL2       VARCHAR2(1000);
    V_ERR        VARCHAR2(200);
    V_COUNT      NUMBER(10);
    v_strPRRDATE varchar2(100);

  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'pr_SABackupData');
    p_err_code:=0;
    V_NEXTDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'NEXTDATE');
    V_CURRDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'CURRDATE');
    v_strPRRDATE := cspks_system.fn_get_sysvar('SYSTEM', 'PREVDATE');

    /*'Sao luu du lieu bang TLLOG, TLLOGFLD Cho cac giao dichi?? BACKUP=Y*/
    INSERT INTO TLLOGALL(
        AUTOID,
        TXNUM,
        TXDATE,
        TXTIME,
        BRID,
        TLID,
        OFFID,
        OVRRQS,
        CHID,
        CHKID,
        TLTXCD,
        IBT,
        BRID2,
        TLID2,
        CCYUSAGE,
        OFF_LINE,
        DELTD,
        BRDATE,
        BUSDATE,
        TXDESC,
        IPADDRESS,
        WSNAME,
        TXSTATUS,
        MSGSTS,
        OVRSTS,
        BATCHNAME,
        MSGAMT,
        MSGACCT,
        CHKTIME,
        OFFTIME,
        CAREBYGRP,
        REFTXNUM,
        NAMENV,
        CFCUSTODYCD,
        CREATEDT,
        CFFULLNAME,
        PTXSTATUS)
        SELECT
           TLLOG.AUTOID,
           TLLOG.TXNUM,
           TLLOG.TXDATE,
           TLLOG.TXTIME,
           TLLOG.BRID,
           TLLOG.TLID,
           TLLOG.OFFID,
           TLLOG.OVRRQS,
           TLLOG.CHID,
           TLLOG.CHKID,
           TLLOG.TLTXCD,
           TLLOG.IBT,
           TLLOG.BRID2,
           TLLOG.TLID2,
           TLLOG.CCYUSAGE,
           TLLOG.OFF_LINE,
           TLLOG.DELTD,
           TLLOG.BRDATE,
           TLLOG.BUSDATE,
           TLLOG.TXDESC,
           TLLOG.IPADDRESS,
           TLLOG.WSNAME,
           TLLOG.TXSTATUS,
           TLLOG.MSGSTS,
           TLLOG.OVRSTS,
           TLLOG.BATCHNAME,
           TLLOG.MSGAMT,
           TLLOG.MSGACCT,
           TLLOG.CHKTIME,
           TLLOG.OFFTIME,
           TLLOG.CAREBYGRP,
           TLLOG.REFTXNUM,
           TLLOG.NAMENV,
           TLLOG.CFCUSTODYCD,
           TLLOG.CREATEDT,
           TLLOG.CFFULLNAME,
           TLLOG.PTXSTATUS
        FROM TLLOG, TLTX
        WHERE
           TLLOG.TLTXCD = TLTX.TLTXCD AND
           TLTX.BACKUP = 'Y' AND
           (
           TLLOG.TXSTATUS = '3' OR
           TLLOG.TXSTATUS = '1' OR
           TLLOG.TXSTATUS = '7' OR
           TLLOG.TXSTATUS = '4');

    COMMIT;

    INSERT INTO TLLOGFLDALL(
        AUTOID,
        TXNUM,
        TXDATE,
        FLDCD,
        NVALUE,
        CVALUE,
        TXDESC)
    SELECT
       DTL.AUTOID,
       DTL.TXNUM,
       DTL.TXDATE,
       DTL.FLDCD,
       DTL.NVALUE,
       DTL.CVALUE,
       DTL.TXDESC
    FROM TLLOGFLD DTL, TLLOG, TLTX
    WHERE
       TLLOG.TLTXCD = TLTX.TLTXCD AND
       TLTX.BACKUP = 'Y' AND
       TLLOG.TXNUM = DTL.TXNUM AND
       TLLOG.TXDATE = DTL.TXDATE AND
       (
       TLLOG.TXSTATUS = '3' OR
       TLLOG.TXSTATUS = '1' OR
       TLLOG.TXSTATUS = '7' OR
       TLLOG.TXSTATUS = '4');

    COMMIT;

    V_STRSQL := 'truncate table TLLOG';
    EXECUTE IMMEDIATE V_STRSQL;
    V_STRSQL := 'truncate table TLLOGFLD';
    EXECUTE IMMEDIATE V_STRSQL;

    --'Xoa cac bang khong phai bang giao dich, can backup
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'N') LOOP
        V_STRFRTABLE := REC.FRTABLE;
        V_STRTOTABLE := REC.TOTABLE;
        --Sao luu __HIST
        V_STRSQL := 'INSERT INTO ' || V_STRTOTABLE || ' SELECT * FROM ' || V_STRFRTABLE;
        EXECUTE IMMEDIATE V_STRSQL;

        INSERT INTO LOG_ERR
            (ID, DATE_LOG, POSITION, TEXT)
        VALUES
            (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_STRSQL);

        COMMIT;
        V_STRSQL := 'TRUNCATE TABLE ' || V_STRFRTABLE;
        EXECUTE IMMEDIATE V_STRSQL;
    END LOOP;

    --'Xoa cac bang khong phai bang giao dich, khong backup
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'D') LOOP
        V_STRFRTABLE := REC.FRTABLE;
        --'Xoa bang __TRONGNGAY
        V_STRSQL := 'TRUNCATE TABLE ' || V_STRFRTABLE;
        EXECUTE IMMEDIATE V_STRSQL;

        INSERT INTO LOG_ERR
            (ID, DATE_LOG, POSITION, TEXT)
        VALUES
            (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_STRSQL);
        COMMIT;
    END LOOP;

    --Kiem tra tao sequence moi
    FOR REC IN (SELECT FRTABLE, TOTABLE FROM TBLBACKUP WHERE TYPBK = 'S') LOOP
        V_STRFRTABLE := REC.FRTABLE;
        SELECT COUNT(*) INTO V_COUNT FROM USER_SEQUENCES WHERE SEQUENCE_NAME = V_STRFRTABLE;

        IF V_COUNT > 0 THEN
            INSERT INTO LOG_ERR
              (ID, DATE_LOG, POSITION, TEXT)
            VALUES
              (SEQ_LOG_ERR.NEXTVAL,
               SYSDATE,
               ' BACKUPDATA ',
               'Begin reset seq_' || V_STRFRTABLE);
            COMMIT;
            RESET_SEQUENCE(SEQ_NAME => V_STRFRTABLE, STARTVALUE => 1);
            COMMIT;
        ELSE
            V_SQL2 := 'CREATE SEQUENCE ' || V_STRFRTABLE || '
                      INCREMENT BY 1
                      START WITH 1
                      MINVALUE 1
                      MAXVALUE 999999999999999999999999999
                      NOCYCLE
                      NOORDER
                      NOCACHE';
            INSERT INTO LOG_ERR
                (ID, DATE_LOG, POSITION, TEXT)
            VALUES
                (SEQ_LOG_ERR.NEXTVAL, SYSDATE, ' BACKUPDATA ', V_SQL2);
            COMMIT;
            EXECUTE IMMEDIATE V_SQL2;
        END IF;
        COMMIT;
    END LOOP;

    --back up vsd_mt564_inf sau 2 thang
    INSERT INTO VSD_MT564_INF_HIST (AUTOID, VSDMSGID, VSDPROMSG, VSDPROMSG_VALUE, SYMBOL, REFSYMBOL, VSDMSGDATE, VSDMSGDATEEFF, VSDMSGTYPE, QTTY, REFCUSTODYCD, CUSTODYCD, DATETYPE, ADRESS, EXRATE, PRICE, RIGHTOFFRATE, BEGINDATE, EXPRICE, FRDATETRANSFER, POSTDATE, ROUND, ENDDATE, TODATETRANSFER, DESCRIPTION, TAX, EXPRICETYPE, NUMBERINFORMATION)
    SELECT AUTOID, VSDMSGID, VSDPROMSG, VSDPROMSG_VALUE, SYMBOL, REFSYMBOL, VSDMSGDATE, VSDMSGDATEEFF, VSDMSGTYPE, QTTY, REFCUSTODYCD, CUSTODYCD, DATETYPE, ADRESS, EXRATE, PRICE, RIGHTOFFRATE, BEGINDATE, EXPRICE, FRDATETRANSFER, POSTDATE, ROUND, ENDDATE, TODATETRANSFER, DESCRIPTION, TAX, EXPRICETYPE, NUMBERINFORMATION
    FROM VSD_MT564_INF
    WHERE VSDMSGDATE < ADD_MONTHS(VSDMSGDATE,-2);

    DELETE FROM VSD_MT564_INF
    WHERE VSDMSGDATE < ADD_MONTHS(VSDMSGDATE,-2);

    INSERT INTO VSDTXREQHIST
    SELECT * FROM VSDTXREQ WHERE MSGSTATUS NOT IN('P','S','A');

    DELETE FROM VSDTXREQ WHERE MSGSTATUS NOT IN('P','S','A');

    INSERT INTO VSDTXREQDTLHIST  SELECT * FROM VSDTXREQDTL
    WHERE REQID NOT IN (
        SELECT REQID FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A')
    );

    DELETE FROM VSDTXREQDTL
        WHERE REQID NOT IN (
        SELECT REQID FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A')
    );

    INSERT INTO VSDTRFLOGDTLHIST
    SELECT * FROM VSDTRFLOGDTL
    WHERE REFAUTOID NOT IN (
        SELECT AUTOID FROM VSDTRFLOG
        WHERE STATUS  IN ('P','A')
        OR NVL(REFERENCEID,'----') IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A'))
    );

    DELETE FROM VSDTRFLOGDTL
    WHERE REFAUTOID NOT IN (
        SELECT AUTOID FROM VSDTRFLOG
        WHERE STATUS IN ('P','A')
        OR NVL(REFERENCEID,'----') IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A'))
    );

    INSERT INTO VSDTRFLOGHIST
    SELECT * FROM VSDTRFLOG
    WHERE STATUS NOT IN ('P','A')
    AND NVL(REFERENCEID,'----') NOT IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A'));

    DELETE FROM VSDTRFLOG
    WHERE STATUS NOT IN ('P','A')
    AND NVL(REFERENCEID,'----') NOT IN (SELECT TO_CHAR(REQID) FROM VSDTXREQ WHERE MSGSTATUS IN ('P','S','A'));

    COMMIT;

    
    PLOG.SETENDSECTION(PKGCTX, 'pr_SABackupData');
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM);
      
      PLOG.SETENDSECTION(PKGCTX, 'pr_SABackupData');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END PR_SABACKUPDATA;

  ---------------------------------pr_SABeforeBatch------------------------------------------------
  PROCEDURE pr_SABeforeBatch(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate varchar2(10);
    v_dblTAXRATE number;
    l_err_param varchar2(300);
    l_count NUMBER(20);

  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SABeforeBatch');
    p_err_code:=0;
    v_currdate:= cspks_system.fn_get_sysvar('SYSTEM','CURRDATE');

      SELECT count(*) into l_count
      FROM TLLOG WHERE DELTD <> 'Y' AND TXSTATUS IN ('4','7','3') ;
       IF l_count <> 0 then
         P_ERR_CODE:='-100148';
         RETURN;
         PLOG.SETENDSECTION(PKGCTX, 'pr_SABEGINBATCH');
       ELSE
       
       --trung.luu: 07-04-2020 tu dong dong cua hoi so va chi nhanh

         UPDATE BRGRP SET STATUS='C';

         UPDATE SYSVAR
           SET VARVALUE = '0'
         WHERE GRNAME = 'SYSTEM'
           AND VARNAME = 'HOSTATUS';


       END IF;


    plog.setendsection(pkgctx, 'pr_SABeforeBatch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM  || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SABeforeBatch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SABeforeBatch;

  ---------------------------------pr_SAAfterBatch------------------------------------------------
  PROCEDURE pr_SAAfterBatch(p_err_code  OUT varchar2)
  IS
    v_nextdate varchar2(10);
    v_currdate date;
    l_maxdebtqttyrate number(20,4);
    l_maxdebtse number(20,0);
    l_iratio number(20,4);
    v_prinused number;
    V_FIRSTDAY DATE;
    l_UnHoldRealTime varchar2(3);
    l_prevDate VARCHAR2(10);
    v_sysvar varchar(10);
    n_amount number;
    WDRTYPE varchar2(10);
    v_MAX_NUMBER_VALUE number;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SAAfterBatch');

    v_currdate  := getcurrdate;
    --trung.luu: 07-04-2020 tu dong mo cua hoi so,chi nhanh
    UPDATE SYSVAR
       SET VARVALUE = '1'
     WHERE GRNAME = 'SYSTEM'
       AND VARNAME = 'HOSTATUS';

    UPDATE BRGRP SET STATUS='A';

    l_prevDate := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'PREVDATE');

    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SAAfterBatch');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SAAfterBatch');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SAAfterBatch;

  ---------------------------------pr_SAChangeWorkingDate------------------------------------------------
  PROCEDURE pr_SAChangeWorkingDate(P_ERR_CODE OUT VARCHAR2) IS
    V_NEXTDATE    VARCHAR2(20);
    V_CURRDATE    VARCHAR2(20);
    V_PREVDATE    VARCHAR2(20);
    V_DUEDATE     VARCHAR2(20);
    V_INTNUM      NUMBER;
    V_INTBKNUM    NUMBER;
    V_INTNEXTNUM  NUMBER;
    V_STRLAST_DAY VARCHAR2(20);
     v_advclearday NUMBER;
    V_TOTALFEE   NUMBER(20,4);
    V_REPAIRFEE  NUMBER(20,4);
    V_FEECD      VARCHAR2(5);
    V_FEERATE    NUMBER(20,4);
    V_CCYCD      VARCHAR2(20);
    V_DESC    VARCHAR2(500);
    v_sysvar varchar(10);
    n_amount number;
    WDRTYPE varchar2(10);
    v_MAX_NUMBER_VALUE number;
    --v_prinused number;
  BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
    V_NEXTDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'NEXTDATE');
    V_CURRDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'CURRDATE');

    IF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'RRRR') <>
       TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'RRRR') THEN
      UPDATE SBCLDR
         SET SBEOY = 'Y', SBEOQ = 'Y', SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') AND
          MOD(TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM'),
              3) = 0 THEN
      UPDATE SBCLDR
         SET SBEOQ = 'Y', SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'MM') THEN
      UPDATE SBCLDR
         SET SBEOM = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    ELSIF TO_CHAR(TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT), 'IW') <>
          TO_CHAR(TO_DATE(V_NEXTDATE, SYSTEMNUMS.C_DATE_FORMAT), 'IW') THEN
      UPDATE SBCLDR
         SET SBEOW = 'Y'
       WHERE CLDRTYPE = '000'
         AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    END IF;

    --PhuongHT add_ log Rtt truoc khi doi ngay
    --CSPKS_LOGPROC.PR_LOG_MARGINRATE_LOG('AF-END');
    -- end of PhuongHT add
    --Ngay lam viec truoc
    V_PREVDATE := V_CURRDATE;
    BEGIN
      SELECT TO_CHAR(MIN(SBDATE), 'DD/MM/RRRR')
        INTO V_CURRDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE > TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;

    --Ngay lam viec tiep theo
    BEGIN
      SELECT TO_CHAR(MIN(SBDATE), 'DD/MM/RRRR')
        INTO V_NEXTDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE > TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;

    --Ngay lam viec tiep theo
    BEGIN
      SELECT TO_CHAR(MAX(SBDATE), 'DD/MM/RRRR')
        INTO V_DUEDATE
        FROM SBCLDR
       WHERE CLDRTYPE = '000'
         AND HOLIDAY = 'N'
         AND SBDATE < TO_DATE(V_PREVDATE, SYSTEMNUMS.C_DATE_FORMAT);
    EXCEPTION
      WHEN OTHERS THEN
        PLOG.DEBUG(PKGCTX,
                   'l_lngErrCode: ' || ERRNUMS.C_SA_CALENDAR_MISSING);
        P_ERR_CODE := ERRNUMS.C_SA_CALENDAR_MISSING;
        RETURN;
    END;
    --Dat lai thong tin bang SYSVAR
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'DUEDATE', V_DUEDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'PREVDATE', V_PREVDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'CURRDATE', V_CURRDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'BUSDATE', V_CURRDATE);
    CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'NEXTDATE', V_NEXTDATE);
    --Cap nhat lai tin trong SBCLDR
    UPDATE SBCLDR
       SET SBBUSDAY = 'N'
     WHERE CLDRTYPE = '000'
       AND SBDATE = TO_DATE(V_PREVDATE, SYSTEMNUMS.C_DATE_FORMAT);
    UPDATE SBCLDR
       SET SBBUSDAY = 'Y'
     WHERE CLDRTYPE = '000'
       AND SBDATE = TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);




    --trung.luu dau ngay cap nhat lai so du 2000000000000 cho tai khoan tu doanh
    --lay sysvar tai khoan tu doanh

    --Xu ly dang ky goi chinh sach
    --cspks_cfproc.pr_AutoChangePolicy(P_ERR_CODE);
    --End Xu ly dang ky goi chinh sach

    P_ERR_CODE := 0;
    PLOG.SETENDSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
  EXCEPTION
    WHEN OTHERS THEN
      P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
      PLOG.ERROR(PKGCTX, SQLERRM || dbms_utility.format_error_backtrace);
      PLOG.SETENDSECTION(PKGCTX, 'pr_SAChangeWorkingDate');
      RAISE ERRNUMS.E_SYSTEM_ERROR;
  END PR_SACHANGEWORKINGDATE;

  ---------------------------------pr_SAGeneralWorking------------------------------------------------
  PROCEDURE pr_SAGeneralWorking(p_err_code  OUT varchar2)
  IS
    v_currdate      date;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_SAGeneralWorking');

    v_currdate := getcurrdate;


    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_SAGeneralWorking');
  EXCEPTION
  WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_SAGeneralWorking');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_SAGeneralWorking;

BEGIN
  FOR i IN (SELECT * FROM tlogdebug) LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('TXPKS_BATCH',
                      plevel => logrow.loglevel,
                      plogtable => (logrow.log4table = 'Y'),
                      palert => (logrow.log4alert = 'Y'),
                      ptrace => (logrow.log4trace = 'Y'));
END TXPKS_BATCH;
/
