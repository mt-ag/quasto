PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
-- user_interface to determine if dependet objects should be installed or not
/*accept user_input CHAR PROMPT 'Do you have ut_plsql installed? (J/N)' FORMAT 'A20' DEFAULT 'J';
declare 
  v_script_name varchar2 (100 char);
begin
  if  '&user_Input.' = 'J'
    then
      v_script_name := 'src/install_utplsql_objects.sql';
      @&v_script_name;
  end if;
end;
/
*/
@src/install_utplsql_objects.sql
@src/install_quasto_objects.sql
