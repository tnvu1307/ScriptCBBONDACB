SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_get_cashhold (PV_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR,
TellerId varchar2, BranchId varchar2, SearchFilter varchar2)
is
v_sql clob;
begin

    if TellerId='0001' THEN --Admin he thong
        v_sql:='SELECT  TXNUM,TXDESC,CCYCD,AMOUNT,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE
           FROM (
                 SELECT    l.txnum,x.txdesc,f.bankacctno,f.ccycd,l.msgamt amount,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note, l.cfcustodycd custodycd
              FROM   tllog l,
                     tltx x,
                     famembers m,
                     famembersextra mx1,
                     famembersextra mx2,
                      tlprofiles p,
                     (  SELECT   txnum,
                                 MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  memberid,
                                 MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
                                 MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
                                 MAX (CASE WHEN f.fldcd = ''20'' THEN f.cvalue ELSE '''' END)  ccycd,
                                 MAX (CASE WHEN f.fldcd = ''93'' THEN f.cvalue ELSE '''' END)  bankacctno,
                                 MAX (CASE WHEN f.fldcd = ''30'' THEN f.cvalue ELSE '''' END)  note
                          FROM   tllogfld f
                         WHERE   fldcd IN (''05'', ''06'', ''07'', ''20'', ''93'',''30'')
                      GROUP BY   txnum) f
             WHERE       l.txnum = f.txnum and l.tlid = p.tlid
                     AND f.memberid = m.autoid
                     AND mx1.autoid = f.brname
                     AND mx2.autoid = f.brphone
                     AND l.tltxcd IN (''6690'',''6691'',''6693'', ''6692'')
                     AND l.tltxcd = x.tltxcd  ) where 0=0  ';
    else --User thong thuong
        v_sql:='SELECT  TXNUM,TXDESC,CCYCD,AMOUNT,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE
           FROM (
                 SELECT    l.txnum,x.txdesc,f.bankacctno,f.ccycd,l.msgamt amount,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note, l.cfcustodycd custodycd
              FROM   tllog l,
                     tltx x,
                     famembers m,
                     famembersextra mx1,
                     famembersextra mx2,
                      tlprofiles p,
                     (  SELECT   txnum,
                                 MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  memberid,
                                 MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
                                 MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
                                 MAX (CASE WHEN f.fldcd = ''20'' THEN f.cvalue ELSE '''' END)  ccycd,
                                 MAX (CASE WHEN f.fldcd = ''93'' THEN f.cvalue ELSE '''' END)  bankacctno,
                                 MAX (CASE WHEN f.fldcd = ''30'' THEN f.cvalue ELSE '''' END)  note
                          FROM   tllogfld f
                         WHERE   fldcd IN (''05'', ''06'', ''07'', ''20'', ''93'',''30'')
                      GROUP BY   txnum) f
             WHERE       l.txnum = f.txnum and l.tlid = p.tlid
                     AND f.memberid = m.autoid
                     AND mx1.autoid = f.brname
                     AND mx2.autoid = f.brphone
                     AND l.tltxcd IN (''6690'', ''6692'')
                     AND l.tltxcd = x.tltxcd  ) where 0=0

';
    end if;
    dbms_output.put_line('v_sql:' || v_sql);
    if length(SearchFilter)>0 then
        v_sql := v_sql || ' AND ' || SearchFilter;
    end if;
    open PV_REFCURSOR for v_sql;
EXCEPTION
  WHEN others THEN -- caution handles all exceptions
   plog.error('ERROR: ' || SQLERRM || dbms_utility.format_error_backtrace);
end;
/
