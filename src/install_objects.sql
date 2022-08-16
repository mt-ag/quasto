PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
variable script_name varchar2(100 char)
-- user_interface to determine if dependet objects should be installed or not
accept user_input CHAR PROMPT 'Do you have ut_plsql installed? (J/N)' FORMAT 'A20' DEFAULT 'J';
begin
  if  '&user_Input.' = 'J'
    then
    :script_name := 'install_utplsql_objects.sql';
  else 
    :script_name := 'null.sql';
  end if;
end;
/
print :script_name
--@src/:script_name
--@src/install_quasto_objects.sql
