SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.ACCT//ACLS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('598.ACCT//ACLS', 'Chấp nhận yêu cầu đóng tài khoản', '598', 'Y', 'CFO', '1502', '', '', '1502', 'Y', 'Accept request of opening accounts', '', 'DR', '');COMMIT;