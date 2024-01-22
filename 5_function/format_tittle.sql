SET DEFINE OFF;
CREATE OR REPLACE FUNCTION format_tittle ( InputString IN VARCHAR2 )
RETURN  varchar2

IS
N_Index          NUMBER;
--N_Index2          NUMBER;
--N_Index3         NUMBER;
v_Char           CHAR(10);
V_PrevChar       CHAR(10);
--v_nextChar       CHAR(10);
V_OutputString   VARCHAR(255);
V_length        NUMBER;
--V_length2       NUMBER;
v_InputString   VARCHAR(255);
--v_debug VARCHAR(255);
--v_vitri VARCHAR(255);
v_String VARCHAR(255);
BEGIN
--v_debug:=0;
v_InputString:=trim(InputString);--bo khoang trang dau dong
V_OutputString:= LOWER(v_InputString);
N_Index:=  1;
V_length:= length(v_InputString);
--v_vitri:=0;
WHILE N_Index <= V_length
LOOP
    v_Char     := substr(v_InputString, N_Index, 1);
    V_PrevChar := CASE WHEN N_Index  = 1 THEN '(' --gan ky tu ac biet cho ky tu dau tien
                         ELSE substr(v_InputString, N_Index - 1, 1)
                    END;

    if V_PrevChar IN (';', ':', '!', '?', '.', '_', '-', '/', '&', '"', '(')-- or  (ASCII(V_PrevChar)>=48  and  ASCII(V_PrevChar)<=57)

    then
       while V_Char in (' ',';', ':', '!', '?', '.', '_', '-', '/', '&', '"', '(')

       loop
       N_Index := N_Index + 1;
       v_Char     := substr(v_InputString, N_Index , 1);
       V_PrevChar := substr(v_InputString, N_Index - 1, 1);

       END loop;

       V_OutputString := STUFF(V_OutputString,N_Index, 1,upper(v_Char ));
       --N_Index2:=1;
       --V_length2:=LENGTH(V_OutputString);
       /*while N_Index2<=V_length2
        loop
            v_Char     := substr(V_OutputString, N_Index, 1);
            v_nextChar     := substr(V_OutputString, N_Index+1, 1);

            if v_char = upper(v_char) and v_char not in (' ',';', ':', '!', '?', '.', '_', '-', '&', '"', '(',')')
            and ASCII(v_char)<=122 and ASCII(v_char)>=65
            then
                v_String:=v_char;
                N_Index3:=N_Index2;
                v_debug:=v_debug+1;
                --v_vitri:=N_Index2;
                while (N_Index3 <=V_length) and (v_nextChar not in (' ',')'))
                 loop

                    --v_String:=v_String||v_nextChar;
                    v_string:=replace((v_string||v_nextChar),chr(32), '');

                    v_nextChar:=substr(V_OutputString, N_Index3+1, 1);
                    --v_debug:=v_debug+1;
                    N_Index3:=N_Index3+1;
                 end loop;
                if LENGTH(v_String)>1 then v_vitri:=upper(v_String); end if;
                if upper(v_String)='VSD' --in('A/THQ','TH','CP','VSD/6036','B/THQ','TP','CP','SO','DANH','VSD','CK','CI','CA','DS','TK','GD','TCPH','TNCN','NG','HOSE','SGDCK','SP','DSKH','KK','A/LK','HNX','SMS','TT','UBCK','EXCEL','QTRR','UTTB','UNC','DF','CALL','TRIGGER','GL','MR+BL','T0','GIAO','MM/yyyy','GDKQ','NV','MG','QL','FO','PL','TTBT','CCQ','ATO','DOANH','NVKD','VSD/3011','VSD/3071','B/LK','VSD/3014','TTLK','REPO','BO')
                --and LENGTH(v_String)>1
                then
                    V_OutputString:=STUFF(V_OutputString,N_Index2,LENGTH(v_String),upper(v_String));
                    v_debug:=v_debug+1;
                end if;
                N_Index2:=N_Index3;
            end if;
            N_Index2:=N_Index2+1;
        end loop;
*/

    END if;

    N_Index := N_Index + 1;

END LOOP;
--v_vitri:=V_OutputString||' - '||v_vitri||' - '||v_debug;
RETURN V_OutputString;
    EXCEPTION
    WHEN others THEN return v_InputString;

END;
 
 
 
 
/
