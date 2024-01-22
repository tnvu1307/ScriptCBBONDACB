SET DEFINE OFF;
CREATE OR REPLACE FUNCTION IS_NUMBER (P_STRING IN VARCHAR2)
   RETURN NUMBER
IS
   V_NEW_NUM NUMBER;
   C_STRING VARCHAR2(1000);
BEGIN
    C_STRING := NVL(REPLACE(P_STRING, ',', ''), '0');
    V_NEW_NUM := TO_NUMBER(C_STRING);
    RETURN V_NEW_NUM;
EXCEPTION WHEN VALUE_ERROR THEN
   RETURN 0;
END IS_NUMBER;
/