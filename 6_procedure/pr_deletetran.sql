SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PR_DELETETRAN(P_TXNUM IN VARCHAR2, P_TXDATE IN VARCHAR) IS
    L_TXMSG TX.MSG_RECTYPE;
    L_XMLMSG VARCHAR2(32767);
    L_TLLOG TLLOG%ROWTYPE;
    PV_REFCURSOR PKG_REPORT.REF_CURSOR;
    PKGCTX PLOG.LOG_CTX;
    L_FLDNAME VARCHAR2(100);
    L_DEFNAME VARCHAR2(100);
    L_FLDTYPE CHAR(1);
    P_SQLCOMMAND VARCHAR2(4000);
    P_ERR_CODE VARCHAR2(100);
    P_ERR_PARAM VARCHAR2(1000);
BEGIN
    OPEN PV_REFCURSOR FOR
        SELECT *
        FROM TLLOG
        WHERE TXNUM=P_TXNUM AND TXDATE= TO_DATE(P_TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
    LOOP
    FETCH PV_REFCURSOR
    INTO L_TLLOG;
    EXIT WHEN PV_REFCURSOR%NOTFOUND;
        BEGIN
            IF L_TLLOG.DELTD = 'Y' OR L_TLLOG.TXSTATUS NOT IN ('1') THEN
                
                RETURN;
            END IF;

            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLLOG.TLID;
            L_TXMSG.OFFID       := L_TLLOG.OFFID;
            L_TXMSG.OFF_LINE    := L_TLLOG.OFF_LINE;
            L_TXMSG.WSNAME      := L_TLLOG.WSNAME;
            L_TXMSG.IPADDRESS   := L_TLLOG.IPADDRESS;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXPENDING;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.TXDATE      := TO_DATE(L_TLLOG.TXDATE,SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.BUSDATE     := TO_DATE(L_TLLOG.BUSDATE,SYSTEMNUMS.C_DATE_FORMAT);
            L_TXMSG.TXNUM       := L_TLLOG.TXNUM;
            L_TXMSG.TLTXCD      := L_TLLOG.TLTXCD;
            L_TXMSG.BRID        := L_TLLOG.BRID;
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXDELETED;

            FOR REC IN
            (
                SELECT *
                FROM TLLOGFLD
                WHERE TXNUM = P_TXNUM
                AND TXDATE = TO_DATE(P_TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
            )
            LOOP
                BEGIN
                    BEGIN
                        SELECT FLDNAME, DEFNAME, FLDTYPE
                        INTO L_FLDNAME, L_DEFNAME, L_FLDTYPE
                        FROM FLDMASTER
                        WHERE OBJNAME=L_TLLOG.TLTXCD AND FLDNAME=REC.FLDCD;

                        L_TXMSG.TXFIELDS (L_FLDNAME).DEFNAME := L_DEFNAME;
                        L_TXMSG.TXFIELDS (L_FLDNAME).TYPE := L_FLDTYPE;

                        IF L_FLDTYPE = 'C' THEN
                            L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.CVALUE;
                        ELSIF L_FLDTYPE = 'N' THEN
                            L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.NVALUE;
                        ELSE
                            L_TXMSG.TXFIELDS (L_FLDNAME).VALUE := REC.CVALUE;
                        END IF;
                    EXCEPTION WHEN OTHERS THEN
                       PLOG.ERROR(PKGCTX,' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
                    END;
                END;
            END LOOP;

            L_XMLMSG := TXPKS_MSG.FN_OBJ2XML(L_TXMSG);

            P_SQLCOMMAND := '
            BEGIN
                IF TXPKS_#'|| L_TLLOG.TLTXCD ||'.FN_TXPROCESS (:L_XMLMSG, :P_ERR_CODE, :P_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                    ROLLBACK;
                END IF;
            END;
            ';

            EXECUTE IMMEDIATE P_SQLCOMMAND USING IN OUT L_XMLMSG, IN OUT P_ERR_CODE, OUT P_ERR_PARAM;
            IF P_ERR_CODE = TO_CHAR(SYSTEMNUMS.C_SUCCESS) OR P_ERR_CODE IS NULL THEN
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            END IF;
        EXCEPTION WHEN OTHERS THEN
            PLOG.ERROR(PKGCTX,' ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        END;
    END LOOP;
END;
/
