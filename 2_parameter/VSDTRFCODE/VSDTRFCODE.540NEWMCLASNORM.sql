SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('540.NEWM.CLAS//NORM','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('540.NEWM.CLAS//NORM', 'Gửi lưu ký chứng khoán', '540', 'Y', 'REQ', '1503', '', '', '', 'Y', 'Request for depositing securities', 'CFN1503', 'DR', '');COMMIT;