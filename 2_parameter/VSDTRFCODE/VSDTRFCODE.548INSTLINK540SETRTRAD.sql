SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST.LINK//540.SETR//TRAD.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('548.INST.LINK//540.SETR//TRAD.', 'Từ chối lưu ký chứng khoán', '548', 'Y', 'CFN', 'CFN1503', '', '', '1503', 'Y', 'Reject requests for depositing securities', '', 'DR', '');COMMIT;