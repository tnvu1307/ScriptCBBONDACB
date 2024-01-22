SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getnextbusinessdate (p_frdate date, p_numday number)
return DATE
-------------------------------------------------
---Nhap vao ngay bat dau va so ngay den----------
---Tinh ra ngay lam viec tiep theo---------------
-------------------------------------------------
is
    v_nextwrkdate date;
begin
    -- select min(sbdate) into v_nextwrkdate from sbcurrdate where sbdate>=p_frdate+p_numday and sbtype='B';
    select sbdate into v_nextwrkdate from
    (
        select s.*, rownum-1 rid
        from (select * from sbcurrdate where sbdate >= p_frdate and sbtype='B' order by numday asc) s
    )
    where rid=p_numday
        and rownum<=1;
    return v_nextwrkdate;
exception
when others then
return null;
end;
 
 
/
