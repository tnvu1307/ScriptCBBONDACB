SET DEFINE OFF;
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE', 'Y', 'Y', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');
UNION ALL
SELECT ''2'' VALUE, ''2'' VALUECD,''2'' DISPLAY, ''2'' EN_DISPLAY FROM DUAL
UNION ALL
SELECT ''3'' VALUE, ''3'' VALUECD,''3'' DISPLAY, ''3'' EN_DISPLAY FROM DUAL', '', '1', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE', 'Y', 'N', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'C', 'N');