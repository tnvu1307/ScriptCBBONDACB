SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_length100_description (P_DESCRIPTION VARCHAR2) RETURN VARCHAR2 IS


BEGIN

    IF LENGTH2(P_DESCRIPTION) >= 100 THEN
        return '-1';
    END IF;
    RETURN '0';
EXCEPTION WHEN OTHERS THEN
    RETURN '-1';
END fn_length100_description;
/
