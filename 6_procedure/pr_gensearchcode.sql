SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_gensearchcode (p_tablename varchar2)
         IS

       cursor v_cursor is
      SELECT column_id,column_name,data_type,data_length,avg_col_len
          FROM user_tab_cols
          WHERE table_name = p_tablename;
    v_row v_cursor%rowtype;
   BEGIN


      INSERT INTO search (SEARCHCODE,SEARCHTITLE,EN_SEARCHTITLE,SEARCHCMDSQL,OBJNAME,FRMNAME,ORDERBYCMDSQL,TLTXCD,CNTRECORD,ROWPERPAGE,AUTOSEARCH,INTERVAL,AUTHCODE,ROWLIMIT,CMDTYPE,CONDDEFFLD,BANKINQ,BANKACCT)
      VALUES(upper(p_tablename),'Inquiry for table '||p_tablename,'Inquiry for table '||p_tablename,'select * from '||p_tablename||' where 0=0 ',p_tablename,NULL,NULL,NULL,NULL,50,'N',1,'NNNNYYYNNN','Y','T',NULL,'N',NULL);

       open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

      INSERT INTO searchfld (POSITION,FIELDCODE,FIELDNAME,FIELDTYPE,SEARCHCODE,FIELDSIZE,MASK,OPERATOR,FORMAT,DISPLAY,SRCH,KEY,WIDTH,LOOKUPCMDSQL,EN_FIELDNAME,REFVALUE,FLDCD,DEFVALUE,MULTILANG,ACDTYPE,ACDNAME,FIELDCMP,FIELDCMPKEY,ISPROCESS,QUICKSRCH,SUMMARYCD)
      VALUES(v_row.column_id,v_row.column_name,v_row.column_name,case when instr(v_row.data_type,'TIMESTAMP')>0 then 'D'
                               when instr(v_row.data_type,'NUMBER')>0 then 'N'
                               else 'C' end,upper(p_tablename),v_row.data_length,NULL,
            case when instr(v_row.data_type,'DATE')>0 then '<,<=,=,>=,>,<>'
                               when instr(v_row.data_type,'NUMBER')>0 then '<,<=,=,>=,>,<>'
                               else 'LIKE,=' end,case when instr(v_row.data_type,'TIMESTAMP')>0 then 'dd/MM/yyyy'
                                                      when instr(v_row.data_type,'NUMBER')>0 then '#,##0.####' else null end,'Y','Y','Y',length(v_row.column_name)*15,NULL,v_row.column_name,'N','',NULL,'N',NULL,NULL,NULL,'N','Y',NULL,NULL);
    end loop;
   end ;
/
