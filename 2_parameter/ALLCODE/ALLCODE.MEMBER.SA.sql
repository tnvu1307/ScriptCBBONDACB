SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('MEMBER','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'MEMBER', '099', 'Công ty FSS', 99, 'Y', 'Công ty FSS');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'MEMBER', '099', 'Công ty Cổ phần Chứng khoán SJC', 99, 'Y', 'Công ty C? ph?n Ch?ng khoán SJC');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'MEMBER', '099', 'Công ty Cổ phần Chứng khoán SJC', 99, 'Y', 'Công ty C? ph?n Ch?ng khoán SJC');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'MEMBER', '611', 'Ngân hàng Thương Mại Cổ Phần Sài Gòn', 611, 'Y', 'Ngân hàng Thuong M?i C? Ph?n Sài Gòn');COMMIT;