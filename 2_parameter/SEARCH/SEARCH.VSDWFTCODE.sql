SET DEFINE OFF;
select mt.AUTOID, mt.SYMBOL, mt.VSDWFTCODE, a.CDCONTENT VSDMSGTYPE
from VSD_MT598_ISSU mt
left join (select * from allcode where cdname = ''VSDTYPE_598'') a on mt.VSDMSGTYPE = a.CDVAL', 'VSDWFTCODE', 'frmMT598', 'AUTOID DESC', '', 0, 50, 'N', 30, '', 'Y', 'T', '', 'N', '', '');