SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150009;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150009, '[-150009]: Mã tỉnh thành không hợp lệ!', '[-150009]: Province is invalid!', 'ST', NULL);COMMIT;