SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getdaysfromtype
  ( p_fromdate date,
    p_todate date,
    p_caltype varchar2 DEFAULT 'N'
  )
  RETURN number IS
--
-- To modify this template, edit file FUNC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the function
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
   p_days                 number(20,0);
   p_holidays       varchar2(10);
   -- Declare program variables as shown above
BEGIN
    p_holidays := '%';
    if p_caltype = 'B' then
        p_holidays := 'N';
    end if;
    select count(1) into p_days
    from sbcldr
    where cldrtype = '000'
        and sbdate > p_fromdate and sbdate <= p_todate
        and holiday like p_holidays;
    RETURN p_days ;
EXCEPTION
   WHEN others THEN
       plog.error('Error' || SQLERRM || ' '||dbms_utility.format_error_backtrace);
END;
/
