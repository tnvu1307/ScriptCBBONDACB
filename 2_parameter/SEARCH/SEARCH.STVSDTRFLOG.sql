SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('STVSDTRFLOG','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT, CHKSCOPECMDSQL) Values   ('STVSDTRFLOG', 'Điện trả lời từ VSD', 'Reply from VSD', 'SELECT DA.*,A2.CDCONTENT TYPESTP
FROM
(
SELECT DISTINCT L.* , A.DISPLAY MSGSTATUS,
       (CASE WHEN LD.FLDVAL = ''REJT'' AND LENGTH(C.TRFCODE ) = 0 THEN ''CFN''
            WHEN LD.FLDVAL = ''PACK'' AND LENGTH(C.TRFCODE ) = 0 THEN ''CFO''
            WHEN LENGTH(C.TRFCODE ) >0 AND INSTR(C.TRFCODE,''NAK'')=0 THEN C.TYPE
            ELSE SUBSTR(L.FUNCNAME,LENGTH(L.FUNCNAME)-2) END) TYPE
FROM VSDTRFLOG L,VSDTRFCODE C,
(SELECT A.CDVAL VALUECD, A.CDVAL VALUE , A.CDCONTENT DISPLAY FROM ALLCODE A WHERE CDNAME =  ''VSDTRFLOGSTS'')A,
(SELECT * FROM VSDTRFLOGDTL WHERE FLDNAME = ''STATUS'') LD
WHERE L.STATUS = A.VALUE
AND L.FUNCNAME = C.TRFCODE(+)
AND L.AUTOID = LD.REFAUTOID(+)
AND REFERENCEID = ''<$KEYVAL>''
)DA,
(SELECT * FROM ALLCODE WHERE CDNAME =  ''VSDTRFLOGTYPE'' AND CDTYPE = ''ST'' AND CDUSER = ''Y'') A2
WHERE DA.TYPE = A2.CDVAL(+)', 'ST.TTDIENR', 'STVSDTRFLOG', '', '', 0, 5000, 'Y', 30, '', 'Y', 'T', '', 'N', '', '');COMMIT;