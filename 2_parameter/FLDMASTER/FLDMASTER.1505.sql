SET DEFINE OFF;
FROM SBSECURITIES SEC
WHERE SEC.SECTYPE <> ''004''
ORDER BY SEC.SYMBOL', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'CODEID', '##########', '', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 15, 1);
FROM DEPOSIT_MEMBER D, 
(
    SELECT BICCODE FROM VSDBICCODE WHERE BRID = ''0001''
) S
WHERE D.BICCODE = S.BICCODE', '', '<$SQL>SELECT BICCODE DEFNAME FROM VSDBICCODE WHERE BRID = ''0001''', 'N', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'TYPE', '##########', '', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 25, 1);