SET DEFINE OFF;DELETE FROM FILEMAP WHERE 1 = 1 AND NVL(FILECODE,'NULL') = NVL('S006','NULL');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'CUSTODYCD', 'CUSTODYCD', 'C', 'Y', 10, 'N', 'N', 'Y', 'Y', 1, 'Sổ TK lưu ký', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'AFACCTNO', 'AFACCTNO', 'C', 'N', 16, 'N', 'N', 'Y', 'Y', 2, 'Tiểu khoản', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'CUSTNAME', 'CUSTNAME', 'C', 'N', 50, 'U', 'N', 'Y', 'Y', 3, 'Họ tên', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'IDCODE', 'IDCODE', 'C', 'N', 50, 'U', 'N', 'Y', 'Y', 4, 'CMND', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'IDDATE', 'IDDATE', 'D', 'N', 100, 'N', 'N', 'Y', 'Y', 5, 'Ngày cấp', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'IDPLACE', 'IDPLACE', 'C', 'N', 50, 'U', 'N', 'Y', 'Y', 6, 'Nơi cấp', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'ADDRESS', 'ADDRESS', 'C', 'N', 90, 'U', 'N', 'Y', 'Y', 7, 'Địa chỉ', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'COUNTRY', 'COUNTRY', 'C', 'N', 4, 'U', 'N', 'Y', 'Y', 8, 'Quốc tịch', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'TRFBICCODE', 'TRFBICCODE', 'C', 'N', 20, 'U', 'N', 'Y', 'Y', 9, 'Biccode bên chuyển', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'RECBICCODE', 'RECBICCODE', 'C', 'N', 20, 'U', 'N', 'Y', 'Y', 10, 'Biccode bên nhận', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'RECCUSTODY', 'RECCUSTODY', 'C', 'Y', 10, 'N', 'N', 'Y', 'Y', 11, 'Số TK lưu ký bên nhận', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'ALTERNATEID', 'ALTERNATEID', 'C', 'N', 80, 'U', 'N', 'Y', 'Y', 12, 'Loại giấy tờ', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'TRANTYPE', 'TRANTYPE', 'C', 'N', 50, 'U', 'N', 'Y', 'Y', 13, 'Loại chuyển khoản', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'FILENAME', 'FILENAME', 'C', 'N', 200, 'U', 'N', 'Y', 'Y', 15, 'Tên file', 'N');Insert into FILEMAP   (FILECODE, FILEROWNAME, TBLROWNAME, TBLROWTYPE, ACCTNOFLD, TBLROWMAXLENGTH, CHANGETYPE, DELTD, DISABLED, VISIBLE, LSTODR, FIELDDESC, SUMAMT) Values   ('S006', 'TXDATE', 'TXDATE', 'D', 'N', 100, 'U', 'N', 'Y', 'Y', 16, 'Ngày giao dịch', 'N');COMMIT;