SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('100000','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('150000', '100000', 2, 'N', 'P', '', '', '', 'Tích hợp VSD', 'VSD integration', 'YYYYYYYYYY', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('160000', '100000', 2, 'N', 'P', '', '', '', 'Tích hợp NHTT', 'Bank integration', 'YYYYYYYYYY', '');COMMIT;