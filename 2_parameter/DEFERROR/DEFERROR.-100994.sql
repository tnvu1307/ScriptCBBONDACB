SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100994;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100994, '[-100994]: Không được phân quyền mức NSD/nhóm để sử dụng sản phẩm', '[-100994]: The business product is invalid for user/group', 'SA', NULL);COMMIT;