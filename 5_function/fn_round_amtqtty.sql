SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_ROUND_AMTQTTY( pv_input IN NUMBER, pv_type IN NUMBER, pv_round IN NUMBER)
    RETURN number IS
BEGIN
    --pv_input: so can lam tron
    --pv_type: loai lam tron, 1: len. 2: xuong. 0: chuan
    --pv_round: lam tron bao nhieu so

    IF pv_type = 1 THEN --len
        return CEIL(pv_input * POWER(10, pv_round))/POWER(10, pv_round);
    ELSIF pv_type = 2 THEN --xuong
        return FLOOR(pv_input * POWER(10, pv_round))/POWER(10, pv_round);
    ELSE --chuan
        return ROUND(pv_input, pv_round);
    END IF;
    RETURN 0;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
