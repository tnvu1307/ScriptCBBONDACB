SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9952','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('ST9952', 'Tra cứu file csv nhận từ VSD', 'Look up csv file received from VSD', 'SELECT DT2.*, A1.CDCONTENT CTRADEPLACE
FROM
(
    SELECT DT.*, TO_CHAR(DT.TIMECREATED, ''HH24:MI:SS'') TIMECREATE, 
        CASE WHEN NVL(SB.TRADEPLACE, ''099'') = ''001'' THEN ''0002''
             WHEN NVL(SB.TRADEPLACE, ''099'') = ''002'' THEN ''0001''
             WHEN NVL(SB.TRADEPLACE, ''099'') = ''005'' THEN ''0003''
             WHEN NVL(SB.TRADEPLACE, ''099'') = ''010'' THEN ''0004''
             WHEN NVL(SB.TRADEPLACE, ''099'') = ''099'' THEN ''0008''
         END
        TRADEPLACE
    FROM
    (
        SELECT AUTOID, FILENAME, TIMECREATED, TXDATE, RPTID, SETTDATE, VSDID, SYMBOL FROM VSD_CSVCONTENT_LOG
        UNION ALL
        SELECT AUTOID, FILENAME, TIMECREATED, TXDATE, RPTID, SETTDATE, VSDID, SYMBOL FROM VSD_CSVCONTENT_LOGHIST
    ) DT
    LEFT JOIN SBSECURITIES SB ON SB.SYMBOL = DT.SYMBOL
) DT2
LEFT JOIN ALLCODE A1 ON A1.CDTYPE = ''ST'' AND A1.CDNAME = ''TRADEPLACE'' AND A1.CDVAl = DT2.TRADEPLACE', 'CFMAST', 'frmMT598', 'TIMECREATED DESC', '', 0, 5000, 'Y', 30, 'NNNNYYYNNNN', 'Y', 'T', '', 'N', '', '');COMMIT;