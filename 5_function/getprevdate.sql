SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getprevdate(p_date date, p_prevnum number)
return date
is
l_prevdate date;
begin
    --Tham khao ba0018
      SELECT MIN(SBDATE) INTO l_prevdate FROM (
    SELECT AUTOID,SBDATE FROM SBCLDR WHERE CLDRTYPE ='000' AND HOLIDAY='N' AND ROWNUM <=p_prevnum
              AND SBDATE <=(
                    SELECT MAX(SBDATE)
                            FROM SBCLDR
                            WHERE CLDRTYPE ='000' AND HOLIDAY='N'
                                  AND SBDATE < p_date)
            ORDER BY SBDATE DESC);
     return l_prevdate;
     -- SUA THEO CACH CUA GIANHVG -- 12-MAR-2012
    /* select sbdate into l_prevdate from sbcurrdate where numday=(
        select numday from sbcurrdate
        where sbdate= p_date and sbtype='B'
        ) - p_prevnum + 1
    and sbtype='B';*/
    return l_prevdate;
exception when others then
return p_date;
end;
/
