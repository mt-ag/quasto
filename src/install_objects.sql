PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
set define '^'
set concat on
set concat .
set verify off

COLUMN :script_name NEW_VALUE install_script NOPRINT
VARIABLE script_name VARCHAR2(50)

variable ut_plsql_installation varchar(30 char) = 'ut_plsql'

declare
    l_script_name varchar2(100);
begin
    if    :1 = ut_plsql_installation
    then
        l_script_name := 'src/install_utplsql_objects.sql';
    else
        l_script_name := 'null.sql';
    end if;
    :script_name := l_script_name;
end;
/
print :1
select :script_name from dual;

@@^install_script

--@src/install_quasto_objects.sql
