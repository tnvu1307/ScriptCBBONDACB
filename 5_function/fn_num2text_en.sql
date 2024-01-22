SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_num2text_en (
    l_Input number -- Input number with as many as 18 digits

) RETURN VARCHAR2

/*
* Converts a integer number as large as 34 digits into the
* equivalent words.  The first letter is capitalized.
*
****************************************************************/
AS
    l_Number number;
    l_Cents int;
    l_inputNumber VARCHAR2(500);
    --l_NumbersTable TABLE (numberval CHAR(2), word VARCHAR2(10));
    l_outputString VARCHAR2(8000);
    l_length INT;
    l_counter INT;
    l_loops INT;
    l_position INT;
    l_chunk CHAR(3); -- for chunks of 3 numbers
    l_tensones CHAR(2);
    l_hundreds CHAR(1);
    l_tens CHAR(1);
    l_ones CHAR(1);
BEGIN


l_Number := l_Input;
-- l_Cents := 100* Convert(money,(l_Input - convert(Numeric(38,3),l_Number)));
l_Cents := floor(100* (l_Input - floor(l_Number)));
IF l_Number = 0 then
    Return 'Zero' ;
end if;

l_inputNumber := to_char(floor(l_Input));
l_outputString := '';
l_counter := 1;
l_length := length(l_inputNumber);
l_position := length(l_inputNumber) - 2;
l_loops := length(l_inputNumber)/3;



-- make sure there is an extra loop added for the remaining numbers
IF mod(length(l_inputNumber) , 3) <> 0 then
    l_loops := l_loops + 1 ;
    --l_position:=   length(l_inputNumber) - mod(length(l_inputNumber) , 3) + 1;

    --l_position:= LEAST(length(l_inputNumber),3);
end if;


WHILE l_counter <= l_loops loop

    -- get chunks of 3 numbers at a time, padded with leading zeros
    if l_position <= 0 then
        l_chunk := SUBSTR('000' || SUBSTR(l_inputNumber, GREATEST(l_position,0), 2+l_position), -3);
        
    else
        l_chunk := SUBSTR('000' || SUBSTR(l_inputNumber, l_position, 3), -3);
    end if;
    --l_chunk := SUBSTR('000' || SUBSTR(l_inputNumber,1, l_position), -3);

    IF l_chunk <> '000' THEN
        l_tensones := SUBSTR(l_chunk, 2, 2);
        l_hundreds := SUBSTR(l_chunk, 1, 1);
        l_tens := SUBSTR(l_chunk, 2, 1);
        l_ones := SUBSTR(l_chunk, 3, 1);


        -- If twenty or less, use the word directly from l_NumbersTable
        IF to_number(l_tensones) <= 20 OR l_Ones='0' THEN
            l_outputString := (case when l_tensones = '00' then ''
                                    when l_tensones = '01' then 'one'
                                    when l_tensones = '02' then 'two'
                                    when l_tensones = '03' then 'three'
                                    when l_tensones = '04' then 'four'
                                    when l_tensones = '05' then 'five'
                                    when l_tensones = '06' then 'six'
                                    when l_tensones = '07' then 'seven'
                                    when l_tensones = '08' then 'eight'
                                    when l_tensones = '09' then 'nine'
                                    when l_tensones = '10' then 'ten'
                                    when l_tensones = '11' then 'eleven'
                                    when l_tensones = '12' then 'twelve'
                                    when l_tensones = '13' then 'thirteen'
                                    when l_tensones = '14' then 'fourteen'
                                    when l_tensones = '15' then 'fifteen'
                                    when l_tensones = '16' then 'sixteen'
                                    when l_tensones = '17' then 'seventeen'
                                    when l_tensones = '18' then 'eighteen'
                                    when l_tensones = '19' then 'nineteen'
                                    when l_tensones = '20' then 'twenty'
                                    when l_tensones = '30' then 'thirty'
                                    when l_tensones = '40' then 'forty'
                                    when l_tensones = '50' then 'fifty'
                                    when l_tensones = '60' then 'sixty'
                                    when l_tensones = '70' then 'seventy'
                                    when l_tensones = '80' then 'eighty'
                                    when l_tensones = '90' then 'ninety'
                                    else '' end
                                )
                   || CASE l_counter WHEN 1 THEN '' -- No name
                       WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
                       WHEN 4 THEN ' billion '  WHEN 5 THEN ' trillion '
                       WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
                       WHEN 8 THEN ' sextillion '  WHEN 9 THEN ' septillion '
                       WHEN 10 THEN ' octillion '  WHEN 11 THEN ' nonillion '
                       WHEN 12 THEN ' decillion '  WHEN 13 THEN ' undecillion '
                       ELSE '' END
                               || l_outputString;

         ELSE  -- break down the ones and the tens separately

             l_outputString := ' '
                            || (case when l_tens || '0' = '00' then ''
                                    when l_tens || '0' = '10' then 'ten'
                                    when l_tens || '0' = '20' then 'twenty'
                                    when l_tens || '0' = '30' then 'thirty'
                                    when l_tens || '0' = '40' then 'forty'
                                    when l_tens || '0' = '50' then 'fifty'
                                    when l_tens || '0' = '60' then 'sixty'
                                    when l_tens || '0' = '70' then 'seventy'
                                    when l_tens || '0' = '80' then 'eighty'
                                    when l_tens || '0' = '90' then 'ninety'
                                    else '' end
                                )
                             || '-'
                             || (case when '0'|| l_ones = '00' then ''
                                    when '0'|| l_ones = '01' then 'one'
                                    when '0'|| l_ones = '02' then 'two'
                                    when '0'|| l_ones = '03' then 'three'
                                    when '0'|| l_ones = '04' then 'four'
                                    when '0'|| l_ones = '05' then 'five'
                                    when '0'|| l_ones = '06' then 'six'
                                    when '0'|| l_ones = '07' then 'seven'
                                    when '0'|| l_ones = '08' then 'eight'
                                    when '0'|| l_ones = '09' then 'nine'
                                    else '' end
                                )
                   || CASE l_counter WHEN 1 THEN '' -- No name
                       WHEN 2 THEN ' thousand ' WHEN 3 THEN ' million '
                       WHEN 4 THEN ' billion '  WHEN 5 THEN ' trillion '
                       WHEN 6 THEN ' quadrillion ' WHEN 7 THEN ' quintillion '
                       WHEN 8 THEN ' sextillion '  WHEN 9 THEN ' septillion '
                       WHEN 10 THEN ' octillion '  WHEN 11 THEN ' nonillion '
                       WHEN 12 THEN ' decillion '   WHEN 13 THEN ' undecillion '
                       ELSE '' END
                            || l_outputString;
        END IF;

        -- now get the hundreds
        IF l_hundreds <> '0' THEN
            l_outputString  := (case when '0'|| l_hundreds = '00' then ''
                                    when '0'|| l_hundreds = '01' then 'one'
                                    when '0'|| l_hundreds = '02' then 'two'
                                    when '0'|| l_hundreds = '03' then 'three'
                                    when '0'|| l_hundreds = '04' then 'four'
                                    when '0'|| l_hundreds = '05' then 'five'
                                    when '0'|| l_hundreds = '06' then 'six'
                                    when '0'|| l_hundreds = '07' then 'seven'
                                    when '0'|| l_hundreds = '08' then 'eight'
                                    when '0'|| l_hundreds = '09' then 'nine'
                                    else '' end
                                )
                                || ' hundred '
                                || l_outputString;
        END IF;
    END IF;

    l_counter := l_counter + 1;
    l_position := l_position - 3;

END LOOP;

-- Remove any double spaces
l_outputString := LTRIM(RTRIM(REPLACE(l_outputString, '  ', ' ')));
l_outputstring := UPPER(substr(l_outputstring, 1,1)) || substr(l_outputstring, 2, 8000);


-- RETURN UPPER(l_outputString) || ' DOLLARS & ' || to_char(l_Cents) || '/100 CENTS'; -- return the result
RETURN l_outputString; -- return the result
END;
/
