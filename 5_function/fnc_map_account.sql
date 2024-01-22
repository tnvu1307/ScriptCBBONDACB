SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fnc_map_account(p_codeid VARCHAR2, p_subcd VARCHAR2 , p_refcd VARCHAR2, p_alias varchar2) RETURN VARCHAR
IS
BEGIN
RETURN p_codeid || '.' || p_subcd || '.' || p_refcd || '.' || p_alias;
END;
 
 
/
