SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TLOG','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('TLOG', 'Quản lý log', 'Quản lý log', 'SELECT * FROM TLOG WHERE LUSER = USER', 'TLOG', '', 'ID DESC', '', NULL, 500, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '', '');COMMIT;