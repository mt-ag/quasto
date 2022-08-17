PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
set define '~'
set concat on
set concat .
set verify off

COLUMN :script_name NEW_VALUE script_name2 NOPRINT
variable script_name VARCHAR2(50)

declare
    l_script_name varchar2(100);
begin   
    if    upper('UT_PLSQL') = upper('~1')
    then
        l_script_name := 'install_utplsql_objects.sql';
    else
        l_script_name := 'null.sql';
    end if;
    :script_name := l_script_name;
end;
/
--src/
select :script_name from dual;
@@~script_name2
@src/install_quasto_objects.sql
