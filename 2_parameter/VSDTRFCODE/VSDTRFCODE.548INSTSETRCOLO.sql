SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST..SETR//COLO.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('548.INST..SETR//COLO.', 'Từ chối giải tỏa chứng khoán', '548', 'Y', 'CFN', 'CFN1512', '', '', '1512', 'Y', 'Reject requests of releasing securities', '', 'DR', '');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('548.INST..SETR//COLO.', 'Từ chối phong tỏa chứng khoán', '548', 'Y', 'CFN', 'CFN1511', '', '', '1511', 'Y', 'Reject requests of blocking securities', '', 'DR', '');COMMIT;