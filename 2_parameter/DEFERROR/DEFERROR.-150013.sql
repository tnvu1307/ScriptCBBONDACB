SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150013;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150013, '[-150013]: Biccode bên chuyển không hợp lệ!', '[-150013]: Biccode sent is invalid!', 'ST', NULL);COMMIT;