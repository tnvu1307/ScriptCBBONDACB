SET DEFINE OFF;DELETE FROM RPTMASTER WHERE 1 = 1 AND NVL(RPTID,'NULL') = NVL('ST9951','NULL');Insert into RPTMASTER   (RPTID, DSN, MODCODE, FONTSIZE, RHEADER, PHEADER, RDETAIL, PFOOTER, RFOOTER, DESCRIPTION, AD_HOC, RORDER, PSIZE, ORIENTATION, STOREDNAME, VISIBLE, AREA, ISLOCAL, CMDTYPE, ISCAREBY, ISPUBLIC, ISAUTO, ORD, AORS, ROWPERPAGE, EN_DESCRIPTION, STYLECODE, TOPMARGIN, LEFTMARGIN, RIGHTMARGIN, BOTTOMMARGIN, SUBRPT, ISCMP, ISDEFAULTDB, TEMPLATEID) Values   ('ST9951', 'HOST', 'ST', '12', '5', '5', '60', '5', '5', 'Tra cứu thông tin khách hàng đăng ký TPRL', 'Y', 1, '1', 'P', 'ST9951', 'Y', 'B', 'N', 'V', 'N', 'N', 'M', '000', 'S', -1, 'Look up customer information registered TPRL', '', 0, 0, 0, 0, 'N', 'N', 'Y', '');COMMIT;