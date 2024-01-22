SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getfuturedate
  ( p_OVERDUEDATE IN date,
    p_todate IN date)
  RETURN  number IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
l_returndate number;
BEGIN

    l_returndate:=0;
    select count(*) into l_returndate
    from sbcldr
    where CLDRTYPE = '000' --and holiday='N'
    and sbdate > p_OVERDUEDATE and sbdate <= p_todate;


    return l_returndate;
EXCEPTION
    WHEN others THEN
    plog.error(sqlerrm || dbms_utility.format_error_backtrace);
    return '';
END;
/
