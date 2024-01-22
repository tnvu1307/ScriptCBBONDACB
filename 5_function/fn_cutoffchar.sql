SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_cutoffchar (p_string in varchar2) return varchar2 is
    l_string varchar2(3200);
begin
    l_string := trim(l_string);
    l_string:= upper(p_string);
    l_string := REPLACE(l_string, '-','');
    l_string := REPLACE(l_string, ',','');
    l_string := REPLACE(l_string, '.','');
    l_string := REPLACE(l_string, ' ','');
    return l_string;
end;
 
 
/
