SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_processafterreject(p_tlid  varchar2, p_ATTR_TABLE varchar2, p_strClause varchar2,p_err_code in out varchar2)
is
    v_currdate          date;

    V_STRSQL            varchar2(20000);
    V_STRSQL_update     varchar2(20000);
    v_data_type         varchar2(30);
    v_strClause         varchar2(100);
    V_count             number(10);
    --v_codeidwft         VARCHAR2(10);

begin
    v_strClause := REPLACE(p_strClause,'=','_');
    v_strClause := REPLACE(v_strClause,'''','_');
    
    for rec in
    (
        select * FROM
        (
            select TABLE_NAME, RECORD_KEY, COLUMN_NAME, '' FROM_VALUE, '' TO_VALUE, ACTION_FLAG,
                 CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_DT, max(MAKER_TIME) MAKER_TIME, MOD_NUM
            from maintain_log
            WHERE TABLE_NAME = P_ATTR_TABLE
                 AND APPROVE_ID IS NULL and APPROVE_RQD = 'Y' --AND APPROVE_DT IS NULL AND APPROVE_TIME IS NULL
                 AND RECORD_KEY like p_strClause
                 and ACTION_FLAG in ('ADD','EDIT')
            group by TABLE_NAME, RECORD_KEY, COLUMN_NAME, ACTION_FLAG, CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_DT, MOD_NUM
            UNION all
            SELECT TABLE_NAME, RECORD_KEY, COLUMN_NAME, FROM_VALUE, TO_VALUE, ACTION_FLAG,
                 CHILD_TABLE_NAME, CHILD_RECORD_KEY, MAKER_DT, MAKER_TIME, MOD_NUM --, childrecord_column_key
             FROM MAINTAIN_LOG
             WHERE TABLE_NAME = P_ATTR_TABLE
                 AND APPROVE_ID IS NULL and APPROVE_RQD = 'Y' --AND APPROVE_DT IS NULL AND APPROVE_TIME IS NULL
                 AND RECORD_KEY like p_strClause
                 and ACTION_FLAG = 'EDIT'

        )
        ORDER BY MAKER_DT DESC, MAKER_TIME DESC, MOD_NUM DESC
    )
    LOOP
        V_STRSQL := '';

           

        IF REC.ACTION_FLAG = 'ADD' THEN
            if rec.child_table_name is not null THEN
                V_STRSQL := 'DELETE FROM ' || REC.CHILD_TABLE_NAME || ' WHERE ' || REC.CHILD_RECORD_KEY;
                
                EXECUTE IMMEDIATE V_STRSQL;

                IF rec.child_table_name='SBSECURITIES' THEN
                  --SELECT codeid INTO v_codeidwft FROM SBSECURITIES sbw WHERE EXISTS refcodeid in (select codeid from SBSECURITIES sb where  ) = rec.childrecord_column_key;

                   V_STRSQL := 'DELETE FROM SBSECURITIES sbw WHERE EXISTS(SELECT * FROM SBSECURITIES sb WHERE sb.CODEID = sbw.REFCODEID AND sb.'||REC.CHILD_RECORD_KEY||')';
                   
                EXECUTE IMMEDIATE V_STRSQL;

                   V_STRSQL := 'DELETE FROM SECURITIES_INFO WHERE ' || REC.CHILD_RECORD_KEY;
                   
                EXECUTE IMMEDIATE V_STRSQL;

                 V_STRSQL := 'DELETE FROM SECURITIES_TICKSIZE WHERE ' || REC.CHILD_RECORD_KEY;
                 
                EXECUTE IMMEDIATE V_STRSQL;

                 V_STRSQL := 'DELETE FROM SECURITIES_RATE WHERE ' || REC.CHILD_RECORD_KEY;
                 
                EXECUTE IMMEDIATE V_STRSQL;



                END IF;

                 /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/
                V_STRSQL_update := 'BEGIN ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                    ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                    ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME || ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME
                                    ||CHR(10)|| ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                --''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';
                
                EXECUTE IMMEDIATE V_STRSQL_update;
            else
                V_STRSQL := 'DELETE FROM ' || REC.TABLE_NAME || ' WHERE ' || REC.RECORD_KEY;
                
                EXECUTE IMMEDIATE V_STRSQL;

                 /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                '''  AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/
                --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                --'''  AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';

                V_STRSQL_update := 'BEGIN ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                    ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                    ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME
                                    ||CHR(10)|| ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || '''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                    ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                
                EXECUTE IMMEDIATE V_STRSQL_update;
            end if;
            --commit;
        ELSIF REC.ACTION_FLAG = 'EDIT' THEN
            if nvl(rec.from_value,'xxx') <> nvl(rec.to_value,'xxx') then
                if rec.child_table_name is null then
                    Select nvl(data_type,'VARCHAR2') into v_data_type
                    from user_tab_cols
                    where column_name = UPPER(REC.COLUMN_NAME) and table_name = UPPER(REC.TABLE_NAME);
                    IF (v_data_type = 'DATE') THEN
                        V_STRSQL := 'UPDATE ' || REC.TABLE_NAME || ' SET ' ||
                        REC.COLUMN_NAME || ' = TO_DATE (''' || REC.FROM_VALUE || ''',''DD/MM/RRRR'') WHERE ' || REC.RECORD_KEY;
                    ELSIF (v_data_type = 'VARCHAR2') THEN
                        V_STRSQL := 'UPDATE ' || REC.TABLE_NAME || ' SET ' ||
                        REC.COLUMN_NAME || ' = ''' || REC.FROM_VALUE || ''' WHERE ' || REC.RECORD_KEY;
                    ELSIF (v_data_type = 'CHAR') THEN
                        V_STRSQL := 'UPDATE ' || REC.TABLE_NAME || ' SET ' ||
                        REC.COLUMN_NAME || ' = ''' || REC.FROM_VALUE || ''' WHERE ' || REC.RECORD_KEY;
                    ELSE
                        V_STRSQL := 'UPDATE ' || REC.TABLE_NAME || ' SET ' ||
                        REC.COLUMN_NAME || ' = ' || REC.FROM_VALUE || ' WHERE ' || REC.RECORD_KEY;
                    END IF;

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                    approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''EDIT''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/

                    V_STRSQL_update := 'BEGIN ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME || ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME
                                        ||CHR(10)|| ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                    
                    --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    --''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''EDIT''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';
                    EXECUTE IMMEDIATE V_STRSQL_update;
                else
                    Select nvl(data_type,'VARCHAR2') into v_data_type
                    from user_tab_cols
                    where column_name = UPPER(REC.COLUMN_NAME) and table_name = UPPER(rec.child_table_name);
                    IF (v_data_type = 'DATE') THEN
                        V_STRSQL := 'UPDATE ' || rec.child_table_name || ' SET ' ||
                        REC.COLUMN_NAME || ' = TO_DATE (''' || REC.FROM_VALUE || ''',''DD/MM/RRRR'') WHERE ' || REC.CHILD_RECORD_KEY;
                    ELSIF (v_data_type = 'VARCHAR2') THEN
                        V_STRSQL := 'UPDATE ' || rec.child_table_name || ' SET ' ||
                        REC.COLUMN_NAME || ' = ''' || REC.FROM_VALUE || ''' WHERE ' || REC.CHILD_RECORD_KEY;
                    ELSIF (v_data_type = 'CHAR') THEN
                        V_STRSQL := 'UPDATE ' || rec.child_table_name || ' SET ' ||
                        REC.COLUMN_NAME || ' = ''' || REC.FROM_VALUE || ''' WHERE ' || REC.CHILD_RECORD_KEY;
                    ELSE
                        V_STRSQL := 'UPDATE ' || rec.child_table_name || ' SET ' ||
                        REC.COLUMN_NAME || ' = ' || REC.FROM_VALUE || ' WHERE ' || REC.CHILD_RECORD_KEY;
                    END IF;

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                    approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''EDIT'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/
                    --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    --''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND ACTION_FLAG = ''EDIT''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';
                    V_STRSQL_update := 'BEGIN ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || ''' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME
                                        ||CHR(10)|| ''' AND COLUMN_NAME = ''' || REC.COLUMN_NAME  || '''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                    
                    EXECUTE IMMEDIATE V_STRSQL_update;

                    Select count(*) into V_COUNT
                    from user_tab_cols
                    where column_name = 'CHSTATUS' and table_name = UPPER(rec.child_table_name);
                    if V_COUNT > 0 then
                        V_STRSQL_update := 'UPDATE ' || rec.child_table_name || ' SET CHSTATUS = ''C''  WHERE ' || REC.CHILD_RECORD_KEY;
                        EXECUTE IMMEDIATE V_STRSQL_update;
                    end if;
                end if;
                --COMMIT;
            end if;
        ELSIF REC.ACTION_FLAG = 'DELETE' THEN
            if rec.child_table_name is not null then
                SELECT COUNT(TABLE_NAME) INTO V_COUNT FROM USER_TABLES WHERE TABLE_NAME = REC.CHILD_TABLE_NAME || 'MEMO';
                if V_COUNT > 0 then
                    V_STRSQL := 'DELETE FROM ' || REC.CHILD_TABLE_NAME || ' WHERE ' || REC.CHILD_RECORD_KEY || ' AND (SELECT count(*) FROM ' || REC.CHILD_TABLE_NAME || 'MEMO WHERE ' || REC.CHILD_RECORD_KEY || ' ) > 0';

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    V_STRSQL := 'INSERT INTO ' || REC.CHILD_TABLE_NAME || ' (SELECT * FROM ' || REC.CHILD_TABLE_NAME || 'MEMO WHERE ' || REC.CHILD_RECORD_KEY || ' ) and rownum <= 1';

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    V_STRSQL := 'DELETE FROM ' || REC.CHILD_TABLE_NAME || 'MEMO WHERE ' || REC.CHILD_RECORD_KEY;

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                    approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND ACTION_FLAG = ''DELETE'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/
                    V_STRSQL_update := 'BEGIN ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || '''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || '''  AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' and APPROVE_RQD = ''Y'' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME || ''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME
                                        ||CHR(10)|| '''  AND ACTION_FLAG = ''ADD'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                    --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    --''' AND CHILD_TABLE_NAME = ''' || REC.CHILD_TABLE_NAME || ''' AND ACTION_FLAG = ''DELETE'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND CHILD_RECORD_KEY = ''' || Replace(REC.CHILD_RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';
                    
                    EXECUTE IMMEDIATE V_STRSQL_update;
                end if;
            else
                SELECT COUNT(TABLE_NAME) INTO V_COUNT FROM USER_TABLES WHERE TABLE_NAME = REC.TABLE_NAME || 'MEMO';
                if V_COUNT > 0 then
                    V_STRSQL := 'DELETE FROM ' || REC.TABLE_NAME || ' WHERE ' || REC.RECORD_KEY || ' AND (SELECT count(*) FROM ' || REC.TABLE_NAME || 'MEMO WHERE ' || REC.RECORD_KEY || ' ) > 0';

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    V_STRSQL := 'INSERT INTO ' || REC.TABLE_NAME || ' (SELECT * FROM ' || REC.TABLE_NAME || 'MEMO WHERE ' || REC.RECORD_KEY || ' )  and rownum <= 1';

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    V_STRSQL := 'DELETE FROM ' || REC.TABLE_NAME || 'MEMO WHERE ' || REC.RECORD_KEY;

                    
                    EXECUTE IMMEDIATE V_STRSQL;
                    /*V_STRSQL_update := 'UPDATE MAINTAIN_LOG SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''' ,
                    approve_time = to_char(SYSDATE,''hh24:mi:ss'') WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    ''' AND ACTION_FLAG = ''DELETE'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';*/
                    --V_STRSQL_update := 'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||
                    --''' AND ACTION_FLAG = ''DELETE'' AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''') || ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL ';
                     V_STRSQL_update := 'BEGIN ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'INSERT INTO  MAINTAIN_LOG_REJECT SELECT * FROM MAINTAIN_LOG '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||'''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'UPDATE MAINTAIN_LOG_REJECT SET APPROVE_DT = TO_DATE(sysdate, ''DD/MM/RRRR''), APPROVE_ID = ''' || p_tlid || ''', approve_time = to_char(SYSDATE,''hh24:mi:ss'') '
                                        ||CHR(10)||'WHERE TABLE_NAME = ''' || REC.TABLE_NAME ||'''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| '''  AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||' ; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'DELETE FROM MAINTAIN_LOG  WHERE TABLE_NAME = ''' || REC.TABLE_NAME
                                        ||CHR(10)|| '''  AND RECORD_KEY = ''' || Replace(REC.RECORD_KEY, '''', '''''')
                                        ||CHR(10)|| ''' AND APPROVE_ID IS NULL AND APPROVE_TIME IS NULL and APPROVE_RQD = ''Y'' and ACTION_FLAG = '''||rec.ACTION_FLAG||''' and MOD_NUM = '||rec.MOD_NUM||'; ';
                    V_STRSQL_update := V_STRSQL_update||CHR(10)||'END; ';
                    
                    EXECUTE IMMEDIATE V_STRSQL_update;
                end if;
            end if;
            COMMIT;
        ELSE
           COMMIT;
        END IF;
    END LOOP;
    p_err_code := 0;
exception when others then
    plog.error ('pr_ProcessAfterReject.Error: '|| SQLERRM || '--' || dbms_utility.format_error_backtrace);
    p_err_code := -1;
    return;
end;
/
