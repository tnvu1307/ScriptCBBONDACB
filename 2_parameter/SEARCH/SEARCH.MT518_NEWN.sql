SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MT518_NEWN','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('MT518_NEWN', 'Tra cứu điện thông báo từ VSD (518)', 'Manage notification messages from VSD (518)', 'SELECT MT.AUTOID, MT.VSDMSGID, MT.VSDMSGDATE, MT.VSDPROMSG, MT.VSDMSGTYPE, MT.VSDCUSTODYCD, MT.VSDSYMBOL, MT.VSDBICCODE, MT.VSDQUANTIY,
    ROUND(REPLACE(MT.VSDPRICE,''VND'',''''),0) VSDPRICE,
    ROUND(REPLACE(MT.VSDAMT,''VND'',''''),0) VSDAMT,
    MT.VSDORDERID, MT.VSDMSGPAYDATE, MT.VSDTXNUM, MT.VSDREQID, TRF.DESCRIPTION MTNAME,
    MT.CONFTXNUM, MT.CONFTXDATE, MT.CONFSTATUS, MT.CONFREQID, MT.CONFREQSTATUS, MT.CONFREQERROR, NVL(MT.STATUS, ''NEWM'') STATUS,
    MT.VSDID518CANC, A1.CDCONTENT CCONFREQSTATUS,
    MT.DESCRIPTION, A2.CDCONTENT STATUSTRANSACTION, A3.CDCONTENT SIDE
FROM (
    SELECT * FROM VSD_MT518_INF WHERE NVL(STATUS, ''NEWM'') = ''NEWM''
) MT
LEFT JOIN VSDTRFCODE TRF ON MT.VSDPROMSG = TRF.TRFCODE
LEFT JOIN ALLCODE A1 ON A1.CDNAME = ''VSDTXREQSTS'' AND A1.CDTYPE = ''SA'' AND A1.CDVAL = MT.CONFREQSTATUS
LEFT JOIN ALLCODE A2 ON A2.CDNAME = ''STATUSTRANSACTION'' AND A2.CDTYPE = ''ST'' AND A2.CDVAL = MT.STATUSTRANSACTION
LEFT JOIN ALLCODE A3 ON A3.CDNAME = ''SIDE'' AND A3.CDTYPE = ''ST'' AND (CASE WHEN MT.VSDPROMSG LIKE ''%BUYI'' THEN 0 WHEN MT.VSDPROMSG LIKE ''%SELL'' THEN 1 ELSE 2 END) = A3.CDVAL
WHERE MT.VSDPROMSG IN (''518.NEWM.BUSE//BUYI'',''518.NEWM.BUSE//SELL'')', 'MT518_NEWN', 'frmMT518_NEWN', '', '', 0, 5000, 'Y', 30, 'NNNNYYYNNNN', 'Y', 'T', '', 'N', '', '');COMMIT;