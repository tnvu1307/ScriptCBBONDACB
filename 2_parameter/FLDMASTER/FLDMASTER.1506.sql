SET DEFINE OFF;
FROM DEPOSIT_MEMBER D, 
(
    SELECT BICCODE FROM VSDBICCODE WHERE BRID = ''0001''
) S
WHERE D.BICCODE = S.BICCODE', ' ', '<$SQL>SELECT BICCODE DEFNAME FROM VSDBICCODE WHERE BRID = ''0001''', 'N', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'TYPE', '##########', '88VSDBICCODE', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 25, 1);