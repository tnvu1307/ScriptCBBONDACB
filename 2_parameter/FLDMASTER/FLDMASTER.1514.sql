SET DEFINE OFF;
       nvl(d.biccode, ''XXAAXXAA'') VALUE,
       depositid||''-''||d.fullname DISPLAY,
       depositid||''-''||d.fullname EN_DISPLAY,
       depositid||''-''||d.fullname DESCRIPTION
  from deposit_member d
 order by d.shortname', ' ', 'U', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'TYPE', '##########', '', '', '', '', 'C', 'N', 'MAIN', '', '', '', 'N', '', 'Y', '', 'N', '', '', '', 'N', 20, 1);