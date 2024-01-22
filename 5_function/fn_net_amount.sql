SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_net_amount( pv_feetype varchar2, pv_amt NUMBER, pv_feeamt NUMBER)
    RETURN number IS
    v_netamt number(20,4);

   BEGIN
    v_netamt:=0;
    if pv_feetype = '3' then --3: phi trong
        v_netamt:= pv_amt - pv_feeamt;
    elsif pv_feetype = '1' then --1: phi ngoai
        v_netamt:= pv_amt;
    else
        v_netamt:=pv_amt;
    end if;

    RETURN v_netamt;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;

/
