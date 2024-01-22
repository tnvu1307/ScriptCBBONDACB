SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_prchk
  IS
--
-- To modify this template, edit file PKGSPEC.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter package declarations as shown below


  FUNCTION fn_AutoPRTxProcess(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_prAutoCheck(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_prAutoUpdate(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAutoCheck(p_txmsg in  tx.msg_rectype, p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAutoUpdate(p_txmsg in  tx.msg_rectype, p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAdhocCheck(p_id IN VARCHAR2,
              p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
              p_refid IN VARCHAR2,
              p_qtty IN NUMBER, p_amt IN NUMBER,
              p_brid IN VARCHAR2,
              p_type in VARCHAR2, p_actype IN VARCHAR2,
              p_txnum IN VARCHAR2, p_txdate IN DATE,
              p_deltd IN VARCHAR2,
              p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_txAdhocUpdate(p_id IN VARCHAR2,
              p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
              p_refid IN VARCHAR2,
              p_qtty IN NUMBER, p_amt IN NUMBER,
              p_brid IN VARCHAR2,
              p_type IN VARCHAR2, p_actype IN VARCHAR2,
              p_txnum IN VARCHAR2, p_txdate IN DATE,
              p_deltd IN VARCHAR2,
              p_err_code out varchar2)
  RETURN NUMBER;

  FUNCTION fn_SecuredUpdate(p_dorc varchar2, p_amount NUMBER, p_acctno VARCHAR2, p_txnum varchar2, p_txdate date,
                  p_err_code OUT VARCHAR2)
  RETURN NUMBER;

  FUNCTION fn_RoomLimitCheck(p_afacctno in varchar2, p_codeid in varchar2, p_qtty in NUMBER, p_err_code in out varchar2)
  RETURN NUMBER;

END; -- Package spec
/


CREATE OR REPLACE PACKAGE BODY txpks_prchk
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter procedure, function bodies as shown below

FUNCTION fn_getVal(p_amtexp IN varchar2)
RETURN FLOAT
IS
    l_sql varchar2(500);
    CUR             PKG_REPORT.REF_CURSOR;
    l_EntryAmount FLOAT;
BEGIN
    l_sql := 'select ' || p_amtexp || ' from dual';
    OPEN CUR FOR l_sql;
       LOOP
       FETCH CUR INTO l_EntryAmount ;
       EXIT WHEN CUR%NOTFOUND;
       END LOOP;
       CLOSE CUR;
    RETURN l_EntryAmount;
END fn_getVal;


FUNCTION fn_BuildAMTEXP(p_txmsg IN tx.msg_rectype,p_amtexp IN varchar2)
RETURN VARCHAR2
IS
  l_Evaluator varchar2(100);
  l_Elemenent  varchar2(20);
  l_Index number(10,0);
  l_ChildValue varchar2(100);
BEGIN
    l_Evaluator:= '';
    l_Index:= 1;
    While l_Index < LENGTH(p_amtexp) loop
        --Get 02 charatacters in AMTEXP
        l_Elemenent := substr(p_amtexp, l_Index, 2);
        if l_Elemenent in ( '++', '--', '**', '//', '((', '))') then
                --Operand
                l_Evaluator := l_Evaluator || substr(l_Elemenent,1,1);
        elsif l_Elemenent in ( 'MA') then
                --Operand
                l_Evaluator := 'GREATEST(' || l_Evaluator || ',0)';
        elsif l_Elemenent in ( 'MI') then
                --Operand
                l_Evaluator := 'LEAST(' || l_Evaluator || ',0)';
        else
                --OPERATOR
                l_ChildValue:= p_txmsg.txfields(l_Elemenent).value;
                l_Evaluator := l_Evaluator || l_ChildValue;
        End if;
        l_Index := l_Index + 2;
    end loop;
   RETURN l_Evaluator;
EXCEPTION
WHEN OTHERS THEN
    RETURN '0';
END fn_BuildAMTEXP;

FUNCTION fn_parse_amtexp(p_txmsg IN tx.msg_rectype,p_amtexp IN varchar2)
RETURN FLOAT
IS
    l_value varchar2(100);
BEGIN
    
    IF length(p_amtexp) > 0 THEN
        IF substr(p_amtexp,0,1) = '@' THEN
            l_value:=replace(p_amtexp,'@');
        ELSIF substr(p_amtexp,0,1) = '$' THEN
            l_value:= replace(p_amtexp,'$');
            l_value:= p_txmsg.txfields(l_value).value;
        ELSE
            l_value:= fn_BuildAMTEXP(p_txmsg,p_amtexp);
            l_value:= fn_getVal(l_value);
        END IF;
    END IF;
    RETURN l_value;
END fn_parse_amtexp;

-- Check this function - IF IS FALSE --> Pool/Room: RETURN SUCCESSFUL!
FUNCTION fn_IsPRCheck(p_txmsg IN tx.msg_rectype, p_acctno VARCHAR2, p_prcode VARCHAR2, p_prtype VARCHAR2, p_actionType VARCHAR2)
RETURN BOOLEAN
IS
    l_count NUMBER;
BEGIN


RETURN FALSE;

    RETURN TRUE;
EXCEPTION WHEN OTHERS THEN
    RETURN FALSE;
END fn_IsPRCheck;

--Get by Careby Group.
FUNCTION fn_getCurrentPR(p_txmsg IN tx.msg_rectype, p_PrCode IN VARCHAR2, p_PrTyp IN VARCHAR2, p_AfAcctno IN VARCHAR2, p_CodeID IN VARCHAR2)
RETURN number
IS
    l_ExpectUsed number(20,0);
    l_AvlPR number(20,0);
    l_CIAvlAmount number(20,0);
    l_CodeID varchar2(20);
    l_TempValue number(20,0);
BEGIN

        RETURN 0;


    return l_AvlPR;
exception when others then
    return 0;
END fn_getCurrentPR;


/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi di theo giao dich.
**/
/*FUNCTION fn_SecuredUpdate(p_txnum VARCHAR2, p_txdate DATE, p_deltd VARCHAR2,
                p_dorc varchar2, p_amount NUMBER,
                p_acctno VARCHAR2, p_codeid varchar2, p_prtyp VARCHAR2, p_type VARCHAR2, p_actype VARCHAR2, p_brid VARCHAR2, p_refid VARCHAR2,
                p_err_code OUT VARCHAR2)
RETURN NUMBER
IS
l_count NUMBER;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=systemnums.c_success;*/
/*
    --Kiem tra theo san phan l_actype, l_type, l_brid
    FOR rec IN
    (
        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                pm.prinused, pm.expireddt, pm.prstatus
        FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
        WHERE pm.prcode = brm.prcode
            AND pm.prcode = prtm.prcode
            AND prt.actype = prtm.prtype
            AND prt.actype = tpm.prtype
            AND pm.codeid = decode(p_prtyp,'R',p_codeid,pm.codeid)
            AND pm.prtyp = p_prtyp
            AND prt.TYPE = p_type
            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,p_AcType)
            AND brm.brid = decode(brm.brid,'ALL',brm.brid,p_brid)
    )
    LOOP
        IF p_deltd <> 'Y' THEN
            IF p_dorc = 'C' THEN --Tang nguon: ~ giam nguon du tinh su dung
                INSERT INTO prinusedlog (prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref)
                VALUES (rec.prcode, -p_amount, 'N', SYSTIMESTAMP, seq_prinusedlog.NEXTVAL, p_txnum, p_txdate, p_refid);
            ELSE --Giam nguon: ~ tang nguon du tinh su dung
                INSERT INTO prinusedlog (prcode, prinused, deltd, last_change, autoid, txnum, txdate, ref)
                VALUES (rec.prcode, p_amount, 'N', SYSTIMESTAMP, seq_prinusedlog.NEXTVAL, p_txnum, p_txdate, p_refid);
            END IF;
        ELSE
            UPDATE prinusedlog
            SET deltd = 'Y'
            WHERE txnum = p_txnum AND txdate = p_txdate;
        END IF;
    END LOOP;*/

/*    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    
    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_SecuredUpdate;*/


/*
-- Check if p_dorc = 'D'.
-- Update temporary secured
*/
FUNCTION fn_SecuredUpdate(p_dorc varchar2, p_amount NUMBER, p_acctno VARCHAR2, p_txnum varchar2, p_txdate date,
                p_err_code OUT VARCHAR2)
RETURN NUMBER
IS
l_count NUMBER;
l_amt number(20,4);
l_actype varchar2(10);
l_BrID varchar2(10);
l_IsMarginAccount varchar2(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=systemnums.c_success;

     plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    
    
    plog.setendsection (pkgctx, 'fn_SecuredUpdate');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_SecuredUpdate;

/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi di theo giao dich.
**/
FUNCTION fn_txAutoAdhocUpdate(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
l_AfAcctno varchar2(10);
l_AfAcctno2 varchar2(10);
l_AcType varchar2(4);
l_Type varchar2(10);
l_count NUMBER;
l_IsSpecialPR NUMBER;
l_CodeID varchar2(6);
l_OrderID varchar2(20);
l_UsedAmt NUMBER;
l_UsedQtty NUMBER;
l_TotalUsedQtty NUMBER;
l_CurrDate DATE;
l_sumexecqtty NUMBER;
l_execqtty NUMBER;
l_matchamt NUMBER;
l_trade NUMBER;
l_AIntRate NUMBER;
l_AMinBal NUMBER;
l_AFeeBank NUMBER;
l_AMinFeeBank NUMBER;
l_qtty NUMBER;
l_BrID  varchar2(4);
l_IsMarginAccount char(1);
l_amt number;
l_ExecType varchar2(2);
l_NumVal1 number;
l_NumVal2 number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoAdhocUpdate');
    l_UsedAmt:=0;
    l_UsedQtty:=0;
    l_CurrDate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),systemnums.c_date_format);
    l_AIntRate:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AINTRATE'));
    l_AMinBal:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINBAL'));
    l_AFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AFEEBANK'));
    l_AMinFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINFEEBANK'));
    
    plog.setendsection (pkgctx, 'fn_txAutoAdhocUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:=errnums.C_SYSTEM_ERROR;
    
    
    plog.setendsection (pkgctx, 'fn_txAutoAdhocUpdate');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoAdhocUpdate;

/**
* Kiem tra nguon theo xu ly dac biet. Ham goi di theo giao dich.
**/
FUNCTION fn_txAutoAdhocCheck(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS

/*l_count number;
l_maxdebt number;
l_amt number;
l_amt2 number;
l_actype varchar2(4);
l_type varchar2(100);
l_BrID  varchar2(4);
l_IsMarginAccount char(1);*/
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoAdhocCheck');
    p_err_code:=systemnums.C_SUCCESS;
    /*IF p_txmsg.tltxcd in ('2200','2202','2232','2242','2243','2244','2250') THEN
        begin
            select
                sum (nvl(pr.prinused,0)* least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * nvl(rsk2.mrratioloan,0) / 100)
                - sum((se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)
                    - (case when se.codeid = p_txmsg.txfields('01').value then to_number(p_txmsg.txfields('10').value) else 0 end)) * least(nvl(rsk2.mrpriceloan,0), sb.marginrefprice) * nvl(rsk2.mrratioloan,0) / 100)
                ,
                sum (nvl(pr.sy_prinused,0)* least(nvl(rsk1.mrpriceloan,0), sb.marginprice) * nvl(rsk1.mrratioloan,0) / 100)
                - sum((se.trade - nvl(sts.execsellqtty,0) + nvl(od.buyqtty,0) + nvl(sts.execbuyqtty,0)
                    - (case when se.codeid = p_txmsg.txfields('01').value then to_number(p_txmsg.txfields('10').value) else 0 end)) * least(nvl(rsk1.mrpriceloan,0), sb.marginrefprice) * nvl(rsk1.mrratioloan,0) / 100)

                into l_amt, l_amt2
                from (select se.afacctno, se.codeid, af.actype, se.trade from semast se, afmast af, aftype aft, mrtype mrt
                        where se.afacctno = af.acctno and af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T') se,
                     securities_info sb,
                     afserisk rsk1,afmrserisk rsk2,
                    (select afacctno, codeid,
                        sum(case when duetype = 'SS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execsellqtty,
                        sum(case when duetype = 'RS' then qtty - decode(status,'C',qtty,aqtty) else 0 end) execbuyqtty
                        from stschd
                        where duetype in ('SS','RS') and afacctno = p_txmsg.txfields('02').value and deltd <> 'Y'
                        group by afacctno, codeid) sts,
                    (select afacctno, codeid,
                        sum(case when exectype = 'NB' then remainqtty else 0 end) buyqtty
                        from odmast
                        where exectype = 'NB' and afacctno = p_txmsg.txfields('02').value and deltd <> 'Y'
                        group by afacctno, codeid) od,
                    (select afpr.afacctno, pr.codeid, sum(nvl(afpr.prinused,0)) prinused, sum(nvl(afpr.sy_prinused,0)) sy_prinused,
                       max(nvl(pr.roomlimit,0)) - sum(nvl(afpr.prinused,0)) pravllimit
                           from (select afacctno, codeid, sum(case when restype = 'M' then prinused else 0 end) prinused,
                                    sum(case when restype = 'S' then prinused else 0 end) sy_prinused
                                   from vw_afpralloc_all
                                   where afacctno = p_txmsg.txfields('02').value
                                   group by afacctno,codeid) afpr, vw_marginroomsystem pr
                           where afpr.codeid(+) = pr.codeid
                           group by afpr.afacctno, pr.codeid
                        ) pr
                where se.afacctno = p_txmsg.txfields('02').value
                and se.afacctno = sts.afacctno(+) and se.codeid = sts.codeid(+)
                and se.afacctno = od.afacctno(+) and se.codeid = od.codeid(+)
                and se.afacctno = pr.afacctno(+) and se.codeid = pr.codeid(+)
                and se.actype = rsk1.actype(+) and se.codeid = rsk1.codeid(+)
                and se.actype = rsk2.actype(+) and se.codeid = rsk2.codeid(+)
                and sb.codeid = se.codeid
                group by se.afacctno;
        exception when others then
            l_amt:=0;
            l_amt2:=0;
        end;
        if (l_amt > 0 and l_amt2 > 0) then
            p_err_code:= '-100523';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    ELSIF p_txmsg.tltxcd in ('8876','8874') THEN

        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('03').value and cf.custatcom = 'Y';

        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('03').value;

            if l_count = 0 then
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;

            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        to_number(p_txmsg.txfields('11').value) * to_number(p_txmsg.txfields('12').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
                left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('03').value) al on mst.acctno = al.afacctno
                left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('03').value group by afacctno) adv on adv.afacctno=MST.acctno
                LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('03').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('03').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('03').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
            end if;
        end if;
    elsIF p_txmsg.tltxcd in ('8895') THEN
        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('08').value and cf.custatcom = 'Y';

        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('08').value;
            --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
            if l_count = 0 then
                --return systemnums.C_SUCCESS;
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;


            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - (to_number(p_txmsg.txfields('14').value)+to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        (to_number(p_txmsg.txfields('14').value)+to_number(p_txmsg.txfields('15').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('08').value) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('08').value group by afacctno) adv on adv.afacctno=MST.acctno
            LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('08').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('08').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('08').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
             end if;
         end if;
    elsIF p_txmsg.tltxcd in ('8897') THEN
        select count(1) into l_count
        from cfmast cf, afmast af
        where cf.custid = af.custid
        and af.acctno = p_txmsg.txfields('08').value and cf.custatcom = 'Y';
        if l_count > 0 then

            l_maxdebt:=to_number(cspks_system.fn_get_sysvar('MARGIN','MAXDEBT'));
            --Chi danh dau voi tai khoan Margin, co tuan thu muc he thong.
            select count(1) into l_count
            from afmast af, aftype aft, mrtype mrt, lntype lnt
            where af.actype = aft.actype and aft.mrtype = mrt.actype and mrt.mrtype = 'T'
            and aft.lntype = lnt.actype(+) and nvl(lnt.chksysctrl,'N') = 'Y' and af.acctno = p_txmsg.txfields('08').value;
            --Neu Tieu khoan khong danh dau bat buoc tuan thu he thong hoac ko phai lai tieu khoan margin -> Khong can hach toan nguon.
            if l_count = 0 then
                --return systemnums.C_SUCCESS;
                l_IsMarginAccount:='N';
            else
                l_IsMarginAccount:='Y';
            end if;

            select
                least(-least(nvl(adv.avladvance,0)
                        + mst.balance
                        - mst.odamt
                        - mst.dfdebtamt
                        - mst.dfintdebtamt
                        - mst.depofeeamt
                        - NVL (advamt, 0)
                        - nvl(secureamt,0)
                        - ramt
                        - nvl(dealpaidamt,0)
                        - (to_number(p_txmsg.txfields('11').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value),0),

                        (to_number(p_txmsg.txfields('11').value)) * to_number(p_txmsg.txfields('10').value) * to_number(p_txmsg.txfields('13').value)/100 * to_number(p_txmsg.txfields('98').value))
                into l_amt
            from cimast mst
            left join (select * from v_getbuyorderinfo where afacctno = p_txmsg.txfields('08').value) al on mst.acctno = al.afacctno
            left join (select sum(depoamt) avladvance,afacctno from v_getAccountAvlAdvance where afacctno = p_txmsg.txfields('08').value group by afacctno) adv on adv.afacctno=MST.acctno
            LEFT JOIN (select * from v_getdealpaidbyaccount p where p.afacctno = p_txmsg.txfields('08').value) pd on pd.afacctno=mst.acctno
            where mst.acctno = p_txmsg.txfields('08').value;
            plog.debug(pkgctx,'l_amt:'||l_amt);
            if l_amt > 0 then
                select actype, substr(acctno,1,4) into l_actype, l_BrID from afmast where acctno = p_txmsg.txfields('08').value;

                 FOR rec_pr IN (
                        SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                                pm.prinused + fn_getExpectUsed(pm.prcode) prinused, pm.expireddt, pm.prstatus
                        FROM prmaster pm,  prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
                        WHERE pm.prcode = brm.prcode
                            AND pm.prcode = prtm.prcode
                            AND prt.actype = prtm.prtype
                            AND prt.actype = tpm.prtype
                            AND pm.prtyp = 'P'
                            AND ((prt.TYPE = 'AFTYPE') or (l_IsMarginAccount = 'Y' and prt.TYPE = 'SYSTEM'))
                            AND pm.prstatus = 'A'
                            AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                            AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_BrID)
                               )
                 LOOP
                    if l_amt > least(rec_pr.prlimit,l_maxdebt) - rec_pr.prinused then
                       p_err_code := '-100522'; --Vuot qua nguon.
                       plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:' || p_err_code);
                       plog.setendsection(pkgctx, 'fn_txAutoAdhocCheck');
                       RETURN errnums.C_BIZ_RULE_INVALID;
                    end if;
                 end loop;
             end if;
            -- Xu ly dac biet.
        END IF;
    end if;*/
    plog.setendsection (pkgctx, 'fn_txAutoAdhocCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:=errnums.C_SYSTEM_ERROR;
    
    plog.setendsection (pkgctx, 'fn_txAutoAdhocCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoAdhocCheck;

/**
* Cap nhat gia tri nguon du tinh theo xu ly dac biet. Ham goi Adhoc.
**/
FUNCTION fn_txAdhocUpdate(p_id IN VARCHAR2,
            p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
            p_refid IN VARCHAR2,
            p_qtty IN NUMBER, p_amt IN NUMBER,
            p_brid IN VARCHAR2,
            p_type IN VARCHAR2, p_actype IN VARCHAR2,
            p_txnum IN VARCHAR2, p_txdate IN DATE,
            p_deltd IN VARCHAR2,
            p_err_code out varchar2)
RETURN NUMBER
IS
l_count NUMBER;
l_TotalUsedQtty NUMBER;
l_AcType varchar2(4);
l_sumexecqtty NUMBER;
l_trade NUMBER;
l_UsedQtty NUMBER;
l_UsedAmt NUMBER;

l_CurrDate  DATE;
l_ClearDate DATE;
l_AIntRate NUMBER;
l_AMinBal NUMBER;
l_AFeeBank NUMBER;
l_AMinFeeBank NUMBER;
l_brid varchar2(4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAdhocUpdate');
    p_err_code:=systemnums.C_SUCCESS;
    /*l_CurrDate:= to_date(cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE'),systemnums.c_date_format);
    l_AIntRate:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AINTRATE'));
    l_AMinBal:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINBAL'));
    l_AFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AFEEBANK'));
    l_AMinFeeBank:= to_number(cspks_system.fn_get_sysvar('SYSTEM', 'AMINFEEBANK'));

    l_TotalUsedQtty:=0;
    IF p_id = 'SELLORDERMATCH' THEN

        --Xac dinh deal ban.
        SELECT sum(execqtty) INTO l_sumexecqtty
        FROM odmast
        WHERE txdate = l_CurrDate AND exectype IN ('MS','NS') AND execqtty > 0
        AND afacctno = p_acctno AND codeid = p_codeid;

        select substr(p_acctno,1,4) into l_brid from dual;

        l_sumexecqtty:=l_sumexecqtty - p_qtty;
        -- Over deal
        FOR rec_ovd IN
        (
            SELECT dfqtty, nml, ovd, df.actype, (dfqtty + blockqtty + rcvqtty + carcvqtty + rlsqtty) orgqtty,
            rlsqtty, rlsamt,
            (dfqtty + blockqtty + rcvqtty + carcvqtty) remainqtty
            FROM dfmast df, lnschd ls, securities_info sb
            WHERE df.lnacctno = ls.acctno AND ls.reftype = 'P' AND df.dfqtty > 0
            AND df.afacctno = p_acctno AND df.codeid = p_codeid
            AND sb.codeid = df.codeid
            AND ((flagtrigger = 'T' OR sb.basicprice <= df.triggerprice) OR (ls.overduedate <= l_CurrDate))
            order BY CASE WHEN flagtrigger = 'T' OR sb.basicprice <= df.triggerprice THEN 0
                            WHEN ls.overduedate < l_CurrDate THEN 1
                            WHEN ls.overduedate = l_CurrDate THEN 2
                            ELSE 3 END,
                     ls.overduedate
        )
        LOOP
            IF l_sumexecqtty >= 0 THEN
                l_sumexecqtty:=l_sumexecqtty - rec_ovd.dfqtty;
            END IF;
            if l_sumexecqtty < 0 AND p_qtty > l_TotalUsedQtty then  -- Gia tri khop roi vao deal ban bi canh bao
                l_UsedQtty:= least(p_qtty - l_TotalUsedQtty, CASE WHEN l_TotalUsedQtty = 0 THEN -l_sumexecqtty ELSE rec_ovd.dfqtty END);
                l_UsedAmt:= greatest((rec_ovd.nml + rec_ovd.ovd) - ((rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt)
                                                            / rec_ovd.orgqtty
                                                            * (rec_ovd.remainqtty - l_UsedQtty)),
                                    0);
                l_TotalUsedQtty:= l_TotalUsedQtty + l_UsedQtty;

                --room: l_UsedQtty
                IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                            'C', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', rec_ovd.actype, l_brid, p_refid, p_err_code)
                    <> systemnums.c_success THEN
                    p_err_code:=errnums.c_system_error;
                    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
                --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
                IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                            'C', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', rec_ovd.actype, l_brid, p_refid, p_err_code)
                    <> systemnums.c_success THEN
                    p_err_code:=errnums.c_system_error;
                    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            END IF;
        END LOOP;
        -- normal trade
        IF l_sumexecqtty > 0 OR p_qtty > l_TotalUsedQtty THEN
            SELECT trade INTO l_trade FROM semast WHERE afacctno = p_acctno and codeid = p_codeid;
            l_sumexecqtty:=l_sumexecqtty - l_trade;
            l_TotalUsedQtty:=l_TotalUsedQtty + least((p_qtty - l_TotalUsedQtty),l_trade);
        END IF;
        -- normal deal
        IF l_sumexecqtty > 0 OR p_qtty > l_TotalUsedQtty THEN
            FOR rec_nml IN
            (
                SELECT dfqtty, nml, ovd, df.actype, (dfqtty + blockqtty + rcvqtty + carcvqtty + rlsqtty) orgqtty,
                    rlsqtty, rlsamt,
                    (dfqtty + blockqtty + rcvqtty + carcvqtty) remainqtty
                FROM dfmast df, lnschd ls, securities_info sb
                WHERE df.lnacctno = ls.acctno AND ls.reftype = 'P' AND df.dfqtty > 0
                AND df.afacctno = p_acctno AND df.codeid = p_codeid
                AND sb.codeid = df.codeid
                AND flagtrigger <> 'T' AND sb.basicprice > df.triggerprice AND ls.overduedate > l_CurrDate
                order BY ls.overduedate
            )
            LOOP
                IF l_sumexecqtty >= 0 THEN
                    l_sumexecqtty:=l_sumexecqtty - rec_nml.dfqtty;
                END IF;
                if l_sumexecqtty < 0 AND p_qtty > l_TotalUsedQtty then  -- Gia tri khop roi vao deal ban bi canh bao
                    l_UsedQtty:= least(p_qtty - l_TotalUsedQtty, CASE WHEN l_TotalUsedQtty = 0 THEN -l_sumexecqtty ELSE rec_nml.dfqtty END);
                    l_UsedAmt:= greatest((rec_nml.nml + rec_nml.ovd) - ((rec_nml.nml + rec_nml.ovd + rec_nml.rlsamt)
                                                                / rec_nml.orgqtty
                                                                * (rec_nml.remainqtty - l_UsedQtty)),
                                        0);
                    l_TotalUsedQtty:= l_TotalUsedQtty + l_UsedQtty;
                    -- Tim nguon.
                    --room: l_UsedQtty
                    IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                                'C', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', rec_nml.actype, l_brid, p_refid, p_err_code)
                        <> systemnums.c_success THEN
                        p_err_code:=errnums.c_system_error;
                        plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                    --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
                    IF fn_SecuredUpdate(p_txnum, p_txdate, p_deltd,
                                'C', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', rec_nml.actype, l_brid, p_refid, p_err_code)
                        <> systemnums.c_success THEN
                        p_err_code:=errnums.c_system_error;
                        plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            END LOOP;
        END IF;

    ELSIF p_id = 'BUYORDERMATCH' THEN
-- Margin Loan Matching Order

        --chi xet cho margin loan thoi.
        BEGIN
            SELECT aft.dftype INTO l_actype FROM afmast af, aftype aft, mrtype mrt
            WHERE af.actype = aft.actype AND aft.mrtype = mrt.actype AND mrt.mrtype = 'L' AND af.acctno = p_acctno;
        EXCEPTION WHEN OTHERS THEN
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN systemnums.C_SUCCESS;
        END;

        -- Xac dinh so tien du tinh giai ngan cho lenh khop margin loan.
        l_UsedQtty:= p_qtty;
        SELECT p_amt * (1 + nvl(odt.deffeerate,0)/100 - od.bratio/100) INTO l_UsedAmt
        FROM odmast od, odtype odt
        WHERE od.actype = odt.actype(+) AND od.exectype IN ('NB') AND orderid = p_refid;


        IF l_UsedAmt = 0 AND l_UsedQtty = 0 THEN
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN systemnums.C_SUCCESS;
        END IF;

        -- Tim nguon.
        --room: l_UsedQtty
        IF fn_SecuredUpdate(p_txnum, p_txdate, 'N',
                    'D', l_UsedQtty, p_acctno, p_codeid, 'R', 'DFTYPE', l_actype, l_brid, p_refid, p_err_code)
            <> systemnums.c_success THEN
            p_err_code:=errnums.c_system_error;
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;
        --pool: (rec_ovd.nml + rec_ovd.ovd) - (rec_ovd.nml + rec_ovd.ovd + rec_ovd.rlsamt) / rec_ovd.orgqtty * (rec_ovd.remainqtty - l_UsedQtty)
        IF fn_SecuredUpdate(p_txnum, p_txdate, 'N',
                    'D', l_UsedAmt, p_acctno, p_codeid, 'P', 'DFTYPE', l_actype, l_brid, p_refid, p_err_code)
            <> systemnums.c_success THEN
            p_err_code:=errnums.c_system_error;
            plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

    END IF;*/

    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others THEN
    p_err_code:=errnums.C_SYSTEM_ERROR;
    
    plog.setendsection (pkgctx, 'fn_txAdhocUpdate');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAdhocUpdate;

/**
* Kiem tra nguon theo xu ly dac biet. Ham goi Adhoc.
**/
FUNCTION fn_txAdhocCheck(p_id IN VARCHAR2,
            p_acctno IN VARCHAR2, p_codeid IN VARCHAR2,
            p_refid IN VARCHAR2,
            p_qtty IN NUMBER, p_amt IN NUMBER,
            p_brid IN VARCHAR2,
            p_type in VARCHAR2, p_actype IN VARCHAR2,
            p_txnum IN VARCHAR2, p_txdate IN DATE,
            p_deltd IN VARCHAR2,
            p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAdhocCheck');

    IF p_id = '######' THEN
        NULL;
    END IF;
    plog.setendsection (pkgctx, 'fn_txAdhocCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    
    plog.setendsection (pkgctx, 'fn_txAdhocCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAdhocCheck;


FUNCTION fn_txAutoCheck(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
        l_tltxcd PRCHK.tltxcd%TYPE;
        l_type PRCHK.TYPE%TYPE;
        l_typeid PRCHK.typeid%TYPE;
        l_typefldcd PRCHK.typefldcd%TYPE;
        l_bridtype PRCHK.bridtype%TYPE;
        l_prtype PRCHK.prtype%TYPE;
        l_accfldcd PRCHK.accfldcd%TYPE;
        l_dorc PRCHK.dorc%TYPE;
        l_amtexp PRCHK.amtexp%TYPE;
        l_acctno varchar2(30);
        l_brid varchar2(4);
        l_actype varchar2(10);
        l_value number(20,4);
        l_busdate DATE;
        l_codeid  varchar2(10);
        l_limitcheck number(20,0);
        l_hoststs char(1);
        l_count NUMBER;
        l_IsMarginAccount varchar2(1);
        l_lnaccfldcd varchar2(20);
        l_lntypefldcd varchar2(20);
        l_lntype varchar2(4);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAutoCheck');

    --TruongLD Add, tam thoi return ko check gi khi vao day.
    plog.setendsection (pkgctx, 'fn_txAutoCheck');
    RETURN systemnums.C_SUCCESS;

    -- EXCEPTION NO CHECK POOL/ROOM WHEN RUN batch.
    SELECT varvalue INTO l_hoststs FROM sysvar WHERE varname = 'HOSTATUS' AND grname = 'SYSTEM';
    IF l_hoststs = '0' THEN
        plog.setendsection (pkgctx, 'fn_txAutoCheck');
        RETURN systemnums.C_SUCCESS;
    END IF;
    -- END EXCEPTION NO CHECK POOL/ROOM WHEN RUN batch.

    IF fn_txAutoAdhocCheck(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_txAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    -- Get busdate
    SELECT to_date(varvalue,'DD/MM/RRRR') INTO l_busdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';
    
    FOR i IN
        (
            SELECT a.tltxcd, a.chktype, a.type, a.typeid, a.bridtype, a.prtype, a.accfldcd, a.dorc, a.amtexp, a.typefldcd, a.lnaccfldcd, a.lntypefldcd
            FROM prchk a WHERE a.tltxcd = p_txmsg.tltxcd and a.chktype='I' AND a.deltd <> 'Y' ORDER BY a.odrnum
        )
    LOOP
        l_tltxcd:=i.tltxcd;
        l_type:=i.TYPE;
        l_typeid:=i.typeid;
        l_typefldcd:=i.typefldcd;
        l_bridtype:=i.bridtype;
        l_prtype:=i.prtype;
        l_accfldcd:=i.accfldcd;
        l_dorc:=i.dorc;
        l_amtexp:=i.amtexp;
        l_lnaccfldcd:=i.lnaccfldcd;
        l_lntypefldcd:=i.lntypefldcd;
        --plog.debug (pkgctx, 'kiem tra cho Pool room cho giao dich:' || i.tltxcd);
        --TK CHECK pool room. (CI OR SE account)
        IF NOT l_accfldcd IS NULL AND length(l_accfldcd) > 0 THEN
            IF instr(l_accfldcd,'&') > 0 THEN
                l_acctno:= p_txmsg.txfields(substr(l_accfldcd,0,2)).value || p_txmsg.txfields(ltrim(substr(l_accfldcd,3),'&')).value;
            ELSE
                l_acctno:= p_txmsg.txfields(l_accfldcd).value;
            END IF;
        END IF;

        --Lay tham so chi nhanh. SBS don't use this parameter.
        IF l_bridtype = '0' THEN        --noi mo hop dong
            l_brid:= substr(l_acctno,0,4);
        ELSIF l_bridtype = '1' THEN     --noi lam giao dich
            l_brid:=p_txmsg.brid;
        ELSIF l_bridtype = '2' THEN     --careby tieu khoan.
        /*
            BEGIN
                SELECT tl.brid INTO l_brid
                FROM afmast af, tlprofiles tl
                WHERE af.tlid = tl.tlid AND af.acctno = substr(l_acctno,0,10);
            EXCEPTION WHEN OTHERS THEN
                l_brid:= substr(l_acctno,0,4);
            END;
        */
            l_brid:=nvl(l_brid,'0001');
        END IF;

        --Lay ma loai hinh san pham.
        IF NOT l_typeid IS NULL AND length(l_typeid) > 0 THEN
            -- get XXTYPE FROM XXMAST WHERE XXACCTNO = l_typeid
            /*
            IF l_type = 'DDMAST' THEN
                SELECT actype INTO l_actype FROM ddmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'SETYPE' THEN
                SELECT actype INTO l_actype FROM semast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'AFTYPE' THEN
                SELECT actype INTO l_actype FROM afmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            end if;
            */
            l_actype := '';
        elsif not l_typefldcd is null and length(l_typefldcd) > 0 then
            --Get ACTYPE direct FROM Transactions.
            l_actype:= p_txmsg.txfields(l_typefldcd).value;
        END IF;
        --lay amount
        IF length(l_amtexp) > 0 THEN
            l_value:= fn_parse_amtexp(p_txmsg,l_amtexp);
        ELSE
            l_value:= 0;
        END IF;
        --lay CodeID.
        l_codeid:= substr(l_acctno,11,6);

        if length(trim(l_lntypefldcd))>0 then
            begin
                l_lntype:= p_txmsg.txfields(l_lntypefldcd).value;
            exception when others then
                l_lntype:='XXXX';
            end;
        end if;


        if l_count = 0 then
            l_IsMarginAccount:='N';
        else
            l_IsMarginAccount:='Y';
        end if;
        /*
        --Kiem tra theo san pham: l_actype; l_type; l_brid; l_codeid (chi xai cho tai khoan tien)
        FOR rec IN
        (
            SELECT DISTINCT pm.prcode, pm.prtyp, pm.codeid, pm.prlimit,
                    pm.prinused
            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
            WHERE pm.prcode = brm.prcode
                AND pm.prcode = prtm.prcode
                AND prt.actype = prtm.prtype
                AND prt.actype = tpm.prtype
                AND pm.codeid = decode(l_prtype,'R',l_codeid,pm.codeid)
                AND pm.prtyp = l_prtype
                AND (prt.TYPE = l_type
                        or (prt.type = 'SYSTEM' and l_IsMarginAccount = 'Y' and l_prtype = 'P'))
                AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                AND pm.prstatus = 'A'
                AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_brid)
        )
        LOOP
            --CHECK: IF IS FALSE --> RETURN SUCCESSFUL!
            IF NOT fn_IsPRCheck (p_txmsg, l_acctno, rec.prcode, l_prtype, 'C') THEN
                plog.debug(pkgctx,'fn_IsPRCheck:FALSE;');
                CONTINUE;
            END IF;

            -- get limitcheck remain ON pool/room
            l_limitcheck:=fn_getCurrentPR(p_txmsg, rec.prcode,rec.prtyp, substr(l_acctno,0,10), l_codeid);
            plog.debug(pkgctx,'Limit check:'|| l_limitcheck);

            -- Thuc hien kiem tra nguon.
            IF l_dorc = 'D' THEN -- Giao dich lam giam, check nguon kha dung
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    IF l_value > l_limitcheck THEN
                        IF l_prtype = 'P' THEN
                            p_err_code:='-100522';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:'||p_err_code);
                        ELSE -- reverse transactions
                            p_err_code:='-100523';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100523]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        END IF;
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            ELSIF l_dorc = 'C' THEN -- Giao dich lam tang, truong hop DELETE kiem tra nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    NULL;
                ELSE -- reverse transations
                    --Neu xoa giao dich ghi tang, phai kiem tra nguon truoc moi cho xoa.
                    IF l_value > l_limitcheck THEN
                        IF l_prtype = 'P' THEN
                            p_err_code:='-100522';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon tien:'||p_err_code);
                        ELSE
                            p_err_code:='-100523';        --Vuot qua nguon.
                            plog.debug(pkgctx,'PRCHK: [-100522]:Loi vuot qua nguon chung khoan:'||p_err_code);
                        END IF;
                        plog.setendsection (pkgctx, 'fn_txAutoCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END IF;
            END IF;

        END LOOP;

        */
    END LOOP;
    plog.setendsection (pkgctx, 'fn_txAutoCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    p_err_code:='-1';
    
    plog.setendsection (pkgctx, 'fn_txAutoCheck');
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_txAutoCheck;


FUNCTION fn_txAutoUpdate(p_txmsg in tx.msg_rectype, p_err_code out varchar2)
RETURN NUMBER
IS
        l_tltxcd PRCHK.tltxcd%TYPE;
        l_type PRCHK.TYPE%TYPE;
        l_typeid PRCHK.typeid%TYPE;
        l_typefldcd PRCHK.typefldcd%TYPE;
        l_bridtype PRCHK.bridtype%TYPE;
        l_prtype PRCHK.prtype%TYPE;
        l_accfldcd PRCHK.accfldcd%TYPE;
        l_dorc PRCHK.dorc%TYPE;
        l_amtexp PRCHK.amtexp%TYPE;
        l_acctno varchar2(30);
        l_brid varchar2(4);
        l_actype varchar2(10);
        l_value number(20,4);
        l_busdate DATE;
        l_codeid varchar2(10);
        l_IsSpecialPR NUMBER;
        l_count NUMBER;
        l_IsMarginAccount varchar2(1);
        l_lnaccfldcd varchar2(20);
        l_lntypefldcd varchar2(20);
        l_lntype varchar2(4);
        l_mrtype varchar2(3);

        l_cfcustodycd varchar2(100);
        l_cffullname    varchar2(100);

BEGIN

    plog.setbeginsection (pkgctx, 'fn_txAutoUpdate');

     select cfcustodycd, cffullname
        into l_cfcustodycd,l_cffullname
    from tltx where tltxcd = p_txmsg.tltxcd;

    If l_cfcustodycd <> '##' and LENGTH(l_cfcustodycd) > 0 then
        Update tllog
            set cfcustodycd = p_txmsg.txfields(l_cfcustodycd).value
        where cfcustodycd is not null and txnum = p_txmsg.txnum and txdate = to_date(p_txmsg.txdate,systemnums.c_date_format);
    End If;

    If l_cffullname <> '##' and LENGTH(l_cffullname) > 0 then
        Update tllog
            set cffullname = p_txmsg.txfields(l_cffullname).value
        where cffullname is not null and txnum = p_txmsg.txnum and txdate = to_date(p_txmsg.txdate,systemnums.c_date_format);
    End If;
    plog.setendsection (pkgctx, 'fn_txAutoUpdate');
    Return systemnums.C_SUCCESS;
    plog.debug(pkgctx, 'fn_txAutoAdhocUpdate: begin');
    IF fn_txAutoAdhocUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
      plog.setendsection (pkgctx, 'fn_PRTxProcess');
      RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;
    plog.debug(pkgctx, 'fn_txAutoAdhocUpdate: end');

    SELECT to_date(varvalue,'DD/MM/RRRR') INTO l_busdate FROM sysvar WHERE varname = 'CURRDATE' AND grname = 'SYSTEM';

    FOR i IN
        (
            SELECT a.tltxcd, a.chktype, a.udptype, a.type, a.typeid, a.bridtype, a.prtype, a.accfldcd, a.dorc, a.amtexp, a.typefldcd, a.lnaccfldcd, a.lntypefldcd
            FROM prchk a WHERE a.tltxcd = p_txmsg.tltxcd and a.udptype='I' AND a.deltd <> 'Y' ORDER BY a.odrnum
        )
    LOOP
        l_tltxcd:=i.tltxcd;
        l_type:=i.TYPE;
        l_typeid:=i.typeid;
        l_typefldcd:=i.typefldcd;
        l_bridtype:=i.bridtype;
        l_prtype:=i.prtype;
        l_accfldcd:=i.accfldcd;
        l_dorc:=i.dorc;
        l_amtexp:=i.amtexp;
        l_lnaccfldcd:=i.lnaccfldcd;
        l_lntypefldcd:=i.lntypefldcd;

        --TK CHECK pool room. (CI OR SE account)
        IF NOT l_accfldcd IS NULL AND length(l_accfldcd) > 0 THEN
            IF instr(l_accfldcd,'&') > 0 THEN
                l_acctno:= p_txmsg.txfields(substr(l_accfldcd,0,2)).value || p_txmsg.txfields(ltrim(substr(l_accfldcd,3),'&')).value;
            ELSE
                l_acctno:= p_txmsg.txfields(l_accfldcd).value;
            END IF;
        END IF;

        --Lay tham so chi nhanh.
        IF l_bridtype = '0' THEN        --noi mo hop dong
            l_brid:= substr(l_acctno,0,4);
        ELSIF l_bridtype = '1' THEN     --noi lam giao dich
            l_brid:=p_txmsg.brid;
        ELSIF l_bridtype = '2' THEN     --careby tieu khoan.
            /*
            BEGIN
                SELECT tl.brid INTO l_brid
                FROM afmast af, tlprofiles tl
                WHERE af.tlid = tl.tlid AND af.acctno = substr(l_acctno,0,10);
            EXCEPTION WHEN OTHERS THEN
                l_brid:= substr(l_acctno,0,4);
            END;
            */
            l_brid:=nvl(l_brid, '0001');
        END IF;

        --Lay ma loai hinh san pham.
        IF NOT l_typeid IS NULL AND length(l_typeid) > 0 THEN
            -- get XXTYPE FROM XXMAST WHERE XXACCTNO = l_typeid
            /*
            IF l_type = 'DDMAST' THEN
                SELECT actype INTO l_actype FROM ddmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'SETYPE' THEN
                SELECT actype INTO l_actype FROM semast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            ELSIF l_type = 'AFTYPE' THEN
                SELECT actype INTO l_actype FROM afmast WHERE acctno = p_txmsg.txfields(l_typeid).value;
            end if;
            */
            l_actype := '';
        elsif not l_typefldcd is null and length(l_typefldcd) > 0 then
            --Get ACTYPE direct FROM Transactions.
            l_actype:= p_txmsg.txfields(l_typefldcd).value;
        END IF;

        IF length(l_amtexp) > 0 THEN
            l_value:= fn_parse_amtexp(p_txmsg,l_amtexp);
        ELSE
            l_value:= 0;
        END IF;

        --lay codeid chung khoan.
        l_codeid:= substr(l_acctno,11,6);

        /*
        --Kiem tra theo san phan l_actype, l_type, l_brid
        FOR rec IN
        (
            SELECT DISTINCT pm.prcode, pm.prname, pm.prtyp, pm.codeid, pm.prlimit,
                    pm.prinused, pm.expireddt, pm.prstatus
            FROM prmaster pm, prtype prt, prtypemap prtm, typeidmap tpm, bridmap brm
            WHERE pm.prcode = brm.prcode
                AND pm.prcode = prtm.prcode
                AND prt.actype = prtm.prtype
                AND prt.actype = tpm.prtype
                AND pm.codeid = decode(l_prtype,'R',l_codeid,pm.codeid)
                AND pm.prtyp = l_prtype
                AND (prt.TYPE = l_type
                        or (prt.type = 'SYSTEM' and l_IsMarginAccount = 'Y' and l_prtype = 'P'))
                AND pm.prstatus = 'A'
                AND tpm.typeid = decode(tpm.typeid,'ALL',tpm.typeid,l_actype)
                AND brm.brid = decode(brm.brid,'ALL',brm.brid,l_brid)
        )
        LOOP
            --CHECK: IF IS FALSE --> RETURN SUCCESSFUL!
            IF NOT fn_IsPRCheck(p_txmsg, l_acctno, rec.prcode, l_prtype, 'U') THEN
                plog.debug(pkgctx,'fn_IsPRCheck:FALSE;');
                CONTINUE;
            END IF;

            --Thuc hien cap nhat nguon:
            IF l_dorc = 'D' THEN -- Ghi giam nguon
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)+ l_value WHERE PRCODE= rec.prcode;
                    INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.prcode,'0004',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                ELSE -- reverse transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)- l_value WHERE PRCODE= rec.prcode;
                    update PRTRAN set deltd='Y' where txnum=p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
                END IF;
            ELSIF l_dorc = 'C' THEN --Ghi tang nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)- l_value WHERE PRCODE= rec.prcode;
                    INSERT INTO PRTRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),rec.prcode,'0003',l_value,NULL,p_txmsg.deltd,'',seq_PRTRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || p_txmsg.txdesc || '');
                ELSE -- reverse transactions
                    UPDATE PRMASTER SET PRINUSED=NVL(PRINUSED,0)+ l_value WHERE PRCODE= rec.prcode;
                    update PRTRAN set deltd='Y' where txnum=p_txmsg.txnum and txdate= TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
                END IF;
            END IF;

        END LOOP;

        */
        -- Update for System Room:
        -- << BEGIN
        /*
        if l_prtype = 'R' then
            -- 1. Update on PRCHK Rules:
            IF l_dorc = 'D' THEN -- Ghi giam nguon
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)+ l_value WHERE CODEID= l_codeid;
                ELSE -- reverse transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)- l_value WHERE CODEID= l_codeid;
                END IF;
            ELSIF l_dorc = 'C' THEN --Ghi tang nguon.
                IF p_txmsg.deltd <> 'Y' THEN -- normal transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)- l_value WHERE CODEID= l_codeid;
                ELSE -- reverse transactions
                    UPDATE securities_info SET SYROOMUSED=NVL(SYROOMUSED,0)+ l_value WHERE CODEID= l_codeid;
                END IF;
            END IF;
        end if;
        */
        -- END >>
    END LOOP;
    plog.setendsection (pkgctx, 'fn_txAutoUpdate');

    RETURN systemnums.C_SUCCESS;
exception when others then
    plog.setendsection (pkgctx, 'fn_txAutoUpdate');
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    Return errnums.C_BIZ_RULE_INVALID;
END fn_txAutoUpdate;

FUNCTION fn_AutoPRTxProcess(p_txmsg in out tx.msg_rectype,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;

BEGIN
   plog.setbeginsection (pkgctx, 'fn_AutoTxProcess');
   IF fn_txAutoCheck(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;
   IF fn_txAutoUpdate(p_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.setendsection (pkgctx, 'fn_AutoTxProcess');
   RETURN l_return_code;
EXCEPTION
   WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;
      plog.setendsection (pkgctx, 'fn_AutoTxProcess');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'fn_AutoTxProcess');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_AutoPRTxProcess;

FUNCTION fn_prAutoCheck(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
   l_txmsg tx.msg_rectype;
BEGIN
/*   plog.setbeginsection (pkgctx, 'fn_PRTxProcess');
   plog.debug(pkgctx, 'xml2obj');
   l_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
   IF fn_txAutoCheck(l_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
        plog.setendsection (pkgctx, 'fn_PRTxProcess');
        RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.debug(pkgctx, 'obj2xml');
   p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
   plog.setendsection (pkgctx, 'fn_PRTxProcess');*/
   RETURN l_return_code;
EXCEPTION
WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value := p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value :=  p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_prAutoCheck;


FUNCTION fn_prAutoUpdate(p_xmlmsg IN OUT varchar2,p_err_code in out varchar2,p_err_param out varchar2)
RETURN NUMBER
IS
   l_return_code VARCHAR2(30) := systemnums.C_SUCCESS;
   l_txmsg tx.msg_rectype;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_PRTxProcess');
/*   plog.debug(pkgctx, 'xml2obj');
   l_txmsg := txpks_msg.fn_xml2obj(p_xmlmsg);
   IF fn_txAutoUpdate(l_txmsg, p_err_code) <> systemnums.C_SUCCESS THEN
      plog.setendsection (pkgctx, 'fn_PRTxProcess');
      RAISE errnums.E_BIZ_RULE_INVALID;
   END IF;

   plog.debug(pkgctx, 'obj2xml');
   p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
   plog.setendsection (pkgctx, 'fn_PRTxProcess');*/
   RETURN l_return_code;
EXCEPTION
WHEN errnums.E_BIZ_RULE_INVALID
   THEN
      FOR I IN (
           SELECT ERRDESC,EN_ERRDESC FROM deferror
           WHERE ERRNUM= p_err_code
      ) LOOP
           p_err_param := i.errdesc;
      END LOOP;      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value := p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_BIZ_RULE_INVALID;
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      p_err_param := 'SYSTEM_ERROR';
      plog.error (pkgctx, SQLERRM);
      l_txmsg.txException('ERRSOURCE').value := '';
      l_txmsg.txException('ERRSOURCE').TYPE := 'System.String';
      l_txmsg.txException('ERRCODE').value := p_err_code;
      l_txmsg.txException('ERRCODE').TYPE := 'System.Int64';
      l_txmsg.txException('ERRMSG').value :=  p_err_param;
      l_txmsg.txException('ERRMSG').TYPE := 'System.String';
      p_xmlmsg := txpks_msg.fn_obj2xml(l_txmsg);
      plog.setendsection (pkgctx, 'fn_prUpdate');
      RETURN errnums.C_SYSTEM_ERROR;
END fn_prAutoUpdate;

FUNCTION fn_RoomLimitCheck(p_afacctno in varchar2, p_codeid in varchar2, p_qtty in NUMBER, p_err_code in out varchar2)
RETURN NUMBER
IS
l_remainqtty number;
l_remainamt number;
l_basicprice number;
l_mrrate    number;
l_margintype char(1);
l_istrfbuy  char(1);
l_chksysctrl    char(1);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_RoomLimitCheck');
    p_err_code:=systemnums.c_success;

    plog.setendsection (pkgctx, 'fn_RoomLimitCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION when others then
    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection (pkgctx, 'fn_RoomLimitCheck');
    p_err_code:=errnums.c_system_error;
    RETURN errnums.C_BIZ_RULE_INVALID;
END fn_RoomLimitCheck;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('txpks_prchk',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END;
/
