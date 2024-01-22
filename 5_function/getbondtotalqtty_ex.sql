SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GETBONDTOTALQTTY_EX(LISTQTTY NUMBER,bond_codeid varchar2)
  RETURN  NUMBER
-- Lua chon Ma trai phieu, Load ra LISTINGQTTY

  IS
    v_COUPON NUMBER(20,4);
    v_currdate varchar2(100);
   -- Declare program variables as shown above
BEGIN


    SELECT LISTQTTY * TO_NUMBER(SB.parvalue)
    INTO v_COUPON
    FROM sbsecurities SB
        WHERE CODEID = bond_codeid;
    RETURN v_COUPON;

EXCEPTION
   WHEN others THEN
    RETURN 0;
END;

 
 
 
 
 
/
