SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('UNDERLYINGTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'UNDERLYINGTYPE', 'S', 'Cổ phiếu', 0, 'Y', 'Securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'UNDERLYINGTYPE', 'I', 'Chỉ số', 1, 'Y', 'Index');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'UNDERLYINGTYPE', 'E', 'Chứng chỉ quỹ', 2, 'Y', 'Exchange Traded Fund (ETF)');COMMIT;