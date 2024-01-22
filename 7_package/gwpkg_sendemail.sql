SET DEFINE OFF;
CREATE OR REPLACE PACKAGE gwpkg_sendemail
IS
  procedure prc_sendHTMLemail (
          p_seq in varchar2,
          p_receivername in varchar2,
          p_receivermail in varchar2,
          p_subject in varchar2,
          p_datasource in clob,
          p_return_code in out varchar2,
          p_return_msg in out varchar2,
          p_err_code in out varchar2
  );
  procedure prc_resendHTMLemail (
        p_seq in varchar2,
        p_receivername in out varchar2,
        p_receivermail in out varchar2,
        p_subject in out varchar2,
        p_datasource in clob,
        p_return_code in out varchar2,
        p_return_msg in out varchar2,
        p_err_code in out varchar2
);
 procedure prc_FillValueFromSQL(p_refcursor IN pkg_report.ref_cursor,p_datasource IN OUT VARCHAR2);

  procedure prc_sendExEmail(
        p_emailcode in varchar2,
        p_refcursor in pkg_report.ref_cursor,
        p_receivername in varchar2,
        p_receivermail in varchar2,
        p_err_code  in out varchar2,
        p_err_param in out varchar2);
  procedure process_auto_send_email;

  procedure prc_sendEmailByID(p_autoid number);

  procedure prc_SendExEmailWithAttach(
        p_rptlogid in varchar2,
        p_file_path in varchar2,
        p_err_code  in out varchar2,
        p_err_param in out varchar2
  );
  procedure prc_sendHTMLemail1 (
        p_seq in varchar2,
        p_receivername in varchar2,
        p_receivermail in varchar2,
        p_subject in varchar2,
        p_datasource in clob,
        p_file_path in varchar2,
        p_return_code in out varchar2,
        p_return_msg in out varchar2,
        p_err_code in out varchar2
);
END;                                                           -- Package spec
/


CREATE OR REPLACE PACKAGE BODY gwpkg_sendemail is
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

procedure prc_sendHTMLemail (
        p_seq in varchar2,
        p_receivername in varchar2,
        p_receivermail in varchar2,
        p_subject in varchar2,
        p_datasource in clob,
        p_return_code in out varchar2,
        p_return_msg in out varchar2,
        p_err_code in out varchar2
)is
    v_sql           varchar2(4000);

    v_return_code   varchar2(100);
    v_return_msg    varchar2(500);
    v_err_code      varchar2(100);

    v_strHeader     varchar2(4000);
    v_strFooter    varchar2(4000);
    v_strBody       clob;
    v_istest        varchar2(100);
    v_emailtest        varchar2(100);

begin
    p_return_code   := systemnums.C_SUCCESS;
    p_err_code      := systemnums.C_SUCCESS;
    p_return_msg    := 'SUCCESS';
    plog.setbeginsection (pkgctx, 'prc_sendHTMLemail');

    SELECT varvalue INTO v_strHeader FROM sysvar WHERE varname ='HEADER';
    SELECT varvalue INTO v_strFooter FROM sysvar WHERE varname ='FOOTER';
    Begin
        Select varvalue into v_istest from sysvar where varname='ISTEST';
        Select lower(varvalue) into v_emailtest from sysvar where varname='EMAILTEST';
    exception
    when others
       then
            v_istest := 'Y';
            v_emailtest:= 'acb';
    End;

    -- Noi dung Email
    v_strBody := v_strHeader || chr(10);
    v_strBody := v_strBody || p_datasource || chr(10);
    v_strBody := v_strBody || v_strFooter;


    ---Chuyen sang dynamic sql
    ---Chuyen sang dynamic sql
    If v_istest ='Y' then
        if INSTR(v_emailtest, lower(p_receivermail)) > 0 then
            v_sql :='BEGIN SP_NVSCHEDULEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER,:v_SUBJECT, :v_JONMUN, :V_FILE_PATH1, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
            EXECUTE IMMEDIATE v_sql  USING p_seq, nvl(trim(p_receivername),'N/A'), p_receivermail, p_subject, v_strBody, '', out v_return_code, out v_return_msg, out v_err_code;
        else
            p_return_msg := 'Dang moi truong test, chi gui mail trong DS:' || v_emailtest;
            Return;
        End if;
    Else
        insert into EMAILOG_OUT(seq , receivername ,  receivermail ,    subject ,  strBody) values(p_seq, p_receivername, p_receivermail, p_subject, v_strBody);


         v_sql :='BEGIN SP_NVSCHEDULEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER,:v_SUBJECT, :v_JONMUN, :V_FILE_PATH1, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
        EXECUTE IMMEDIATE v_sql  USING p_seq, nvl(trim(p_receivername),'N/A'), p_receivermail, p_subject, v_strBody, '', out v_return_code, out v_return_msg, out v_err_code;

        update EMAILOG_OUT set return_code=v_return_code, return_msg= v_return_msg, err_code= v_err_code where seq=p_seq;

    End If;

    p_return_code   := v_return_code;
    p_err_code      := v_err_code;
    p_return_msg    := v_return_msg;

    plog.setendsection (pkgctx, 'prc_sendHTMLemail');
exception
when others
   then
      p_return_code := errnums.c_system_error;
      p_err_code    := errnums.c_system_error;
      p_return_msg  := 'error';
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_sendHTMLemail');
      raise errnums.e_system_error;
end;
procedure prc_resendHTMLemail (
        p_seq in varchar2,
        p_receivername in out varchar2,
        p_receivermail in out varchar2,
        p_subject in out varchar2,
        p_datasource in clob,
        p_return_code in out varchar2,
        p_return_msg in out varchar2,
        p_err_code in out varchar2
)is
    v_sql           varchar2(4000);

    v_return_code   varchar2(100);
    v_return_msg    varchar2(500);
    v_err_code      varchar2(100);

    v_strHeader     varchar2(4000);
    v_strFooter    varchar2(4000);
    v_strBody       clob;
    v_istest        varchar2(100);
    v_emailtest        varchar2(100);
begin
    p_return_code   := systemnums.C_SUCCESS;
    p_err_code      := systemnums.C_SUCCESS;
    p_return_msg    := 'SUCCESS';
    plog.setbeginsection (pkgctx, 'prc_sendHTMLemail');
    select  receivername ,  receivermail ,    subject ,  strBody
    into  p_receivername, p_receivermail, p_subject, v_strBody
    from EMAILOG_OUT
    where seq= p_seq;


       v_sql :='BEGIN SP_NVSCHEDULEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER,:v_SUBJECT, :v_JONMUN, :V_FILE_PATH1, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
        EXECUTE IMMEDIATE v_sql  USING p_seq, nvl(trim(p_receivername),'N/A'), p_receivermail, p_subject, v_strBody, '', out v_return_code, out v_return_msg, out v_err_code;

        insert into EMAILOG_OUT(seq , receivername ,  receivermail ,    subject ,  strBody) values(p_seq, nvl(trim(p_receivername),'N/A'), p_receivermail, p_subject, v_strBody);
       update EMAILOG_OUT set return_code=v_return_code, return_msg= v_return_msg, err_code= v_err_code where seq=p_seq;


    p_return_code   := v_return_code;
    p_err_code      := v_err_code;
    p_return_msg    := v_return_msg;

    plog.setendsection (pkgctx, 'prc_sendHTMLemail');
exception
when others
   then
      p_return_code := errnums.c_system_error;
      p_err_code    := errnums.c_system_error;
      p_return_msg  := 'error';
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_sendHTMLemail');
      raise errnums.e_system_error;
end;


procedure prc_SendExEmailWithAttach(
    p_rptlogid in varchar2,
    p_file_path in varchar2,
    p_err_code  in out varchar2,
    p_err_param in out varchar2
)

is
    l_count number;
    l_mailto varchar2(200);
    l_emailtempid varchar2(100);
    l_seq varchar2(50);
    l_datasource varchar2(32000);
    l_subject varchar2(500);
  l_rptparam varchar2(500);
  l_refcursor PKG_REPORT.REF_CURSOR;
  l_createdt varchar2(50);
begin
    plog.setBeginSection(pkgctx, 'prc_SendExEmailWithAttach');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    select count(*) into l_count from rptlogs where autoid = p_rptlogid;
    if l_count >0 then
        begin
            select mailto,emailtempid,rptparam into l_mailto, l_emailtempid, l_rptparam from rptlogs where autoid = p_rptlogid;
            SELECT  to_char(emailcontent),subject into l_datasource, l_subject  FROM templates WHERE code = l_emailtempid;
        exception when others then
            l_mailto :='';
            l_emailtempid :='';
            l_datasource :='';
            l_subject :='';
      l_rptparam :='';
        end;

        l_seq := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');

    select REPLACE (substr(l_rptparam,instr(l_rptparam,'=>','3',5)+2,8),'''','') INTO l_createdt from dual;
        if INSTR(l_createdt, '/') = 0 then
      l_createdt := substr(l_createdt,1,2) || '/' || substr(l_createdt,3,4) ;
    else
      l_createdt := l_createdt ;
    end if;
        if l_mailto is not null and length(l_mailto)>0  and length(p_file_path)>0 then
            --insert emailog
       for rec in(
           select regexp_substr(l_mailto, '[^#,]+', 1, level) dtl from dual
           connect by regexp_substr(l_mailto, '[^#,]+', 1, level) is not null)
       loop
           open l_refcursor for
              select l_createdt p_createddate from dual;
              gwpkg_sendemail.prc_FillValueFromSQL(l_refcursor,l_datasource);

              INSERT INTO emaillog (autoid,templateid,email,fullname,emailcontent,createtime,reqid,subject,status,export_path,refrptlogs)
              VALUES(seq_emaillog.NEXTVAL,l_emailtempid,rec.dtl,rec.dtl,l_datasource,SYSTIMESTAMP,l_seq,l_subject,'N',replace(p_file_path,'$#',''),p_rptlogid);
       end loop;
        end if;
    end if;

    plog.setEndSection(pkgctx, 'prc_SendExEmailWithAttach');
exception
    when others then
    p_err_code := errnums.C_SYSTEM_ERROR;
    plog.error(pkgctx,
                 'Err: ' || sqlerrm || ' Trace: ' ||
                 dbms_utility.format_error_backtrace);
    plog.setEndSection(pkgctx, 'prc_SendExEmailWithAttach');
end;

procedure prc_sendEmailByID(p_autoid number)
is
    l_count number;
    l_datasource clob;
    l_subject varchar2(500);
    l_seq varchar2(100);
    l_return_code varchar2(1000);
    l_return_msg varchar2(1000);
    l_return_err_code varchar2(4000);
    l_send_status varchar2(10);
    v_emailmode varchar2(10);
    v_istest varchar2(10);
    v_emailtest varchar2(1000);
    l_receivername varchar2(500);
    l_receivermail varchar2(500);
    l_file_path varchar2(500);
begin
    plog.setBeginSection(pkgctx, 'prc_sendEmailByID');
    --p_err_code  := systemnums.C_SUCCESS;
    --p_err_param := 'SUCCESS';

    begin
        SELECT varvalue INTO v_emailmode FROM sysvar WHERE varname ='EMAILMODE';
        Select varvalue into v_istest from sysvar where varname='ISTEST';
   --     Select lower(varvalue) into v_emailtest from sysvar where varname='EMAILTEST';
        SELECT e.refid,NVL(e.fullname,''),NVL(e.email,''),NVL(e.subject,''),NVL(e.emailcontent,''), SUBSTR(r.refrptfile, INSTR(r.refrptfile,'\',-1) +1)
            into l_seq,l_receivername,l_receivermail,l_subject,l_datasource,l_file_path
            FROM emaillog e, rptlogs r
            WHERE E.refrptlogs = r.AUTOID(+)
            AND e.autoid = p_autoid;
    exception
        when others then
        v_istest := 'Y';
        v_emailtest:= 'xxx';
        v_emailmode :='N';
        l_seq :='';
        l_receivername :='';
        l_receivermail :='';
        l_subject:='';
        l_datasource :='';
        l_file_path:='';
    end;

    if v_emailmode ='Y' then
        if LENGTH(l_receivermail) >0 and LENGTH(l_datasource) >0 then
                  prc_sendHTMLemail1(l_seq,l_receivername,l_receivermail,l_subject,l_datasource,l_file_path,l_return_code,l_return_msg,l_return_err_code);
                    if l_return_code = 'S' then
                        --Gui thanh cong
                        l_send_status :='S'; --sending
                    elsif l_return_code = 'A' then
                       l_send_status :='A'; --cho gui
                    else
                        l_send_status :='R'; --error
                    end if;
        else
            l_send_status :='R';
            l_return_msg := 'Reject by email or datasouce invalid';
            l_return_err_code := errnums.C_SYSTEM_ERROR;
        end if;
    else
        l_send_status :='R';
        l_return_msg := 'Reject by emailmode = N';
        l_return_err_code := errnums.C_SYSTEM_ERROR;
    end if;
    --Cap nhat emailog
    update emaillog set status = l_send_status,err_code = l_return_err_code,err_msg = l_return_msg, senttime= SYSTIMESTAMP
        where autoid = p_autoid;
    plog.setEndSection(pkgctx, 'prc_sendEmailByID');
exception
    when others then
      --p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,
                 'Err: ' || sqlerrm || ' Trace: ' ||
                 dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'prc_sendEmailByID');
end prc_sendEmailByID;

procedure process_auto_send_email
as
    l_count number;
    p_err_code varchar2(100);
    p_err_param varchar2(1000);
    l_datasource varchar2(2000);
begin
    plog.setBeginSection(pkgctx, 'process_auto_send_email');
    FOR REC IN (
        SELECT * FROM EMAILLOG E WHERE STATUS ='N'
        AND NOT EXISTS (SELECT * FROM  RPTLOGS WHERE  AUTOID = E.REFRPTLOGS AND STATUS <> 'A')
        AND ROWNUM < 51
        ORDER BY AUTOID
    )
    loop
        begin
            /*IF REC.REFRPTLOGS IS NOT NULL THEN
                DBMS_LOCK.SLEEP(1); --sleep 5s de server day file
            END IF;*/
            gwpkg_sendemail.prc_sendEmailByID(rec.autoid);
            update emaillog set processtatus ='A' where autoid = rec.autoid;
            --send mail pass zip

            IF INSTR(LOWER(REC.email),'@goldwing.shinhan.com') = 0 THEN
                FOR REC2 IN (
                    SELECT * FROM RPTLOGS WHERE AUTOID = REC.REFRPTLOGS AND STATUS = 'A' AND ISZIP = 'Y' AND ROWNUM = 1
                )
                LOOP
                    l_datasource := 'select ''' || REC2.passzip || ''' p_password, ''' || REC.subject || ''' p_subject from dual';
                    nmpks_ems.InsertEmailLog(REC.email, '997E', l_datasource, '');
                END LOOP;
            END IF;
        exception
            WHEN OTHERS THEN
            update emaillog set processtatus ='A',err_code = errnums.C_SYSTEM_ERROR,
                err_msg = substr(dbms_utility.format_error_backtrace,1000)
                where autoid = rec.autoid;
        end;
    end loop;
    plog.setEndSection(pkgctx, 'process_auto_send_email');
exception
    WHEN OTHERS THEN
    plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'process_auto_send_email');

end process_auto_send_email;
procedure prc_sendExEmail(
        p_emailcode in varchar2,
        p_refcursor in pkg_report.ref_cursor,
        p_receivername in varchar2,
        p_receivermail in varchar2,
        p_err_code  in out varchar2,
        p_err_param in out varchar2)
is
    l_count number;
    l_datasource varchar2(32000);
    l_subject varchar2(500);
    l_seq varchar2(100);
    l_return_code varchar2(1000);
    l_return_msg varchar2(1000);
    l_return_err_code varchar2(4000);
    l_send_status varchar2(10);
    v_emailmode varchar2(10);
begin
    plog.setBeginSection(pkgctx, 'prc_sendExEmail');
    p_err_code  := systemnums.C_SUCCESS;
    p_err_param := 'SUCCESS';
    select count(*) into l_count from templates where code = p_emailcode;
    if l_count >0 then
        SELECT  to_char(emailcontent),subject into l_datasource, l_subject  FROM templates WHERE code = p_emailcode;
        --gen datasouce
        gwpkg_sendemail.prc_FillValueFromSQL(p_refcursor,l_datasource);
        --Gui mail
        l_seq := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
        --insert emailog
        INSERT INTO emaillog (autoid,templateid,email,fullname,emailcontent,createtime,reqid,subject,status)
        VALUES(seq_emaillog.NEXTVAL,p_emailcode,p_receivermail,p_receivername,l_datasource,SYSTIMESTAMP,l_seq,l_subject,'N');
    end if;

    plog.setEndSection(pkgctx, 'prc_sendExEmail');
exception
    when others then
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error(pkgctx,
                 'Err: ' || sqlerrm || ' Trace: ' ||
                 dbms_utility.format_error_backtrace);
      plog.setEndSection(pkgctx, 'prc_sendExEmail');
end prc_sendExEmail;

procedure prc_FillValueFromSQL(p_refcursor IN pkg_report.ref_cursor,p_datasource IN OUT VARCHAR2)
IS
    l_return varchar2(1000);
    l_count NUMBER;
    l_refcursor pkg_report.ref_cursor;
    v_desc_tab dbms_sql.desc_tab;
    v_cursor_number NUMBER;
    v_columns NUMBER;
    v_number_value NUMBER;
    v_varchar_value VARCHAR(200);
    v_date_value DATE;
    l_fldname varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'prc_FillValueFromSQL');

    l_return :='';
    l_refcursor := p_refcursor;
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
                dbms_sql.define_column(v_cursor_number, i, v_varchar_value,200);
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
              --dbms_output.put_line('fldname:' || l_fldname || ', fldvalue:' || l_return);
              p_datasource := replace(p_datasource, '[' || LOWER(l_fldname) || ']', l_return);
        END LOOP;
    END LOOP;
    plog.setendsection (pkgctx, 'prc_FillValueFromSQL');

EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_FillValueFromSQL');
      raise errnums.e_system_error;
END;

procedure prc_sendHTMLemail1 (
        p_seq in varchar2,
        p_receivername in varchar2,
        p_receivermail in varchar2,
        p_subject in varchar2,
        p_datasource in clob,
        p_file_path in varchar2,
        p_return_code in out varchar2,
        p_return_msg in out varchar2,
        p_err_code in out varchar2

)is
    v_sql           varchar2(4000);

    v_return_code   varchar2(100);
    v_return_msg    varchar2(500);
    v_err_code      varchar2(100);

    v_strHeader     varchar2(4000);
    v_strFooter    varchar2(4000);
    v_strBody       clob;
    v_istest varchar2(1);

begin
    p_return_code   := systemnums.C_SUCCESS;
    p_err_code      := systemnums.C_SUCCESS;
    p_return_msg    := 'SUCCESS';
    plog.setbeginsection (pkgctx, 'prc_sendHTMLemail1');

    SELECT varvalue INTO v_strHeader FROM sysvar WHERE varname ='HEADER';
    SELECT varvalue INTO v_strFooter FROM sysvar WHERE varname ='FOOTER';

Begin
        Select varvalue into v_istest from sysvar where varname='ISTEST';

    exception
    when others
       then
            v_istest := 'Y';

    End;

    -- Noi dung Email
    v_strBody := v_strHeader || chr(10);
    v_strBody := v_strBody || p_datasource || chr(10);
    v_strBody := v_strBody || v_strFooter;

   if v_istest = 'Y' OR INSTR(LOWER(p_receivermail),'@goldwing.shinhan.com') > 0 then

      -- neu la test thi update status de email runtime boc di
      --update emaillog set status = 'A' where refid = p_seq;
       p_return_code   := 'A';

   else

    ---Chuyen sang dynamic sql
    v_sql :='BEGIN SP_NVSCHEDULEACCEPT_API_GEN@REPAY_MAIL(:v_SEQ, :v_RECEIVER_NM, :v_RECEIVER,:v_SUBJECT, :v_JONMUN, :V_FILE_PATH1, :v_RTN_CD, :v_RTN_MSG, :v_ER_CD); END;';
    EXECUTE IMMEDIATE v_sql  USING p_seq, nvl(trim(p_receivername),'N/A'), p_receivermail, p_subject, v_strBody,p_file_path, out v_return_code, out v_return_msg, out v_err_code;

    p_return_code   := v_return_code;
    p_err_code      := v_err_code;
    p_return_msg    := v_return_msg;
   end if ;
    plog.setendsection (pkgctx, 'prc_sendHTMLemail1');
exception
when others
   then
      p_return_code := errnums.c_system_error;
      p_err_code    := errnums.c_system_error;
      p_return_msg  := 'error';
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_sendHTMLemail1');
      raise errnums.e_system_error;
end;

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('gwpkg_sendemail',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

end gwpkg_sendemail;
/
