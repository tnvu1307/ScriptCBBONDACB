SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('VSD_MT598_INF','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('VSD_MT598_INF', 'VSD_MT598_INF_HIST', 'N');COMMIT;