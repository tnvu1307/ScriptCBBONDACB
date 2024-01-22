SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_getussearch2 (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
TellerId varchar2, BranchId varchar2, SearchFilter varchar2)
is
v_sql clob;
begin
    
    
    if TellerId='0001' THEN --Admin he thong
        v_sql:='SELECT distinct * FROM (SELECT TLLOG.CFFULLNAME CFFULLNAME,TLLOG.CFCUSTODYCD IDAFACCTNO,NVL(SB.SYMBOL,''---'') CODEID, tltx.txdesc NAMENV,TLLOG.CAREBYGRP,TLLOG.AUTOID,A1.CDCONTENT DELTD,TLLOG.TXTIME,TLLOG.TXNUM,TLLOG.TXDATE,TLLOG.BUSDATE,TLLOG.BRID,TLLOG.TLTXCD,A0.CDCONTENT TXSTATUS,
        ((CASE WHEN TLLOG.TXSTATUS=''7'' THEN ''4''  ELSE  TLLOG.TXSTATUS END)  ) TXSTATUSCD,
            TLLOG.TXDESC,TLLOG.MSGACCT ACCTNO, TLLOG.MSGAMT AMT, TLLOG.TLID,TLLOG.CHID,TLLOG.CHKID,TLLOG.OFFID,
            TLMAKER.TLNAME TLNAME, TLCASHIER.TLNAME CHNAME, TLCHECKER.TLNAME CHKNAME, TLOFFICER.TLNAME OFFNAME
            FROM TLLOG TLLOG, ALLCODE A0, ALLCODE A1,tltx,SBSECURITIES SB,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 1, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 1, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 1, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLMAKER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 2, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 2, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 2, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCASHIER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 3, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL UNION ALL SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 3, 1) <> ''Y'')
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 3, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 3, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLOFFICER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 4, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 4, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 4, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCHECKER
            WHERE NOT (TLLOG.TLTXCD LIKE ''%71''OR TLLOG.TLTXCD LIKE ''%72'' OR TLLOG.TLTXCD IN (''0011'',''1175'',''8873'',''2282'',''1177''))
            AND A0.CDTYPE=''SY'' AND A0.CDNAME = ''TXSTATUS'' AND A0.CDVAL= ( CASE WHEN DELTD=''Y'' THEN ''9'' WHEN (TLLOG.TXSTATUS=''4'' AND (TLLOG.OVRRQS <> ''0'' AND TLLOG.OVRRQS <> ''@00'') AND TLLOG.CHKID IS NOT NULL  AND TLLOG.OFFID IS NULL) THEN ''10'' ELSE  TLLOG.TXSTATUS END)
            AND A1.CDTYPE=''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL=DELTD
            -- TruongLD Add--> Khong lay nhung GD phat sinh tu GD khac hoac GD tu do
            AND SUBSTR(TLLOG.TXNUM, 1,4) not in (''6800'',''6900'',''7000'',''8000'',''8080'',''9800'',''9900'')
            AND TLLOG.ccyusage= SB.CODEID(+)
            AND (CASE WHEN TLLOG.TLID IS NULL THEN ''____'' ELSE TLLOG.TLID END)=TLMAKER.TLID
            AND (CASE WHEN TLLOG.CHID IS NULL THEN ''____'' ELSE TLLOG.CHID END)=TLCASHIER.TLID
            AND (CASE WHEN TLLOG.CHKID IS NULL THEN ''____'' ELSE TLLOG.CHKID END)=TLCHECKER.TLID
            AND (CASE WHEN TLLOG.OFFID IS NULL THEN ''____'' ELSE TLLOG.OFFID END)=TLOFFICER.TLID and tltx.tltxcd=tllog.tltxcd) TLLOG WHERE 0=0 ';
    else --User thong thuong
        v_sql:='
        with grpuser as
        (
        select grpid from tlgrpusers where tlid = '''||TellerId||'''
        )
        SELECT distinct * FROM (SELECT TLLOG.CFFULLNAME CFFULLNAME, TLLOG.CFCUSTODYCD IDAFACCTNO,NVL(SB.SYMBOL,''---'') CODEID,tltx.txdesc NAMENV,TLLOG.CAREBYGRP,TLLOG.AUTOID,A1.CDCONTENT DELTD,TLLOG.TXTIME,TLLOG.TXNUM,
            TLLOG.TXDATE,TLLOG.BUSDATE,TLLOG.BRID,TLLOG.TLTXCD,A0.CDCONTENT TXSTATUS,
             ((CASE WHEN TLLOG.TXSTATUS=''7'' THEN ''4'' ELSE  TLLOG.TXSTATUS END)  ) TXSTATUSCD,
            TLLOG.TXDESC,TLLOG.MSGACCT ACCTNO, TLLOG.MSGAMT AMT, TLLOG.TLID,TLLOG.CHID,TLLOG.CHKID,TLLOG.OFFID,
            TLMAKER.TLNAME TLNAME, TLCASHIER.TLNAME CHNAME, TLCHECKER.TLNAME CHKNAME, TLOFFICER.TLNAME OFFNAME
            FROM TLLOG TLLOG, ALLCODE A0, ALLCODE A1,tltx,SBSECURITIES SB,
            (SELECT GRPID FROM TLGRPUSERS WHERE BRID=''' || BranchId || ''' AND TLID=''' || TellerId || ''' UNION ALL select ''XXXX'' GRPID from dual) TLCAREBY,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 1, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 1, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 1, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLMAKER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 2, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 2, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 2, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCASHIER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 3, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL UNION ALL SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 3, 1) <> ''Y'' AND TLID =''' || TellerId || ''')
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 3, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 3, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLOFFICER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM TLPROFILES WHERE SUBSTR(TLTYPE, 4, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM TLPROFILES TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 4, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 4, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCHECKER
            WHERE NOT (TLLOG.TLTXCD LIKE ''%71''OR TLLOG.TLTXCD LIKE ''%72'' OR TLLOG.TLTXCD IN (''0011'',''1175'',''8873'',''2282'',''1177''))
            AND (TLLOG.TLID= ''' || TellerId || ''' or  TLLOG.CAREBYGRP IS NULL OR (TLLOG.CAREBYGRP LIKE ''%'' || TLCAREBY.GRPID || ''%''))
            AND A0.CDTYPE=''SY'' AND A0.CDNAME = ''TXSTATUS'' AND A0.CDVAL=( CASE WHEN DELTD=''Y'' THEN ''9'' WHEN (TLLOG.TXSTATUS=''4'' AND (TLLOG.OVRRQS <> ''0'' AND TLLOG.OVRRQS <> ''@00'') AND TLLOG.CHKID IS NOT NULL  AND TLLOG.OFFID IS NULL) THEN ''10'' ELSE  TLLOG.TXSTATUS END)
            AND A1.CDTYPE=''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL=DELTD
            -- TruongLD Add--> Khong lay nhung GD phat sinh tu GD khac hoac GD tu do
            AND SUBSTR(TLLOG.TXNUM, 1,4) not in (''6800'',''6900'',''7000'',''8000'',''8080'',''9800'',''9900'')
            AND TLLOG.ccyusage= SB.CODEID(+)
            AND (CASE WHEN TLLOG.TLID IS NULL THEN ''____'' ELSE TLLOG.TLID END)=TLMAKER.TLID
            AND (CASE WHEN TLLOG.CHID IS NULL THEN ''____'' ELSE TLLOG.CHID END)=TLCASHIER.TLID
            AND (CASE WHEN TLLOG.CHKID IS NULL THEN ''____'' ELSE TLLOG.CHKID END)=TLCHECKER.TLID
            AND (CASE WHEN TLLOG.OFFID IS NULL THEN ''____'' ELSE TLLOG.OFFID END)=TLOFFICER.TLID and tltx.tltxcd=tllog.tltxcd
            AND (TLLOG.TLID= ''' || TellerId || '''
            OR (TLLOG.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''T'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''T'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from tlgrpusers where tlid = ''' || TellerId ||''')  AND AUTHTYPE=''G''))
            OR (TLLOG.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''A'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''A'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from tlgrpusers where tlid = ''' || TellerId ||''')  AND AUTHTYPE=''G''))
            OR (TLLOG.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''C'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''C'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from tlgrpusers where tlid = ''' || TellerId ||''')  AND AUTHTYPE=''G''))
            OR (TLLOG.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''R'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''R'' AND TLLIMIT >=0 and AUTHID IN (select grpid from tlgrpusers where tlid = ''' || TellerId ||''') AND AUTHTYPE=''G''))))TLLOG WHERE 0=0 ';
    end if;

    if length(SearchFilter)>0 then
        v_sql := v_sql || ' AND ' || SearchFilter;
    end if;


    open PV_REFCURSOR for v_sql;
EXCEPTION
  WHEN others THEN -- caution handles all exceptions
   plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
end;
/
