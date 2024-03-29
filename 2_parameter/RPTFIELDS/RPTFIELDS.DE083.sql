SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('DE083','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'TXDATE', 'DE083', 'TXDATE', 'Đến ngày', 'To date', 0, 'D', '99/99/9999', 'DD/MM/YYYY', 10, '', '', '<$BUSDATE>', 'Y', 'N', 'Y', '', '', 'N', 'D', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'FRSICODE', 'DE083', 'FRSICODE', 'Từ mã CK', 'From code', 1, 'M', '', '', 40, 'SELECT ''000'' VALUECD, ''000'' VALUE, ''000'' DISPLAY, ''000'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT DT.* 
FROM
(
    SELECT SEC.SYMBOL VALUECD, SEC.SYMBOL VALUE, SEC.SYMBOL || '':'' || NVL(ISS.FULLNAME, '''') DISPLAY, SEC.SYMBOL EN_DISPLAY
    FROM SBSECURITIES SEC, ISSUERS ISS
    WHERE SEC.SECTYPE <> ''004''
    AND SEC.ISSUERID= ISS.ISSUERID
    AND INSTR(''WFT'', SEC.SYMBOL) = 0
    ORDER BY SEC.SYMBOL
) DT', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'TOSICODE', 'DE083', 'TOSICODE', 'Đến mã CK', 'From code', 2, 'M', '', '', 40, 'SELECT ''ZZZ'' VALUECD, ''ZZZ'' VALUE, ''ZZZ'' DISPLAY, ''ZZZ'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT DT.* 
FROM
(
    SELECT SEC.SYMBOL VALUECD, SEC.SYMBOL VALUE, SEC.SYMBOL || '':'' || NVL(ISS.FULLNAME, '''') DISPLAY, SEC.SYMBOL EN_DISPLAY
    FROM SBSECURITIES SEC, ISSUERS ISS
    WHERE SEC.SECTYPE <> ''004''
    AND SEC.ISSUERID= ISS.ISSUERID
    AND INSTR(''WFT'', SEC.SYMBOL) = 0
    ORDER BY SEC.SYMBOL DESC
) DT', '', '', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('ST', 'BRID', 'DE083', 'BRID', 'Sàn giao dịch', 'Trade place', 3, 'M', '', '', 10, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY FROM ALLCODE WHERE CDNAME = ''TRADEPLACE'' AND CDUSER = ''Y'' AND CDTYPE = ''ST''', '', '0008', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');COMMIT;