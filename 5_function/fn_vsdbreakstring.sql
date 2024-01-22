SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_vsdbreakstring (p_string in varchar2,p_maxlength in number) return varchar2 is
l_oldstring varchar2(4000);
l_newstring varchar2(4000);
l_newrow varchar2(4000);
begin
    l_oldstring := fn_convertutf8totelex(p_string);
    l_newstring := '';
    l_newrow    := '';
    FOR rec IN (
                SELECT REGEXP_SUBSTR (l_oldstring,
                                         '[^ ]+',
                                         1,
                                         LEVEL)
                             TXT
                        FROM DUAL
                        CONNECT BY REGEXP_SUBSTR (l_oldstring,
                                         '[^ ]+',
                                         1,
                                         LEVEL)
                             IS NOT NULL
            )
            LOOP

                if length(l_newrow) + LENGTH(' ') + length(trim(rec.txt)) <= p_maxlength then
                    IF l_newrow IS NULL OR l_newrow = '' THEN
                        l_newrow := l_newrow || rec.txt;
                    else
                        l_newrow := l_newrow ||' '|| trim(rec.txt);
                    END IF;
                else
                    IF l_newstring IS NULL OR l_newstring = '' THEN
                        l_newstring := l_newrow;
                    else
                        l_newstring := l_newstring||chr(10)||l_newrow;
                    END IF;
                    l_newrow := trim(rec.txt);
                end if;
            END LOOP;
            IF l_newstring IS NULL OR l_newstring = '' THEN
                l_newstring := l_newrow;
            else
                l_newstring := l_newstring||chr(10)||l_newrow;
            END IF;
    l_newstring := REPLACE(l_newstring,chr(10)||chr(10),chr(10));
    return l_newstring;
exception
   when others then
     return p_string;

end;
/
