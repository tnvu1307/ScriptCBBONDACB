SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_payment_date(p_Type varchar2, p_Payday number, p_Prevdate date, p_Currdate date, p_Nextdate date)
return number
is
/*Ham check Ngay hien tai co phai la ngay thu no khong
    p_Type: AF: Neu ngay thu roi vao ngay nghi se thu vao ngay lam viec tiep theo
            BF: Neu ngay thu roi vao ngay nghi se thu vao ngay lam viec lien trc
    p_Payday: Ngay thu no
    p_Prevdate: Ngay lam viec lien trc
    p_Currdate: Ngay hien tai
    p_Nextdate: Ngay lam viec tiep theo
*/
    v_paydate       date;
    v_Checkdate     date;
begin
    IF p_Type = 'AF' THEN --Neu ngay Thu la ngay hien tai thi thu tai ngay HT, Neu ngay thu la ngay nghi thi thu tai ngay lam viec tiep theo

        IF to_number(to_char(p_Prevdate,'DD')) > p_Payday THEN
            v_Checkdate    := p_Currdate;
        ELSE
            v_Checkdate    := p_Prevdate;
        END  IF;

        -- Tinh ngay thu no
        v_paydate := least(
                            greatest(to_date(TO_CHAR(LEAST(p_Payday, to_char(last_day(v_Checkdate),'DD'))) || '/' || to_char(v_Checkdate,'MM/RRRR'),'DD/MM/RRRR'),
                                        trunc(v_Checkdate,'MM')),
                            last_day(v_Checkdate)
                        );

        IF (v_paydate > p_Prevdate and v_paydate <= p_Currdate)  THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;

    ELSIF p_Type = 'BF' THEN --Neu ngay Thu la ngay hien tai thi thu tai ngay HT, Neu ngay thu la ngay nghi thi thu tai ngay lam viec lien truoc

        v_Checkdate :=  p_Currdate;

        -- Tinh ngay thu no
        v_paydate := least(
                            greatest(to_date(TO_CHAR(LEAST(p_Payday, to_char(last_day(v_Checkdate),'DD'))) || '/' || to_char(v_Checkdate,'MM/RRRR'),'DD/MM/RRRR'),
                                        trunc(v_Checkdate,'MM')),
                            last_day(v_Checkdate)
                        );

        IF (v_paydate >= p_Currdate and v_paydate < p_Nextdate)  THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;



    END IF;


exception when others then
    
    plog.error ('fn_check_payment_date: '||SQLERRM || dbms_utility.format_error_backtrace);
    RETURN 0;
end;
/
