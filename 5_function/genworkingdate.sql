SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GENworkingdate (f_indate date)
return date
-------------------------------------------------
-----Lay ngay lam viec tiep theo-----------------
-------------------------------------------------
is
    v_nextwrkdate date;
    l_count NUMBER;
begin
    v_nextwrkdate := f_indate;
    select COUNT(sbcldr.holiday) into l_count
    from sbcldr
    where sbdate =  TO_DATE(f_indate,'DD/MM/RRRR' )
        and  sbcldr.holiday  = 'Y';

    IF l_count > 0 THEN
        select min(sbdate) into v_nextwrkdate
        from sbcldr
        where sbdate>f_indate
            and holiday='N'
            and cldrtype='000';
    END IF;

    RETURN v_nextwrkdate;
exception
when others then
    return getcurrdate + 99999; --28/02/2017 DieuNDA: Truong hop ngay lam viec bi loi
end;
 
 
/
