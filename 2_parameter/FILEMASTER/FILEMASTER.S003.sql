SET DEFINE OFF;DELETE FROM FILEMASTER WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('S003','NULL');Insert into FILEMASTER   (EORI, FILECODE, FILENAME, FILEPATH, TABLENAME, SHEETNAME, ROWTITLE, DELTD, EXTENTION, PAGE, PROCNAME, PROCFILLTER, OVRRQD, MODCODE, RPTID, CMDCODE, IMPBYINDEX, TABLENAME_HIST, TRADEDATE) Values   ('T', 'S003', 'Gửi lưu ký chứng khoán/ Requests for sending securities depository', '', 'MT540_1503', '1', 1, 'N', '.xls', 100, 'PR_FILE_1503', 'PR_FILE_1503_FILLER', 'Y', 'SE', '', 'SE', 'N', 'MT540_1503_HIST', 'N');COMMIT;