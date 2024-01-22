SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_system
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
     FUNCTION fn_get_sysvar (p_sys_grp IN VARCHAR2, p_sys_name IN VARCHAR2)
        RETURN sysvar.varvalue%TYPE;

     FUNCTION fn_get_errmsg (p_errnum IN varchar2)
        RETURN deferror.errdesc%TYPE;

  PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2
   );

  Function fn_NETgen_trandesc (p_xmlmsg     IN varchar2,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2;
  Function fn_DBgen_trandesc (p_txmsg IN tx.msg_rectype,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2;

   FUNCTION fn_PasswordGenerator (p_PwdLenght IN varchar2)
   RETURN VARCHAR2;

   FUNCTION fn_PasswordGenerator2 (p_PwdLenght IN varchar2)
   RETURN VARCHAR2;

   function fn_correct_field(p_txmsg in tx.msg_rectype, p_fldname in varchar2, p_type in varchar2) return varchar2;
   function fn_random_str(v_length number) return VARCHAR2;
   Function fn_formatnumber (p_number IN NUMBER) return VARCHAR2;

END;
/


CREATE OR REPLACE PACKAGE BODY CSPKS_SYSTEM
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


    function fn_correct_field(p_txmsg in tx.msg_rectype, p_fldname in varchar2, p_type in varchar2)
    return varchar2
    is
    begin
        return p_txmsg.txfields(p_fldname).value;
    exception when others then
        return case when p_type='N' then '0' else '' end;
    end fn_correct_field;

   PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2
   )
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      UPDATE sysvar
      SET varvalue    = p_sys_value
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      COMMIT;
   END;

   PROCEDURE pr_set_sysvar (p_sys_grp IN varchar2,
                            p_sys_name IN varchar2,
                            p_sys_value IN varchar2,
                            p_auto_commit IN boolean
   )
   IS
   BEGIN
      UPDATE sysvar
      SET varvalue    = p_sys_value
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      IF p_auto_commit
      THEN
         COMMIT;
      END IF;
   END;

   FUNCTION fn_get_sysvar (p_sys_grp IN varchar2, p_sys_name IN varchar2)
      RETURN sysvar.varvalue%TYPE
   IS
      l_sys_value   sysvar.varvalue%TYPE;
   BEGIN
      SELECT varvalue
      INTO l_sys_value
      FROM sysvar
      WHERE varname = p_sys_name AND grname = p_sys_grp;

      RETURN l_sys_value;
   END;

   FUNCTION fn_get_errmsg (p_errnum IN varchar2)
      RETURN deferror.errdesc%TYPE
   IS
      l_errdesc   deferror.errdesc%TYPE;
   BEGIN
      FOR i IN (SELECT errdesc
                FROM deferror
                WHERE errnum = p_errnum)
      LOOP
         l_errdesc   := i.errdesc;
      END LOOP;

      RETURN l_errdesc;
   END;

   FUNCTION fn_get_date (p_date IN varchar2, p_date_format IN varchar2)
      RETURN VARCHAR2
   IS
      l_date   DATE;
   BEGIN
      l_date   := TO_DATE (p_date, systemnums.c_date_format);
      RETURN TO_CHAR (l_date, p_date_format);
   END;

   FUNCTION fn_get_param (p_type IN varchar2, p_name IN varchar2)
      RETURN VARCHAR2
   IS
      l_value   VARCHAR2 (20);
   BEGIN
      SELECT a.cdval
      INTO l_value
      FROM allcode a
      WHERE UPPER (a.cdtype) = UPPER (p_type)
            AND UPPER (a.cdname) = UPPER (p_name);

      RETURN l_value;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;

   Function fn_NETgen_trandesc (p_xmlmsg     IN varchar2,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2
   IS
        p_txmsg tx.msg_rectype;
        var1 varchar2(1000);
        var2 varchar2(1000);
        var3 varchar2(1000);
        p_txdesc varchar2(1000);
   BEGIN
      plog.setbeginsection(pkgctx, 'fn_NETgen_trandesc');
      plog.debug (pkgctx, 'p_tltxcd:' || p_tltxcd);
      plog.debug (pkgctx, 'p_apptype:' || p_apptype);
      plog.debug (pkgctx, 'p_apptxcd:' || p_apptxcd);

      p_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
      p_txdesc:='';
      plog.setendsection(pkgctx, 'fn_NETgen_trandesc');
      return p_txdesc;
   exception when others then

    plog.setendsection (pkgctx, 'fn_NETgen_trandesc');
    RETURN '';
   END;

   Function fn_DBgen_trandesc (p_txmsg IN tx.msg_rectype,
                            p_tltxcd IN varchar2,
                            p_apptype IN varchar2,
                            p_apptxcd IN varchar2
   )
   return varchar2
   IS
        p_txdesc varchar2(1000);
        var1 varchar2(1000);
        var2 varchar2(1000);
        --var3 varchar2(1000);
   BEGIN
      plog.setbeginsection(pkgctx, 'fn_DBgen_trandesc');
      plog.debug (pkgctx, 'p_tltxcd:' || p_tltxcd);
      plog.debug (pkgctx, 'p_apptype:' || p_apptype);
      plog.debug (pkgctx, 'p_apptxcd:' || p_apptxcd);

      p_txdesc:='';
      plog.setendsection(pkgctx, 'fn_DBgen_trandesc');
      return p_txdesc;
   exception when others then
      plog.setendsection(pkgctx, 'fn_DBgen_trandesc');
    return '';
   END;

   FUNCTION fn_PasswordGenerator (p_PwdLenght IN varchar2)
      RETURN VARCHAR2
   IS
      l_Password   sysvar.varvalue%TYPE;
   BEGIN

     -- SELECT upper(dbms_random.string('U', 10)) str INTO l_Password from dual;
      SELECT   ROUND (dbms_random.value(100000,999998)) str INTO l_Password from dual;
      RETURN l_Password;
   END;

   FUNCTION fn_PasswordGenerator2 (p_PwdLenght IN varchar2)
      RETURN VARCHAR2
   IS
      l_Password   sysvar.varvalue%TYPE;
   BEGIN

     -- SELECT upper(dbms_random.string('U', 10)) str INTO l_Password from dual;
      SELECT  '123456' INTO l_Password from dual;
      RETURN l_Password;
   END;

   function fn_random_str(v_length number) return varchar2 is
    my_str varchar2(4000);
    begin
    for i in 1..v_length loop
        my_str := my_str || dbms_random.string(
            case when dbms_random.value(0, 1) < 0.5 then 'l' else 'x' end, 1);
    end loop;
    return my_str;
    END;

    function fn_formatnumber (p_number IN NUMBER) return varchar2 is
    my_str varchar2(4000);
    begin
           if p_number=floor(p_number) then
             my_str := ltrim(to_char(p_number,'999,999,999,999,999,999,999,999,990'));
           else
             my_str := ltrim(rtrim(to_char(p_number,'999,999,999,999,999,999,999,999,990.9999999999999999'),'0'));
           end if;
    return my_str;
    Exception
    When others then
      return to_char(p_number);
    END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('CSPKS_SYSTEM',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
