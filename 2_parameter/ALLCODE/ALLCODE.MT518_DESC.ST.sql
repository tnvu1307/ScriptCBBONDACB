SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('MT518_DESC','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'MT518_DESC', '518.NEWM.BUSE//BUYI', 'Xác nhận thông báo KQGD TPRL', 0, 'Y', 'Xác nh?n thông báo KQGD TPRL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'MT518_DESC', '518.NEWM.BUSE//SELL', 'Xác nhận thông báo KQGD TPRL', 1, 'Y', 'Xác nh?n thông báo KQGD TPRL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'MT518_DESC', '518.CANC.BUSE//BUYI', 'Loại bỏ thanh toán giao dịch TPRL', 2, 'Y', 'Lo?i b? thanh toán giao d?ch TPRL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'MT518_DESC', '518.CANC.BUSE//SELL', 'Loại bỏ thanh toán giao dịch TPRL', 3, 'Y', 'Lo?i b? thanh toán giao d?ch TPRL');COMMIT;