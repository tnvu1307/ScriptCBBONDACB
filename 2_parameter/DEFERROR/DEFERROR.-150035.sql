SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150035;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150035, '[-150035]: Tiêu chí đăng ký không hợp lệ!', '[-150035]: ITYP is invalid!', 'ST', 0);COMMIT;