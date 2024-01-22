SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbusinessdate(p_date IN varchar2)
return date
is
l_prevdate date;
v_check number;
begin
--nhap ngay ra ngay lam viec gan nhat
    select count(*) into v_check
    from sbcldr where sbcldr.holiday  = 'Y' and sbdate = TO_DATE(p_date,'DD/MM/RRRR') and cldrtype ='000';
    if v_check > 0 then
        select to_date(max(sbdate),'DD/MM/RRRR') into l_prevdate
        from sbcldr where  sbdate < TO_DATE(p_date,'DD/MM/RRRR') and cldrtype ='000' and sbcldr.holiday  = 'N';
    else
        l_prevdate := TO_DATE(p_date,'DD/MM/RRRR');
    end if;
    return l_prevdate;
exception when others then
return p_date;
end;
 
 
 
 
/
