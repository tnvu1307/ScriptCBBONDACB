SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_vsdbreakstring_check_1711 (pv_string in varchar2) return number is
    l_count number;
begin
    select REGEXP_COUNT(pv_string, chr(10)) into l_count from dual;
    if l_count >= 10 then
        return -1;
    end if;
    return 0;
exception when others then
    return -1;
end;
/
