SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('ROWPERPAGE','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE, STATUS, PSTATUS) Values   ('SYSTEM', 'ROWPERPAGE', '100', 'Row in page', '', 'N', 'C', 'A', '');COMMIT;