SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('CANCELED','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'CANCELED', 'Y', 'Hủy', 0, 'Y', 'Yes');COMMIT;