SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.007.ISIN.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('598.007.ISIN.', 'Thông báo mã chứng khoán đăng ký mới', '598', 'Y', 'INF', '', '', '', '', 'Y', 'Notice of new-securities registration', '', 'DR', '');COMMIT;