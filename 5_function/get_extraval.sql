SET DEFINE OFF;
CREATE OR REPLACE FUNCTION get_extraval(EXTRACD VARCHAR2,IPHONE VARCHAR2 DEFAULT '',BBROKERNAME VARCHAR2 DEFAULT '')
return VARCHAR2
is
V_RESULT VARCHAR2(1000);
begin
    IF EXTRACD = 'B' THEN
        V_RESULT:= BBROKERNAME;
    ELSE
        V_RESULT := IPHONE;
    END IF;
    RETURN V_RESULT;

  EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
end GET_EXTRAVAL;
/
