SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#1701EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1701EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      15/06/2023     Created
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
END;
/


CREATE OR REPLACE PACKAGE BODY TXPKS_#1701EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_custodycd        CONSTANT CHAR(2) := '88';
   c_fullname         CONSTANT CHAR(2) := '90';
   c_dobdate          CONSTANT CHAR(2) := '34';
   c_idcode           CONSTANT CHAR(2) := '31';
   c_iddate           CONSTANT CHAR(2) := '95';
   c_idplace          CONSTANT CHAR(2) := '97';
   c_phone            CONSTANT CHAR(2) := '93';
   c_email            CONSTANT CHAR(2) := '37';
   c_address          CONSTANT CHAR(2) := '91';
   c_alternateid      CONSTANT CHAR(2) := '38';
   c_country          CONSTANT CHAR(2) := '40';
   c_province         CONSTANT CHAR(2) := '96';
   c_adtxtype         CONSTANT CHAR(2) := '56';
   c_adtxinfo         CONSTANT CHAR(2) := '57';
   c_adtxftype        CONSTANT CHAR(2) := '58';
   c_acctype          CONSTANT CHAR(2) := '55';
   c_beginstrategydate   CONSTANT CHAR(2) := '59';
   c_endstrategydate   CONSTANT CHAR(2) := '60';
   c_ityp             CONSTANT CHAR(2) := '61';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

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
    L_COUNT NUMBER;
    v_strITYP   VARCHAR2(100);
    v_strACCTYPE    VARCHAR2(100);
    v_strENDSTRATEGYDATE   VARCHAR2(20);
    v_strBEGINSTRATEGYDATE  VARCHAR2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    v_strITYP := p_txmsg.txfields('61').value;
    v_strACCTYPE := p_txmsg.txfields('55').value;
    v_strENDSTRATEGYDATE := p_txmsg.txfields('60').value;
    v_strBEGINSTRATEGYDATE := p_txmsg.txfields('59').value;

    IF v_strACCTYPE <> 'PINV' THEN
        v_strITYP := '';
        v_strENDSTRATEGYDATE := '';
        v_strBEGINSTRATEGYDATE := '';
    END IF;

    SELECT COUNT(*) INTO L_COUNT FROM CFMAST_TPRL  WHERE CUSTODYCD= p_txmsg.txfields('88').value;
    IF L_COUNT > 0 AND LENGTH(trim(p_txmsg.txfields('88').value)) > 0 THEN
        UPDATE  CFMAST_TPRL SET
            ACCTYPE = v_strACCTYPE, ADTXTYPE = p_txmsg.txfields('56').value,
            ADTXINFO = p_txmsg.txfields('57').value, ADTXFTYPE = p_txmsg.txfields('58').value,
            BEGINSTRATEGYDATE = TO_DATE(v_strBEGINSTRATEGYDATE,'dd/MM/RRRR'),
            ENDSTRATEGYDATE = TO_DATE(v_strENDSTRATEGYDATE,'dd/MM/RRRR'),
            ITYP = v_strITYP
        WHERE CUSTODYCD= p_txmsg.txfields('88').value;

    ELSE
        Insert into CFMAST_TPRL (CUSTODYCD,ACCTYPE,ADTXTYPE,ADTXINFO,ADTXFTYPE,BEGINSTRATEGYDATE,ENDSTRATEGYDATE,ITYP,STATUS)
        VALUES (p_txmsg.txfields('88').value, v_strACCTYPE, p_txmsg.txfields('56').value, p_txmsg.txfields('57').value,
                p_txmsg.txfields('58').value, TO_DATE(v_strBEGINSTRATEGYDATE,'dd/MM/RRRR'),
                TO_DATE(v_strENDSTRATEGYDATE,'dd/MM/RRRR'), v_strITYP,'P');

    END IF;

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
         plog.init ('TXPKS_#1701EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1701EX;
/
