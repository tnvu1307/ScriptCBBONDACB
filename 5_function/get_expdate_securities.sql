SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GET_EXPDATE_SECURITIES( p_ISSUEDATE IN VARCHAR2, p_TYPETERM IN VARCHAR2, p_TERM IN NUMBER)
    RETURN VARCHAR2 IS
    v_ISSUEDATE  DATE;
    v_Result     VARCHAR2(10);
BEGIN
    v_ISSUEDATE := TO_DATE(p_ISSUEDATE, SYSTEMNUMS.C_DATE_FORMAT);
    IF (p_TYPETERM = 'W') THEN
        v_ISSUEDATE := v_ISSUEDATE + (p_TERM*7);
    ELSIF (p_TYPETERM = 'M') THEN
        v_ISSUEDATE := ADD_MONTHS(v_ISSUEDATE,(p_TERM*1));
    ELSIF (p_TYPETERM = 'Y') THEN
        v_ISSUEDATE := ADD_MONTHS(v_ISSUEDATE,(p_TERM*12));
    elsif (p_TYPETERM = 'D') THEN
        v_ISSUEDATE := v_ISSUEDATE + (p_TERM);
    END IF;
    v_Result := TO_CHAR(v_ISSUEDATE, SYSTEMNUMS.C_DATE_FORMAT);
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '//';
END;
/