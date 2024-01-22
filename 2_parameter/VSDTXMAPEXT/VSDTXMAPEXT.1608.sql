SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1608','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'IDCODE', 'C', '$31', '', 'Giấy đăng ký sở hữu (95S:)', '', '', 'N', 5, 'F', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'IDDATE', 'D', '$95', '', 'Ngày cấp CMT/hộ chiếu/giấy phép (98A:)', '', '', 'N', 6, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'ALTERNATEID', 'C', '$38', 'SELECT SUBSTR(''<$FILTERID>'',6,4) FROM DUAL', 'Loại hình cổ đông (95S:)', '', '', 'N', 15, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'VSDSTOCKTYPE', 'C', '$08', '', 'Loại chứng khoán phong tỏa (12A:)', '', '', 'N', 7, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'STOCKTYPE', 'C', '$01', 'SELECT (CASE WHEN SECTYPE IN (''006'', ''003'', ''010'', ''011'', ''012'') THEN ''FAMT'' ELSE ''UNIT'' END)
FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Loại chứng khoán phong tỏa (36B:)', '', '', 'N', 8, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'CUSTODYCD', 'C', '$88', '', 'Tài khoản nhà đầu tư (97A:)', '', '', 'N', 1, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'TXDATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu (98A:)', '', '', 'N', 14, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'REFERENCEID', 'C', '$02', '', 'Mã đợt thực hiện quyền (20C:)', '', '', 'N', 16, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'SYMBOL_ORG', 'C', '$01', 'SELECT SYMBOL FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Mã chứng khoán chốt (35B:)', '', '', 'N', 12, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'QTTY', 'C', '$92', '', 'Khối lượng (36B:)', '', '', 'N', 13, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'ORDERNUMBER', 'C', '$03', '', 'Số thứ tự thông tin phụ (13A:)', '', '', 'N', 16, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'PREV1608', 'C', '$59', '', 'Số hiệu điện Y/C trước (23C:)', '', '', 'N', 7, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '1608', '565.CANC.CAEV//RHTS', 'DESC', 'C', '$30', '', 'Diễn giải (70E:)', '', '', 'N', 15, 'F', '');COMMIT;