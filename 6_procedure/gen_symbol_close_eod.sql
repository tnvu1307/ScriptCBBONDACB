SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE GEN_SYMBOL_CLOSE_EOD (
   TRADING_DATE      IN       VARCHAR2
       )
IS

--
-- PURPOSE: LAY MA CK , GIA DONG CUA
-- MODIFICATION HISTORY
-- PERSON       DATE        COMMENTS
-- diennt        10-APR-2015 CREATED
-- ---------    ------      -------------------------------------------
v_trading_date DATE;
v_count number;
BEGIN
    v_trading_date :=to_date(TRADING_DATE,'DD/MM/YYYY');
    RETURN ;
    /*DELETE PHS_SE_CLOSE_EOD WHERE TRADING_DATE=v_trading_date;

    INSERT INTO PHS_SE_CLOSE_EOD(SYMBOL,MARKET,TRADING_DATE,CLOSE)
    SELECT SYMBOL,MARKET,TRADING_DATE,TO_NUMBER(CASE WHEN CLOSE =0 THEN prior_price ELSE CLOSE END)*1000 FROM share_intraday@REMOTEMARKETDB WHERE trading_date=v_trading_date;

    select count(*) into v_count
    from share_intraday@REMOTEMARKETDB WHERE trading_date=v_trading_date;

    */

/*EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
      ROLLBACK;*/
  EXCEPTION
  WHEN OTHERS THEN
      ROLLBACK;
      plog.error ('GEN_SYMBOL_CLOSE_EOD ERR: ' || SQLERRM || dbms_utility.format_error_backtrace);
  return;
END;
/
