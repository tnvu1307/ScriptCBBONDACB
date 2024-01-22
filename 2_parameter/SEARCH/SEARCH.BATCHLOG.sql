SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BATCHLOG','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('BATCHLOG', 'Lịch sử chạy Batch', 'Batch History management', 'SELECT BAT.AUTOID, BAT.ID, BAT.SERVERDATE, BAT.SERVERTIME,
    BAT.CMDID, BAT.IPADDRESS, TLP.TLNAME TLID, BAT.TXDATE, BAT.USERBATCH, BAT.ISAUTO,
    ''Y'' EDITALLOW,
    (CASE WHEN BAT.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
    ''N'' DELALLOW, A1.CDCONTENT STATUS, A2.CDCONTENT ACTIVE
FROM BATCHLOG BAT , TLPROFILES TLP , ALLCODE A1, ALLCODE A2
WHERE BAT.TLID = TLP.TLID
    AND A1.CDTYPE = ''SA'' AND A1.CDNAME = ''STATUS'' AND NVL(BAT.STATUS,''A'') = A1.CDVAL
    AND A2.CDTYPE = ''SA'' AND A2.CDNAME = ''ACTIVE'' AND NVL(BAT.ISACTIVE,''Y'') = A2.CDVAL', 'BATCHLOG', 'frmBATCHLOG', '', '', NULL, 5000, 'N', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;