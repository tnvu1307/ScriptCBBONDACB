SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('508.NEWM.FROM//PLED.TOBA//AVAL.OK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('508.NEWM.FROM//PLED.TOBA//AVAL.OK', 'Chấp nhận giải tỏa chứng khoán', '508', 'Y', 'CFO', 'CFO1512', '', '', '1512', 'Y', 'Accept requests for releasing securities', '', 'DR', '');COMMIT;