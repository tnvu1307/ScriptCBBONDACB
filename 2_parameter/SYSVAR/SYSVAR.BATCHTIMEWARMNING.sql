SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('BATCHTIMEWARMNING','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE, STATUS, PSTATUS) Values   ('SYSTEM', 'BATCHTIMEWARMNING', '18:00:00', 'Thời điểm gửi sms cảnh báo nếu chưa chạy batch', '', 'N', 'C', 'A', '');COMMIT;