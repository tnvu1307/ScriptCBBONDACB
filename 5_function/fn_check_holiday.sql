SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_holiday(p_date date)
return date
is
l_prevdate date;
v_holiday varchar2(1);
BEGIN
     select holiday into v_holiday from sbcldr where sbdate = p_date;
     if v_holiday = 'Y' then
        SELECT sbdate
        INTO l_prevdate
        FROM (SELECT ROWNUM DAY, cldr.sbdate
              FROM (SELECT   sbdate
                        FROM sbcldr
                       WHERE sbdate < p_date
                         AND holiday = 'N'
                         AND cldrtype = '001'
                    ORDER BY sbdate DESC) cldr) rl
         WHERE rl.DAY = 1;
     end if;
    return l_prevdate;
exception when others then
    return p_date ;
end;
/
