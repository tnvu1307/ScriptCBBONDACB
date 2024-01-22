SET DEFINE OFF;
CREATE OR REPLACE PACKAGE nmpks_ems is

  function CheckEmail(p_email varchar2) return boolean;
  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2);
  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2;

  PROCEDURE pr_sendInternalEmail (p_datasource IN VARCHAR2,
                                 p_template_id IN VARCHAR2,
                                 p_afacctno    IN VARCHAR2 DEFAULT '',
                                 p_sendTemplateLnk IN VARCHAR2 DEFAULT 'N');

  procedure prc_EmailReq2API(
      p_account IN VARCHAR2,
      p_email IN VARCHAR2,
      p_subject IN VARCHAR2,
      p_datasource IN VARCHAR2,
      p_EmailContent IN clob,
      p_return_code in out VARCHAR2,
      P_return_msg in out VARCHAR2
  );
  procedure prc_EmailReq2API_NEW(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
    p_template_id IN varchar2,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2
);
    PROCEDURE CREATE_RPT_REQUEST(p_report_id IN VARCHAR2, p_datasource IN VARCHAR2, p_template_id IN VARCHAR2, p_account IN VARCHAR2, p_refrptlogs IN OUT VARCHAR2, p_datasource_ref IN OUT VARCHAR2);
end NMPKS_EMS;
/


CREATE OR REPLACE PACKAGE BODY nmpks_ems is
  pkgctx plog.log_ctx;
  logrow tlogdebug%rowtype;

  function CheckEmail(p_email varchar2) return boolean as

    l_is_email_valid boolean;
  begin

    plog.setBeginSection(pkgctx, 'CheckEmail');

    if owa_pattern.match(p_email,
                         '^\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}' ||
                         '@\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}[.,0-9,a-z,A-Z,_]\w{1,}$') then
      l_is_email_valid := true;
    else
      l_is_email_valid := false;
    end if;

    /*IF( ( REPLACE( p_email, ' ','') IS NOT NULL ) AND
         ( NOT owa_pattern.match(
                   p_email, '^[a-z]+[\.\_\-[a-z0-9]+]*[a-z0-9]@[a-z0-9]+\-?[a-z0-9]{1,63}\.?[a-z0-9]{0,6}\.?[a-z0-9]{0,6}\.[a-z]{0,6}$') ) ) THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;*/

    plog.setEndSection(pkgctx, 'CheckEmail');

    return l_is_email_valid;

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'CheckEmail');
  end;

  procedure InsertEmailLog(p_email       varchar2,
                           p_template_id varchar2,
                           p_data_source varchar2,
                           p_account     varchar2) is

    l_status             char(1) := 'A';
    l_reject_status      char(1) := 'R';
    l_receiver_address   varchar2(3000);
    l_template_id        emaillog.templateid%type;
    l_datasource         emaillog.datasource%type;
    l_account            emaillog.afacctno%type;
    l_message_type       templates.type%type;
    l_is_required        templates.require_register%type;
    l_can_create_message boolean := true;
    l_typesms             emaillog.typesms%type;
    l_is_active          templates.isactive%type;
    l_isinternal      templates.isinternal%type;
    l_multilang         templates.multilang%type;
    l_LANGUAGE_TYPE     varchar2(5);


    l_EmailContent      CLOB;
    v_subject       VARCHAR2(1000);
    v_sendstatus    VARCHAR2(10);
    v_fromemail     VARCHAR2(100);
    v_return_code   VARCHAR2(100);
    v_return_msg    VARCHAR2(1000);
    v_err_code      VARCHAR2(100);
    v_SEQ           VARCHAR2(1000);
    v_fullname      VARCHAR2(1000);
    v_emailmode     VARCHAR2(10);
    v_isincode      VARCHAR2(100);
    v_catype        VARCHAR2(400);
  begin

    plog.setBeginSection(pkgctx, 'InsertEmailLog');

    

    plog.info(pkgctx, 'DATA [' || p_data_source || ']');
    l_receiver_address := p_email;
    l_template_id      := p_template_id;
    l_account          := p_account;

    --start SHBVNEX-2496
    IF P_TEMPLATE_ID IN ('201E', '207E', '208E') THEN
        BEGIN
            SELECT LISTAGG(T.EMAIL, ',') WITHIN GROUP (ORDER BY T.EMAIL) EMAIL INTO L_RECEIVER_ADDRESS
            FROM
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(EMAILCS,'[^,]+',1,LEVEL)) EMAIL
                FROM
                (
                    SELECT * FROM TEMPLATES WHERE CODE = P_TEMPLATE_ID
                )
                CONNECT BY INSTR(EMAILCS ,',',1,LEVEL -1) > 0
            ) T,
            (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(EMAILCS,'[^,]+',1,LEVEL)) EMAIL
                FROM (
                    SELECT P_EMAIL EMAILCS FROM DUAL
                )
                CONNECT BY INSTR(EMAILCS ,',',1,LEVEL -1) > 0
            ) E
            WHERE T.EMAIL = E.EMAIL;
        EXCEPTION WHEN OTHERS THEN
            L_RECEIVER_ADDRESS := 'ZZZ';
        END;

        IF NVL(L_RECEIVER_ADDRESS,'ZZZ') = 'ZZZ' THEN
            RETURN;
        END IF;
    END IF;
    --end SHBVNEX-2496

    if l_message_type = 'S' AND p_template_id<>'0321'  then
        l_datasource := fn_convert_to_vn(p_data_source);
    else
        l_datasource := p_data_source;
    end if;

    Begin
        select t.type, t.require_register, t.isactive, t.multilang, t.isinternal, t.emailcontent, en_subject
            into l_message_type, l_is_required, l_is_active, l_multilang, l_isinternal, l_EmailContent, v_subject
        from templates t
        where code = l_template_id;
    EXCEPTION
        WHEN OTHERS
           THEN
            l_message_type := 'E';
            l_is_required :='N';
            l_is_active := 'N';
            l_multilang :='Y';
            l_isinternal := 'Y';
            l_EmailContent := '';
    End;
    -- Thoai.tran 29/06/2022
    -- SHBVNEX-2672
    IF l_template_id IN ('210E', '211E', '212E', '213E', '214E', '215E', '216E', '217E', '218E', '264E', '250E','251E',
        '252E','253E','254E','255E','256E','257E', '258E', '265E', '230E', '234E', '235E', '238E','220E','221E','222E','223E','224E','225E','226E','227E','266E',
        '240E','241E','242E','243E','244E','245E','246E','267E','119E','129E','260E','261E','262E','263E','130E') THEN
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'p_isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'p_event_type,')-3) EVENTTYPE
        from dual);
    elsif l_template_id in ('EM31', 'E281','E282', 'EM30') then
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'catype,')-3) EVENTTYPE
        from dual);
    elsif l_template_id in ('EM24', 'EM25','EM26','EM27') then
        select v_subject||' - '||substr(ISINCODE,instr(ISINCODE,',',-1)+3,20)||' - '|| substr(EVENTTYPE,instr(EVENTTYPE,',',-1)+3,50)  INTO v_subject
        from (
         select substr(l_datasource, 0, instr(l_datasource,'isincode,')-3) ISINCODE,
         substr(l_datasource, 0, instr(l_datasource,'cacontent,')-3) EVENTTYPE
        from dual);
    END IF;
    
    --12/02/2020, TruongLD add, xu ly khi tich hop voi he thong email cua SHB
    If l_isinternal ='N' then
        prc_EmailReq2API_NEW(
                          l_account,
                          l_receiver_address,
                          v_subject,
                          l_datasource,
                          l_EmailContent,
                          p_template_id,
                          v_return_code,
                          v_return_msg

                      );
        return;
    End If;
    --End TruongLD


    l_can_create_message:=true;
    if l_can_create_message then
      if l_receiver_address is not null and length(l_receiver_address) > 0 then
      
        insert into emaillog
          (autoid,
           email,
           templateid,
           datasource,
           status,
           createtime,
           afacctno,typesms, txdate,language_type)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_status,
           sysdate,
           l_account,l_typesms, getcurrdate,l_language_type);
      else
        insert into emaillog
          (autoid, email, templateid, datasource, status, createtime, note,afacctno,typesms, txdate,language_type)
        values
          (seq_emaillog.nextval,
           l_receiver_address,
           l_template_id,
           l_datasource,
           l_reject_status,
           sysdate,
           '---',l_account,l_typesms, getcurrdate,l_language_type);
      end if;
    ELSIF l_is_active = 'Y' then
      insert into emaillog
        (autoid, email, templateid, datasource, status, createtime, note,afacctno,typesms, txdate, language_type)
      values
        (seq_emaillog.nextval,
         l_receiver_address,
         l_template_id,
         l_datasource,
         l_reject_status,
         sysdate,
         'This template not registed yet',l_account,l_typesms, getcurrdate,l_language_type);
    end if;

    plog.setEndSection(pkgctx, 'InsertEmailLog');

  exception
    when others then
      plog.error(pkgctx, sqlerrm);
      plog.setEndSection(pkgctx, 'InsertEmailLog');
  end;


  function fn_convert_to_vn(strinput in nvarchar2) return nvarchar2 is
    strconvert nvarchar2(32527);
  begin
    strconvert := translate(strinput,
                            utf8nums.c_FindText,
                            utf8nums.c_ReplText);
                  ---'???????a?????d????????i??????o????????u?u???????????????????A????????????????I?????????O???????U?U?????????',
                     ----       'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYY');

    return strconvert;
  end;


  PROCEDURE pr_sendInternalEmail (p_datasource IN VARCHAR2,
                                 p_template_id IN VARCHAR2,
                                 p_afacctno    IN VARCHAR2 DEFAULT '',
                                 p_sendTemplateLnk IN VARCHAR2 DEFAULT 'N')
  IS
  l_email   VARCHAR2(2000);
  l_custodycd varchar2(100);
  BEGIN
    plog.setBeginSection(pkgctx, 'pr_sendInternalEmail');
    select substr(p_datasource, instr(p_datasource,'FEEAMT,')+8, instr(p_datasource,'EMAIL,') - instr(p_datasource,'FEEAMT,')-10)
    into l_email
    from dual;

    FOR rec IN (
            SELECT emailcs email FROM templates WHERE code = trim(p_template_id) AND emailcs IS NOT NULL
    ) LOOP
       --IF nmpks_ems.CheckEmail(rec.email) THEN
         IF l_email IS NULL  OR length(l_email) <= 0 THEN
           l_email := rec.email;
         ELSE
           l_email := l_email || ', ' || rec.email;
         END IF;
       --END IF;

    END LOOP;
    
    
    InsertEmailLog(p_email       => l_email,
                   p_template_id => p_template_id,
                   p_data_source => p_datasource,
                   p_account     => l_custodycd);
    plog.setEndSection(pkgctx, 'pr_sendInternalEmail');
  EXCEPTION
    WHEN OTHERS THEN
      plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setEndSection (pkgctx, 'pr_sendInternalEmail');
  END;


procedure prc_EmailReq2API(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2
)
IS
    l_fullname      VARCHAR2(500);
    l_email         VARCHAR2(500);
    l_datasource    VARCHAR2(3800);
    l_EmailContent  clob;
    l_emailmode     VARCHAR2(10);
    l_SEQ           VARCHAR2(1000);
    l_sendstatus    VARCHAR2(100);
    l_err_code      VARCHAR2(100);
BEGIN

    plog.setbeginsection (pkgctx, 'prc_EmailReq2API');

    l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
    l_email         := p_email;
    l_datasource    := p_datasource; /*String SQL*/
    l_EmailContent  := p_EmailContent; /*String HTML */

    -- Fill data from SQL to string HTML
    
    
    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_EmailContent);

    SELECT varvalue INTO l_emailmode FROM sysvar WHERE varname ='EMAILMODE';
    

    IF l_emailmode = 'Y' THEN
        Begin
            gwpkg_sendemail.prc_sendHTMLemail(l_SEQ,
                                             nvl(l_fullname,'N/A'),                               l_email,
                                            p_subject,
                                            l_EmailContent,
                                            p_return_code,
                                            P_return_msg,
                                            l_err_code);
        exception
        when others then
            
            
            plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
            INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
            VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'E',systimestamp, 'Error:' || p_return_msg, l_SEQ);
            plog.setEndSection(pkgctx, 'InsertEmailLog');
            return;
        End;

        IF p_return_code ='S' THEN
            --sending
            l_sendstatus :='S';
        ELSE
             --Error
            l_sendstatus :='E';
        END IF;

        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,l_sendstatus,systimestamp,p_return_code, l_SEQ);

    Else
        --Cap nhat emaillog
        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'R',systimestamp,'Emailmode:' || l_emailmode, l_SEQ);
    End If;

    plog.setendsection (pkgctx, 'prc_EmailReq2API');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_EmailReq2API');
      raise errnums.e_system_error;
END;

procedure prc_EmailReq2API_NEW(
    p_account IN VARCHAR2,
    p_email IN VARCHAR2,
    p_subject IN VARCHAR2,
    p_datasource IN VARCHAR2,
    p_EmailContent IN clob,
    p_template_id IN varchar2,
    p_return_code in out VARCHAR2,
    P_return_msg in out VARCHAR2

)
IS
    l_fullname      VARCHAR2(500);
    l_email         VARCHAR2(3000);
    l_datasource    VARCHAR2(3800);
    l_datasource_ref VARCHAR2(3800);
    l_subject    VARCHAR2(3800);
    l_EmailContent  clob;
    l_emailmode     VARCHAR2(10);
    l_SEQ           VARCHAR2(1000);
    l_sendstatus    VARCHAR2(100);
    l_err_code      VARCHAR2(100);
    l_refrptlogs    number;
BEGIN

    plog.setbeginsection (pkgctx, 'prc_EmailReq2API_NEW');

    l_email         := trim(p_email);
    l_datasource    := p_datasource; /*String SQL*/
    l_EmailContent  := p_EmailContent; /*String HTML */
    l_subject       := p_subject;

    -- Fill data from SQL to string HTML
    
    
    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_EmailContent);

    cspks_saproc.prc_FillValueFromSQL(l_datasource,l_subject);

    SELECT varvalue INTO l_emailmode FROM sysvar WHERE varname ='EMAILMODE';
    IF l_emailmode = 'Y' THEN

        l_refrptlogs := null;
        FOR RECAT IN (
            SELECT * FROM ATTACHMENTS WHERE attachment_id = p_template_id AND ROWNUM = 1
        ) LOOP
            l_datasource_ref := 'SELECT * FROM DUAL';
            CREATE_RPT_REQUEST(RECAT.REPORT_ID, l_datasource, p_template_id, p_account, l_refrptlogs, l_datasource_ref);
            BEGIN
                cspks_saproc.prc_FillValueFromSQL(l_datasource_ref,l_subject);
            EXCEPTION WHEN OTHERS THEN
                l_subject := l_subject;
            END;
        END LOOP;

        for rec in (
            select REGEXP_SUBSTR(l_email,'[^,]+',1,LEVEL) email
            from dual connect by  REGEXP_SUBSTR(l_email,'[^,]+',1,LEVEL) is not null
        )
        loop
            l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
            INSERT INTO emaillog (autoid,email,templateid,datasource,status,createtime,note, refid,emailcontent,fullname,subject,processtatus, refrptlogs)
            VALUES(seq_emaillog.NEXTVAL,trim(rec.email),p_template_id,p_datasource,'N',systimestamp,p_return_code, l_SEQ,l_EmailContent,l_fullname,l_subject,'N', l_refrptlogs);
        end loop;
    Else
        --Cap nhat emaillog
        l_SEQ           := TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF8');
        INSERT INTO emaillog (autoid,email,datasource,status,createtime,note, refid, refrptlogs)
        VALUES(seq_emaillog.NEXTVAL,l_email,l_EmailContent,'R',systimestamp,'Emailmode:' || l_emailmode, l_SEQ, l_refrptlogs);
    End If;

    plog.setendsection (pkgctx, 'prc_EmailReq2API_NEW');
EXCEPTION WHEN OTHERS THEN
      plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'prc_EmailReq2API_NEW');
      raise errnums.e_system_error;
END;

    PROCEDURE CREATE_RPT_REQUEST(p_report_id IN VARCHAR2, p_datasource IN VARCHAR2, p_template_id IN VARCHAR2, p_account IN VARCHAR2, p_refrptlogs IN OUT VARCHAR2, p_datasource_ref IN OUT VARCHAR2)
    IS
        l_rptParam  VARCHAR2(2000) := '(:l_refcursor, ''A'', ''0001''';
        l_rebuild   NUMBER;
        l_shortname VARCHAR2(500);
        l_filename  VARCHAR2(1000);
        l_createtime TIMESTAMP;
        l_passzip varchar2(100);
        l_getcurrdate date;
        l_iszip varchar2(1);
    BEGIN
        plog.setbeginsection (pkgctx, 'CREATE_RPT_REQUEST');

        l_createtime := SYSTIMESTAMP;
        l_shortname := '';
        l_passzip := '';
        l_iszip := 'N';
        l_getcurrdate := getcurrdate();

        BEGIN
            SELECT VARVALUE INTO l_iszip
            FROM SYSVAR
            WHERE GRNAME = 'SYSTEM'
            AND VARNAME = 'ISZIPFILE';
        EXCEPTION WHEN OTHERS THEN
            l_iszip := 'N';
        END;
        /*
        FOR R1 IN (
            SELECT SHORTNAME FROM FAMEMBERS WHERE AUTOID = TO_NUMBER((CASE WHEN IS_NUMBER(P_ACCOUNT) = 0 THEN '-1' ELSE P_ACCOUNT END))
        )
        LOOP
            l_shortname := R1.SHORTNAME;
            l_passzip := R1.SHORTNAME || TO_CHAR(l_getcurrdate,'RRRR') || '#Shinhan';
        END LOOP;

        FOR R2 IN (
            SELECT SHORTNAME FROM CFMAST WHERE CUSTODYCD = (CASE WHEN IS_NUMBER(P_ACCOUNT) = 0 THEN P_ACCOUNT ELSE '-1' END)
        )
        LOOP
            l_shortname := R2.SHORTNAME;
            l_passzip := P_ACCOUNT || '#' || TO_CHAR(l_getcurrdate,'RRRR');
        END LOOP;
        */
        IF p_report_id IN ('OD6008_1','OD6008_2','OD6008_3') THEN
            l_filename := 'SHBVN_Position_report_[RPTLOGID]_' || l_shortname || '_[p_txdate]';
            p_datasource_ref := 'SELECT ''[SHBVN] Position report ' || l_shortname || ' [p_txdate]'' p_subject206e FROM DUAL';

            cspks_saproc.prc_FillValueFromSQL(p_datasource, l_filename);
            cspks_saproc.prc_FillValueFromSQL(p_datasource, p_datasource_ref);
        ELSE
            l_filename := 'CB_[RPTLOGID]_' || l_shortname || '_' || TO_CHAR(l_createtime, 'DDMMRRRR');
        END IF;



        FOR RECRPT IN (
                SELECT CF.RPTID, CF.FILETYPE
                FROM RPTGENCFG CF, RPTMASTER RPT
                WHERE CF.RPTID = RPT.RPTID
                AND CF.CYCLE_CRET = 'M'
                AND RPT.RPTID = p_report_id
        ) LOOP
            l_rebuild := 0;
            FOR REC IN (
                    SELECT * FROM RPTFIELDS WHERE OBJNAME = RECRPT.RPTID ORDER BY ODRNUM
            ) LOOP
                IF REC.FLDNAME = 'P_DATASOURCE' THEN
                    l_rptParam := l_rptParam || ',''' || REPLACE(p_datasource,'''','''''') || '''';
                    EXIT;
                ELSE
                    l_rebuild := 1;
                    l_rptParam := l_rptParam || ',''[' || lower(REC.FLDNAME) || ']''';
                END IF;
            END LOOP;
            l_rptParam := l_rptParam || ')';

            IF l_rebuild = 1 THEN
                cspks_saproc.prc_FillValueFromSQL(p_datasource, l_rptParam);
            END IF;
            p_refrptlogs := seq_rptlogs.NEXTVAL;

            l_filename := REPLACE(l_filename, '[RPTLOGID]', p_refrptlogs);
            l_filename := REGEXP_REPLACE(l_filename, '[\/:*?"<>|.'']', '_');

            if p_report_id in ('CAEM24','CAEM25','CAEM26','CAEM27') then   --thangpv  SHBVNEX-2752
                INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
                VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,'N',l_passzip);
            else
                INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
                VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,l_iszip,l_passzip);
            end if;

            /*INSERT INTO  rptlogs(autoid,rptid,rptparam,status,subuserid,priority,txdate,exptype,isauto,emailtempid,crtdatetime,filename,iszip,passzip)
            VALUES(p_refrptlogs,p_report_id,l_rptParam,'P','0000','Y',getcurrdate,RECRPT.FILETYPE,'Y',p_template_id,l_createtime,l_filename,l_iszip,l_passzip);*/
        END LOOP;
        plog.setendsection (pkgctx, 'CREATE_RPT_REQUEST');
    EXCEPTION WHEN OTHERS THEN
        plog.error (pkgctx, sqlerrm || dbms_utility.format_error_backtrace);
        plog.setendsection (pkgctx, 'CREATE_RPT_REQUEST');
        raise errnums.e_system_error;
    END;

begin
  -- Initialization
  -- <Statement>;
  for i in (select * from tlogdebug) loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('NMPKS_EMS',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
end NMPKS_EMS;
/
