SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ADTX_FTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '1', 'Công ty đại chúng', 0, 'Y', 'Public company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '2', 'Công ty cổ phần chưa đại chúng', 1, 'Y', 'Non-public joint stock company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '3', 'Công ty trách nhiệm hữu hạn', 2, 'Y', 'Limited liability company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '4', 'Doanh nghiệp nhà nước', 3, 'Y', 'State enterprises');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '5', 'Doanh Nghiệp tư nhân', 4, 'Y', 'Private Enterprise');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '6', 'Loại hình khác', 5, 'Y', 'Other type');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'ADTX_FTYPE', '7', 'Cá nhân', 6, 'Y', 'Individual');COMMIT;