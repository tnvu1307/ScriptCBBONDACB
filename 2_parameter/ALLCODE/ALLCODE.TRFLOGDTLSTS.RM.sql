SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TRFLOGDTLSTS','NULL') AND NVL(CDTYPE,'NULL') = NVL('RM','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'P', 'Chờ gửi', 0, 'N', 'Sending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'A', 'Đang gửi', 1, 'N', 'Sent');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'S', 'Đã gửi', 2, 'N', 'Sent');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'C', 'Xác nhận', 3, 'N', 'Confirmed');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'E', 'Lỗi', 4, 'N', 'Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'D', 'Đã xóa', 5, 'N', 'Deleted');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'TRFLOGDTLSTS', 'B', 'Đã gửi lại', 6, 'N', 'Resent');COMMIT;