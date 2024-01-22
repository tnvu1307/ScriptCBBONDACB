SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8800ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8800EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      05/02/2020     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;

FUNCTION fn_txAppReject(p_txdate varchar2,p_txnum in varchar2, p_tlid in varchar2)
RETURN NUMBER;

END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#8800ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_fileid           CONSTANT CHAR(2) := '15';
   c_fileidcode       CONSTANT CHAR(2) := '16';
   c_des              CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count number;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    /*if p_txmsg.deltd <> 'Y' THEN
        select count(*) into l_count from tllog tl, tllogfld tf
        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
            and tf.txnum <> p_txmsg.txnum
            and  tl.tltxcd = '8800' and tf.fldcd = '16'
            and tf.cvalue = p_txmsg.txfields('16').value
            and tl.txstatus = '4' ;
        if l_count > 0 then
            p_err_code := '-100819';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
        --
    end if;*/
    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    p_err_message varchar2(2000);
    p_tableName     varchar2(200);
    l_ovrrqd        varchar2(200);
    l_PROCNAME      varchar2(200);
    l_sql_query     varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Reversal transaction
        
        if p_txmsg.TXSTATUS = TXSTATUSNUMS.c_txcompleted then

            select tableName, ovrrqd, PROCNAME
            into p_tableName, l_ovrrqd, l_PROCNAME
            from filemaster where filecode = p_txmsg.txfields('16').value;
            --trung.luu: 03-03-2020 import tu online goi procname rieng
            if length(l_PROCNAME) > 0  then
                --Goi ham xu ly Duyet
                l_sql_query:=' BEGIN cspks_filemaster.'||l_PROCNAME||'(:p_tlid,:p_fileid, :p_err_code,:p_err_message); END;';

                execute immediate l_sql_query using     in p_txmsg.tlid,
                                                        in p_txmsg.txfields('15').value,
                                                        out p_err_code,
                                                        out p_err_message ;

               
                if p_err_code <> systemnums.C_SUCCESS then
                    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    return p_err_code;
                end if;
            end if;
            --Goi ham update trang thai Duyet
            cspks_filemaster.PR_AUTO_UPDATE_AFPRO(p_txmsg.tlid, p_txmsg.txfields('16').value,p_txmsg.txfields('15').value, p_err_code, p_err_message);
            
            if p_err_code <> systemnums.C_SUCCESS then
                plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN p_err_code;
            end if;
        End If;
    Else
     
        return systemnums.C_SUCCESS;
    End If;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
        p_err_code := errnums.C_SYSTEM_ERROR;
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
        RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

FUNCTION fn_txAppReject(p_txdate varchar2, p_txnum in varchar2, p_tlid in varchar2)
RETURN NUMBER
IS
    p_fileCode  varchar2(2000);
    p_fileId    varchar2(2000);
    l_tableName varchar2(2000);
    l_sql_query varchar2(4000);
    p_err_code  varchar2(4000);
    p_err_message   varchar2(4000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAppReject');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAppReject');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    p_err_message   := '';
    p_err_code      := systemnums.C_SUCCESS;

    select max(DECODE(tf.fldcd,'16',tf.cvalue,'')), max(DECODE(tf.fldcd,'15',tf.cvalue,'')) into p_fileCode, p_fileId
    from tllog tl, tllogfld tf
    where tl.txdate = tf.txdate and tl.txnum = tf.txnum
        and tl.txdate = to_date(p_txdate,systemnums.C_DATE_FORMAT) and tl.txnum = p_txnum;

    

    cspks_filemaster.PR_AUTO_REJECT(p_tlid, p_fileCode, p_fileId, p_err_code, p_err_message);
    if p_err_code <> systemnums.C_SUCCESS then
        plog.debug (pkgctx, '<<END OF fn_txAppReject');
        plog.setendsection (pkgctx, 'fn_txAppReject');
        RETURN p_err_code;
    end if;

    plog.debug (pkgctx, '<<END OF fn_txAppReject');
    plog.setendsection (pkgctx, 'fn_txAppReject');
    RETURN p_err_code;
EXCEPTION
WHEN OTHERS
   THEN
        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'fn_txAppReject');
        return errnums.C_SYSTEM_ERROR;
END fn_txAppReject;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#8800EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8800EX;
/
