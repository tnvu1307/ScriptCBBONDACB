SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ISSUERS','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('ISSUERS', 'Quản lý tổ chức phát hành', 'Issuers management', 'SELECT ISSUERID, SHORTNAME,FULLNAME,EN_FULLNAME, OFFICENAME, CUSTID, ADDRESS,PHONE, FAX, A0.<@CDCONTENT> ECONIMIC,A1.<@CDCONTENT> BUSINESSTYPE,
    BANKACCOUNT,BANKNAME,LICENSENO,LICENSEDATE,LINCENSEPLACE,OPERATENO,OPERATEDATE,OPERATEPLACE,LEGALCAPTIAL,SHARECAPITAL,
    A2.<@CDCONTENT> MARKETSIZE,PRPERSON,INFOADDRESS,DESCRIPTION,A3.<@CDCONTENT> STATUS,
    (CASE WHEN STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW
FROM ISSUERS, 
(SELECT * FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''ECONIMIC'') A0,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''BUSINESSTYPE'') A1, ALLCODE A2, ALLCODE A3
WHERE ECONIMIC = A0.CDVAL (+) 
AND BUSINESSTYPE=A1.CDVAL (+) 
AND A2.CDTYPE = ''SA'' AND A2.CDNAME = ''MARKETSIZE'' AND A2.CDVAL=MARKETSIZE
AND A3.CDTYPE =''SA'' AND A3.CDNAME=''STATUS''  
and a3.cdval= STATUS', 'ISSUERS', 'frmISSUERS', '', '', 0, 5000, 'N', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;