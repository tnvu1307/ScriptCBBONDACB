SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9942','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('ST9942', 'Tra cứu điện thông báo 564 từ VSD', 'Manage notification messages 564 from VSD', 'SELECT VSD.AUTOID, VSD.VSDMSGID, VSD.VSDMSGDATE, VSD.SYMBOL, A1.CDCONTENT VSDMSGTYPE, VSD.DATETYPE, VSD.EXRATE, NULL PAYDATE, VSD.CAMASTID
FROM (
    SELECT * FROM VSD_MT564_INF
    UNION ALL
    SELECT * FROM VSD_MT564_INF_HIST
) VSD
INNER JOIN (SELECT * FROM ALLCODE WHERE CDNAME = ''MT_564'') A1 ON VSD.VSDMSGTYPE = A1.CDVAL', 'CFMAST', 'frmMT598', 'AUTOID DESC', '', 0, 5000, 'Y', 30, 'NNNNYYYNNNN', 'Y', 'T', '', 'N', '', '');COMMIT;