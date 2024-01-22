SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_vstp

IS
    PROCEDURE PRC_CALL_2201(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_2202(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1704(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CHECK_1704(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1503(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1504(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1505(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1506(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1511(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1512(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1510(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_1705(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_vstp

IS
    PROCEDURE PRC_CALL_2201(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_2201');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '2201';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DISTINCT CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE,
                TO_NUMBER(DT.AMT) AMOUNT, DT.VSDORDERID,
                VSD.BICCODE, 'VND' CURRENCY
            FROM CFMAST CF,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                        AMT VARCHAR2(100) PATH '$.AMT',
                        CUSTODYCD VARCHAR2(100) PATH '$.CUSTODYCD'
                    )
                ) AS JT
            ) DT,
            (SELECT DISTINCT BICCODE FROM VSDBICCODE) VSD
            WHERE CF.CUSTODYCD = DT.CUSTODYCD
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Ngày giao d?ch   C
                 l_txmsg.txfields ('01').defname   := 'TXDATE';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := TO_CHAR(L_CURRDATE, 'DD/MM/RRRR');
            --05    Tên nhà d?u tu   C
                 l_txmsg.txfields ('05').defname   := 'FULLNAME';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.FULLNAME;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    CMND/GPKD/TradingCode   C
                 l_txmsg.txfields ('31').defname   := 'IDCODE';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.IDCODE;
            --56    Biccode thành viên   C
                 l_txmsg.txfields ('56').defname   := 'BICCODE';
                 l_txmsg.txfields ('56').TYPE      := 'C';
                 l_txmsg.txfields ('56').value      := rec.BICCODE;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --94    VSDORDERID   C
                 l_txmsg.txfields ('94').defname   := 'VSDORDERID';
                 l_txmsg.txfields ('94').TYPE      := 'C';
                 l_txmsg.txfields ('94').value      := rec.VSDORDERID;
            --95    Ngày c?p   C
                 l_txmsg.txfields ('95').defname   := 'IDDATE';
                 l_txmsg.txfields ('95').TYPE      := 'C';
                 l_txmsg.txfields ('95').value      := rec.IDDATE;
            --96    Noi c?p   C
                 l_txmsg.txfields ('96').defname   := 'IDPLACE';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.IDPLACE;
            --97    Lo?i ti?n t?   C
                 l_txmsg.txfields ('97').defname   := 'CURRENCY';
                 l_txmsg.txfields ('97').TYPE      := 'C';
                 l_txmsg.txfields ('97').value      := rec.CURRENCY;
            --99    S? ti?n   N
                 l_txmsg.txfields ('99').defname   := 'AMOUNT';
                 l_txmsg.txfields ('99').TYPE      := 'N';
                 l_txmsg.txfields ('99').value      := rec.AMOUNT;
            IF TXPKS_#2201.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2201');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2201');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2201');
    END PRC_CALL_2201;

    PROCEDURE PRC_CALL_2202(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_2202');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '2202';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DISTINCT CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.IDPLACE,
                TO_NUMBER(DT.AMT) AMOUNT, DT.VSDORDERID,
                VSD.BICCODE, 'VND' CURRENCY
            FROM CFMAST CF,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                        AMT VARCHAR2(100) PATH '$.AMT',
                        CUSTODYCD VARCHAR2(100) PATH '$.CUSTODYCD'
                    )
                ) AS JT
            ) DT,
            (SELECT DISTINCT BICCODE FROM VSDBICCODE) VSD
            WHERE CF.CUSTODYCD = DT.CUSTODYCD
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Ngày giao d?ch   C
                 l_txmsg.txfields ('01').defname   := 'TXDATE';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := TO_CHAR(L_CURRDATE, 'DD/MM/RRRR');
            --05    Tên nhà d?u tu   C
                 l_txmsg.txfields ('05').defname   := 'FULLNAME';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.FULLNAME;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    CMND/GPKD/TradingCode   C
                 l_txmsg.txfields ('31').defname   := 'IDCODE';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.IDCODE;
            --56    Biccode thành viên   C
                 l_txmsg.txfields ('56').defname   := 'BICCODE';
                 l_txmsg.txfields ('56').TYPE      := 'C';
                 l_txmsg.txfields ('56').value      := rec.BICCODE;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --94    VSDORDERID   C
                 l_txmsg.txfields ('94').defname   := 'VSDORDERID';
                 l_txmsg.txfields ('94').TYPE      := 'C';
                 l_txmsg.txfields ('94').value      := rec.VSDORDERID;
            --95    Ngày c?p   C
                 l_txmsg.txfields ('95').defname   := 'IDDATE';
                 l_txmsg.txfields ('95').TYPE      := 'C';
                 l_txmsg.txfields ('95').value      := rec.IDDATE;
            --96    Noi c?p   C
                 l_txmsg.txfields ('96').defname   := 'IDPLACE';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.IDPLACE;
            --97    Lo?i ti?n t?   C
                 l_txmsg.txfields ('97').defname   := 'CURRENCY';
                 l_txmsg.txfields ('97').TYPE      := 'C';
                 l_txmsg.txfields ('97').value      := rec.CURRENCY;
            --99    S? ti?n   N
                 l_txmsg.txfields ('99').defname   := 'AMOUNT';
                 l_txmsg.txfields ('99').TYPE      := 'N';
                 l_txmsg.txfields ('99').value      := rec.AMOUNT;

            IF TXPKS_#2202.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2202');
                RETURN;
            END IF;

            RETURN;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2202');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_2202');
    END PRC_CALL_2202;

    PROCEDURE PRC_CALL_1704(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1704');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1704';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT MT518.AUTOID, MT518.VSDTXNUM, MT518.VSDREQID, MT518.VSDMSGID,
                TO_NUMBER(REPLACE(MT518.VSDPRICE,'VND','')) VSDPRICE,
                TO_NUMBER(REPLACE(MT518.VSDAMT,'VND','')) VSDAMT,
                TO_NUMBER(MT518.VSDQUANTIY) VSDQUANTIY,
                TO_CHAR(MT518.VSDMSGDATE, 'DD/MM/RRRR') VSDMSGDATE,
                MT518.VSDORDERID, MT518.VSDSYMBOL, MT518.VSDCUSTODYCD,
                DT.CONF
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                        CONF VARCHAR2(100) PATH '$.CONF'
                    )
                ) AS JT
            ) DT,
            (SELECT * FROM VSD_MT518_INF WHERE STATUS = 'NEWM' AND NVL(CONFREQSTATUS, 'P') NOT IN ('F')) MT518
            WHERE DT.VSDORDERID = MT518.VSDORDERID
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Ngày giao d?ch   C
                 l_txmsg.txfields ('01').defname   := 'TXDATE';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := TO_CHAR(L_CURRDATE, 'DD/MM/RRRR');
            --02    AUTOID   C
                 l_txmsg.txfields ('02').defname   := 'AUTOID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.AUTOID;
            --03    S? hi?u tham chi?u   C
                 l_txmsg.txfields ('03').defname   := 'VSDTXNUM';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.VSDTXNUM;
            --04    Mã yêu c?u   C
                 l_txmsg.txfields ('04').defname   := 'VSDREQID';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.VSDREQID;
            --05    Tr?ng thái xác nh?n   C
                 l_txmsg.txfields ('05').defname   := 'CONFIRMSTATUS';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.CONF;
            --06    S? xác nh?n   C
                 l_txmsg.txfields ('06').defname   := 'VSDMSGID';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.VSDMSGID;
            --09    Giá   N
                 l_txmsg.txfields ('09').defname   := 'VSDPRICE';
                 l_txmsg.txfields ('09').TYPE      := 'N';
                 l_txmsg.txfields ('09').value      := rec.VSDPRICE;
            --10    Giá tr? th?c hi?n   N
                 l_txmsg.txfields ('10').defname   := 'AMT';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.VSDAMT;
            --22    S? hi?u l?nh   C
                 l_txmsg.txfields ('22').defname   := 'VSDORDERID';
                 l_txmsg.txfields ('22').TYPE      := 'C';
                 l_txmsg.txfields ('22').value      := rec.VSDORDERID;
            --23    Mã ch?ng khoán   C
                 l_txmsg.txfields ('23').defname   := 'VSDSYMBOL';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.VSDSYMBOL;
            --24    S? lu?ng   N
                 l_txmsg.txfields ('24').defname   := 'VSDQUANTIY';
                 l_txmsg.txfields ('24').TYPE      := 'N';
                 l_txmsg.txfields ('24').value      := rec.VSDQUANTIY;
            --25    Ngày thanh toán   D
                 l_txmsg.txfields ('25').defname   := 'VSDMSGDATE';
                 l_txmsg.txfields ('25').TYPE      := 'C';
                 l_txmsg.txfields ('25').value      := rec.VSDMSGDATE;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    S? TK   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.VSDCUSTODYCD;

            IF TXPKS_#1704.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1704');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := '-400508';

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1704');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1704');
    END PRC_CALL_1704;

    PROCEDURE PRC_CHECK_1704(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_COUNT NUMBER;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CHECK_1704');

        FOR REC IN (
            SELECT DT.VSDORDERID
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            SELECT COUNT(1) INTO L_COUNT FROM VSD_MT518_INF WHERE VSDORDERID = REC.VSDORDERID AND STATUS = 'NEWM';
            IF L_COUNT = 0 THEN
                P_ERR_CODE := '-400508';
                RETURN;
            END IF;

            SELECT COUNT(1) INTO L_COUNT FROM VSD_MT518_INF WHERE VSDORDERID = REC.VSDORDERID AND STATUS = 'NEWM' AND NVL(CONFREQSTATUS, 'P') NOT IN ('F');
            IF L_COUNT = 0 THEN
                P_ERR_CODE := '-100165';
                RETURN;
            END IF;
        END LOOP;

        P_ERR_CODE := SYSTEMNUMS.C_SUCCESS;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CHECK_1704');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CHECK_1704');
    END PRC_CHECK_1704;

    PROCEDURE PRC_CALL_1503(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1503');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1503';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CODEID VARCHAR2(20) PATH '$.CODEID',
                        REFERENCEID VARCHAR2(50) PATH '$.REFERENCEID',
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        SETTLEMENTDATE VARCHAR2(20) PATH '$.SETTLEMENTDATE',
                        IDCODE VARCHAR2(50) PATH '$.IDCODE',
                        STOCKTYPE VARCHAR2(20) PATH '$.STOCKTYPE',
                        DOBDATE VARCHAR2(20) PATH '$.DOBDATE',
                        IDPLACE VARCHAR2(500) PATH '$.IDPLACE',
                        ALTERNATEID VARCHAR2(50) PATH '$.ALTERNATEID',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        ADDRESS VARCHAR2(500) PATH '$.ADDRESS',
                        QTTY VARCHAR2(20) PATH '$.QTTY',
                        IDDATE VARCHAR2(20) PATH '$.IDDATE',
                        COUNTRY VARCHAR2(50) PATH '$.COUNTRY',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --01    Mã ch?ng khoán   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --02    Mã s? ki?n CK ch? giao d?ch   C
                 l_txmsg.txfields ('02').defname   := 'REFERENCEID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.REFERENCEID;
            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --09    Ngày h?ch toán   C
                 l_txmsg.txfields ('09').defname   := 'SETTLEMENTDATE';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.SETTLEMENTDATE;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    CMND/GPKD/TradingCode   C
                 l_txmsg.txfields ('31').defname   := 'IDCODE';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.IDCODE;
            --33    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('33').TYPE      := 'C';
                 l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
            --34    Ngày sinh   C
                 l_txmsg.txfields ('34').defname   := 'DOBDATE';
                 l_txmsg.txfields ('34').TYPE      := 'C';
                 l_txmsg.txfields ('34').value      := rec.DOBDATE;
            --37    Noi c?p   C
                 l_txmsg.txfields ('37').defname   := 'IDPLACE';
                 l_txmsg.txfields ('37').TYPE      := 'C';
                 l_txmsg.txfields ('37').value      := rec.IDPLACE;
            --38    Lo?i hình c? dông   C
                 l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                 l_txmsg.txfields ('38').TYPE      := 'C';
                 l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --91    Ð?a ch?   C
                 l_txmsg.txfields ('91').defname   := 'ADDRESS';
                 l_txmsg.txfields ('91').TYPE      := 'C';
                 l_txmsg.txfields ('91').value      := rec.ADDRESS;
            --92    S? lu?ng   N
                 l_txmsg.txfields ('92').defname   := 'QTTY';
                 l_txmsg.txfields ('92').TYPE      := 'N';
                 l_txmsg.txfields ('92').value      := rec.QTTY;
            --95    Ngày c?p   C
                 l_txmsg.txfields ('95').defname   := 'IDDATE';
                 l_txmsg.txfields ('95').TYPE      := 'C';
                 l_txmsg.txfields ('95').value      := rec.IDDATE;
            --96    Qu?c t?ch   C
                 l_txmsg.txfields ('96').defname   := 'COUNTRY';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.COUNTRY;
            --99    CBREF   C
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1503.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1503');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1503');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1503');
    END PRC_CALL_1503;

    PROCEDURE PRC_CALL_1504(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1504');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1504';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CODEID VARCHAR2(20) PATH '$.CODEID',
                        TXDATE VARCHAR2(20) PATH '$.TXDATE',
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        REFERENCEID VARCHAR2(50) PATH '$.REFERENCEID',
                        STOCKTYPE VARCHAR2(20) PATH '$.STOCKTYPE',
                        COUNTRY VARCHAR2(50) PATH '$.COUNTRY',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        QTTY VARCHAR2(20) PATH '$.QTTY',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --01    Mã ch?ng khoán   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --02    Ngày h?ch toán   C
                 l_txmsg.txfields ('02').defname   := 'TXDATE';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.TXDATE;
            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --09    Mã s? ki?n CK ch? giao d?ch   C
                 l_txmsg.txfields ('09').defname   := 'REFERENCEID';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.REFERENCEID;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --33    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('33').TYPE      := 'C';
                 l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
            --40    Qu?c gia   C
                 l_txmsg.txfields ('40').defname   := 'COUNTRY';
                 l_txmsg.txfields ('40').TYPE      := 'C';
                 l_txmsg.txfields ('40').value      := rec.COUNTRY;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --92    S? lu?ng   N
                 l_txmsg.txfields ('92').defname   := 'QTTY';
                 l_txmsg.txfields ('92').TYPE      := 'N';
                 l_txmsg.txfields ('92').value      := rec.QTTY;
            --99    CBREF   C
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1504.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1504');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1504');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1504');
    END PRC_CALL_1504;

    PROCEDURE PRC_CALL_1505(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1505');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1505';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CODEID VARCHAR2(20) PATH '$.CODEID',
                        REFERENCEID VARCHAR2(50) PATH '$.REFERENCEID',
                        SETTLEMENTDATE VARCHAR2(20) PATH '$.SETTLEMENTDATE',
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        SYMBOLNAME VARCHAR2(200) PATH '$.SYMBOLNAME',
                        STOCKTYPE VARCHAR2(20) PATH '$.STOCKTYPE',
                        YBEN VARCHAR2(20) PATH '$.YBEN',
                        RECBICCODE VARCHAR2(20) PATH '$.RECBICCODE',
                        RECCUSTODY VARCHAR2(20) PATH '$.RECCUSTODY',
                        BICCODE VARCHAR2(20) PATH '$.BICCODE',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        QTTY VARCHAR2(20) PATH '$.QTTY',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --01    Mã ch?ng khoán   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --02    Mã s? ki?n CK ch? giao d?ch   C
                 l_txmsg.txfields ('02').defname   := 'REFERENCEID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.REFERENCEID;
            --04    Ngày h?ch toán   C
                 l_txmsg.txfields ('04').defname   := 'SETTLEMENTDATE';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SETTLEMENTDATE;
            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --33    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('33').TYPE      := 'C';
                 l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
            --34    Chuy?n kho?n th?a k?   C
                 l_txmsg.txfields ('34').defname   := 'YBEN';
                 l_txmsg.txfields ('34').TYPE      := 'C';
                 l_txmsg.txfields ('34').value      := rec.YBEN;
            --56    TVLK bên nh?n   C
                 l_txmsg.txfields ('56').defname   := 'RECBICCODE';
                 l_txmsg.txfields ('56').TYPE      := 'C';
                 l_txmsg.txfields ('56').value      := rec.RECBICCODE;
            --57    S? tài kho?n bên nh?n   C
                 l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
                 l_txmsg.txfields ('57').TYPE      := 'C';
                 l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
            --58    TVLK bên chuy?n   C
                 l_txmsg.txfields ('58').defname   := 'BICCODE';
                 l_txmsg.txfields ('58').TYPE      := 'C';
                 l_txmsg.txfields ('58').value      := rec.BICCODE;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --92    S? lu?ng   N
                 l_txmsg.txfields ('92').defname   := 'QTTY';
                 l_txmsg.txfields ('92').TYPE      := 'N';
                 l_txmsg.txfields ('92').value      := rec.QTTY;
            --99    CBREF   C
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1505.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1505');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1505');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1505');
    END PRC_CALL_1505;

    PROCEDURE PRC_CALL_1506(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1506');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1506';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        IDCODE VARCHAR2(50) PATH '$.IDCODE',
                        TRANTYPE VARCHAR2(50) PATH '$.TRANTYPE',
                        ALTERNATEID VARCHAR2(50) PATH '$.ALTERNATEID',
                        COUNTRY VARCHAR2(50) PATH '$.COUNTRY',
                        RECBICCODE VARCHAR2(20) PATH '$.RECBICCODE',
                        RECCUSTODY VARCHAR2(20) PATH '$.RECCUSTODY',
                        BICCODE VARCHAR2(20) PATH '$.BICCODE',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        ADDRESS VARCHAR2(500) PATH '$.ADDRESS',
                        IDDATE VARCHAR2(20) PATH '$.IDDATE',
                        IDPLACE VARCHAR2(500) PATH '$.IDPLACE',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    CMND/GPKD/TradingCode   C
                 l_txmsg.txfields ('31').defname   := 'IDCODE';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.IDCODE;
            --32    Lo?i chuy?n kho?n   C
                 l_txmsg.txfields ('32').defname   := 'TRANTYPE';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := rec.TRANTYPE;
            --38    Lo?i hình c? dông   C
                 l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                 l_txmsg.txfields ('38').TYPE      := 'C';
                 l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
            --40    Qu?c t?ch   C
                 l_txmsg.txfields ('40').defname   := 'COUNTRY';
                 l_txmsg.txfields ('40').TYPE      := 'C';
                 l_txmsg.txfields ('40').value      := rec.COUNTRY;
            --56    TVLK bên nh?n   C
                 l_txmsg.txfields ('56').defname   := 'RECBICCODE';
                 l_txmsg.txfields ('56').TYPE      := 'C';
                 l_txmsg.txfields ('56').value      := rec.RECBICCODE;
            --57    S? tài kho?n bên nh?n   C
                 l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
                 l_txmsg.txfields ('57').TYPE      := 'C';
                 l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
            --58    TVLK bên chuy?n   C
                 l_txmsg.txfields ('58').defname   := 'BICCODE';
                 l_txmsg.txfields ('58').TYPE      := 'C';
                 l_txmsg.txfields ('58').value      := rec.BICCODE;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --91    Ð?a ch?   C
                 l_txmsg.txfields ('91').defname   := 'ADDRESS';
                 l_txmsg.txfields ('91').TYPE      := 'C';
                 l_txmsg.txfields ('91').value      := rec.ADDRESS;
            --95    Ngày c?p   C
                 l_txmsg.txfields ('95').defname   := 'IDDATE';
                 l_txmsg.txfields ('95').TYPE      := 'C';
                 l_txmsg.txfields ('95').value      := rec.IDDATE;
            --96    Noi c?p   C
                 l_txmsg.txfields ('96').defname   := 'IDPLACE';
                 l_txmsg.txfields ('96').TYPE      := 'C';
                 l_txmsg.txfields ('96').value      := rec.IDPLACE;

            IF TXPKS_#1506.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1506');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1506');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1506');
    END PRC_CALL_1506;

    PROCEDURE PRC_CALL_1511(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1511');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1511';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CODEID VARCHAR2(20) PATH '$.CODEID',
                        SETTLEMENTDATE VARCHAR2(20) PATH '$.SETTLEMENTDATE',
                        PLACEID VARCHAR2(50) PATH '$.PLACEID',
                        CONTRACTNO VARCHAR2(100) PATH '$.CONTRACTNO',
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        CONTRACTDATE VARCHAR2(20) PATH '$.CONTRACTDATE',
                        STOCKTYPE VARCHAR2(20) PATH '$.STOCKTYPE',
                        QTTY VARCHAR2(20) PATH '$.QTTY',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --01    Mã ch?ng khoán   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --02    Ngày h?ch toán   C
                 l_txmsg.txfields ('02').defname   := 'SETTLEMENTDATE';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.SETTLEMENTDATE;
            --04    Noi nh?n phong t?a   C
                 l_txmsg.txfields ('04').defname   := 'PLACEID';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.PLACEID;
            --05    S? h?p d?ng phong t?a   C
                 l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.CONTRACTNO;
            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --07    Ngày phong t?a   C
                 l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := rec.CONTRACTDATE;
            --08    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('08').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := rec.STOCKTYPE;
            --10    S? lu?ng   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.QTTY;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --99    CBREF   C
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1511.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1511');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1511');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1511');
    END PRC_CALL_1511;

    PROCEDURE PRC_CALL_1512(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1512');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1512';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        SETTLEMENTDATE VARCHAR2(20) PATH '$.SETTLEMENTDATE',
                        CODEID VARCHAR2(20) PATH '$.CODEID',
                        PLACEID VARCHAR2(50) PATH '$.PLACEID',
                        CONTRACTNO VARCHAR2(100) PATH '$.CONTRACTNO',
                        AFACCTNO VARCHAR2(20) PATH '$.AFACCTNO',
                        CONTRACTDATE VARCHAR2(20) PATH '$.CONTRACTDATE',
                        STOCKTYPE VARCHAR2(20) PATH '$.STOCKTYPE',
                        QTTY VARCHAR2(20) PATH '$.QTTY',
                        BPLOCKREQID VARCHAR2(20) PATH '$.BPLOCKREQID',
                        CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                        CUSTNAME VARCHAR2(200) PATH '$.CUSTNAME',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --02    Ngày h?ch toán   C
                 l_txmsg.txfields ('02').defname   := 'SETTLEMENTDATE';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.SETTLEMENTDATE;
            --03    Mã ch?ng khoán   C
                 l_txmsg.txfields ('03').defname   := 'CODEID';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.CODEID;
            --04    Noi nh?n phong t?a   C
                 l_txmsg.txfields ('04').defname   := 'PLACEID';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.PLACEID;
            --05    S? h?p d?ng phong t?a   C
                 l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.CONTRACTNO;
            --06    Ti?u kho?n   C
                 l_txmsg.txfields ('06').defname   := 'AFACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.AFACCTNO;
            --07    Ngày phong t?a   C
                 l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := rec.CONTRACTDATE;
            --08    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('08').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := rec.STOCKTYPE;
            --10    S? lu?ng   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.QTTY;
            --11    S? hi?u di?n tham chi?u   C
                 l_txmsg.txfields ('11').defname   := 'BPLOCKREQID';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := rec.BPLOCKREQID;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    Tài kho?n luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --90    H? tên   C
                 l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                 l_txmsg.txfields ('90').TYPE      := 'C';
                 l_txmsg.txfields ('90').value      := rec.CUSTNAME;
            --99    CBREF   C
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1512.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1512');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1512');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1512');
    END PRC_CALL_1512;

    PROCEDURE PRC_CALL_1510(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1510');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1510';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        RPTID VARCHAR2(20) PATH '$.RPTID',
                        VSDCAID VARCHAR2(50) PATH '$.VSDCAID',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Mã báo cáo   C
                 l_txmsg.txfields ('01').defname   := 'RPTID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.RPTID;
            --02    Sàn giao d?ch   C
                 l_txmsg.txfields ('02').defname   := 'BRID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := '0008';
            --03    Mã d?t th?c hi?n quy?n   C
                 l_txmsg.txfields ('03').defname   := 'TRANNUM';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.VSDCAID;
            --05    Tr?ng thái xác nh?n   C
                 l_txmsg.txfields ('05').defname   := 'CONFIRMSTATUS';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := 'CONF';
            --21    Ngày giao d?ch   C
                 l_txmsg.txfields ('21').defname   := 'TRANDATE';
                 l_txmsg.txfields ('21').TYPE      := 'C';
                 l_txmsg.txfields ('21').value      := TO_CHAR(L_CURRDATE, 'DD/MM/RRRR');
            --22    S? hi?u tham chi?u báo cáo   C
                 l_txmsg.txfields ('22').defname   := 'REFRPTID';
                 l_txmsg.txfields ('22').TYPE      := 'C';
                 l_txmsg.txfields ('22').value      := rec.VSDCAID;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --99    CBREF
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1510.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1510');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1510');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1510');
    END PRC_CALL_1510;

    PROCEDURE PRC_CALL_1705(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_1705');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '1705';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDCAID VARCHAR2(50) PATH '$.VSDCAID',
                        SYMBOL VARCHAR2(50) PATH '$.SYMBOL',
                        CUSTODYCD VARCHAR2(50) PATH '$.CUSTODYCD',
                        FULLNAME VARCHAR2(500) PATH '$.FULLNAME',
                        IDCODE VARCHAR2(50) PATH '$.IDCODE',
                        IDDATE VARCHAR2(50) PATH '$.IDDATE',
                        ALTERNATEID VARCHAR2(50) PATH '$.ALTERNATEID',
                        QTTY VARCHAR2(50) PATH '$.QTTY',
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Mã TPRL   M
                 l_txmsg.txfields ('01').defname   := 'SYMBOL';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.SYMBOL;
            --02    Mã d?t THQ   C
                 l_txmsg.txfields ('02').defname   := 'CAMASTID';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.VSDCAID;
            --03    H? tên   C
                 l_txmsg.txfields ('03').defname   := 'FULLNAME';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.FULLNAME;
            --04    S? ÐKSH   C
                 l_txmsg.txfields ('04').defname   := 'IDCODE';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.IDCODE;
            --05    Ngày c?p   D
                 l_txmsg.txfields ('05').defname   := 'IDDATE';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.IDDATE;
            --06    Lo?i ÐKSH   C
                 l_txmsg.txfields ('06').defname   := 'IDTYPE';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.ALTERNATEID;
            --07    Lo?i ch?ng khoán   C
                 l_txmsg.txfields ('07').defname   := 'STOCKTYPE';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := '1';
            --08    Thông tin ph?   M
                 l_txmsg.txfields ('08').defname   := 'NUMBERID';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := '001';
            --10    S? lu?ng dang ký   N
                 l_txmsg.txfields ('10').defname   := 'QTTY';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.QTTY;
            --14    Ngày ch?ng t?   D
                 l_txmsg.txfields ('14').defname   := 'TXDATE';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := TO_CHAR(L_CURRDATE, 'DD/MM/RRRR');
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    S? TK luu ký   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --99    CBREF
                 l_txmsg.txfields ('99').defname   := 'CBREF';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := rec.CBREF;

            IF TXPKS_#1705.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1705');
                RETURN;
            END IF;

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1705');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_1705');
    END PRC_CALL_1705;
END;
/
