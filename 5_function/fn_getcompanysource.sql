SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getcompanysource(pv_RRTYPE In VARCHAR2, pv_CUSTBANK in VARCHAR2) RETURN VARCHAR2
IS
    v_Result  VARCHAR2(20);
    v_CompanySourceID VARCHAR2(20);
BEGIN
    dbms_output.put_line('pv_RRTYPE:' || pv_RRTYPE);
    dbms_output.put_line('pv_CUSTBANK:' || pv_CUSTBANK);

    begin
        Select VARVALUE into v_CompanySourceID from sysvar where GRNAME='DEFINED' and VARNAME='CUSTIDCMPSRC';
    exception
    when others then
        v_CompanySourceID := '';
    end;

    If pv_RRTYPE ='C' then
        v_Result := v_CompanySourceID;
    Else
        If pv_CUSTBANK = v_CompanySourceID then
            v_Result := '';
        Else
            v_Result := pv_CUSTBANK;
        End if;
    End If;

    dbms_output.put_line('v_Result:' || v_Result);
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;

 
 
 
/
