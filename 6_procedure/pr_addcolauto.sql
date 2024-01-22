SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PR_ADDCOLAUTO
IS
l_sql_query varchar2(1000);
begin
  FOR REC IN
        (
          select * from filemaster where filecode <>'tbli065'
        )
    LOOP
        begin
        l_sql_query:= 'alter table '|| rec.tablename|| ' add (AUTOID number,TLIDIMP VARCHAR2(10),  TLIDOVR VARCHAR2(10),TXTIME TIMESTAMP,IMPSTATUS VARCHAR2(2),  OVRSTATUS VARCHAR2(2))';
        execute immediate l_sql_query;
        exception
        when others then
            l_sql_query:= '';
        end;

    END LOOP;

  commit;
end;
 
 
 
 
/
