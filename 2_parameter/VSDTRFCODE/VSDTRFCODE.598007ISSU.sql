SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.007.ISSU.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('598.007.ISSU.', 'Thông báo mã đợt đăng ký bổ sung - Phát hành', '598', 'Y', 'INF', '', '', '', '', 'Y', 'Notice of the additional securities registration  - Issuance', '', 'DR', '');COMMIT;