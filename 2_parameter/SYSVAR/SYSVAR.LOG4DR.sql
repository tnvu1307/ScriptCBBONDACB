SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('LOG4DR','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE, STATUS, PSTATUS) Values   ('SYSTEM', 'LOG4DR', 'Y', 'Log for direct recovery', '', 'N', 'C', 'A', '');COMMIT;