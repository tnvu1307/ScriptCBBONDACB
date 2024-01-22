SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1603','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'REFREQID', 'C', '$08', '', 'Mã yêu cầu (20C:)', '', '', 'N', 0, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'CUSTODYCD', 'C', '$88', '', 'Tài khoản nhà đầu tư (95A:)', '', '', 'N', 1, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'QTTY', 'C', '$92', '', 'Khối lượng (36B:)', '', '', 'N', 13, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'TXDATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu (98A:)', '', '', 'N', 14, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'FULLNAME', 'D', '$90', '', 'Tên đầy đủ nhà đầu tư (95Q:)', '', '', 'N', 2, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'DATEOFBIRTH', 'D', '$34', '', 'Ngày sinh (95Q:)', '', '', 'N', 3, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'IDDATE', 'D', '$95', '', 'Ngày cấp CMT/hộ chiếu/giấy phép (70E:)', '', '', 'N', 6, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'ADDRESS', 'D', '$91', '', 'Ðịa chỉ', '', '', 'N', 8, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'DESC', 'C', '$30', '', 'Diễn giải', '', '', 'N', 15, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'IDTYPE', 'C', '$33', '', 'Loại chứng khoán (12A:)', '', '', 'N', 10, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'ALTERNATEID', 'C', '$38', 'SELECT ''/'' || ''<$FILTERID>'' FROM DUAL', 'Loại hình cổ đông (95S:)', '', '', 'N', 15, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'REFERENCEID', 'C', '$02', '', 'Mã đợt phát hành', '', '', 'N', 16, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'NATIONAL', 'C', '$96', '', 'Mã quốc gia (95Q:)', '', '', 'N', 9, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'SYMBOL', 'C', '$01', 'SELECT REPLACE(SYMBOL, ''_WFT'', '''') FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Mã chứng khoán (35B:)', '', '', 'N', 12, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'IDPLACE', 'C', '$37', '', 'Nơi cấp CMT/hộ chiếu/giấy phép (70E:)', '', '', 'N', 7, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'IDCODE', 'C', '$31', '', 'Giấy đăng ký sở hữu (95S:)', '', '', 'N', 5, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'REFREQID', 'C', '$08', '', 'Mã yêu cầu (20C:)', '', '', 'N', 0, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'QTTY', 'C', '$92', '', 'Khối lượng (36B:)', '', '', 'N', 13, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'TXDATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu (98A:)', '', '', 'N', 14, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'DATEOFBIRTH', 'D', '$34', '', 'Ngày sinh (95Q:)', '', '', 'N', 3, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'CUSTODYCD', 'C', '$88', '', 'Tài khoản nhà đầu tư (95A:)', '', '', 'N', 1, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'IDDATE', 'D', '$95', '', 'Ngày cấp CMT/hộ chiếu/giấy phép (70E:)', '', '', 'N', 6, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'ADDRESS', 'D', '$91', '', 'Ðịa chỉ', '', '', 'N', 8, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'FULLNAME', 'D', '$90', '', 'Tên đầy đủ nhà đầu tư (95Q:)', '', '', 'N', 2, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'DESC', 'C', '$30', '', 'Diễn giải', '', '', 'N', 15, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'IDTYPE', 'C', '$33', '', 'Loại chứng khoán (12A:)', '', '', 'N', 10, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'ALTERNATEID', 'C', '$38', 'SELECT ''/'' || ''<$FILTERID>'' FROM DUAL', 'Loại hình cổ đông (95S:)', '', '', 'N', 15, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'REFERENCEID', 'C', '$02', '', 'Mã đợt phát hành', '', '', 'N', 16, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'NATIONAL', 'C', '$96', '', 'Mã quốc gia (95Q:)', '', '', 'N', 9, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'SYMBOL', 'C', '$01', 'SELECT REPLACE(SYMBOL, ''_WFT'', '''') FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Mã chứng khoán (35B:)', '', '', 'N', 12, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'IDPLACE', 'C', '$37', '', 'Nơi cấp CMT/hộ chiếu/giấy phép (70E:)', '', '', 'N', 7, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'IDCODE', 'C', '$31', '', 'Giấy đăng ký sở hữu (95S:)', '', '', 'N', 5, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//NORM', 'UNIT', 'C', '$01', 'SELECT (CASE WHEN SECTYPE IN (''006'', ''003'', ''010'', ''011'', ''012'') THEN ''FAMT'' ELSE ''UNIT'' END)
FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Loại chứng khoán (36B:)', '', '', 'N', 12, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1603', '540.CANC.CLAS//PEND', 'UNIT', 'C', '$01', 'SELECT (CASE WHEN SECTYPE IN (''006'', ''003'', ''010'', ''011'', ''012'') THEN ''FAMT'' ELSE ''UNIT'' END)
FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Loại chứng khoán (36B:)', '', '', 'N', 12, '', '');COMMIT;