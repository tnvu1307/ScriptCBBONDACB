SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TEMPLATE_FORMAT','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_FORMAT', 'H', 'HTML', 1, 'Y', 'HTML');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_FORMAT', 'T', 'Text', 2, 'Y', 'Text');COMMIT;