SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CAEV//BPUT','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('564.CAEV//BPUT', 'Thông báo bán lại trái phiếu cho TCPH', '564', 'Y', 'INF', '', '', '', '', 'Y', 'Notice annual general meeting', '', 'DR', '');COMMIT;