SET DEFINE OFF;
CREATE OR REPLACE TRIGGER TRG_CIREMITTANCE_BEFORE 
 BEFORE
  INSERT
 ON ciremittance
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
BEGIN
  :NEW.autoid := seq_CIREMITTANCE.NEXTVAL;
END;
-- End of
/
