SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('546.NEWM.LINK//542.SETR//OWNE..OK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('546.NEWM.LINK//542.SETR//OWNE..OK', 'Chấp nhận chuyển khoản chứng khoán ra ngoài khác TVLK', '546', 'Y', 'CFO', 'CFO1505', '', '', '1505', 'Y', 'Accept securities transfer requests', '', 'DR', '');COMMIT;