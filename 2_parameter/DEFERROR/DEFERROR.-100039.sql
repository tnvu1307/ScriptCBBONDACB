SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100039;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100039, '[-100039]: Mã phân hệ không tồn tại!', '[-100038]: Module code is not exist!', 'SA', NULL);COMMIT;