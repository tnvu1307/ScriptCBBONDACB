SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_Gebitcustomeronday(
    p_refcursor in out pkg_report.ref_cursor,
    p_custodycd    IN VARCHAR2,
    p_afacctno in varchar2,
    p_date in varchar2,
    p_type in number,
    p_tlid in varchar2
)
    is
    begin
        if p_type = 1 --- thong tin no trong ngay
        then
                open p_refcursor for
                    select 
                        0 dfmr,--- no MR
                        0 dfpay,-- no tra cham
                        0 dfguarantee,-- no bao lanh
                        0 dfmortage, -- no cam co
                        0 dfadvance, -- no ung truoc tien co tuc
                        0 totaldf
                    from dual;
        elsif p_type=2 --thong tin no den han/qua han thanh toan trong ngay
        then
            open p_refcursor for
                    select 
                        0 dfmr,--- no MR
                        0 dfpay,-- no tra cham
                        0 dfguarantee,-- no bao lanh
                        0 dfmortage, -- no cam co
                        0 dfadvance, -- no ung truoc tien co tuc
                        0 totaldf
                    from dual;
        else  -- du kien phat vay trong ngay
            open p_refcursor for
                    select 
                        0 dfmr,--- no MR
                        0 dfpay,-- no tra cham
                        0 dfguarantee,-- no bao lanh
                        0 dfmortage, -- no cam co
                        0 dfadvance, -- no ung truoc tien co tuc
                        0 totaldf
                    from dual;
        end if;
    
end pr_Gebitcustomeronday;
 
 
 
 
/
