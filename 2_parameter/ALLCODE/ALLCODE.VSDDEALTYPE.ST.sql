SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('VSDDEALTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('ST','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '1', 'Chứng khoán phổ thông', 1, 'Y', 'Freely-transferrable securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '2', 'Chứng khoán hạn chế chuyển nhượng', 2, 'Y', 'Conditionally-transferrable securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '3', 'Chứng khoán ưu đãi biểu quyết', 3, 'Y', 'Voting preference securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '4', 'Chứng khoán ưu đãi cổ tức không biểu quyết', 4, 'Y', 'Non-voting, dividend preference securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '5', 'Chứng khoán ưu đãi hoàn lại không biểu quyết', 5, 'Y', 'Non-voting redeemable preference securities');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('ST', 'VSDDEALTYPE', '6', 'Chứng khoán ưu đãi khác không biểu quyết', 6, 'Y', 'Other non-voting preference securities');COMMIT;