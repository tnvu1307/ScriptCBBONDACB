SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_num2text(l_Number in number)
return varchar2
AS
l_sNumber varchar2(4000);
l_Return varchar2(4000);
l_mLen number;
l_i number;
l_mDigit number;
l_mGroup number;
l_mTemp varchar2(4000);
l_mNumText varchar2(4000);
BEGIN


l_sNumber:=LTRIM(To_char(l_Number));
l_mLen := length(l_sNumber);
l_i:=1;
l_mTemp:='';

WHILE l_i <= l_mLen loop
    l_mDigit:=SUBSTR(l_sNumber, l_i, 1);
    IF l_mDigit=0 then l_mNumText := 'không';
        ELSIF l_mDigit=1 then l_mNumText:= 'một';
        ELSIF l_mDigit=2 then l_mNumText:= 'hai';
        ELSIF l_mDigit=3 then l_mNumText:= 'ba';
        ELSIF l_mDigit=4 then l_mNumText:= 'bốn';
        ELSIF l_mDigit=5 then l_mNumText:= 'năm';
        ELSIF l_mDigit=6 then l_mNumText:= 'sáu';
        ELSIF l_mDigit=7 then l_mNumText:= 'bảy';
        ELSIF l_mDigit=8 then l_mNumText:= 'tám';
        ELSIF l_mDigit=9 then l_mNumText:= 'chín';
    end if;


    l_mTemp := l_mTemp || ' ' || l_mNumText;

    IF (l_mLen = l_i) then
        EXIT;
    end if;

    l_mGroup :=mod((l_mLen - l_i) , 9);

    IF l_mGroup=0 then
        l_mTemp := l_mTemp || ' tỷ';

        If SUBSTR(l_sNumber, l_i + 1, 3) = '000' then
            l_i := l_i + 3;
        end if;

        If SUBSTR(l_sNumber, l_i + 1, 3) = '000'  then
            l_i := l_i + 3;
        end if;

        If SUBSTR(l_sNumber, l_i + 1, 3) = '000' then
            l_i := l_i + 3;
        end if;
    ELSIF l_mGroup=6 then
        l_mTemp := l_mTemp || ' triệu';

        If SUBSTR(l_sNumber, l_i + 1, 3) = '000' then
            l_i := l_i + 3;
        end if;

        If SUBSTR(l_sNumber, l_i + 1, 3) = '000' then
            l_i := l_i + 3;
        end if;
    ELSIF l_mGroup=3 then
        l_mTemp := l_mTemp || ' nghìn';
        If SUBSTR(l_sNumber, l_i + 1, 3) = '000' then
            l_i := l_i + 3;
        end if;
    ELSE
        l_mGroup:=mod((l_mLen - l_i) , 3);
        IF l_mGroup=2 then
            l_mTemp := l_mTemp || ' trăm';
        ELSIF l_mGroup=1 then
            l_mTemp := l_mTemp || ' mươi';
        end if;
    end if;
    l_i:=l_i+1;
END LOOP;

--'Loai bo truong hop x00
l_mTemp := Replace(l_mTemp, 'không mươi không', '');

--'Loai bo truong hop 00x
l_mTemp := Replace(l_mTemp, 'không mươi ', 'linh ');

--'Loai bo truong hop x0, x>=2
l_mTemp := Replace(l_mTemp, 'mươi không', 'mươi');

--'Fix truong hop 10
l_mTemp := Replace(l_mTemp, 'một mươi', 'mười');

--'Fix truong hop x4, x>=2
l_mTemp := Replace(l_mTemp, 'mươi bốn', 'mươi tư');

--'Fix truong hop x04
l_mTemp := Replace(l_mTemp, 'linh bốn', 'linh tư');

--'Fix truong hop x5, x>=2
l_mTemp := Replace(l_mTemp, 'mươi năm', 'mươi lăm');

--'Fix truong hop x1, x>=2
l_mTemp := Replace(l_mTemp, 'mươi một', 'mươi mốt');

--'Fix truong hop x15
l_mTemp := Replace(l_mTemp, 'mười năm', 'mười lăm');

--'Bo ky tu space
l_mTemp := LTrim(l_mTemp);

--'Ucase ky tu dau tien
--l_Return:=UPPER(SUBSTR(l_mTemp, 1,1)) + SUBSTR(l_mTemp,2, 4000);
l_Return:=l_mTemp;

RETURN l_Return;
END;
 
 
/
