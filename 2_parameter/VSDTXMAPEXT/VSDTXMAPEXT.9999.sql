SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9999','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '9999', '598.NEWM/003', 'REPORTID', 'C', '<$TXNUM>', 'SELECT RPTID FROM REPORTMTLOG WHERE TXNUM = ''<$FILTERID>''', 'Mã báo cáo', '', '', 'N', 1, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '9999', '598.NEWM/003', 'PARAM', 'C', '<$TXNUM>', 'SELECT RPTINPUT FROM REPORTMTLOG WHERE TXNUM = ''<$FILTERID>''', 'Tham số', '', '', 'N', 2, '', '');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM, CONVERT, MAXLENGTH) Values   ('T', '9999', '598.NEWM/003', 'TXDATE', 'D', '<$BUSDATE>', '', 'Ngày tạo yêu cầu (98A:)', '', '', 'N', 5, '', '');COMMIT;