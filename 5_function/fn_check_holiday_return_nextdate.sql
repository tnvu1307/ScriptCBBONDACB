SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_holiday_return_nextdate(p_date date)
return date
is
l_nextdate date;
v_holiday varchar2(1);
BEGIN
     select holiday into v_holiday from sbcldr where sbdate = p_date;
     if v_holiday = 'Y' then
        l_nextdate := fn_get_nextdate(p_date,1);
     end if;
    return l_nextdate;
exception when others then
    return p_date ; 
end;
/
