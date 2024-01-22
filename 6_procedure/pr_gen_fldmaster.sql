SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_gen_fldmaster (p_searchcode varchar2,p_tltxcd varchar2)
         IS

       cursor v_cursor is
      SELECT lpad(column_id,2,'0') fldname,column_id,column_name,data_type,data_length,avg_col_len
          FROM user_tab_cols
          WHERE table_name = p_searchcode;
    v_row v_cursor%rowtype;
    v_modcode varchar2(200);
   BEGIN
        delete from tltx where tltxcd = p_tltxcd;
        begin
            select modcode into v_modcode from cmdmenu where objname = p_searchcode;
        exception when NO_DATA_FOUND
            then
                v_modcode:= '';
        end;
        insert into tltx
            (
               tltxcd, txdesc, en_txdesc, limit, offlineallow, ibt,
               ovrrqd, late, ovrlev, prn, local, chain, direct,
               hostacno, backup, txtype, nosubmit, delallow, feeapp,
               msqrqr, voucher, mnem, msg_amt, msg_acct, withacct,
               acctentry, bgcolor, display, bkdate, adjallow, glgp,
               voucherid, ccycd, runmod, restrictallow, refobj,
               refkeyfld, msgtype, chkbkdate, cfcustodycd, cffullname,
               visible, chgtypeallow, numbkdate, chksingle
            )
        select p_tltxcd tltxcd,s.searchtitle txdesc,s.en_searchtitle en_txdesc,0 limit,'Y' offlineallow,'N' ibt, 'Y', 0 late,2 ovrlev,'Y' PRN,'N' local, 'N' chain,'N',null hostacno,'Y' backup,'M',2 nosubmit
            ,'N' delallow,'N' feeapp,'N' msqrqr,'' voucher,'' mnem,'10' msg_amt,'00' msg_acct,'' withacct,'' acctentry,0 bgcolor,'Y' display,'N' bkdate,'Y' adjallow,'N' glgp,'' voucherid,
            '##'ccycd, 'DB' runmod,'N' restrictallow,'' refobj,'' refkeyfld,'' msgtype,'N' chkbkdate,'##' cfcustodycd,'##' cffullname,'Y' visible,'Y' chgtypeallow,0 numbkdate,'N' chksingle
        from search s
        where   s.searchcode = p_searchcode
        ;

       delete from fldmaster where objname = p_tltxcd;
       open v_cursor;
    loop
      fetch v_cursor
        into v_row;
      exit when v_cursor%notfound;

        insert into fldmaster
        (
           modcode, fldname, objname, defname, caption,
           en_caption, odrnum, fldtype, fldmask, fldformat,
           fldlen, llist, lchk, defval, visible, disable,
           mandatory, amtexp, validtag, lookup, datatype,
           invname, fldsource, flddesc, chainname, printinfo,
           lookupname, searchcode, srmodcode, invformat, ctltype,
           riskfld, grname, tagfield, tagvalue, taglist,
           tagquery, pdefname, tagupdate, fldrnd, subfield,
           pdefval, defdesc, defparam, chkscope, fldwidth,
           fldrow
        )
            select cm.modcode modecode,v_row.fldname,p_tltxcd objname,sf.fieldcode defname,sf.fieldname caption,sf.en_fieldname en_caption,sf.position odrnum,sf.fieldtype fldtype,sf.format fldmask,
                    sf.format fldformat,sf.fieldsize fldlen,null,null lchk, (case when sf.fieldtype = 'N' then '0' else '' end) defval,sf.display visible, 'N','N','' amtexp,null,'N',sf.fieldtype datatype,
                    '' invname,null,null,null,'##########' printinfo,null,null,null,null,'T','N' riskfld,'MAIN' grname,'' tagfield,null,null,'N' tagquery,null,'Y' tagupdate,(case when sf.fieldtype = 'N' then '0' else '' end) fldrnd,'N' subfield,null,null,
                    null defparam,'N' chkscope,'30' fldwidth,1 fldrow
                from searchfld sf ,cmdmenu cm
                where   sf.searchcode = cm.objname
                    and sf.searchcode = p_searchcode
                    and sf.position = v_row.column_id
        ;
        update searchfld set fldcd = v_row.fldname where position = v_row.column_id and searchcode = p_searchcode ;
    end loop;
    INSERT INTO FLDMASTER (MODCODE,FLDNAME,OBJNAME,DEFNAME,CAPTION,EN_CAPTION,ODRNUM,FLDTYPE,FLDMASK,FLDFORMAT,FLDLEN,LLIST,LCHK,DEFVAL,VISIBLE,DISABLE,MANDATORY,AMTEXP,VALIDTAG,LOOKUP,DATATYPE,INVNAME,FLDSOURCE,FLDDESC,CHAINNAME,PRINTINFO,LOOKUPNAME,SEARCHCODE,SRMODCODE,INVFORMAT,CTLTYPE,RISKFLD,GRNAME,TAGFIELD,TAGVALUE,TAGLIST,TAGQUERY,PDEFNAME,TAGUPDATE,FLDRND,SUBFIELD,PDEFVAL,DEFDESC,DEFPARAM,CHKSCOPE,FLDWIDTH,FLDROW)
    VALUES (v_modcode,'30',p_tltxcd,'DESC','Dien giai','Description',99,'C',' ',' ',50,' ',' ','','Y','N','N',' ',' ','N','C',null,null,null,null,'##########',null,null,null,null,'T','N','MAIN',null,null,null,'N',null,'Y',null,'N',null,null,null,'N',30,1);
    update search set tltxcd = p_tltxcd where searchcode = p_searchcode;


   end ;
/
