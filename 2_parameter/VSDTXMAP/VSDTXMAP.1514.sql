SET DEFINE OFF;DELETE FROM VSDTXMAP WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('1514','NULL');Insert into VSDTXMAP   (OBJTYPE, OBJNAME, TRFCODE, FLDREFCODE, FLDNOTES, AMTEXP, AFFECTDATE, FLDACCTNO, FLDKEYSEND, VALUESEND) Values   ('T', '1514', '542.NEWM.CLAS//CORP.STCO//DLWM', '', '$30', '$92', '<$TXDATE>', '$06', '', '');COMMIT;