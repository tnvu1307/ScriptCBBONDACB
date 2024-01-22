SET DEFINE OFF;
CREATE OR REPLACE function get_value_contract(P_CODEID VARCHAR2, P_QTTY NUMBER)
return number 
is
v_parvalue number;
begin
  SELECT PARVALUE INTO v_parvalue from SBSECURITIES where CODEID=P_CODEID;
return v_parvalue * P_QTTY;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
end;

/
