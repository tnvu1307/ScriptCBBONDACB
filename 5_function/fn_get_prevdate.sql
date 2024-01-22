SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_prevdate(busdate IN DATE, clearday IN NUMBER)
return date
is
    pdate  DATE;
    l_prevdate date;
BEGIN
    IF clearday=0 THEN
        pdate:=busdate;
    ELSE
        SELECT sbdate
        INTO pdate
        FROM (SELECT ROWNUM DAY, cldr.sbdate
              FROM (SELECT   sbdate
                        FROM sbcldr
                       WHERE sbdate < busdate
                         AND holiday = 'N'
                         AND cldrtype = '001'
                    ORDER BY sbdate DESC) cldr) rl
         WHERE rl.DAY = clearday;
    END IF;
    RETURN pdate;
exception when others then
    RETURN SYSDATE;
end;
/
