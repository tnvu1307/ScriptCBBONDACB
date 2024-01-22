SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_resetdploantype(p_ISTRFBUY In VARCHAR2, p_DPLNTYPE in VARCHAR2) RETURN VARCHAR2
IS
    v_Result  VARCHAR2(20);
    v_CompanySourceID VARCHAR2(20);
BEGIN


    If p_ISTRFBUY ='N' then
        v_Result := '';
    Else
        v_Result := p_DPLNTYPE;
    End If;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;

 
 
 
/
