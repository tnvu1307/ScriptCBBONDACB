SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('VSDTXREQ','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('VSDTXREQ', 'Tra cứu thông tin chi tiết trạng thái điện gửi VSD', 'Manage the details of messages sent VSD', 'SELECT REQ.REQID,REQ.OBJNAME,SUBSTR(REQ.TRFCODE,1,3)TRFCODE,REQ.OBJKEY,REQ.TXDATE,REQ.MSGACCT,
(CASE WHEN REQ.OBJNAME = ''1704'' THEN REQ.NOTES ELSE CODE.<@CDCONTENT> || (CASE WHEN RDT2.CVAL IS NULL THEN '''' ELSE '' - '' || RDT2.CVAL END) END) NOTES,
(CASE WHEN REQ.AFACCTNO = ''0'' THEN '''' ELSE REQ.AFACCTNO END) AFACCTNO,
A5.<@CDCONTENT> MSGSTATUS,A5.CDVAL, REQ.VSD_ERR_MSG, REQ.CREATEDATE CREATEDATE, REQ.TLID, TL.TLNAME,
MT518.VSDPROMSG, MT518.VSDORDERID, TLG.SYMBOL, REQ.TXAMT, REQ.RECCUSTODYCD, MT518.<@CDCONTENT> SIDE, NVL(RDT.<@CDCONTENT>, RDT1.<@CDCONTENT>) SYMBOLTYPE
FROM VSDTXREQ REQ
INNER JOIN (SELECT TRFCODE, DESCRIPTION CDCONTENT, EN_DESCRIPTION EN_CDCONTENT FROM VSDTRFCODE) CODE ON REQ.TRFCODE = CODE.TRFCODE
LEFT JOIN (
    SELECT V.REQID, AC.CDCONTENT, AC.EN_CDCONTENT FROM VSDTXREQDTL V 
    LEFT JOIN (SELECT * FROM ALLCODE WHERE CDTYPE=''ST'' AND CDNAME =''VSDSTOCKTYPE'') AC 
    ON AC.CDVAL=V.CVAL WHERE FLDNAME =''VSDSTOCKTYPE''
) RDT ON RDT.REQID=REQ.REQID
LEFT JOIN (
    SELECT V.REQID, AC1.CDCONTENT, AC1.EN_CDCONTENT FROM VSDTXREQDTL V 
    LEFT JOIN (SELECT * FROM ALLCODE WHERE CDTYPE=''ST'' AND CDNAME =''VSDDEALTYPE'') AC1 
    ON AC1.CDVAL=V.CVAL WHERE (FLDNAME =''STOCKTYPE'' OR FLDNAME=''TYPE'')
) RDT1 ON RDT1.REQID=REQ.REQID
LEFT JOIN (
    SELECT * FROM VSDTXREQDTL WHERE FLDNAME in (''REPORTID'',''RPTID'')
) RDT2 ON RDT2.REQID=REQ.REQID
LEFT JOIN TLPROFILES TL ON REQ.TLID=TL.TLID 
LEFT JOIN (
    SELECT M518.*, A.CDCONTENT, A.EN_CDCONTENT FROM
    (
        SELECT AUTOID, VSDPROMSG, VSDMSGID, VSDORDERID FROM VSD_MT518_INF 
        UNION ALL 
        SELECT AUTOID, VSDPROMSG, VSDMSGID, VSDORDERID FROM VSD_MT518_INF_HIST
    ) M518
    LEFT JOIN (SELECT * FROM ALLCODE WHERE CDNAME = ''SIDE'' AND CDTYPE = ''ST'') A 
    ON CASE WHEN M518.VSDPROMSG LIKE ''%BUYI'' THEN 0 WHEN M518.VSDPROMSG LIKE ''%SELL'' THEN 1 ELSE 2 END = A.CDVAL
) MT518 ON REQ.REFCODE = TO_CHAR(MT518.AUTOID)
LEFT JOIN (SELECT * FROM ALLCODE WHERE CDNAME = ''VSDTXREQSTS'' AND CDTYPE = ''SA'') A5 ON A5.CDVAL = REQ.MSGSTATUS
LEFT JOIN (
    SELECT TL.TXNUM, TL.TXDATE, NVL(S.SYMBOL, CASE WHEN TL.CCYUSAGE = ''00'' THEN NULL ELSE TL.CCYUSAGE END) SYMBOL
    FROM TLLOG TL
    LEFT JOIN SBSECURITIES S ON TL.CCYUSAGE = S.CODEID
) TLG ON TLG.TXNUM = REQ.OBJKEY AND TLG.TXDATE = REQ.TXDATE', 'VSDTXREQ', 'frmVSDTXREQ', 'TXDATE DESC,REQID DESC', '', 0, 5000, 'Y', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;