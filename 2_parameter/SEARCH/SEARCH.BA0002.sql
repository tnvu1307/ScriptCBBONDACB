SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0002','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('BA0002', 'Tra cứu danh sách điện nộp/rút tiền của NĐT', 'Look up the list of electricity to pay and withdraw money of investors', 'SELECT TBL.*, A.CDCONTENT CSTATUS, to_char(TBL.CREATEDATE_AT, ''HH24:MI:SS'') TIMECREATED
FROM (
	SELECT * FROM TBL_TRANSFER_LOG 
	UNION ALL 
	SELECT * FROM TBL_TRANSFER_LOGHIST
) TBL
LEFT JOIN (
	SELECT * FROM ALLCODE WHERE CDNAME LIKE ''BANKTRANSTATUS'' AND CDTYPE = ''SA''
) A ON A.CDVAL = TBL.STATUS', 'CFMAST_TPRL', 'frmCFMAST', 'CREATEDATE_AT DESC', '    ', 0, 50, 'N', 30, 'NNNNYYYNNNN', 'Y', 'T', '', 'N', '', '');COMMIT;