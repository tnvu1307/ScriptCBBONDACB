SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE set_holiday
   ( p_Day IN VARCHAR2,
     p_IsHoliday IN VARCHAR2,
     p_CLDRType IN VARCHAR2
   )
   IS
--
-- To modify this template, edit file PROC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------

V_NEXTDATE    VARCHAR2(20);
V_CURRDATE    VARCHAR2(20);

BEGIN


    -- Set holiday
    UPDATE SBCLDR
    SET HOLIDAY = p_isHoliday
    WHERE SBDATE = to_date(p_Day, 'DD/MM/RRRR') AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay dau tuan.
    -- xoa
    UPDATE SBCLDR SET SBBOW = 'N'
    WHERE to_char(sbdate,'WW') = to_char(to_date(p_Day,'DD/MM/RRRR'),'WW')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBBOW <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBBOW = 'Y'
    WHERE SBDATE in (select min(SBDATE) from sbcldr
                    where to_char(sbdate,'WW') = to_char(to_date(p_Day,'DD/MM/RRRR'),'WW')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay dau thang.
    -- xoa
    UPDATE SBCLDR SET SBBOM = 'N'
    WHERE to_char(sbdate,'MM') = to_char(to_date(p_Day,'DD/MM/RRRR'),'MM')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBBOM <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBBOM = 'Y'
    WHERE SBDATE in (select min(SBDATE) from sbcldr
                    where to_char(sbdate,'MM') = to_char(to_date(p_Day,'DD/MM/RRRR'),'MM')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay dau nam.
    -- xoa
    UPDATE SBCLDR SET SBBOY = 'N'
    WHERE to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBBOY <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBBOY = 'Y'
    WHERE SBDATE in (select min(SBDATE) from sbcldr
                    where to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay cuoi tuan.
    -- xoa
    UPDATE SBCLDR SET SBEOW = 'N'
    WHERE to_char(sbdate,'WW') = to_char(to_date(p_Day,'DD/MM/RRRR'),'WW')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBEOW <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBEOW = 'Y'
    WHERE SBDATE in (select max(SBDATE) from sbcldr
                    where to_char(sbdate,'WW') = to_char(to_date(p_Day,'DD/MM/RRRR'),'WW')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay cuoi thang.
    -- xoa
    UPDATE SBCLDR SET SBEOM = 'N'
    WHERE to_char(sbdate,'MM') = to_char(to_date(p_Day,'DD/MM/RRRR'),'MM')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBEOM <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBEOM = 'Y'
    WHERE SBDATE in (select max(SBDATE) from sbcldr
                    where to_char(sbdate,'MM') = to_char(to_date(p_Day,'DD/MM/RRRR'),'MM')
                    and to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- Set ngay cuoi nam.
    -- xoa
    UPDATE SBCLDR SET SBEOY = 'N'
    WHERE to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and SBEOY <> 'N';
    -- cap nhat lai
    UPDATE SBCLDR SET SBEOY = 'Y'
    WHERE SBDATE in (select max(SBDATE) from sbcldr
                    where to_char(sbdate,'RRRR') = to_char(to_date(p_Day,'DD/MM/RRRR'),'RRRR')
                    and CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE)
                    and holiday = 'N')
    AND CLDRTYPE = decode(p_CLDRTYPE,'999',CLDRTYPE,p_CLDRTYPE);

    -- cap nhat sysvar ngay lam viec tiep theo
    V_CURRDATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'CURRDATE');
    --Ngay lam viec tiep theo
    BEGIN
        SELECT TO_CHAR(MIN(SBDATE), 'DD/MM/RRRR')
        INTO V_NEXTDATE
        FROM SBCLDR
        WHERE CLDRTYPE = '000'
        AND HOLIDAY = 'N'
        AND SBDATE > TO_DATE(V_CURRDATE, SYSTEMNUMS.C_DATE_FORMAT);

        CSPKS_SYSTEM.PR_SET_SYSVAR('SYSTEM', 'NEXTDATE', V_NEXTDATE);
    EXCEPTION WHEN OTHERS THEN
        V_NEXTDATE := '';
    END;

EXCEPTION WHEN OTHERS THEN
    PLOG.ERROR ('SET_HOLIDAY: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    BEGIN
        rollback;
        raise;
        return;
    END;
END; -- Procedure
/
