SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getnextdate2(p_date date, p_nextnum number)
return date
-------------------------------------------------
-----Lay ngay lam viec tiep theo-----------------
-------------------------------------------------
is
    v_nextwrkdate date;
begin
    SELECT MAX(SBDATE) INTO v_nextwrkdate
    FROM (
        SELECT AUTOID,SBDATE
        FROM SBCLDR
        WHERE CLDRTYPE ='000'
        AND HOLIDAY='N'
        AND SBDATE > p_date
        ORDER BY SBDATE ASC
    ) WHERE ROWNUM <= p_nextnum;
     return v_nextwrkdate;
exception
when others then
return p_date;
end;

/
