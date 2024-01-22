SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_getussearchall (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
TellerId varchar2, BranchId varchar2, SearchFilter varchar2)
is
v_sql clob;
begin
    
    
    if TellerId='0001' THEN --Admin he thong
        v_sql:='SELECT distinct *
        FROM (
        SELECT lg0.CFFULLNAME CFFULLNAME,lg0.CFCUSTODYCD IDAFACCTNO, NVL(SB.SYMBOL,''---'') CODEID, tltx.txdesc NAMENV,
          lg0.CAREBYGRP,lg0.AUTOID,A1.CDCONTENT DELTD,lg0.TXNUM,lg0.TXDATE,
          lg0.BUSDATE,lg0.BRID,lg0.TLTXCD,A0.CDCONTENT TXSTATUS,
          ((CASE WHEN lg0.TXSTATUS=''7'' THEN ''4''  ELSE  lg0.TXSTATUS END)  ) TXSTATUSCD,
          lg0.TXDESC,lg0.MSGACCT ACCTNO, lg0.MSGAMT AMT, lg0.TLID,lg0.CHID,lg0.CHKID,lg0.OFFID,tltx.DELALLOW,
          TLMAKER.TLNAME TLNAME, TLCASHIER.TLNAME CHNAME,
          TLCHECKER.TLNAME CHKNAME, TLOFFICER.TLNAME OFFNAME, NVL(lg0.TXTIME,lg0.OFFTIME) TXTIME, lg0.OFFTIME
        FROM (select * from tllogall where batchname = ''DAY'' or tltxcd in (''0381'',''3375'')) lg0, ALLCODE A0, ALLCODE A1,tltx,SBSECURITIES SB,
          (
          SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 1, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
          UNION ALL
          SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
          WHERE SUBSTR(TL.TLTYPE, 1, 1) <> ''Y''
              AND SUBSTR(GRP.GRPRIGHT, 1, 1) = ''Y''
              AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID
          ) TLMAKER,
          (
          SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 2, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
          UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
          WHERE SUBSTR(TL.TLTYPE, 2, 1) <> ''Y''
              AND SUBSTR(GRP.GRPRIGHT, 2, 1) = ''Y''
              AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID
          ) TLCASHIER,
          (
          SELECT TLID, TLNAME
          FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 3, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL UNION ALL SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 3, 1) <> ''Y'')
          UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
          WHERE SUBSTR(TL.TLTYPE, 3, 1) <> ''Y''
              AND SUBSTR(GRP.GRPRIGHT, 3, 1) = ''Y''
              AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID
          ) TLOFFICER,
          (
          SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 4, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL)
          UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
          WHERE SUBSTR(TL.TLTYPE, 4, 1) <> ''Y''
              AND SUBSTR(GRP.GRPRIGHT, 4, 1) = ''Y''
              AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID
          ) TLCHECKER
        WHERE NOT (lg0.TLTXCD LIKE ''%71'' OR lg0.TLTXCD LIKE ''%72'' OR lg0.TLTXCD LIKE ''%6631''  OR lg0.TLTXCD IN (''0011'',''1175'',''8873'',''2282'',''1177''))
          AND A0.CDTYPE=''SY'' AND A0.CDNAME = ''TXSTATUS''
          AND A0.CDVAL= ( CASE WHEN DELTD=''Y'' THEN ''9'' WHEN (lg0.TXSTATUS=''4'' AND (lg0.OVRRQS <> ''0'' AND lg0.OVRRQS <> ''@00'') AND lg0.CHKID IS NOT NULL  AND lg0.OFFID IS NULL) THEN ''10'' ELSE  lg0.TXSTATUS END)
          AND A1.CDTYPE=''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL=DELTD
          -- TruongLD Add--> Khong lay nhung GD phat sinh tu GD khac hoac GD tu do
          AND (lg0.tltxcd in(''0381'',''1101'',''1141'',''1153'',''8800'',''3375'') or SUBSTR(lg0.TXNUM, 1,4) not in (''6800'',''6900'',''7000'',''8000'',''8080'',''9800'',''9900''))
          AND (CASE WHEN LG0.TLTXCD IN (''8800'',''8802'') AND LG0.TXSTATUS = ''5'' AND LG0.OFFID IS NULL THEN 0 ELSE 1 END) = 1
          AND lg0.ccyusage= SB.CODEID(+)
          AND (CASE WHEN lg0.TLID IS NULL THEN ''____'' ELSE lg0.TLID END)=TLMAKER.TLID
          AND (CASE WHEN lg0.CHID IS NULL THEN ''____'' ELSE lg0.CHID END)=TLCASHIER.TLID
          AND (CASE WHEN lg0.CHKID IS NULL THEN ''____'' ELSE lg0.CHKID END)=TLCHECKER.TLID
          AND (CASE WHEN lg0.OFFID IS NULL THEN ''____'' ELSE lg0.OFFID END)=TLOFFICER.TLID and tltx.tltxcd=lg0.tltxcd
        ) TLLOG WHERE 0=0 ';
    else --User thong thuong
        v_sql:='
        with
        grpuser as
        (
        select grpid from tlgrpusers where tlid = '''||TellerId||'''
        )
        SELECT distinct * FROM (SELECT lg0.CFFULLNAME CFFULLNAME, lg0.CFCUSTODYCD IDAFACCTNO, NVL(SB.SYMBOL,''---'') CODEID,
            tltx.txdesc NAMENV,lg0.CAREBYGRP,lg0.AUTOID,A1.CDCONTENT DELTD,lg0.TXNUM,
            lg0.TXDATE,lg0.BUSDATE,lg0.BRID,lg0.TLTXCD,A0.CDCONTENT TXSTATUS,
             ((CASE WHEN lg0.TXSTATUS=''7'' THEN ''4'' ELSE  lg0.TXSTATUS END)  ) TXSTATUSCD,
            lg0.TXDESC,lg0.MSGACCT ACCTNO, lg0.MSGAMT AMT, lg0.TLID,lg0.CHID,lg0.CHKID,lg0.OFFID,tltx.DELALLOW,
            TLMAKER.TLNAME TLNAME, TLCASHIER.TLNAME CHNAME, TLCHECKER.TLNAME CHKNAME,
            TLOFFICER.TLNAME OFFNAME, NVL(lg0.TXTIME,lg0.OFFTIME) TXTIME, lg0.OFFTIME
            FROM (select * from tllogall where batchname = ''DAY'' or tltxcd in (''0381'',''3375'')) lg0,
                ALLCODE A0, ALLCODE A1,tltx,SBSECURITIES SB,
                (
                    select * from brgrp where BRID= ''' || BranchId || '''
                ) BR,
            (SELECT GRPID FROM TLGRPUSERS WHERE BRID=''' || BranchId || ''' AND TLID=''' || TellerId || ''' UNION ALL select ''XXXX'' GRPID from dual) TLCAREBY,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 1, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 1, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 1, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLMAKER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 2, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 2, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 2, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCASHIER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 3, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL UNION ALL SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 3, 1) <> ''Y'' AND TLID =''' || TellerId || ''')
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 3, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 3, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLOFFICER,
            (SELECT TLID, TLNAME FROM (SELECT TLID, TLNAME FROM tlprofiles WHERE SUBSTR(TLTYPE, 4, 1) = ''Y'' UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL )
             UNION ALL SELECT DISTINCT TL.TLID, TL.TLNAME FROM tlprofiles TL, TLGROUPS GRP, TLGRPUSERS TLGRP
             WHERE SUBSTR(TL.TLTYPE, 4, 1) <> ''Y'' AND SUBSTR(GRP.GRPRIGHT, 4, 1) = ''Y'' AND TL.TLID = TLGRP.TLID AND GRP.GRPID = TLGRP.GRPID) TLCHECKER
            WHERE NOT (lg0.TLTXCD LIKE ''%71''OR lg0.TLTXCD LIKE ''%72'' OR lg0.TLTXCD LIKE ''%6631'' OR lg0.TLTXCD IN (''0011'',''1175'',''8873'',''2282'',''1177''))
            AND (lg0.tltxcd in(''0381'',''1101'',''1141'',''1153'',''3375'') or  lg0.CAREBYGRP IS NULL OR (lg0.CAREBYGRP LIKE ''%'' || TLCAREBY.GRPID || ''%''))
            AND A0.CDTYPE=''SY'' AND A0.CDNAME = ''TXSTATUS'' AND A0.CDVAL=( CASE WHEN DELTD=''Y'' THEN ''9'' WHEN (lg0.TXSTATUS=''4'' AND (lg0.OVRRQS <> ''0'' AND lg0.OVRRQS <> ''@00'') AND lg0.CHKID IS NOT NULL  AND lg0.OFFID IS NULL) THEN ''10'' ELSE  lg0.TXSTATUS END)
            AND A1.CDTYPE=''SY'' AND A1.CDNAME = ''YESNO'' AND A1.CDVAL=DELTD
            --25/07/2016, TruongLD Add Fix loi, User chi nhanh nay thay giao dich chi nhanh khac
            and INSTR(nvl(br.mapid,br.brid), lg0.brid) > 0
            -- TruongLD Add--> Khong lay nhung GD phat sinh tu GD khac hoac GD tu do
            AND (lg0.tltxcd in(''0381'',''1101'',''1141'',''8800'',''3375'') or SUBSTR(lg0.TXNUM, 1,4) not in (''6800'',''6900'',''7000'',''8000'',''8080'',''9800'',''9900''))
            AND (CASE WHEN LG0.TLTXCD IN (''8800'',''8802'') AND LG0.TXSTATUS = ''5'' AND LG0.OFFID IS NULL THEN 0 ELSE 1 END) = 1
            AND lg0.ccyusage= SB.CODEID(+)
            AND (CASE WHEN lg0.TLID IS NULL THEN ''____'' ELSE lg0.TLID END)=TLMAKER.TLID
            AND (CASE WHEN lg0.CHID IS NULL THEN ''____'' ELSE lg0.CHID END)=TLCASHIER.TLID
            AND (CASE WHEN lg0.CHKID IS NULL THEN ''____'' ELSE lg0.CHKID END)=TLCHECKER.TLID
            AND (CASE WHEN lg0.OFFID IS NULL THEN ''____'' ELSE lg0.OFFID END)=TLOFFICER.TLID and tltx.tltxcd=lg0.tltxcd
            AND (lg0.TLID= ''' || TellerId || '''
            OR (lg0.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''T'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''T'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from grpuser)  AND AUTHTYPE=''G''))
            OR (lg0.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''A'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''A'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from grpuser)  AND AUTHTYPE=''G''))
            OR (lg0.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''C'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''C'' AND TLLIMIT >=0 and AUTHID IN  (select grpid from grpuser)  AND AUTHTYPE=''G''))
            OR (lg0.TLTXCD IN ( SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''R'' AND TLLIMIT >=0 and AUTHID= ''' || TellerId || ''' AND AUTHTYPE=''U''
             UNION ALL SELECT DISTINCT TLTXCD FROM TLAUTH WHERE TLTYPE=''R'' AND TLLIMIT >=0 and AUTHID IN (select grpid from grpuser) AND AUTHTYPE=''G''))))TLLOG WHERE 0=0 ';
    end if;

    v_sql := v_sql || ' AND TLLOG.TXSTATUSCD NOT IN (''0'') ';

    if length(SearchFilter)>0 then
        v_sql := v_sql || ' AND ' || SearchFilter;
    end if;
    
    
    
    open PV_REFCURSOR for v_sql;
EXCEPTION
  WHEN others THEN -- caution handles all exceptions
   plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
end;
/
