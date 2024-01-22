SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PRC_BACKUPDAT_EOD IS
-- PERSON       DATE                COMMENTS
-- ---------   ------  -------------------------------------------
-- TRUONGLD     31-08-2015           CREATED
    l_CurrDate date;
Begin

    l_CurrDate := sysdate;
    

  EXCEPTION
  WHEN OTHERS THEN
      
      return;

  END ;
 
 
/
