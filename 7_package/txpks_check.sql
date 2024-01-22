SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_check
IS


END;
/


CREATE OR REPLACE PACKAGE BODY txpks_check
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

BEGIN
   FOR i IN (SELECT *
               FROM tlogdebug)
   LOOP
      logrow.loglevel := i.loglevel;
      logrow.log4table := i.log4table;
      logrow.log4alert := i.log4alert;
      logrow.log4trace := i.log4trace;
   END LOOP;

   pkgctx :=
      plog.init ('TXPKS_CHECK',
                 plevel         => NVL (logrow.loglevel, 30),
                 plogtable      => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert         => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace         => (NVL (logrow.log4trace, 'N') = 'Y')
                );
END txpks_check;
/
