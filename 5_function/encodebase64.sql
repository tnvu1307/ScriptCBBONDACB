SET DEFINE OFF;
CREATE OR REPLACE FUNCTION encodebase64(InBlob IN BLOB)
  RETURN CLOB IS
    BlobLen INTEGER := DBMS_LOB.GETLENGTH(InBlob);
    read_offset INTEGER := 1;

    amount INTEGER := 1440; -- must be a whole multiple of 3
    -- size of a whole multiple of 48 is beneficial to get NEW_LINE after each 64 characters 
    buffer RAW(1440);
    res CLOB := EMPTY_CLOB();

BEGIN

    IF InBlob IS NULL OR NVL(BlobLen, 0) = 0 THEN 
        RETURN NULL;
    ELSIF BlobLen <= 24000 THEN
        RETURN UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(InBlob));
    ELSE
        -- UTL_ENCODE.BASE64_ENCODE is limited to 32k, process in chunks if bigger
        LOOP
            EXIT WHEN read_offset >= BlobLen;
            DBMS_LOB.READ(InBlob, amount, read_offset, buffer);
            res := res || UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(buffer));       
            read_offset := read_offset + amount;
        END LOOP;
    END IF;
    RETURN res;
END EncodeBASE64;

/
