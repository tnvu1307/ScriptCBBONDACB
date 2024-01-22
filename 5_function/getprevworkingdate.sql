SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getprevworkingdate (f_indate date)
return date
-------------------------------------------------
-----Lay ngay lam viec truoc do-----------------
-------------------------------------------------
is
    v_prevwrkdate date;
begin
    select max(sbdate) into v_prevwrkdate from sbcldr where sbdate < f_indate and holiday='N' and cldrtype='000';
    return v_prevwrkdate;
exception
when others then
return f_indate;
end;
 
 

/
