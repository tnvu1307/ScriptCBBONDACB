SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('544.NEWM.LINK//518.SETR//TRAD.STCO//NPAR','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('544.NEWM.LINK//518.SETR//TRAD.STCO//NPAR', 'Thông báo ghi tăng TPRL bên mua', '544', 'Y', 'INF', '', '', '', '', 'Y', 'Notice of recording decrease of individual bonds by the seller and increase of the purchaser''s bonds', '', 'DR', '');COMMIT;