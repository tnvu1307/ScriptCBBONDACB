SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_biccode(P_BICCODE VARCHAR2)
return VARCHAR2
is
v_result VARCHAR2(100);
v_number number;
begin
  SELECT length(P_BICCODE) into v_number from dual;
  if v_number = 11 then
    v_result := 'True';
  else
    v_result := 'False';
  end if;
return v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
end;
/
