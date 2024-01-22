SET DEFINE OFF;DELETE FROM SEARCHFLD WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFOSEBLOCKID','NULL');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (1, 'VSDMSGID', 'Số hiệu tham chiếu phong tỏa CK', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'N', 'Y', 100, '', 'S? hi?u tham chi?u phong t?a CK', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (2, 'REQID', 'Mã yêu cầu', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'N', 'N', 100, '', 'Mã yêu c?u', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (3, 'SYMBOL', 'Mã CK', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Mã CK', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (3, 'CODEID', 'CODEID', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Mã CK', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (4, 'QTTY', 'Số lượng', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'S? lu?ng', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (5, 'CUSTODYCD', 'Tài khoản', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Account', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (6, 'VSDDEFDATE', 'Ngày yêu cầu', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'Y', 'Y', 'N', 100, '', 'Ngày yêu c?u', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (99, 'CONTRACTNO', 'CONTRACTNO', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Account', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (99, 'CONTRACTDATE', 'CONTRACTDATE', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Account', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (99, 'VSDSTOCKTYPE', 'VSDSTOCKTYPE', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Account', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');Insert into SEARCHFLD   (POSITION, FIELDCODE, FIELDNAME, FIELDTYPE, SEARCHCODE, FIELDSIZE, MASK, OPERATOR, FORMAT, DISPLAY, SRCH, KEY, WIDTH, LOOKUPCMDSQL, EN_FIELDNAME, REFVALUE, FLDCD, DEFVALUE, MULTILANG, ACDTYPE, ACDNAME, FIELDCMP, FIELDCMPKEY, ISPROCESS, QUICKSRCH, SUMMARYCD, CHKSCOPE) Values   (99, 'PLACEID', 'PLACEID', 'C', 'CFOSEBLOCKID', 100, '', 'LIKE,=', '', 'N', 'N', 'N', 100, '', 'Account', 'N', '', '', 'N', '', '', '', 'N', 'Y', '', '', 'N');COMMIT;