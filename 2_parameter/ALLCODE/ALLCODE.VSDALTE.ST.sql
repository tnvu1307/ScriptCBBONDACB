SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('VSDALTE','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/IDNO', 'Cá nhân trong nước dùng chứng minh thư', 0, 'Y', 'Individual - Domestic - Indetity card');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/CCPT', 'Cá nhân dùng hộ chiếu', 1, 'Y', 'Individual - Passport');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/ARNU', 'Cá nhân nước ngoài dùng trading code', 3, 'Y', 'Individual - Foreign - Trading code');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/CORP', 'Pháp nhân trong nước', 4, 'Y', 'Organization - Domestic');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/FIIN', 'Pháp nhân nước ngoài', 5, 'Y', 'Organization - Foreign');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/GOVT', 'Nhà nước', 6, 'Y', 'Government');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDALTE', 'VISD/OTHR', 'Chứng thư khác', 7, 'Y', 'Other');COMMIT;