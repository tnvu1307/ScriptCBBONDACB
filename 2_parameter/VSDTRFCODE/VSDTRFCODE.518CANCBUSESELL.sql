SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('518.CANC.BUSE//SELL','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, REJTLTXCD, TRFTYPE, ACKTLTXCD) Values   ('518.CANC.BUSE//SELL', 'Thông báo hủy KQ giao dịch và nghĩa vụ thanh toán cho bên bán', '518', 'Y', 'INF', '', '', '', '', 'Y', 'Notify the cancel transaction results and payment obligations to the seller', '', 'DR', '');COMMIT;