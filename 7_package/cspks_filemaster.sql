SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_filemaster
IS
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
     **  TienPQ      09-JUNE-2009    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
    PROCEDURE PR_PREV_AUTO_FILLER(p_tlid in varchar2,p_filecode in varchar2, p_fileid  OUT varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

    PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2,p_tableName in varchar2,p_filecode in varchar2, p_fileid  IN varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

    PROCEDURE PR_AUTO_REJECT(p_tlid in varchar2,p_fileCode in varchar2,p_fileId in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

    PROCEDURE PR_AUTO_UPDATE_AFPRO(p_tlid in varchar2,p_filecode in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2);

    PROCEDURE PR_FILLER_1501(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_APR_1501(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1502_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1502(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1503_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1503(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1504_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1504(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1505_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1505(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1506_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1506(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1507_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1507(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1508_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1508(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1511_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1511(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1512_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1512(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1514_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1514(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1701_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2);
    PROCEDURE PR_FILE_1701(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_filemaster
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

PROCEDURE PR_PREV_AUTO_FILLER(p_tlid in varchar2,p_filecode in varchar2, p_fileid  OUT varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_autoid number;

BEGIN

    plog.setbeginsection(pkgctx, 'PR_PREV_AUTO_FILLER');

    SELECT seq_fileimport.NEXTVAL INTO  v_autoid FROM dual;

    p_fileid := to_char(v_autoid);

    commit;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_PREV_AUTO_FILLER');
exception
when others then
    rollback;
    p_err_code      := -100800; --File du lieu dau vao khong hop le
    p_err_message   := 'System error. Invalid file format';
    /*
    p_err_code      := 0;
    p_err_message   := 'Sucessfull!';
    */
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_PREV_AUTO_FILLER');
RETURN;
END PR_PREV_AUTO_FILLER;

PROCEDURE PR_AUTO_FILLER(p_tlid in varchar2,p_tablename in varchar2,p_filecode in varchar2, p_fileid  IN varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
    v_autoid number;
    l_txmsg       tx.msg_rectype;
    l_sql_query VARCHAR2(1000);
    v_fileid    VARCHAR2(1000);
    v_currdate date;
    l_strdesc     varchar2(400);
    l_tltxcd      varchar2(4);
    l_ovrrqd      varchar2(10);
    l_procfillter varchar2(50);
    l_VIA         varchar2(50);
    l_count number;
    l_errcode number;
BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_FILLER');

    if p_tablename='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    SELECT count(*) INTO l_count
    FROM SYSVAR
    WHERE GRNAME='SYSTEM' AND VARNAME='HOSTATUS'  AND VARVALUE= systemnums.C_OPERATION_ACTIVE;
    IF l_count = 0 THEN
        p_err_code := errnums.C_HOST_OPERATION_ISINACTIVE;
        plog.setendsection (pkgctx, 'PR_AUTO_FILLER');
        RETURN ;
    END IF;
    v_fileid    := p_fileid;
    If p_tlid ='6868' then
        l_VIA := 'O';
    Else
        l_VIA := 'F'; --
    End If;

    l_sql_query:='BEGIN UPDATE ' || p_tablename  || '  SET TLIDIMP = ''' || LPAD(p_tlid, 4, '0') || '''' ||
        ', TXTIME = SYSTIMESTAMP, IMPSTATUS =''Y'', OVRSTATUS=''N'', STATUS = ''P'', DELTD = ''N''' ||
        ', AUTOID = seq_imp_temp.nextval where fileid = ''' || v_fileid || '''; COMMIT; END;';

    execute immediate l_sql_query;

    select ovrrqd, filecode||': '||filename||'(File Id = '||p_fileid||')', procfillter into l_ovrrqd, l_strdesc, l_procfillter
    from filemaster where filecode = p_filecode;

    --Goi ham xu ly check validate
    if length(nvl(l_procfillter,'')) <> 0 then
        l_sql_query:=' BEGIN cspks_filemaster.'||l_procfillter||'(:p_tlid,:p_fileid, :p_err_code,:p_err_message); END;';
        execute immediate l_sql_query using     in p_tlid,
                                                in p_fileid,
                                                out p_err_code,
                                                out p_err_message ;


        if p_err_code <> systemnums.C_SUCCESS then
            plog.debug (pkgctx, '<<END OF PR_AUTO_FILLER');
            plog.setendsection (pkgctx, 'PR_AUTO_FILLER');
            return ;
        end if;
    end if;
    -- nap giao dich de xu ly
      v_currdate    := getcurrdate;
      l_tltxcd       := '8800';
      l_txmsg.tltxcd := l_tltxcd;

      l_txmsg.msgtype := 'T';
      l_txmsg.local   := 'N';
      l_txmsg.tlid    := p_tlid;
      select sys_context('USERENV', 'HOST'),
             sys_context('USERENV', 'IP_ADDRESS', 15)
        into l_txmsg.wsname, l_txmsg.ipaddress
        from dual;
      l_txmsg.off_line  := 'N';
      l_txmsg.deltd     := txnums.c_deltd_txnormal;
      if l_ovrrqd = 'Y' then
        l_txmsg.txstatus  := txstatusnums.c_txpending;
      else
        l_txmsg.txstatus  := txstatusnums.c_txcompleted;
      end if;
      l_txmsg.ovrrqd      := errnums.C_OFFID_REQUIRED;
      l_txmsg.msgsts    := '0';
      l_txmsg.ovrsts    := '0';
      l_txmsg.batchname := 'DAY';
      l_txmsg.busdate   := v_currdate;
      l_txmsg.txdate    := v_currdate;

      select to_char(sysdate, 'hh24:mi:ss') into l_txmsg.txtime from dual;
      select brid into l_txmsg.brid from tlprofiles where tlid = p_tlid;

        select l_txmsg.brid ||
                lpad(seq_batchtxnum.nextval, 6, '0')
          into l_txmsg.txnum
          from dual;

      --16    Loai file   C
         l_txmsg.txfields ('16').defname   := 'FILEIDCODE';
         l_txmsg.txfields ('16').TYPE      := 'C';
         l_txmsg.txfields ('16').value      := p_filecode;
    --15    Ma    C
         l_txmsg.txfields ('15').defname   := 'FILEID';
         l_txmsg.txfields ('15').TYPE      := 'C';
         l_txmsg.txfields ('15').value      := v_fileid;
    --30    Dien giai   C
         l_txmsg.txfields ('30').defname   := 'DES';
         l_txmsg.txfields ('30').TYPE      := 'C';
         l_txmsg.txfields ('30').value      := l_strdesc;
         --30    Dien giai   C
         l_txmsg.txfields ('99').defname   := 'USERNAME';
         l_txmsg.txfields ('99').TYPE      := 'C';
         l_txmsg.txfields ('99').value      := '';

        begin
            l_errcode := txpks_#8800.fn_batchtxprocess(l_txmsg, p_err_code, p_err_message);
            if l_errcode <> systemnums.c_success then
                plog.error (pkgctx, 'call 8800 error p_err_code: ' || p_err_code || ', l_errcode: ' || l_errcode);
                rollback;
                plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
                return;
            end if;
        end;

    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
exception
when others then
    rollback;
    p_err_code      := -100800; --File du lieu dau vao khong hop le
    p_err_message   := 'System error. Invalid file format';
    /*
    p_err_code      := 0;
    p_err_message   := 'Sucessfull!';
    */
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
RETURN;
END PR_AUTO_FILLER;

PROCEDURE PR_AUTO_UPDATE_AFPRO(p_tlid in varchar2,p_filecode in varchar2,p_fileid in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
v_autoid number;
l_sql_query VARCHAR2(1000);
p_tablename varchar2(200);
l_tablename_hist varchar2(200);

BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_UPDATE_AFPRO');
    if p_tablename='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    select tablename, tablename_hist into p_tablename, l_tablename_hist from filemaster where fileCode = p_fileCode;

    l_sql_query:=' UPDATE ' || p_tablename  || '  SET TLIDOVR =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP,  OVRSTATUS=''Y'' where nvl(OVRSTATUS,''N'') = ''N''  and fileid = '''||p_fileid||''' ';
    execute immediate l_sql_query;

    if length(nvl(l_tablename_hist,'')) > 0 then
        l_sql_query:=' insert into  '||l_tablename_hist||' select * from '||p_tablename ||' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;

        l_sql_query:=' delete from  '||p_tablename || ' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;

    end if;

    --commit;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_AUTO_UPDATE_AFPRO');

exception
when others then
    --rollback;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_FILLER');
RETURN;
END PR_AUTO_UPDATE_AFPRO;

PROCEDURE PR_AUTO_REJECT(p_tlid in varchar2,p_fileCode in varchar2,p_fileId in varchar2, p_err_code  OUT varchar2,p_err_message  OUT varchar2)
IS
p_tablename varchar2(300);
l_tablename_hist    varchar2(300);
l_sql_query VARCHAR2(1000);

BEGIN
    plog.setbeginsection(pkgctx, 'PR_AUTO_REJECT');
    if p_tablename='' then
        p_err_code := 0;
        p_err_message:= 'Sucessfull!';
        return;
    end if;

    select tablename, tablename_hist into p_tablename, l_tablename_hist from filemaster where fileCode = p_fileCode;

    l_sql_query:=' UPDATE ' || p_tablename  || '  SET TLIDOVR =''' || LPAD(p_tlid, 4, '0') || ''', TXTIME = SYSTIMESTAMP,  OVRSTATUS=''R'' where nvl(OVRSTATUS,''N'') = ''N'' and fileid = '''||p_fileid||''' ';
    execute immediate l_sql_query;

    if length(nvl(l_tablename_hist,'')) > 0 then
        l_sql_query:=' insert into  '||l_tablename_hist||' select * from '||p_tablename|| ' where fileid = '''||p_fileid||''' ' ;
        execute immediate l_sql_query;
        

        l_sql_query:=' delete from  '||p_tablename || ' where fileid = '''||p_fileid||''' ';
        execute immediate l_sql_query;
        
    end if;

    --commit;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';

    plog.setendsection(pkgctx, 'PR_AUTO_REJECT');

exception
when others then
    --rollback;
    p_err_code := 0;
    p_err_message:= 'Sucessfull!';
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PR_AUTO_REJECT');
RETURN;
END PR_AUTO_REJECT;

PROCEDURE PR_FILLER_1501(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILLER_1501');

    /*IDDATE*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_AOPN.FILEID = P_FILEID AND ISDATE(MT598_AOPN.IDDATE) = 'N';

    /*DOBDATE*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_AOPN.FILEID = P_FILEID AND ISDATE(MT598_AOPN.DOBDATE) = 'N';

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150019')
    WHERE MT598_AOPN.FILEID = P_FILEID AND MT598_AOPN.DOBDATE > GETCURRDATE();

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150024')
    WHERE MT598_AOPN.FILEID = P_FILEID AND MT598_AOPN.IDDATE > GETCURRDATE();

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150020')
    WHERE MT598_AOPN.FILEID = P_FILEID AND MT598_AOPN.DOBDATE > MT598_AOPN.IDDATE;


    /*CUSTODYCD*/
    /*
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND (
        SUBSTR(MT598_AOPN.CUSTODYCD, 1, 3) NOT IN
        (
            SELECT SYSVAR.VARVALUE
            FROM SYSVAR
            WHERE SYSVAR.VARNAME = 'COMPANYCD'
        ) OR length(MT598_AOPN.CUSTODYCD) <> 10
    );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND SUBSTR(MT598_AOPN.CUSTODYCD, 4, 1) NOT IN (
        'P',
        'C',
        'E',
        'F',
        'A',
        'B'
    );
    */
    /*CUSTNAME,IDCODE,IDPLACE,PHONE,EMAIL,ADDRESS*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT598_AOPN.FILEID = P_FILEID AND (
        MT598_AOPN.CUSTNAME IS NULL OR
        MT598_AOPN.IDCODE IS NULL OR
        MT598_AOPN.IDPLACE IS NULL OR
        MT598_AOPN.PHONE IS NULL OR
        MT598_AOPN.EMAIL IS NULL OR
        MT598_AOPN.ADDRESS IS NULL
    );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT598_AOPN.FILEID = P_FILEID AND (
        length(MT598_AOPN.CUSTNAME) > 100 OR
        length(MT598_AOPN.IDCODE) > 30 OR
        length(MT598_AOPN.IDPLACE) > 50 OR
        length(MT598_AOPN.PHONE) > 70 OR
        length(MT598_AOPN.EMAIL) > 70 OR
        length(MT598_AOPN.ADDRESS) > 50
    );

    /*COUNTRY*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND (
        MT598_AOPN.COUNTRY NOT IN
        (
            SELECT A.CDCONTENT
            FROM ALLCODE A
            WHERE A.CDNAME = 'NATIONAL'
        ) OR length(MT598_AOPN.COUNTRY) = 0
    );

    /*ALTERNATEID*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND (
        MT598_AOPN.ALTERNATEID NOT IN
        (
        SELECT A.CDVAL
        FROM ALLCODE A
        WHERE A.CDNAME = 'VSDALTE'
        ) OR length(MT598_AOPN.ALTERNATEID) = 0
    );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND MT598_AOPN.COUNTRY = 'VN'
    AND MT598_AOPN.ALTERNATEID IN ('VISD/ARNU', 'VISD/FIIN');

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND MT598_AOPN.COUNTRY <> 'VN'
    AND MT598_AOPN.ALTERNATEID IN ( 'VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND SUBSTR(MT598_AOPN.CUSTODYCD, 4, 1) NOT IN (
        'P',
        'C',
        'B'
    )
    AND MT598_AOPN.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND SUBSTR(MT598_AOPN.CUSTODYCD, 4, 1)  IN (
        'P',
        'C',
        'B'
    )
    AND MT598_AOPN.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN');

    /* COUNTRY */
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND SUBSTR(MT598_AOPN.CUSTODYCD, 4, 1)  IN (
        'P',
        'C',
        'B'
    )
    AND MT598_AOPN.COUNTRY <> 'VN';

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND SUBSTR(MT598_AOPN.CUSTODYCD, 4, 1) NOT IN (
        'P',
        'C',
        'B'
    )
    AND MT598_AOPN.COUNTRY = 'VN';

    /*PROVINCE*/
    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND MT598_AOPN.COUNTRY <> 'VN'
    AND MT598_AOPN.PROVINCE <> '--';

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE MT598_AOPN.FILEID = P_FILEID
    AND MT598_AOPN.COUNTRY = 'VN' AND
    (
        MT598_AOPN.PROVINCE NOT IN
        (
            SELECT A.CDVAL
            FROM ALLCODE A
            WHERE A.CDNAME = 'PROVINCE'
        ) OR length(MT598_AOPN.PROVINCE) = 0
    );

    UPDATE MT598_AOPN
    SET
    STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT598_AOPN.FILEID = P_FILEID AND GETCURRDATE() <> MT598_AOPN.TXDATE;

    SELECT COUNT(1) INTO V_COUNT FROM MT598_AOPN WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILLER_1501');
EXCEPTION
WHEN OTHERS THEN
    ROLLBACK;
    PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    PLOG.SETENDSECTION(PKGCTX, 'PR_FILLER_1501');
    P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
    P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
RETURN;
END PR_FILLER_1501;

PROCEDURE PR_APR_1501(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_APR_1501');
    L_TLTXCD := '1501';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;

    FOR REC IN (
        SELECT * FROM MT598_AOPN WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        --30    Mô T?   C
             L_TXMSG.TXFIELDS ('30').DEFNAME   := 'DESC';
             L_TXMSG.TXFIELDS ('30').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('30').VALUE      := L_DESC;
        --31    CMND/GPKD/TRADINGCODE   C
             L_TXMSG.TXFIELDS ('31').DEFNAME   := 'IDCODE';
             L_TXMSG.TXFIELDS ('31').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('31').VALUE      := REC.IDCODE;
        --34    NGàY SINH   C
             L_TXMSG.TXFIELDS ('34').DEFNAME   := 'DOBDATE';
             L_TXMSG.TXFIELDS ('34').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('34').VALUE      := REC.DOBDATE;
        --37    THU DI?N T?   C
             L_TXMSG.TXFIELDS ('37').DEFNAME   := 'EMAIL';
             L_TXMSG.TXFIELDS ('37').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('37').VALUE      := REC.EMAIL;
        --38    LO?I HìNH C? DôNG   C
             L_TXMSG.TXFIELDS ('38').DEFNAME   := 'ALTERNATEID';
             L_TXMSG.TXFIELDS ('38').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('38').VALUE      := REC.ALTERNATEID;
        --40    QU?C T?CH   C
             L_TXMSG.TXFIELDS ('40').DEFNAME   := 'COUNTRY';
             L_TXMSG.TXFIELDS ('40').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('40').VALUE      := REC.COUNTRY;
        --88    TàI KHO?N LUU Ký   C
             L_TXMSG.TXFIELDS ('88').DEFNAME   := 'CUSTODYCD';
             L_TXMSG.TXFIELDS ('88').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('88').VALUE      := REC.CUSTODYCD;
        --90    H? TêN   C
             L_TXMSG.TXFIELDS ('90').DEFNAME   := 'CUSTNAME';
             L_TXMSG.TXFIELDS ('90').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('90').VALUE      := REC.CUSTNAME;
        --91    Ð?A CH?   C
             L_TXMSG.TXFIELDS ('91').DEFNAME   := 'ADDRESS';
             L_TXMSG.TXFIELDS ('91').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('91').VALUE      := REC.ADDRESS;
        --93    S? DI?N THO?I   C
             L_TXMSG.TXFIELDS ('93').DEFNAME   := 'PHONE';
             L_TXMSG.TXFIELDS ('93').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('93').VALUE      := REC.PHONE;
        --95    NGàY C?P   C
             L_TXMSG.TXFIELDS ('95').DEFNAME   := 'IDDATE';
             L_TXMSG.TXFIELDS ('95').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('95').VALUE      := REC.IDDATE;
        --96    T?NH THàNH   C
             L_TXMSG.TXFIELDS ('96').DEFNAME   := 'PROVINCE';
             L_TXMSG.TXFIELDS ('96').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('96').VALUE      := REC.PROVINCE;
        --97    NOI C?P   C
             L_TXMSG.TXFIELDS ('97').DEFNAME   := 'IDPLACE';
             L_TXMSG.TXFIELDS ('97').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('97').VALUE      := REC.IDPLACE;

        BEGIN
          IF TXPKS_#1501.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
       END;
    END LOOP;
    PLOG.SETENDSECTION(PKGCTX, 'PR_APR_1501');
EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_APR_1501');
        RETURN;
END PR_APR_1501;

PROCEDURE PR_FILE_1502_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1502_FILLER');

    /*dobdate*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_ACLS.FILEID = P_FILEID AND  ISDATE(MT598_ACLS.IDDATE) = 'N';

    /*dobdate*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_ACLS.FILEID = P_FILEID AND ISDATE(MT598_ACLS.DOBDATE) = 'N';

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150019')
    WHERE MT598_ACLS.FILEID = P_FILEID AND MT598_ACLS.DOBDATE > GETCURRDATE;

    UPDATE MT598_ACLS
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150020')
    WHERE MT598_ACLS.FILEID = P_FILEID AND MT598_ACLS.DOBDATE > MT598_ACLS.IDDATE;

    UPDATE MT598_ACLS
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150024')
    WHERE MT598_ACLS.FILEID = P_FILEID AND MT598_ACLS.IDDATE > GETCURRDATE;

    /*CUSTODYCD*/
    /*
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND (SUBSTR(MT598_ACLS.CUSTODYCD, 1, 3) NOT IN
                (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT598_ACLS.CUSTODYCD) <> 10);

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND (SUBSTR(MT598_ACLS.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    --OR dbo.ISNUMBER(RIGHT(MT598_ACLS.CUSTODYCD, length(MT598_ACLS.CUSTODYCD)-4))  = '0')
    */
    /*custname,idcode,idplace,phone,email,address*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT598_ACLS.FILEID = P_FILEID AND (
        nvl(MT598_ACLS.CUSTNAME,'') = '' OR
        nvl(MT598_ACLS.IDCODE,'') = '' OR
        nvl(MT598_ACLS.IDPLACE,'') = '' OR
        nvl(MT598_ACLS.ADDRESS,'') = '');

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT598_ACLS.FILEID = P_FILEID AND (
        length(MT598_ACLS.CUSTNAME) > 100 OR
        length(MT598_ACLS.IDCODE) > 30 OR
        length(MT598_ACLS.IDPLACE) > 50 OR
        length(MT598_ACLS.PHONE) > 70 OR
        length(MT598_ACLS.EMAIL) > 70 OR
        length(MT598_ACLS.ADDRESS) > 50);

    /*country*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND (MT598_ACLS.COUNTRY NOT IN (SELECT A.CDCONTENT FROM ALLCODE A WHERE A.CDNAME = 'NATIONAL')
            OR length(MT598_ACLS.COUNTRY) = 0);

    /*alternateid*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND (MT598_ACLS.ALTERNATEID NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'VSDALTE')
            OR length(MT598_ACLS.ALTERNATEID) = 0);

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE
        MT598_ACLS.FILEID = P_FILEID AND
        MT598_ACLS.COUNTRY = 'VN' AND
        MT598_ACLS.ALTERNATEID IN ('VISD/ARNU', 'VISD/FIIN');

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE
        MT598_ACLS.FILEID = P_FILEID AND
        MT598_ACLS.COUNTRY <> 'VN' AND
        MT598_ACLS.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT');

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND SUBSTR(MT598_ACLS.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT598_ACLS.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT');

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND SUBSTR(MT598_ACLS.CUSTODYCD, 4, 1) IN ('P', 'C', 'B')
        AND MT598_ACLS.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' );
    /* country */
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND SUBSTR(MT598_ACLS.CUSTODYCD, 4, 1) IN ('P', 'C', 'B')
        AND MT598_ACLS.COUNTRY <> 'VN';

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND SUBSTR(MT598_ACLS.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT598_ACLS.COUNTRY = 'VN';
    /*PROVINCE*/
    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE
        MT598_ACLS.FILEID = P_FILEID AND
        MT598_ACLS.COUNTRY <> 'VN' AND
        MT598_ACLS.PROVINCE <> '--';

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE MT598_ACLS.FILEID = P_FILEID
        AND MT598_ACLS.COUNTRY = 'VN'
        AND (MT598_ACLS.PROVINCE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'PROVINCE')
            OR length(MT598_ACLS.PROVINCE) = 0);

    UPDATE MT598_ACLS
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT598_ACLS.FILEID = P_FILEID AND GETCURRDATE <> MT598_ACLS.TXDATE;

    SELECT COUNT(1) INTO V_COUNT FROM MT598_ACLS WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1502_FILLER');
        RETURN;
END PR_FILE_1502_FILLER;


PROCEDURE PR_FILE_1502(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1502');
    L_TLTXCD := '1502';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT598_ACLS WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --34    Ngày sinh   C
        l_txmsg.txfields ('34').defname   := 'DOBDATE';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').value      := rec.DOBDATE;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --97    Noi c?p   C
        l_txmsg.txfields ('97').defname   := 'IDPLACE';
        l_txmsg.txfields ('97').TYPE      := 'C';
        l_txmsg.txfields ('97').value      := rec.IDPLACE;
        --93    S? di?n tho?i   C
        l_txmsg.txfields ('93').defname   := 'PHONE';
        l_txmsg.txfields ('93').TYPE      := 'C';
        l_txmsg.txfields ('93').value      := rec.PHONE;
        --37    Thu di?n t?   C
        l_txmsg.txfields ('37').defname   := 'EMAIL';
        l_txmsg.txfields ('37').TYPE      := 'C';
        l_txmsg.txfields ('37').value      := rec.EMAIL;
        --91    Ð?a ch?   C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').value      := rec.ADDRESS;
        --38    Lo?i hình c? dông   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --40    Qu?c t?ch   C
        l_txmsg.txfields ('40').defname   := 'COUNTRY';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').value      := rec.COUNTRY;
        --96    T?nh thành   C
        l_txmsg.txfields ('96').defname   := 'PROVINCE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').value      := rec.PROVINCE;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1502.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;
    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1502');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1502');
        RETURN;
END PR_FILE_1502;

PROCEDURE PR_FILE_1503_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1503_FILLER');
    FOR REC IN (
        SELECT SB.CODEID, SB.SYMBOL
        FROM SBSECURITIES SB, MT540_1503 MT
        WHERE MT.STATUS = 'P' AND SB.SYMBOL = MT.SYMBOL
    )
    LOOP
        UPDATE MT540_1503 SET CODEID = REC.CODEID WHERE SYMBOL = REC.SYMBOL;
    END LOOP;

    /*symbol*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150004')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (MT540_1503.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES)
            OR length(MT540_1503.SYMBOL) = 0);

     /*settlementdate*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150008')
     WHERE MT540_1503.FILEID = P_FILEID AND ISDATE(MT540_1503.SETTLEMENTDATE) = 'N';

     UPDATE MT540_1503
        SET
           STATUS = 'E',
           ERRMSG = FN_GET_ERRMSG_EN('-150997')
     WHERE MT540_1503.FILEID = P_FILEID AND fn_check_holiday(MT540_1503.SETTLEMENTDATE) <> MT540_1503.SETTLEMENTDATE;

     /*iddate*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150008')
     WHERE MT540_1503.FILEID = P_FILEID AND ISDATE(MT540_1503.IDDATE) = 'N';

     /*DOBDATE*/
     UPDATE MT540_1503
        SET
           STATUS = 'E',
           ERRMSG = FN_GET_ERRMSG_EN('-150008')
     WHERE MT540_1503.FILEID = P_FILEID AND ISDATE(MT540_1503.DOBDATE) = 'N';

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150019')
     WHERE MT540_1503.FILEID = P_FILEID AND MT540_1503.DOBDATE > GETCURRDATE;

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150020')
     WHERE MT540_1503.FILEID = P_FILEID AND MT540_1503.DOBDATE > MT540_1503.IDDATE;

     /*QTTY*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150005')
     WHERE MT540_1503.FILEID = P_FILEID AND (MT540_1503.QTTY <= 0 OR length(MT540_1503.QTTY) > 15);

     /*stocktype*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150015')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (MT540_1503.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
            OR length(MT540_1503.STOCKTYPE) = 0);

     /*REFERENCEID*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150007')
     WHERE MT540_1503.FILEID = P_FILEID
        AND INSTR(MT540_1503.SYMBOL,'_WFT') > 0
        AND nvl(MT540_1503.REFERENCEID,'')  = '';
     /*CUSTODYCD*/
     /*
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150006')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (SUBSTR(MT540_1503.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT540_1503.CUSTODYCD) <> 10);

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150006')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (SUBSTR(MT540_1503.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A','B'));
        --OR dbo.ISNUMBER(RIGHT(MT540_1503.CUSTODYCD, length(MT540_1503.CUSTODYCD)-4))  = '0')
    */
     /*custname,idcode,idplace,phone,email,address*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150010')
     WHERE MT540_1503.FILEID = P_FILEID AND (
        nvl(MT540_1503.CUSTNAME,'') = '' OR
        nvl(MT540_1503.IDCODE,'') = '' OR
        nvl(MT540_1503.IDPLACE,'') = '' OR
        nvl(MT540_1503.ADDRESS,'') = '');

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150022')
     WHERE MT540_1503.FILEID = P_FILEID AND (
        length(MT540_1503.CUSTNAME) > 100 OR
        length(MT540_1503.IDCODE) > 30 OR
        length(MT540_1503.IDPLACE) > 50 OR
        length(MT540_1503.ADDRESS) > 50);

     /*country*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150011')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (MT540_1503.COUNTRY NOT IN (SELECT A.CDCONTENT FROM ALLCODE A WHERE A.CDNAME = 'NATIONAL')
            OR length(MT540_1503.COUNTRY) = 0);

     /*alternateid*/
     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150012')
     WHERE MT540_1503.FILEID = P_FILEID
        AND (MT540_1503.ALTERNATEID NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'VSDALTE')
            OR length(MT540_1503.ALTERNATEID) = 0);

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150012')
     WHERE
        MT540_1503.FILEID = P_FILEID AND
        MT540_1503.COUNTRY = 'VN' AND
        MT540_1503.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' );

     UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150012')
     WHERE
        MT540_1503.FILEID = P_FILEID AND
        MT540_1503.COUNTRY <> 'VN' AND
        MT540_1503.ALTERNATEID IN ( 'VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' );
    UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150012')
     WHERE MT540_1503.FILEID = P_FILEID AND (SUBSTR(MT540_1503.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT540_1503.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' ));

    UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150012')
     WHERE MT540_1503.FILEID = P_FILEID AND (SUBSTR(MT540_1503.CUSTODYCD, 4, 1)  IN ('P', 'C', 'B')
        AND MT540_1503.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' ));
    /* country */
    UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150011')
     WHERE MT540_1503.FILEID = P_FILEID AND (SUBSTR(MT540_1503.CUSTODYCD, 4, 1)  IN ('P','C','B')
        AND MT540_1503.COUNTRY <> 'VN' );

    UPDATE MT540_1503
        SET STATUS = 'E',
            ERRMSG = FN_GET_ERRMSG_EN('-150011')
     WHERE MT540_1503.FILEID = P_FILEID AND (SUBSTR(MT540_1503.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT540_1503.COUNTRY = 'VN' );

    UPDATE MT540_1503
        SET
           STATUS = 'E',
           ERRMSG = FN_GET_ERRMSG_EN('-150026')
     WHERE MT540_1503.FILEID = P_FILEID AND GETCURRDATE <> MT540_1503.TXDATE;


    SELECT COUNT(1) INTO V_COUNT FROM MT540_1503 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1503_FILLER');
        RETURN;
END PR_FILE_1503_FILLER;

PROCEDURE PR_FILE_1503(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1503');
    L_TLTXCD := '1503';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT540_1503 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --09    Ngày h?ch toán   C
        l_txmsg.txfields ('09').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').value      := rec.SETTLEMENTDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --34    Ngày sinh   C
        l_txmsg.txfields ('34').defname   := 'DOBDATE';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').value      := rec.DOBDATE;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --37    Noi c?p   C
        l_txmsg.txfields ('37').defname   := 'IDPLACE';
        l_txmsg.txfields ('37').TYPE      := 'C';
        l_txmsg.txfields ('37').value      := rec.IDPLACE;
        --91    Ð?a ch?   C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').value      := rec.ADDRESS;
        --96    Qu?c t?ch   C
        l_txmsg.txfields ('96').defname   := 'COUNTRY';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').value      := rec.COUNTRY;
        --38    Lo?i hình c? dông   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --15    T? ch?c phát hành   C
        l_txmsg.txfields ('15').defname   := 'SYMBOLNAME';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').value      := '';
        --33    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
        --92    S? lu?ng   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --02    Mã s? ki?n CK ch? giao d?ch   C
        l_txmsg.txfields ('02').defname   := 'REFERENCEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.REFERENCEID;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1503.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1503');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1503');
        RETURN;
END PR_FILE_1503;

PROCEDURE PR_FILE_1504_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1504_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1504 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1504 set codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1504.FILEID = P_FILEID
        AND (MT542_1504.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES)
            OR length(MT542_1504.SYMBOL) = 0);

    /*settlementdate*/
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1504.FILEID = P_FILEID AND ISDATE(MT542_1504.SETTLEMENTDATE) = 'N';

    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1504.FILEID = P_FILEID AND fn_check_holiday(MT542_1504.SETTLEMENTDATE)<> MT542_1504.SETTLEMENTDATE;

    /*QTTY*/
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1504.FILEID = P_FILEID AND (MT542_1504.QTTY <= 0 OR length(MT542_1504.QTTY) > 15);


    /*stocktype*/
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1504.FILEID = P_FILEID
        AND (MT542_1504.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
            OR length(MT542_1504.STOCKTYPE) = 0);

    /*REFERENCEID*/
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150007')
    WHERE MT542_1504.FILEID = P_FILEID
        AND INSTR(MT542_1504.SYMBOL,'_WFT') > 0
        AND NVL(MT542_1504.REFERENCEID,'') = '';

     /*CUSTODYCD*/
    /*
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1504.FILEID = P_FILEID
        AND (SUBSTR(MT542_1504.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT542_1504.CUSTODYCD) <> 10);

    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1504.FILEID = P_FILEID
    AND (SUBSTR(MT542_1504.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    -- OR dbo.ISNUMBER(RIGHT(MT542_1504.CUSTODYCD, length(MT542_1504.CUSTODYCD)-4))  = '0')
    */
    UPDATE MT542_1504
    SET STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1504.FILEID = P_FILEID AND GETCURRDATE <> MT542_1504.TXDATE;

    SELECT COUNT(1) INTO V_COUNT FROM MT542_1504 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1504_FILLER');
        RETURN;
END PR_FILE_1504_FILLER;

PROCEDURE PR_FILE_1504(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1504');
    L_TLTXCD := '1504';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1504 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --02    Ngày h?ch toán   C
        l_txmsg.txfields ('02').defname   := 'TXDATE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.TXDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --40    Qu?c gia   C
        l_txmsg.txfields ('40').defname   := 'NATIONAL';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').value      := '';
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --15    T? ch?c phát hành   M
        l_txmsg.txfields ('15').defname   := 'SYMBOLNAME';
        l_txmsg.txfields ('15').TYPE      := 'M';
        l_txmsg.txfields ('15').value      := '';
        --33    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
        --92    S? lu?ng   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --09    Mã s? ki?n CK ch? giao d?ch   C
        l_txmsg.txfields ('09').defname   := 'REFERENCEID';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').value      := rec.REFERENCEID;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1504.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1504');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1504');
        RETURN;
END PR_FILE_1504;

PROCEDURE PR_FILE_1505_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1505_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1505 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1505 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (MT542_1505.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES)
            OR length(MT542_1505.SYMBOL) = 0);

    /*QTTY*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1505.FILEID = P_FILEID AND (MT542_1505.QTTY <= 0 OR length(MT542_1505.QTTY) > 15);


    /*RECCUSTODY*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1505.FILEID = P_FILEID AND (nvl(MT542_1505.RECCUSTODY,'') = '' OR length(MT542_1505.RECCUSTODY) <> 10);

    /*
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1505.FILEID = P_FILEID
        AND SUBSTR2(MT542_1505.RECCUSTODY, 1, 3) NOT IN
            (SELECT d.DEPOSITID FROM DEPOSIT_MEMBER d WHERE d.BICCODE = MT542_1505.RECBICCODE);
    */

    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (SUBSTR2(MT542_1505.RECCUSTODY, 4, 1) NOT IN ('P','C','E','F','A','B' ));
    --OR dbo.ISNUMBER(RIGHT(MT542_1505.RECCUSTODY, length(MT542_1505.RECCUSTODY)-4)) = '0')

    /*RECBICCODE*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150021')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (MT542_1505.RECBICCODE NOT IN (SELECT d.BICCODE FROM DEPOSIT_MEMBER d)
            OR length(MT542_1505.RECBICCODE) = 0);

    /*stocktype*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (MT542_1505.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
            OR length(MT542_1505.STOCKTYPE) = 0);

    /*REFERENCEID*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150007')
    WHERE MT542_1505.FILEID = P_FILEID
        AND INSTR(MT542_1505.SYMBOL,'_WFT') > 0
        AND nvl(MT542_1505.REFERENCEID,'') = '';

    /*settlementdate*/
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1505.FILEID = P_FILEID AND fn_check_holiday(MT542_1505.SETTLEMENTDATE) <> MT542_1505.SETTLEMENTDATE;

    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1505.FILEID = P_FILEID AND ISDATE(MT542_1505.SETTLEMENTDATE) = 'N';

     /*CUSTODYCD*/
    /*
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (SUBSTR2(MT542_1505.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT542_1505.CUSTODYCD) <> 10);

    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1505.FILEID = P_FILEID
        AND (SUBSTR2(MT542_1505.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B'));
    --OR dbo.ISNUMBER(RIGHT(MT542_1505.CUSTODYCD, length(MT542_1505.CUSTODYCD)-4))  = '0')
    */
    UPDATE MT542_1505
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1505.FILEID = P_FILEID AND GETCURRDATE <> MT542_1505.TXDATE;

    SELECT COUNT(1) INTO V_COUNT FROM MT542_1505 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1505_FILLER');
        RETURN;
END PR_FILE_1505_FILLER;

PROCEDURE PR_FILE_1505(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1505');
    L_TLTXCD := '1505';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1505 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --04    Ngày h?ch toán   C
        l_txmsg.txfields ('04').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').value      := rec.SETTLEMENTDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --33    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
        --34    Chuy?n kho?n th?a k?   C
        l_txmsg.txfields ('34').defname   := 'YBEN';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').value      := 'N';
        --02    Mã s? ki?n CK ch? giao d?ch   C
        l_txmsg.txfields ('02').defname   := 'REFERENCEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.REFERENCEID;
        --92    S? lu?ng   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --58    TVLK bên chuy?n   C
        l_txmsg.txfields ('58').defname   := 'VSDBICCODE';
        l_txmsg.txfields ('58').TYPE      := 'C';
        l_txmsg.txfields ('58').value      := rec.VSDBICCODE;
        --56    TVLK bên nh?n   C
        l_txmsg.txfields ('56').defname   := 'RECBICCODE';
        l_txmsg.txfields ('56').TYPE      := 'C';
        l_txmsg.txfields ('56').value      := rec.RECBICCODE;
        --57    S? tài kho?n bên nh?n   C
        l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
        l_txmsg.txfields ('57').TYPE      := 'C';
        l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1505.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1505');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1505');
        RETURN;
END PR_FILE_1505;

PROCEDURE PR_FILE_1506_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1506_FILLER');

    /*iddate*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_1506.FILEID = P_FILEID AND ISDATE(MT598_1506.IDDATE) = 'N';

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT598_1506.FILEID = P_FILEID AND MT598_1506.IDDATE > MT598_1506.TXDATE;

    /*
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT598_1506.FILEID = P_FILEID
        AND SUBSTR2(MT598_1506.RECCUSTODY, 1, 3) NOT IN
            (SELECT d.DEPOSITID FROM DEPOSIT_MEMBER d WHERE d.BICCODE = MT598_1506.RECBICCODE);
    */

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.RECCUSTODY, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    --OR dbo.ISNUMBER(RIGHT(MT598_1506.RECCUSTODY, len(MT598_1506.RECCUSTODY)-4)) = '0')

    /*RECBICCODE*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150021')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (MT598_1506.RECBICCODE NOT IN (SELECT d.BICCODE FROM DEPOSIT_MEMBER d)
            OR length(MT598_1506.RECBICCODE) = 0);

    /*TRANTYPE*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150014')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (MT598_1506.TRANTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'TRANTYPE')
            OR length(MT598_1506.TRANTYPE) = 0);

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT598_1506.FILEID = P_FILEID AND GETCURRDATE <> MT598_1506.TXDATE;
    /*CUSTODYCD*/
    /*
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT598_1506.CUSTODYCD) <> 10);

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    --OR dbo.ISNUMBER(RIGHT(MT598_1506.CUSTODYCD, len(MT598_1506.CUSTODYCD)-4))  = '0')
    */
    /*custname,idcode,idplace,phone,email,address*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT598_1506.FILEID = P_FILEID AND (
        nvl(MT598_1506.CUSTNAME,'') = '' OR
        nvl(MT598_1506.IDCODE,'') = '' OR
        nvl(MT598_1506.IDPLACE,'') = '' OR
        nvl(MT598_1506.ADDRESS,'') = '');

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT598_1506.FILEID = P_FILEID AND (
        length(MT598_1506.CUSTNAME) > 100 OR
        length(MT598_1506.IDCODE) > 30 OR
        length(MT598_1506.IDPLACE) > 50 OR
        length(MT598_1506.ADDRESS) > 50);

    /*country*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (MT598_1506.COUNTRY NOT IN (SELECT A.CDCONTENT FROM ALLCODE A WHERE A.CDNAME = 'NATIONAL')
            OR length(MT598_1506.COUNTRY) = 0);

    /*alternateid*/
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (MT598_1506.ALTERNATEID NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'VSDALTE')
            OR length(MT598_1506.ALTERNATEID) = 0);

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1506.FILEID = P_FILEID
        AND MT598_1506.COUNTRY = 'VN'
        AND MT598_1506.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN');

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1506.FILEID = P_FILEID
        AND MT598_1506.COUNTRY <> 'VN'
        AND MT598_1506.ALTERNATEID IN ( 'VISD/IDNO', 'VISD/CORP', 'VISD/GOVT');

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT598_1506.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' ));

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 4, 1) IN ('P', 'C', 'B')
        AND MT598_1506.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' ));

    /* country */
    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 4, 1) IN ('P', 'C', 'B')
        AND MT598_1506.COUNTRY <> 'VN' );

    UPDATE MT598_1506
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1506.FILEID = P_FILEID
        AND (SUBSTR2(MT598_1506.CUSTODYCD, 4, 1) NOT  IN ('P', 'C', 'B')
        AND MT598_1506.COUNTRY = 'VN' );

    SELECT COUNT(1) INTO V_COUNT FROM MT598_1506 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1506_FILLER');
        RETURN;
END PR_FILE_1506_FILLER;

PROCEDURE PR_FILE_1506(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1506');
    L_TLTXCD := '1506';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT598_1506 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --96    Noi c?p   C
        l_txmsg.txfields ('96').defname   := 'IDPLACE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').value      := rec.IDPLACE;
        --91    Ð?a ch?   C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').value      := rec.ADDRESS;
        --40    Qu?c t?ch   C
        l_txmsg.txfields ('40').defname   := 'COUNTRY';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').value      := rec.COUNTRY;
        --38    Lo?i hình c? dông   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --32    Lo?i chuy?n kho?n   C
        l_txmsg.txfields ('32').defname   := 'TRANTYPE';
        l_txmsg.txfields ('32').TYPE      := 'C';
        l_txmsg.txfields ('32').value      := rec.TRANTYPE;
        --58    TVLK bên chuy?n   C
        l_txmsg.txfields ('58').defname   := 'VSDBICCODE';
        l_txmsg.txfields ('58').TYPE      := 'C';
        l_txmsg.txfields ('58').value      := 'VSDVCBSX';
        --56    TVLK bên nh?n   C
        l_txmsg.txfields ('56').defname   := 'RECBICCODE';
        l_txmsg.txfields ('56').TYPE      := 'C';
        l_txmsg.txfields ('56').value      := rec.RECBICCODE;
        --57    S? tài kho?n bên nh?n   C
        l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
        l_txmsg.txfields ('57').TYPE      := 'C';
        l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1506.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1506');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1506');
        RETURN;
END PR_FILE_1506;

PROCEDURE PR_FILE_1507_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1507_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1507 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1507 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1507.FILEID = P_FILEID AND nvl(MT542_1507.SYMBOL,'') = '';

    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1507.FILEID = P_FILEID
        AND MT542_1507.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES);

    /*QTTY*/
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1507.FILEID = P_FILEID AND (MT542_1507.QTTY <= 0 OR length(MT542_1507.QTTY) > 15);

    /*stocktype*/
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1507.FILEID = P_FILEID
        AND (MT542_1507.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
            OR length(MT542_1507.STOCKTYPE) = 0);

    /*REFERENCEID*/
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150007')
    WHERE MT542_1507.FILEID = P_FILEID
        AND INSTR(MT542_1507.SYMBOL,'_WFT') > 0
        AND nvl(MT542_1507.REFERENCEID,'') = '';

    /*settlementdate*/
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1507.FILEID = P_FILEID AND fn_check_holiday(MT542_1507.SETTLEMENTDATE) <>MT542_1507.SETTLEMENTDATE;

    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1507.FILEID = P_FILEID AND ISDATE(MT542_1507.SETTLEMENTDATE) = 'N';

    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1507.FILEID = P_FILEID AND GETCURRDATE <> MT542_1507.TXDATE;

    /*CUSTODYCD*/
    /*
    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1507.FILEID = P_FILEID
        AND (SUBSTR(MT542_1507.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD' )
            OR length(MT542_1507.CUSTODYCD) <> 10);

    UPDATE MT542_1507
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1507.FILEID = P_FILEID
        AND (SUBSTR(MT542_1507.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    --OR dbo.ISNUMBER(RIGHT(MT542_1507.CUSTODYCD, len(MT542_1507.CUSTODYCD)-4))  = '0')
    */
    SELECT COUNT(1) INTO V_COUNT FROM MT542_1507 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1507_FILLER');
        RETURN;
END PR_FILE_1507_FILLER;

PROCEDURE PR_FILE_1507(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1507');
    L_TLTXCD := '1507';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1507 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --04    Ngày h?ch toán   C
        l_txmsg.txfields ('04').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').value      := rec.SETTLEMENTDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --57    S? tài kho?n bên nh?n   C
        l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
        l_txmsg.txfields ('57').TYPE      := 'C';
        l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
        --58    S? ti?u kho?n bên nh?n   C
        l_txmsg.txfields ('58').defname   := 'REAFACCTNO';
        l_txmsg.txfields ('58').TYPE      := 'C';
        l_txmsg.txfields ('58').value      := rec.REAFACCTNO;
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --33    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
        --92    S? lu?ng   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --02    Mã s? ki?n CK ch? giao d?ch   C
        l_txmsg.txfields ('02').defname   := 'REFERENCEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.REFERENCEID;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1507.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1507');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1507');
        RETURN;
END PR_FILE_1507;

PROCEDURE PR_FILE_1508_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1508_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT565_1508 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT565_1508 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT565_1508.FILEID = P_FILEID
        AND (MT565_1508.SYMBOL NOT IN
                (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES WHERE INSTR( SBSECURITIES.SYMBOL,'WFT') = 0)
            OR length(MT565_1508.SYMBOL) = 0);

    /*QTTY*/
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT565_1508.FILEID = P_FILEID AND (MT565_1508.QTTY <= 0 OR length(MT565_1508.QTTY) > 15);



    /*REFERENCEID*/
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT565_1508.FILEID = P_FILEID AND (nvl(MT565_1508.REFERENCEID,'') = '');

    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT565_1508.FILEID = P_FILEID AND (length(MT565_1508.REFERENCEID) > 16);

    /*ORDERNUMBER*/
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150017')
    WHERE MT565_1508.FILEID = P_FILEID AND (isnumber(MT565_1508.ORDERNUMBER) = '0' OR length(MT565_1508.ORDERNUMBER) <> 3);

    /*stocktype*/
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT565_1508.FILEID = P_FILEID
        AND (MT565_1508.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
            OR length(MT565_1508.STOCKTYPE) = 0);


    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT565_1508.FILEID = P_FILEID AND GETCURRDATE <> MT565_1508.TXDATE;

     /*CUSTODYCD*/
     /*
    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT565_1508.FILEID = P_FILEID
        AND (substr2(MT565_1508.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT565_1508.CUSTODYCD) <> 10);

    UPDATE MT565_1508
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT565_1508.FILEID = P_FILEID
        AND (substr2(MT565_1508.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    -- OR dbo.ISNUMBER(RIGHT(MT565_1508.CUSTODYCD, len(MT565_1508.CUSTODYCD)-4))  = '0')
    */
    SELECT COUNT(1) INTO V_COUNT FROM MT565_1508 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1508_FILLER');
        RETURN;
END PR_FILE_1508_FILLER;

PROCEDURE PR_FILE_1508(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1508');
    L_TLTXCD := '1508';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT565_1508 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --38    Lo?i hình c? dông   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --02    Mã d?t th?c hi?n quy?n   C
        l_txmsg.txfields ('02').defname   := 'REFERENCEID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.REFERENCEID;
        --03    STT thông tin ph?   C
        l_txmsg.txfields ('03').defname   := 'ORDERNUMBER';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').value      := rec.ORDERNUMBER;
        --01    Mã ch?ng khoán ch?t   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --08    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('08').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').value      := rec.STOCKTYPE;
        --92    S? lu?ng CK d?t mua   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1508.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1508');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1508');
        RETURN;
END PR_FILE_1508;

PROCEDURE PR_FILE_1511_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1511_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1511 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1511 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*QTTY*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1511.FILEID = P_FILEID AND (MT542_1511.QTTY <= 0 OR length(MT542_1511.QTTY) > 15);

    /*symbol*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1511.FILEID = P_FILEID
        AND (MT542_1511.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES)
            OR length(MT542_1511.SYMBOL) = 0);

    /*placeid*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150003')
    WHERE MT542_1511.FILEID = P_FILEID
        AND (MT542_1511.PLACEID NOT IN (SELECT BLOCKPLACE.PLACEID FROM BLOCKPLACE)
            OR length(MT542_1511.PLACEID) = 0);

    /*stocktype*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1511.FILEID = P_FILEID
        AND (MT542_1511.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE' )
            OR length(MT542_1511.STOCKTYPE) = 0);

    /*settlementdate*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1511.FILEID = P_FILEID AND fn_check_holiday(MT542_1511.SETTLEMENTDATE) <>MT542_1511.SETTLEMENTDATE;

    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1511.FILEID = P_FILEID AND ISDATE(MT542_1511.SETTLEMENTDATE) = 'N';

    /*CONTRACTDATE*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1511.FILEID = P_FILEID AND fn_check_holiday(MT542_1511.CONTRACTDATE) <> MT542_1511.CONTRACTDATE;

    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1511.FILEID = P_FILEID AND ISDATE(MT542_1511.CONTRACTDATE) = 'N';

    /*CONTRACTNO*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT542_1511.FILEID = P_FILEID AND (nvl(MT542_1511.CONTRACTNO,'') = '' OR length(MT542_1511.CONTRACTNO) > 35);
    /*CUSTODYCD*/
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1511.FILEID = P_FILEID AND GETCURRDATE <> MT542_1511.TXDATE;
     /*CUSTODYCD*/
     /*
    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1511.FILEID = P_FILEID
        AND (substr2(MT542_1511.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT542_1511.CUSTODYCD) <> 10);

    UPDATE MT542_1511
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1511.FILEID = P_FILEID
        AND (substr2(MT542_1511.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));
    --OR dbo.ISNUMBER(RIGHT(MT542_1511.CUSTODYCD, len(MT542_1511.CUSTODYCD)-4))  = '0')
    */
    SELECT COUNT(1) INTO V_COUNT FROM MT542_1511 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1511_FILLER');
        RETURN;
END PR_FILE_1511_FILLER;

PROCEDURE PR_FILE_1511(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1511');
    L_TLTXCD := '1511';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1511 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --02    Ngày h?ch toán   C
        l_txmsg.txfields ('02').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.SETTLEMENTDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --15    T? ch?c phát hành   C
        l_txmsg.txfields ('15').defname   := 'SYMBOLNAME';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').value      := '';
        --08    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('08').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').value      := rec.STOCKTYPE;
        --10    S? lu?ng   N
        l_txmsg.txfields ('10').defname   := 'QTTY';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').value      := rec.QTTY;
        --04    Noi nh?n phong t?a   C
        l_txmsg.txfields ('04').defname   := 'PLACEID';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').value      := rec.PLACEID;
        --05    S? h?p d?ng phong t?a   C
        l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').value      := rec.CONTRACTNO;
        --07    Ngày phong t?a   C
        l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').value      := rec.CONTRACTDATE;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1511.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1511');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1511');
        RETURN;
END PR_FILE_1511;

PROCEDURE PR_FILE_1512_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1512_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1512 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1512 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1512.FILEID = P_FILEID
        AND (MT542_1512.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES)
        OR length(MT542_1512.SYMBOL) = 0);

    /*placeid*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150003')
    WHERE MT542_1512.FILEID = P_FILEID
        AND (MT542_1512.PLACEID NOT IN (SELECT BLOCKPLACE.PLACEID FROM BLOCKPLACE)
        OR length(MT542_1512.PLACEID) = 0);

    /*stocktype*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1512.FILEID = P_FILEID
        AND (MT542_1512.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
        OR length(MT542_1512.STOCKTYPE) = 0);

    /*qtty*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1512.FILEID = P_FILEID AND (MT542_1512.QTTY <= 0 OR length(MT542_1512.QTTY) > 15);

    /*settlementdate*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1512.FILEID = P_FILEID AND fn_check_holiday(MT542_1512.SETTLEMENTDATE) <> MT542_1512.SETTLEMENTDATE;

    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1512.FILEID = P_FILEID AND ISDATE(MT542_1512.SETTLEMENTDATE) = 'N';

    /*CONTRACTDATE*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1512.FILEID = P_FILEID AND fn_check_holiday(MT542_1512.CONTRACTDATE) <> MT542_1512.CONTRACTDATE;

    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1512.FILEID = P_FILEID AND ISDATE(MT542_1512.CONTRACTDATE) = 'N';

    /*CONTRACTNO,BPLOCKREQID*/
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT542_1512.FILEID = P_FILEID AND (nvl(MT542_1512.CONTRACTNO,'')  = '' OR nvl(MT542_1512.BPLOCKREQID,'')  = '');

    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT542_1512.FILEID = P_FILEID AND (length(MT542_1512.CONTRACTNO) > 35 OR length(MT542_1512.BPLOCKREQID) > 16);

    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1512.FILEID = P_FILEID AND GETCURRDATE <> MT542_1512.TXDATE;


     /*CUSTODYCD*/
     /*
    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1512.FILEID = P_FILEID
        AND (substr2(MT542_1512.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT542_1512.CUSTODYCD) <> 10);

    UPDATE MT542_1512
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1512.FILEID = P_FILEID
        AND (substr2(MT542_1512.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ) );
    --OR dbo.ISNUMBER(RIGHT(MT542_1512.CUSTODYCD, len(MT542_1512.CUSTODYCD)-4))  = '0')
    */
    SELECT COUNT(1) INTO V_COUNT FROM MT542_1512 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1512_FILLER');
        RETURN;
END PR_FILE_1512_FILLER;

PROCEDURE PR_FILE_1512(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1512');
    L_TLTXCD := '1512';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1512 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --02    Ngày h?ch toán   C
        l_txmsg.txfields ('02').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').value      := rec.SETTLEMENTDATE;
        --11    S? hi?u di?n tham chi?u   C
        l_txmsg.txfields ('11').defname   := 'BPLOCKREQID';
        l_txmsg.txfields ('11').TYPE      := 'C';
        l_txmsg.txfields ('11').value      := rec.BPLOCKREQID;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --08    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('08').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').value      := rec.STOCKTYPE;
        --03    Mã ch?ng khoán   C
        l_txmsg.txfields ('03').defname   := 'CODEID';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').value      := rec.CODEID;
        --15    T? ch?c phát hành   C
        l_txmsg.txfields ('15').defname   := 'SYMBOLNAME';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').value      := '';
        --10    S? lu?ng   N
        l_txmsg.txfields ('10').defname   := 'QTTY';
        l_txmsg.txfields ('10').TYPE      := 'N';
        l_txmsg.txfields ('10').value      := rec.QTTY;
        --05    S? h?p d?ng phong t?a   C
        l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').value      := rec.CONTRACTNO;
        --04    Noi nh?n phong t?a   C
        l_txmsg.txfields ('04').defname   := 'PLACEID';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').value      := rec.PLACEID;
        --07    Ngày phong t?a   C
        l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').value      := rec.CONTRACTDATE;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1512.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1512');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1512');
        RETURN;
END PR_FILE_1512;

PROCEDURE PR_FILE_1514_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1514_FILLER');

    for rec in (
        SELECT sb.codeid ,sb.SYMBOL
        FROM SBSECURITIES sb, MT542_1514 mt
        WHERE mt.STATUS = 'P' and sb.SYMBOL = mt.SYMBOL)
    LOOP
        UPDATE MT542_1514 set  codeid = rec.codeid where symbol = rec.symbol;
    END LOOP;

    /*symbol*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150004')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (MT542_1514.SYMBOL NOT IN (SELECT SBSECURITIES.SYMBOL FROM SBSECURITIES WHERE instr(SBSECURITIES.SYMBOL,'WFT') = 0)
            OR length(MT542_1514.SYMBOL) = 0);

    /*settlementdate*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150997')
    WHERE MT542_1514.FILEID = P_FILEID AND fn_check_holiday(MT542_1514.SETTLEMENTDATE) <> MT542_1514.SETTLEMENTDATE;

    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150008')
    WHERE MT542_1514.FILEID = P_FILEID AND ISDATE(MT542_1514.SETTLEMENTDATE) = 'N';

    /*QTTY*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150005')
    WHERE MT542_1514.FILEID = P_FILEID AND (MT542_1514.QTTY <= 0 OR length(MT542_1514.QTTY) > 15);

    /*CAMASTID*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT542_1514.FILEID = P_FILEID AND (nvl(MT542_1514.CAMASTID,'') = '');

    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT542_1514.FILEID = P_FILEID AND (length(MT542_1514.CAMASTID) > 16);

    /*stocktype*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150015')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (MT542_1514.STOCKTYPE NOT IN (SELECT A.CDVAL FROM ALLCODE A WHERE A.CDNAME = 'VSDDEALTYPE')
        OR length(MT542_1514.STOCKTYPE) = 0);

    /*RECCODE*/
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150021')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (MT542_1514.RECCODE NOT IN (SELECT d.BICCODE FROM DEPOSIT_MEMBER d)
        OR length(MT542_1514.RECCODE) = 0);

    /*RECCUSTODY*/

    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1514.FILEID = P_FILEID AND (nvl(MT542_1514.RECCUSTODY,'')  = '' OR length(MT542_1514.RECCUSTODY) <> 10);

    /*
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1514.FILEID = P_FILEID
        AND substr2(MT542_1514.RECCUSTODY, 1, 3) NOT IN
            (SELECT d.DEPOSITID FROM DEPOSIT_MEMBER d WHERE d.BICCODE = MT542_1514.RECCODE);
    */

    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150018')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (substr2(MT542_1514.RECCUSTODY, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ));

         /*CUSTODYCD*/
    /*
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (substr2(MT542_1514.CUSTODYCD, 1, 3) NOT IN (SELECT SYSVAR.VARVALUE FROM SYSVAR WHERE SYSVAR.VARNAME = 'COMPANYCD')
            OR length(MT542_1514.CUSTODYCD) <> 10);

    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT542_1514.FILEID = P_FILEID
        AND (substr2(MT542_1514.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B' ) );
    --OR dbo.ISNUMBER(RIGHT(MT542_1514.CUSTODYCD, len(MT542_1514.CUSTODYCD)-4))  = '0')
    */
    UPDATE MT542_1514
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150026')
    WHERE MT542_1514.FILEID = P_FILEID AND GETCURRDATE <> MT542_1514.TXDATE;

    SELECT COUNT(1) INTO V_COUNT FROM MT542_1514 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1514_FILLER');
        RETURN;
END PR_FILE_1514_FILLER;

PROCEDURE PR_FILE_1514(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1514');
    L_TLTXCD := '1514';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT542_1514 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        L_TXMSG.CCYUSAGE := REC.CODEID;

        --21    Ngày h?ch toán   C
        l_txmsg.txfields ('21').defname   := 'SETTLEMENTDATE';
        l_txmsg.txfields ('21').TYPE      := 'C';
        l_txmsg.txfields ('21').value      := rec.SETTLEMENTDATE;
        --22    Ngày chuy?n nhu?ng   C
        l_txmsg.txfields ('22').defname   := 'TXDATE';
        l_txmsg.txfields ('22').TYPE      := 'C';
        l_txmsg.txfields ('22').value      := rec.TXDATE;
        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'CUSTNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.CUSTNAME;
        --06    Ti?u kho?n   C
        l_txmsg.txfields ('06').defname   := 'AFACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').value      := rec.AFACCTNO;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --38    Lo?i hình c? dông   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --23    S? hi?u TC d?t THQ mua   C
        l_txmsg.txfields ('23').defname   := 'CAMASTID';
        l_txmsg.txfields ('23').TYPE      := 'C';
        l_txmsg.txfields ('23').value      := rec.CAMASTID;
        --01    Mã ch?ng khoán   C
        l_txmsg.txfields ('01').defname   := 'CODEID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').value      := rec.CODEID;
        --33    Lo?i ch?ng khoán   C
        l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
        l_txmsg.txfields ('33').TYPE      := 'C';
        l_txmsg.txfields ('33').value      := rec.STOCKTYPE;
        --92    S? lu?ng quy?n   N
        l_txmsg.txfields ('92').defname   := 'QTTY';
        l_txmsg.txfields ('92').TYPE      := 'N';
        l_txmsg.txfields ('92').value      := rec.QTTY;
        --56    TVLK bên nh?n   C
        l_txmsg.txfields ('56').defname   := 'RECCODE';
        l_txmsg.txfields ('56').TYPE      := 'C';
        l_txmsg.txfields ('56').value      := rec.RECCODE;
        --57    S? tài kho?n bên nh?n   C
        l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
        l_txmsg.txfields ('57').TYPE      := 'C';
        l_txmsg.txfields ('57').value      := rec.RECCUSTODY;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1514.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1514');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1514');
        RETURN;
END PR_FILE_1514;

PROCEDURE PR_FILE_1701_FILLER(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2,P_ERR_MESSAGE OUT VARCHAR2)
IS
    V_COUNT NUMBER;

BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'PR_FILE_1701_FILLER');

    UPDATE MT598_1701
    set BEGINSTRATEGYDATE = (CASE WHEN ACCTYPE NOT IN ('PINV') THEN NULL ELSE BEGINSTRATEGYDATE END),
        ENDSTRATEGYDATE = (CASE WHEN ACCTYPE NOT IN ('PINV') THEN NULL ELSE ENDSTRATEGYDATE END),
        ITYP = (CASE WHEN ACCTYPE NOT IN ('PINV') THEN NULL ELSE ITYP END)
    WHERE MT598_1701.FILEID = P_FILEID;

    /*iddate*/
    UPDATE MT598_1701
    SET
        STATUS = 'E',
        ERRMSG = FN_GET_ERRMSG_EN('-150038')
    WHERE MT598_1701.FILEID = P_FILEID AND ISDATE(MT598_1701.IDDATE) = 'N';

    /*DOBDATE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150036')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.DOBDATE IS NOT NULL AND ISDATE(MT598_1701.DOBDATE) = 'N';

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150019')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.DOBDATE IS NOT NULL AND MT598_1701.DOBDATE > GETCURRDATE;

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150024')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.IDDATE > GETCURRDATE;

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150020')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.DOBDATE IS NOT NULL AND MT598_1701.DOBDATE > MT598_1701.IDDATE;


    /*CUSTODYCD*/
    /*
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (substr2(MT598_1701.CUSTODYCD, 1, 3) NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'COMPANYCD')
            OR length(MT598_1701.CUSTODYCD) <> 10);

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150006')
    WHERE MT598_1701.FILEID = P_FILEID AND (substr2(MT598_1701.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'E', 'F', 'A', 'B'));
    --OR dbo.ISNUMBER(RIGHT(MT598_1701.CUSTODYCD, len(MT598_1701.CUSTODYCD)-4))  = '0')
    */
    /*custname,idcode,idplace,phone,email,address*/

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150010')
    WHERE MT598_1701.FILEID = P_FILEID AND (
    MT598_1701.FULLNAME IS NULL OR
    MT598_1701.IDCODE IS NULL OR
    MT598_1701.IDPLACE IS NULL OR
    MT598_1701.ADDRESS IS NULL);

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150022')
    WHERE MT598_1701.FILEID = P_FILEID AND (
    length(MT598_1701.FULLNAME) > 100 OR
    length(MT598_1701.IDCODE) > 30 OR
    length(MT598_1701.IDPLACE) > 50 OR
    length(MT598_1701.PHONE) > 70 OR
    length(MT598_1701.EMAIL) > 70 OR
    length(MT598_1701.ADDRESS) > 50);

    /*country*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
    ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.COUNTRY NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'NATIONAL')
        OR length(MT598_1701.COUNTRY) = 0);

    /*alternateid*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.ALTERNATEID NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'VSDALTE')
        OR length(MT598_1701.ALTERNATEID) = 0);

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1701.FILEID = P_FILEID
        AND MT598_1701.COUNTRY = 'VN'
        AND MT598_1701.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' );

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1701.FILEID = P_FILEID
        AND MT598_1701.COUNTRY <> 'VN'
        AND MT598_1701.ALTERNATEID IN ( 'VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' );

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1701.FILEID = P_FILEID AND (substr2(MT598_1701.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B')
        AND MT598_1701.ALTERNATEID IN ('VISD/IDNO', 'VISD/CORP', 'VISD/GOVT' ));

     UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150012')
    WHERE MT598_1701.FILEID = P_FILEID AND (substr2(MT598_1701.CUSTODYCD, 4, 1)  IN ('P', 'C', 'B')
        AND MT598_1701.ALTERNATEID IN ( 'VISD/ARNU', 'VISD/FIIN' ));
    /* country */
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1701.FILEID = P_FILEID AND (substr2(MT598_1701.CUSTODYCD, 4, 1)  IN ('P', 'C', 'B')
        AND MT598_1701.COUNTRY <> 'VN' );

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150011')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (substr2(MT598_1701.CUSTODYCD, 4, 1) NOT IN ('P', 'C', 'B') AND MT598_1701.COUNTRY = 'VN' );
    /*PROVINCE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE  MT598_1701.FILEID = P_FILEID
        AND MT598_1701.COUNTRY <> 'VN'
        AND MT598_1701.PROVINCE <> '--';

    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150009')
    WHERE MT598_1701.FILEID = P_FILEID
        AND MT598_1701.COUNTRY = 'VN'
        AND (MT598_1701.PROVINCE NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'PROVINCE')
            OR length(MT598_1701.PROVINCE) = 0);

    /*ACCTYPE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150031')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.ACCTYPE NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'TPRL_ACCTYPE')
        OR length(MT598_1701.ACCTYPE) = 0);

    /*ADTXINFO*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150033')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.ADTXINFO NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'ADTX_INFO')
        OR length(MT598_1701.ADTXINFO) = 0) ;


    /*ADTXTYPE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150034')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.ADTXTYPE NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'ADTX_TYPE')
        OR length(MT598_1701.ADTXTYPE) = 0);

    /*ADTXFTYPE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150034')
    WHERE MT598_1701.FILEID = P_FILEID
        AND (MT598_1701.ADTXFTYPE NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'ADTX_FTYPE')
        OR length(MT598_1701.ADTXFTYPE) = 0);

    /*BEGINSTRATEGYDATE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150037')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.ACCTYPE ='PINV' AND ISDATE(MT598_1701.BEGINSTRATEGYDATE) = 'N';
    /*ENDSTRATEGYDATE*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150039')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.ACCTYPE ='PINV' AND ISDATE(MT598_1701.ENDSTRATEGYDATE) = 'N';
    /*ITYP*/
    UPDATE MT598_1701
    SET
       STATUS = 'E',
       ERRMSG = FN_GET_ERRMSG_EN('-150035')
    WHERE MT598_1701.FILEID = P_FILEID AND MT598_1701.ACCTYPE ='PINV'
        AND (MT598_1701.ITYP NOT IN (SELECT A.CDVAL  AS cdval FROM ALLCODE A WHERE A.CDNAME = 'PINV_ITYP')
        OR LENGTH(MT598_1701.ITYP)=0);


    SELECT COUNT(1) INTO V_COUNT FROM MT598_1701 WHERE STATUS = 'E' AND FILEID = P_FILEID;
    IF V_COUNT > 0 THEN
        P_ERR_CODE := -100800; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE:= 'SYSTEM ERROR. INVALID FILE FORMAT';
        RETURN;
    END IF;

    P_ERR_CODE := 0;
    P_ERR_MESSAGE:= 'SUCESSFULL!';

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1701_FILLER');
        RETURN;
END PR_FILE_1701_FILLER;

PROCEDURE PR_FILE_1701(P_TLID IN VARCHAR2, P_FILEID IN VARCHAR2, P_ERR_CODE OUT VARCHAR2, P_ERR_MESSAGE OUT VARCHAR2)
IS
    L_STRCURRDATE   VARCHAR2(20);
    L_TXNUM         VARCHAR2(20);
    L_TXMSG         TX.MSG_RECTYPE;
    L_DESC          VARCHAR2(500);
    L_TLTXCD        VARCHAR2(20);
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX,'PR_FILE_1701');
    L_TLTXCD := '1701';

    SELECT TXDESC INTO L_DESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    SELECT TO_DATE (VARVALUE, SYSTEMNUMS.C_DATE_FORMAT)
    INTO L_STRCURRDATE
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME = 'CURRDATE';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    BEGIN
        SELECT TXNUM
        INTO L_TXNUM
        FROM TLLOG
        WHERE TLTXCD = '8800'
        AND MSGACCT = P_FILEID;
    EXCEPTION WHEN OTHERS THEN
        L_TXNUM := P_FILEID;
    END;
    BEGIN
        SELECT BRID
        INTO L_TXMSG.BRID
        FROM TLPROFILES WHERE TLID = L_TXMSG.TLID;
    EXCEPTION WHEN OTHERS THEN
        L_TXMSG.BRID := '0001';
    END;
    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := P_TLID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.REFTXNUM := L_TXNUM;
    L_TXMSG.TXDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE := TO_DATE(L_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := L_TLTXCD;
    FOR REC IN (
        SELECT * FROM MT598_1701 WHERE FILEID = P_FILEID AND NVL(STATUS, 'P') = 'P'
    )
    LOOP
        SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        --88    Tài kho?n luu ký   C
        l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
        l_txmsg.txfields ('88').TYPE      := 'C';
        l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
        --90    H? tên   C
        l_txmsg.txfields ('90').defname   := 'FULLNAME';
        l_txmsg.txfields ('90').TYPE      := 'C';
        l_txmsg.txfields ('90').value      := rec.FULLNAME;
        --34    Ngày sinh   C
        l_txmsg.txfields ('34').defname   := 'DOBDATE';
        l_txmsg.txfields ('34').TYPE      := 'C';
        l_txmsg.txfields ('34').value      := rec.DOBDATE;
        --31    CMND/GPKD/TradingCode   C
        l_txmsg.txfields ('31').defname   := 'IDCODE';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').value      := rec.IDCODE;
        --95    Ngày c?p   C
        l_txmsg.txfields ('95').defname   := 'IDDATE';
        l_txmsg.txfields ('95').TYPE      := 'C';
        l_txmsg.txfields ('95').value      := rec.IDDATE;
        --97    Noi c?p   C
        l_txmsg.txfields ('97').defname   := 'IDPLACE';
        l_txmsg.txfields ('97').TYPE      := 'C';
        l_txmsg.txfields ('97').value      := rec.IDPLACE;
        --93    S? di?n tho?i   C
        l_txmsg.txfields ('93').defname   := 'PHONE';
        l_txmsg.txfields ('93').TYPE      := 'C';
        l_txmsg.txfields ('93').value      := rec.PHONE;
        --37    Thu di?n t?   C
        l_txmsg.txfields ('37').defname   := 'EMAIL';
        l_txmsg.txfields ('37').TYPE      := 'C';
        l_txmsg.txfields ('37').value      := rec.EMAIL;
        --91    Ð?a ch?   C
        l_txmsg.txfields ('91').defname   := 'ADDRESS';
        l_txmsg.txfields ('91').TYPE      := 'C';
        l_txmsg.txfields ('91').value      := rec.ADDRESS;
        --38    Lo?i hình s? h?u   C
        l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
        l_txmsg.txfields ('38').TYPE      := 'C';
        l_txmsg.txfields ('38').value      := rec.ALTERNATEID;
        --40    Qu?c t?ch   C
        l_txmsg.txfields ('40').defname   := 'COUNTRY';
        l_txmsg.txfields ('40').TYPE      := 'C';
        l_txmsg.txfields ('40').value      := rec.COUNTRY;
        --96    T?nh thành   C
        l_txmsg.txfields ('96').defname   := 'PROVINCE';
        l_txmsg.txfields ('96').TYPE      := 'C';
        l_txmsg.txfields ('96').value      := rec.PROVINCE;
        --56    Lo?i hình c? dông   C
        l_txmsg.txfields ('56').defname   := 'ADTXTYPE';
        l_txmsg.txfields ('56').TYPE      := 'C';
        l_txmsg.txfields ('56').value      := rec.ADTXTYPE;
        --57    Linh v?c ho?t d?ng   C
        l_txmsg.txfields ('57').defname   := 'ADTXINFO';
        l_txmsg.txfields ('57').TYPE      := 'C';
        l_txmsg.txfields ('57').value      := rec.ADTXINFO;
        --58    Lo?i hình doanh nghi?p   C
        l_txmsg.txfields ('58').defname   := 'ADTXFTYPE';
        l_txmsg.txfields ('58').TYPE      := 'C';
        l_txmsg.txfields ('58').value      := rec.ADTXFTYPE;
        --55    Lo?i NÐT   C
        l_txmsg.txfields ('55').defname   := 'ACCTYPE';
        l_txmsg.txfields ('55').TYPE      := 'C';
        l_txmsg.txfields ('55').value      := rec.ACCTYPE;
        --59    Ngày b?t d?u   C
        l_txmsg.txfields ('59').defname   := 'BEGINSTRATEGYDATE';
        l_txmsg.txfields ('59').TYPE      := 'C';
        l_txmsg.txfields ('59').value      := rec.BEGINSTRATEGYDATE;
        --60    Ngày k?t thúc   C
        l_txmsg.txfields ('60').defname   := 'ENDSTRATEGYDATE';
        l_txmsg.txfields ('60').TYPE      := 'C';
        l_txmsg.txfields ('60').value      := rec.ENDSTRATEGYDATE;
        --61    Tiêu chí dang ký   C
        l_txmsg.txfields ('61').defname   := 'ITYP';
        l_txmsg.txfields ('61').TYPE      := 'C';
        l_txmsg.txfields ('61').value      := rec.ITYP;
        --30    Mô t?   C
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').value      := L_DESC;

        BEGIN
          IF TXPKS_#1701.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
             ROLLBACK;
             RETURN;
          END IF;
        END;
    END LOOP;

    PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1701');

EXCEPTION
     WHEN OTHERS THEN
        P_ERR_CODE    := -100129; --FILE DU LIEU DAU VAO KHONG HOP LE
        P_ERR_MESSAGE := 'SYSTEM ERROR. INVALID FILE FORMAT';
        PLOG.ERROR (PKGCTX,'TRACE: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PR_FILE_1701');
        RETURN;
END PR_FILE_1701;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_filemaster',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
