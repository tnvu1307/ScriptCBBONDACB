SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST.LINK//542.SETR//OWNE.STCO//DLWM','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('548.INST.LINK//542.SETR//OWNE.STCO//DLWM', 'Từ chối chuyển khoản chứng khoán khác TVLK', '548', 'Y', 'CFN', 'CFN1505', '', '', '1505', 'Y', 'Reject securities transfer requests', '', 'DR', '');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('548.INST.LINK//542.SETR//OWNE.STCO//DLWM', 'Từ chối chuyển khoản quyển mua khác TVLK', '548', 'Y', 'CFN', '1514', '', '', '1514', 'Y', 'Reject the right transfer requests', '', 'DR', '');COMMIT;