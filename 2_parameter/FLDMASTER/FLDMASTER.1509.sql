SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1509','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '01', '1509', 'RPTID', 'Mã báo cáo', 'Report id', 1, 'C', '999999', '999999', 30, 'SELECT CDVAL VALUECD, CDVAL VALUE, CDVAL||''-''||CDCONTENT 
DISPLAY, CDVAL||''-''||EN_CDCONTENT EN_DISPLAY, '''' 
DESCRIPTION
FROM ALLCODE WHERE CDNAME = ''RPTID'' AND CDTYPE=''ST'' AND 
CDUSER=''Y'' AND CDVAL IN (''DE013'',''DE065'',''DE083'')
ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'RPTID', '##########', '', '', 'SA', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_RPTID', 'Y', '', 'N', '', '', '', 'N', 30, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '02', '1509', 'BRID', 'Sàn giao dịch', 'Trading venue', 4, 'C', '999999', '999999', 10, 'SELECT A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION FROM ALLCODE A WHERE CDNAME = ''TRADEPLACE'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'' ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'BRID', '##########', '', '', 'SA', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_BRID', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '03', '1509', 'REFRPTID', 'Số hiệu tham chiếu báo cáo', 'Report reference', 6, 'C', '', '', 255, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 100, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '05', '1509', 'CONFIRMSTATUS', 'Trạng thái xác nhận', 'Confirmation status', 7, 'C', '999999', '999999', 10, 'SELECT A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION FROM ALLCODE A WHERE CDNAME = ''CONFIRM_STATUS'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'' ORDER BY LSTODR', ' ', '', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'CONFIRMSTATUS', '##########', '', '', 'SA', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_CONFIRMSTATUS', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '10', '1509', 'BALANCE', 'Số lượng', 'Quantity', 5, 'N', '999g999g999', '999g999g999', 15, '', ' ', '0', 'N', 'N', 'N', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_QTTYDK', 'Y', '0', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '20', '1509', 'TRANNUM', 'Mã đợt chốt số dư', 'Period of fixing the balance of securities', 5.1, 'C', '', '', 15, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', 'CUSTODYCD', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '21', '1509', 'TRANDATE', 'Ngày giao dịch', 'Transaction date', 3, 'C', '99/99/9999', '99/99/9999', 15, '', ' ', '<$BUSDATE>', 'Y', 'N', 'Y', ' ', ' ', 'N', 'D', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '30', '1509', 'DESC', 'Mô tả', 'Description', 30, 'C', ' ', ' ', 500, '', ' ', '', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 100, 1);COMMIT;