SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbondintcoupon(bond_codeid varchar2)
  RETURN  number IS
-- Lua chon Ma trai phieu, load ra Lai Coupon tuong ung
--
-- ---------   ------  -------------------------------------------
   v_bondintcoupon number;
   -- Declare program variables as shown above
BEGIN
    SELECT intcoupon into v_bondintcoupon
        from sbsecurities where codeid = bond_codeid
            and SECTYPE IN ('003','006','222');
    RETURN v_bondintcoupon ;
EXCEPTION
   WHEN others THEN
    RETURN 0;
END;

 
 
 
 
 
 
 
 
 
 
/
