SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('BRADDRESS','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE, STATUS, PSTATUS) Values   ('SYSTEM', 'BRADDRESS', '138-142 Hai Bà Trưng, P. Đa Kao, Q. 1, TP HCM', 'Branch address', '', 'N', 'C', 'A', '');COMMIT;