SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DEPOSIT_MEMBER','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('DEPOSIT_MEMBER', 'Quản lý thành viên lưu ký', 'Deposit member management', 'SELECT DEPOSITID, SHORTNAME, FULLNAME, OFFICENAME, ADDRESS, PHONE, FAX, DESCRIPTION, BICCODE, INTERBICCODE
FROM DEPOSIT_MEMBER 
WHERE 0=0', 'DEPOSIT_MEMBER', 'frmDEPOSIT_MEMBER', '', '', 0, 5000, 'N', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;