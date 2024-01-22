SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_saproc
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
     **  FSS      20-mar-2010    Created
     ** (c) 2008 by Financial Software Solutions. JSC.
     ----------------------------------------------------------------------------------------------------*/
    PROCEDURE pr_GenDeletedTable(ATTR_TABLE in varchar2, STRCLAUSE in varchar2, p_err_param in out varchar2);
    procedure prc_FillValueFromSQL(p_strSQL IN VARCHAR2,p_datasource IN OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_saproc
IS
   -- declare log context
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;


PROCEDURE pr_GenDeletedTable(ATTR_TABLE in varchar2, STRCLAUSE in varchar2, p_err_param in out varchar2)
IS

v_count number;
l_sql_query varchar2(200);
BEGIN
    p_err_param := '0';

    SELECT count(1)
    into v_count
    FROM user_tables
    where table_name = ATTR_TABLE||'_DELTD';

    begin
        if(v_count = 0)  then

            l_sql_query:=' CREATE TABLE ' || ATTR_TABLE  || '_DELTD AS SELECT * FROM ' || ATTR_TABLE || ' WHERE 0=1 ';

            
            execute immediate l_sql_query;
            commit;
        end if;

         l_sql_query:=' INSERT INTO  ' || ATTR_TABLE  || '_DELTD  SELECT * FROM ' || ATTR_TABLE || ' WHERE 0=0 AND ' || STRCLAUSE;
         
         execute immediate l_sql_query;
         COMMIT;


    exception when others then
            plog.error (pkgctx, SQLERRM);
    end;


    plog.debug (pkgctx, '<<END OF pr_GenDeletedTable');
    plog.setendsection (pkgctx, 'pr_GenDeletedTable');
EXCEPTION
WHEN OTHERS
   THEN
      p_err_param := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'pr_GenDeletedTable');
      RAISE errnums.E_SYSTEM_ERROR;
END pr_GenDeletedTable;

procedure prc_FillValueFromSQL(p_strSQL IN VARCHAR2,p_datasource IN OUT VARCHAR2)
IS
l_return varchar2(4000);
l_count NUMBER;
l_refcursor pkg_report.ref_cursor;
v_desc_tab dbms_sql.desc_tab;
v_cursor_number NUMBER;
v_columns NUMBER;
v_number_value NUMBER;
v_varchar_value VARCHAR(4000);
v_date_value DATE;
l_fldname varchar2(100);
BEGIN
    /*
    12/02/2020, TruongLD add
    Dua vao SQL User truyen vao va datasource cua email, tu dong dien gia tri vao.
    Ghi chu: Cac cot trong datasource phai co trong SQL.
    VD: Cacn goi va khai bao
    declare
        v_SQL VARCHAR2(4000);
        v_datasource VARCHAR2(4000);
    Begin
        v_SQL := 'Select fullname, custodycd, custodycd || ''.'' || fullname fullname2 from cfmast where custodycd=''SHVB000307''';
        v_datasource := '<p>Kinh gui [fullname]!</p>
                   </br>
                   <p>Shinhan bank thong bao TK [custodycd] cua khach hang [fullname2]</p>';
        cspks_saproc.prc_getvalFromSQL(v_SQL, v_datasource);
        dbms_output.put_line('v_datasource:' || v_datasource);
    End;
    */
    plog.setbeginsection (pkgctx, 'prc_FillValueFromSQL');

    l_return :='';
    OPEN l_refcursor FOR p_strSQL;
    v_cursor_number := dbms_sql.to_cursor_number(l_refcursor);
    dbms_sql.describe_columns(v_cursor_number, v_columns, v_desc_tab);
    --define colums
    FOR i IN 1 .. v_desc_tab.COUNT LOOP
            IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
            --Number
                dbms_sql.define_column(v_cursor_number, i, v_number_value);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char THEN
            --Varchar, char
                dbms_sql.define_column(v_cursor_number, i, v_varchar_value,4000);
            ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
            --Date,
               dbms_sql.define_column(v_cursor_number, i, v_date_value);
            END IF;
    END LOOP;

    WHILE dbms_sql.fetch_rows(v_cursor_number) > 0 LOOP
        FOR i IN 1 .. v_desc_tab.COUNT LOOP
              l_fldname :=  v_desc_tab(i).col_name;
              IF v_desc_tab(i).col_type = dbms_types.typecode_number THEN
                   dbms_sql.column_value(v_cursor_number, i, v_number_value);
                   l_return := to_char(v_number_value);
              ELSIF  v_desc_tab(i).col_type = dbms_types.typecode_varchar
                OR  v_desc_tab(i).col_type = dbms_types.typecode_char
                THEN
                   dbms_sql.column_value(v_cursor_number, i, v_varchar_value);
                   l_return := v_varchar_value;
              ELSIF v_desc_tab(i).col_type = dbms_types.typecode_date THEN
                   dbms_sql.column_value(v_cursor_number, i, v_date_value);
                   l_return:=to_char(v_date_value,'DD/MM/RRRR');
              END IF;
              
              
              p_datasource := replace(p_datasource, '[' || LOWER(l_fldname) || ']', l_return);
        END LOOP;
    END LOOP;
    plog.setendsection (pkgctx, 'prc_FillValueFromSQL');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_FillValueFromSQL');
      raise errnums.e_system_error;
END;

-- initial LOG
BEGIN
   SELECT *
   INTO logrow
   FROM tlogdebug
   WHERE ROWNUM <= 1;

   pkgctx    :=
      plog.init ('cspks_saproc',
                 plevel => logrow.loglevel,
                 plogtable => (logrow.log4table = 'Y'),
                 palert => (logrow.log4alert = 'Y'),
                 ptrace => (logrow.log4trace = 'Y')
      );
END;
/
