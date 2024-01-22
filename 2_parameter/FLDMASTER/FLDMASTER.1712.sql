SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1712','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '01', '1712', 'TRANDATE', 'Ngày giao dịch', 'Transaction date', 2, 'C', '99/99/9999', '99/99/9999', 15, '', ' ', '<$BUSDATE>', 'Y', 'Y', 'N', ' ', ' ', 'N', 'D', '', '', '', '', '##########', '55TRANDATE', '', '', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '02', '1712', 'SETTLEMENTDATE', 'Ngày thanh toán', 'Settle date', 3, 'C', '99/99/9999', '99/99/9999', 15, '', ' ', '<$BUSDATE>', 'Y', 'Y', 'N', ' ', ' ', 'N', 'D', '', '', '', '', '##########', '55SETTLEMENTDATE', '', '', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '10', '1712', 'QTTY', 'Tổng số lượng TPRL', 'Total quantity', 5, 'N', '999g999g999g999', '999g999g999g999', 15, '', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '55TOTALQTTY', '', '', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '11', '1712', 'AMOUNT', 'Tổng số tiền thanh toán', 'Total amount', 6, 'N', '999g999g999g999', '999g999g999g999', 15, '', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '55TOTALAMT', '', '', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 15, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '30', '1712', 'DESCC', 'Ghi chú', 'Note', 7, 'C', ' ', ' ', 35, '', ' ', '', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '55NOTE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 35, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '55', '1712', 'REFREQID', 'Số hiệu lệnh xác nhận', 'Ref requestid', 1, 'C', ' ', ' ', 20, '', ' ', '', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '', 'REQ1711CONF', 'SA', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 20, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '92', '1712', 'QTTYACC', 'Tổng số lượng TK', 'Quantity account', 4, 'N', '999g999g999g999', '999g999g999g999', 15, '', ' ', '0', 'Y', 'Y', 'N', ' ', ' ', 'N', 'N', '', '', '', '', '##########', '55TOTALACC', '', '', '', 'T', 'N', 'MAIN', '05', '', '', 'N', '', 'Y', '0', 'N', '', '', '', 'N', 15, 1);COMMIT;