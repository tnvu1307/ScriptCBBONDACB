SET DEFINE OFF;
CREATE OR REPLACE function isint(n number)
return integer is
begin
  if remainder(n,1) = 0 then -- is integer 
     return(1);
  else -- is float 
    return(0);
  end if;
end isInt;

/
