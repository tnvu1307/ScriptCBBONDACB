SET DEFINE OFF;
CREATE OR REPLACE FUNCTION spell_number (p_number IN NUMBER)
   RETURN VARCHAR2
AS
   TYPE myArray IS TABLE OF VARCHAR2 (255);

   l_str myArray
         := myArray ('',
                     ' thousand ',
                     ' million ',
                     ' billion ',
                     ' trillion ',
                     ' quadrillion ',
                     ' quintillion ',
                     ' sextillion ',
                     ' septillion ',
                     ' octillion ',
                     ' nonillion ',
                     ' decillion ',
                     ' undecillion ',
                     ' duodecillion ');

   l_num      VARCHAR2 (50) DEFAULT TRUNC (p_number);
   l_return   VARCHAR2 (4000);
BEGIN
   FOR i IN 1 .. l_str.COUNT
   LOOP
      EXIT WHEN l_num IS NULL;

      IF (SUBSTR (l_num, LENGTH (l_num) - 2, 3) <> 0)
      THEN
         l_return :=
            TO_CHAR (TO_DATE (SUBSTR (l_num, LENGTH (l_num) - 2, 3), 'J'),
                     'Jsp')
            || l_str (i)
            || l_return;
      END IF;

      l_num := SUBSTR (l_num, 1, LENGTH (l_num) - 3);
   END LOOP;

   RETURN l_return;
END;
/
