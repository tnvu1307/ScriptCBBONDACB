SET DEFINE OFF;
DISPLAY, CDVAL||''-''||EN_CDCONTENT EN_DISPLAY, '''' 
DESCRIPTION
FROM ALLCODE WHERE CDNAME = ''RPTID'' AND CDTYPE=''ST'' AND 
CDUSER=''Y'' AND CDVAL IN (''CS070'',''CS077'')
ORDER BY LSTODR', ' ', ' ', 'Y', 'N', 'Y', ' ', ' ', 'Y', 'C', '', '', '', 'RPTID', '##########', '', '', 'SA', '', 'C', 'N', 'MAIN', '', '', '', 'N', 'P_RPTID', 'Y', '', 'N', '', '', '', 'N', 30, 1);