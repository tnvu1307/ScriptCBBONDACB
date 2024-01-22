SET DEFINE OFF;
CREATE OR REPLACE FUNCTION get_selling_amount(P_CODEID VARCHAR2, P_QTTY NUMBER, P_INTERESTRATE NUMBER, P_17QTTY NUMBER)
return number
is
v_parvalue NUMBER;
v_interestrate number;
v_qtty number;
begin
    IF NVL(P_17QTTY, 0) > 0 THEN
        RETURN NVL(P_17QTTY, 0);
    END IF;
    v_qtty := nvl(P_QTTY,0);
    SELECT PARVALUE INTO v_parvalue from SBSECURITIES where CODEID=P_CODEID;
    return NVL(v_parvalue * v_qtty + v_parvalue * v_qtty * P_INTERESTRATE, 0);
EXCEPTION WHEN OTHERS THEN
    RETURN 0;
end GET_SELLING_AMOUNT;
/
