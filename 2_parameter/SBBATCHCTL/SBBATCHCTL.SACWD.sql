SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('SACWD','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS, EN_BCHTITLE) Values   ('3000', 'SA', 'SACWD', 'Chuyển ngày làm việc', 'EOD', 'BF', 'N', 'SACD', 'Chuyển ngày làm việc...', ' ', ' ', ' ', 0, 'DB', 'Y', 'Changer working date');COMMIT;