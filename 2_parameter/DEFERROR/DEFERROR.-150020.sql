SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150020;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150020, '[-150020]: Ngày sinh phải bé hơn ngày cấp!', '[-150020]: Birthdays must be smaller than the iddate!', 'ST', NULL);COMMIT;