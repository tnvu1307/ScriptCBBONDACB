SET DEFINE OFF;
       nvl(D.BICCODE, ''XXAAXXAA'') VALUE,
       DEPOSITID||''-''||D.FULLNAME DISPLAY,
       DEPOSITID||''-''||D.FULLNAME EN_DISPLAY,
       DEPOSITID||''-''||D.FULLNAME DESCRIPTION
FROM DEPOSIT_MEMBER D
ORDER BY D.SHORTNAME', ' ', '<$SQL>SELECT nvl(D.BICCODE, ''XXAAXXAA'') DEFNAME
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE
ORDER BY D.SHORTNAME', 'Y', 'Y', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'TYPE', '##########', '', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 30, 1);