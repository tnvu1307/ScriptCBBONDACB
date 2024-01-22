SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_eval_amtexp(p_txnum IN VARCHAR2, p_txdate IN VARCHAR2, p_REFVAL IN VARCHAR2, p_FLDTYPE IN VARCHAR2)
  RETURN  varchar2
  IS
  TYPE v_CurTyp  IS REF CURSOR;
  c1        v_CurTyp;
  v_RETURN   varchar2(2000);
  v_RETURN2   varchar2(2000);
  v_EXPRESSION varchar2(250);
  strSql varchar2(500);
  v_msgid varchar2(50);
  v_txdate varchar2(50);
BEGIN
    If p_FLDTYPE = 'N' then
        v_RETURN :='0';
    else
        v_RETURN := '';
    end if;

    v_txdate := to_char(to_date(p_txdate,'DD/MM/RRRR'),'DD/MM/RRRR');
    IF NOT p_REFVAL IS NULL THEN
        BEGIN
            IF SUBSTR(p_REFVAL,1,1)='@' THEN
                BEGIN
                    --LAY TRUC TIEP GIA TRI
                    v_RETURN := SUBSTR(p_REFVAL,2);
                END;
            ELSIF SUBSTR(p_REFVAL,1,1) IN ('$', '#') THEN
                BEGIN
                    --LAY THEO MOT TRUONG TREEN MAN HINH
                    v_EXPRESSION := SUBSTR(p_REFVAL,2, 2);  --LAY MA TRUONG DU LIEU
                    BEGIN
                        SELECT (CASE WHEN CVALUE IS NULL THEN TO_CHAR(NVALUE) ELSE CVALUE END) INTO v_RETURN
                        FROM TLLOGFLD WHERE TXNUM=p_txnum AND TXDATE=TO_DATE(v_txdate,'DD/MM/RRRR') AND FLDCD=v_EXPRESSION;
                    EXCEPTION WHEN OTHERS THEN
                        SELECT (CASE WHEN CVALUE IS NULL THEN TO_CHAR(NVALUE) ELSE CVALUE END) INTO v_RETURN
                        FROM TLLOGFLDALL WHERE TXNUM=p_txnum AND TXDATE=TO_DATE(v_txdate,'DD/MM/RRRR') AND FLDCD=v_EXPRESSION;
                    END;
                END;
            ELSIF p_REFVAL = '<$BUSDATE>' THEN
                --BIEN HE THONG
                SELECT VARVALUE INTO v_RETURN FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE';
            ELSIF p_REFVAL = '<$TXNUM>' THEN
                --BIEN HE THONG
                SELECT p_txnum INTO v_RETURN FROM dual;
            ELSIF p_REFVAL = '<$TXNUM$TXDATE>' THEN
                SELECT p_txnum||VARVALUE INTO v_RETURN FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='CURRDATE';
            ELSIF p_REFVAL = '<$COMPANYNAME>' THEN
                --BIEN HE THONG
                SELECT VARVALUE INTO v_RETURN FROM SYSVAR WHERE GRNAME='SYSTEM' AND VARNAME='COMPANYNAME';
            ELSE
                BEGIN
                    --BIEU THUC TINH TOAN SO HOC
                    v_EXPRESSION := FN_CRB_BUILDAMTEXP(p_REFVAL, p_txnum, v_txdate);
                     OPEN c1 FOR 'SELECT TO_CHAR(' || v_EXPRESSION || ') AS RETVAL FROM DUAL';
                    FETCH c1 INTO v_RETURN;
                    CLOSE c1;
                END;
            END IF;
            IF SUBSTR(p_REFVAL,4,1) IN ('+') THEN
                BEGIN
                    --LAY THEO MOT TRUONG TREEN MAN HINH
                    v_EXPRESSION := SUBSTR(p_REFVAL,6, 2);  --LAY MA TRUONG DU LIEU
                    BEGIN
                        SELECT (CASE WHEN CVALUE IS NULL THEN TO_CHAR(NVALUE) ELSE CVALUE END) INTO v_RETURN2
                        FROM TLLOGFLD WHERE TXNUM=p_txnum AND TXDATE=TO_DATE(v_txdate,'DD/MM/RRRR') AND FLDCD=v_EXPRESSION;
                    EXCEPTION WHEN OTHERS THEN
                        SELECT (CASE WHEN CVALUE IS NULL THEN TO_CHAR(NVALUE) ELSE CVALUE END) INTO v_RETURN2
                        FROM TLLOGFLDALL WHERE TXNUM=p_txnum AND TXDATE=TO_DATE(v_txdate,'DD/MM/RRRR') AND FLDCD=v_EXPRESSION;
                    END;
                    v_RETURN:=v_RETURN||v_RETURN2;
                END;
            END IF;
        END;
    END IF;
    RETURN v_RETURN;
EXCEPTION WHEN OTHERS THEN
    RETURN '';
END;
/
