SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SASECURITIES','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('SASECURITIES', 'Quản lý chứng khoán', 'Securities management', 'SELECT DISTINCT  MST.CODEID, MST.ISSUERID, MST.SYMBOL, A0.<@CDCONTENT> SECTYPE, A2.<@CDCONTENT> TRADEPLACE, MST.PARVALUE, MST.FOREIGNRATE
FROM SBSECURITIES MST, ALLCODE A0, ALLCODE A2
WHERE A0.CDTYPE = ''SA'' AND A0.CDNAME = ''SECTYPE''
AND A0.CDVAL = MST.SECTYPE AND A2.CDTYPE = ''SA''
AND A2.CDNAME = ''TRADEPLACE'' AND A2.CDVAL = MST.TRADEPLACE
AND MST.ISSUERID=''<$KEYVAL>''
ORDER BY MST.CODEID', 'SA.SBSECURITIES', 'frmSBSECURITIES', '', '', 0, 5000, 'N', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;