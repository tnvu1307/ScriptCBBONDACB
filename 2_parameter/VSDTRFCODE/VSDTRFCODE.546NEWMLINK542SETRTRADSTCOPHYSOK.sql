SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('546.NEWM.LINK//542.SETR//TRAD.STCO//PHYS.OK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('546.NEWM.LINK//542.SETR//TRAD.STCO//PHYS.OK', 'Chấp nhận rút chứng khoán', '546', 'Y', 'CFO', 'CFO1504', '', '', '1504', 'Y', 'Accept the depository securities withdrawal', '', 'DR', '');COMMIT;