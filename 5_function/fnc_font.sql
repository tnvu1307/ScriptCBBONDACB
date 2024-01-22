SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FNC_FONT(v_IN IN Varchar2) Return Varchar2 is

   v_FontTV varchar2(500):='aa???a?????a?????ee???e?????ii??ioo???o?????o?????uu??uu??????y???dAA???A?????A?????EE???E?????II??IOO???O?????O?????UU??UU??????Y????';
   v_FontTA varchar2(500):='aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';
   i number;
   j number;
   v_Kq varchar2(500);
   v_result varchar2(500);
   
   BEGIN
    v_Kq:=v_In;
    For i in 1..length(v_In)
    Loop
       For j in 1..Length(v_FontTV)
       Loop
         If substr(V_IN,i,1)=substr(v_FontTV,j,1) Then
          v_Kq:=Replace(v_Kq,substr(v_FontTV,j,1),substr(v_FontTA,j,1));
         End if;
       End Loop;
       v_result :=v_Kq;
    End loop;
    Return v_result;

    Exception when others then
    v_Kq:=Null;
    return null;

    END;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
/