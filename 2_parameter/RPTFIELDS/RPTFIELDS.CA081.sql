SET DEFINE OFF;
FROM DEPOSIT_MEMBER D
JOIN (SELECT * FROM VSDBICCODE WHERE BRID=''0001'') V  ON V.BICCODE = D.BICCODE', 'Y', 'Y', 'Y', '', '', 'N', 'C', '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'T', 'N');