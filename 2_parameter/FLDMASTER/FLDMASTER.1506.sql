SET DEFINE OFF;DELETE FROM FLDMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1506','NULL');Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '06', '1506', 'AFACCTNO', 'Tiểu khoản', 'Sub account', 1, 'C', '9999.999999', '9999.999999', 10, '', '', ' ', 'N', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', 'AFACCTNO', '##########', '88AFACCTNO', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_ACCTNO', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '30', '1506', 'DESC', 'Mô tả', 'Description', 14, 'C', ' ', ' ', 500, '', ' ', '', 'Y', 'N', 'N', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '88DESC', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 500, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '31', '1506', 'IDCODE', 'CMND/GPKD/TradingCode', 'ID code', 3, 'C', ' ', ' ', 50, '', ' ', '', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '88IDCODE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 50, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '32', '1506', 'TRANTYPE', 'Loại chuyển khoản', 'Transfer type', 9, 'C', '', '', 25, 'SELECT A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION FROM ALLCODE A WHERE CDNAME = ''TRANTYPE'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'' ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', '', '##########', '88TRANTYPE', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_CODEID', 'Y', '', 'N', '', '', '', 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '38', '1506', 'ALTERNATEID', 'Loại hình cổ đông', 'Type of investors', 8, 'C', ' ', ' ', 25, 'SELECT A.CDVAL VALUECD, A.CDVAL VALUE, A.CDCONTENT DISPLAY, A.EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION FROM ALLCODE A WHERE CDNAME = ''VSDALTE'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'' ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', ' ', '##########', '88ALTERNATEID', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_LICENSEPLACE', 'Y', '', 'N', '', '', '', 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '40', '1506', 'COUNTRY', 'Quốc tịch', 'Nationality', 7, 'C', ' ', ' ', 25, 'SELECT CDCONTENT VALUECD, CDCONTENT VALUE, EN_CDCONTENT DISPLAY, A.EN_CDCONTENT EN_DISPLAY, EN_CDCONTENT DESCRIPTION FROM ALLCODE A WHERE CDNAME = ''NATIONAL'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'' ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '88COUNTRY', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_LICENSEPLACE', 'Y', '', 'N', '', '', '', 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '56', '1506', 'RECBICCODE', 'TVLK bên nhận', 'The transferee DM', 11, 'C', '999999', '999999', 10, '', 'Y', '', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'T', '', '', '', 'TYPE', '##########', '', 'DEPOSIT_MEMBER', 'SA', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '57', '1506', 'RECCUSTODY', 'Số tài khoản bên nhận', 'Custody code of the transferee DM', 12, 'C', ' ', ' ', 10, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', '', '##########', '88RECCUSTODY', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_BENEFACCT', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '58', '1506', 'VSDBICCODE', 'TVLK bên chuyển', 'Depository member transfer', 10, 'C', '999999', '999999', 25, 'SELECT D.BICCODE VALUE, D.BICCODE VALUECD,D.FULLNAME DISPLAY, D.FULLNAME EN_DISPLAY, D.FULLNAME DESCRIPTION 
FROM DEPOSIT_MEMBER D, 
(
    SELECT BICCODE FROM VSDBICCODE WHERE BRID = ''0001''
) S
WHERE D.BICCODE = S.BICCODE', ' ', '<$SQL>SELECT BICCODE DEFNAME FROM VSDBICCODE WHERE BRID = ''0001''', 'N', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'TYPE', '##########', '88VSDBICCODE', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 25, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '88', '1506', 'CUSTODYCD', 'Tài khoản lưu ký', 'Custody code', 0, 'C', '', '', 10, '', 'Y', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', 'CUSTODYCD', '##########', '', 'CUSTODYCD_CF', 'SA', '', 'T', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '90', '1506', 'CUSTNAME', 'Họ tên', 'Full name', 2, 'C', ' ', ' ', 500, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '88FULLNAME', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_CUSTNAME', 'Y', '', 'N', '', '', '', 'N', 500, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '91', '1506', 'ADDRESS', 'Ðịa chỉ', 'Address', 6, 'C', ' ', ' ', 500, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '88ADDRESS', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_ADDRESS', 'Y', '', 'N', '', '', '', 'N', 500, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '95', '1506', 'IDDATE', 'Ngày cấp', 'Issue date', 4, 'C', '99/99/9999', '99/99/9999', 10, '', ' ', '', 'Y', 'N', 'Y', ' ', ' ', 'N', 'D', '', '', '', '', '##########', '88IDDATE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_LICENSEDATEOLD', 'Y', '', 'N', '', '', '', 'N', 10, 1);Insert into FLDMASTER   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, CTLTYPE, RISKFLD, GRNAME, TAGFIELD, TAGVALUE, TAGLIST, TAGQUERY, PDEFNAME, TAGUPDATE, FLDRND, SUBFIELD, PDEFVAL, DEFDESC, DEFPARAM, CHKSCOPE, FLDWIDTH, FLDROW) Values   ('ST', '96', '1506', 'IDPLACE', 'Nơi cấp', 'Issue place', 5, 'C', ' ', ' ', 50, '', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'N', 'C', '', '', '', ' ', '##########', '88IDPLACE', '', '', '', 'T', 'N', 'MAIN', '', '', '', 'N', 'P_LICENSEPLACE', 'Y', '', 'N', '', '', '', 'N', 50, 1);COMMIT;