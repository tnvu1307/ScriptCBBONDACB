SET DEFINE OFF;
CREATE OR REPLACE FUNCTION rebuildStringETFbyCodeid( p_list varchar2)
    RETURN VARCHAR2 IS

v_string VARCHAR2(4000);
csr                SYS_REFCURSOR;
l_sql_query varchar2(3000);
v_new_list VARCHAR2(100);
v_final_list VARCHAR2(4000);
BEGIN
    FOR V_REC IN (

 SELECT trim(regexp_substr(p_list,  '[^#]+', 1, LEVEL)) str
                              FROM dual
                              CONNECT BY regexp_substr(p_list ,  '[^#]+' , 1, LEVEL) IS NOT NULL
                              )
    LOOP
    begin
        SELECT regexp_replace(V_REC.str, SUBSTR(V_REC.str,0,iNSTR(V_REC.str, '|')-1) , symbol,1,1) into v_new_list
        FROM sbsecurities
        where SUBSTR(V_REC.str,0,iNSTR(V_REC.str, '|')-1)=codeid;
        v_final_list:=v_final_list||v_new_list ||'#';
       end;

     END LOOP;
   RETURN v_final_list;

EXCEPTION
   WHEN OTHERS THEN
    RETURN null;
END;
/
