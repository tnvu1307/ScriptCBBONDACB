SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_nextdate(p_date date, p_prevnum number)
return date
is
l_prevdate date;
BEGIN

     select TO_DATE(sbdate,systemnums.c_date_format) into l_prevdate from sbcurrdate where numday=(
        select numday from sbcurrdate
        where sbdate= p_date and sbtype='B'
        ) + p_prevnum
    and sbtype='B';
    return l_prevdate;
exception when others then
    return p_date + p_prevnum; --28/02/2017 DieuNDA: TH p_prevnum la so qua lon thi ngay lam vieck tiep theo = p_date + p_prevnum do bang lich chua sinh du lieu
end;
/
