SET DEFINE OFF;
CREATE OR REPLACE FUNCTION buildamtexp(strAMTEXP IN varchar2,
    strTxnum IN VARCHAR2,
    strtxdate IN VARCHAR2)
  RETURN  varchar2
  IS
  v_strEvaluator varchar2(100);
  v_strElemenent  varchar2(20);
  v_lngIndex number(10,0);
  v_strNodedata varchar2(10);
BEGIN
    v_strEvaluator := '';
    v_lngIndex := 1;
    While v_lngIndex < Length(strAMTEXP) loop
        --Get 02 charatacters in AMTEXP
        v_strElemenent := substr(strAMTEXP, v_lngIndex, 2);
        if v_strElemenent in ( '++', '--', '**', '//', '((', '))') then
                --Operand
                v_strEvaluator := v_strEvaluator || substr(v_strElemenent,1,1);
        else
                --Operator
                select nvalue into v_strNodedata from tllogfld where txnum =strTxnum and txdate =to_date(strtxdate,'DD/MM/YYYY') and fldcd=v_strElemenent;
                v_strEvaluator := v_strEvaluator || v_strNodedata;
        End if;
        v_lngIndex := v_lngIndex + 2;
    end loop;
    RETURN v_strEvaluator;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '0';
END;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/
