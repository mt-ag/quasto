PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
set define '~'
set concat on
set concat .
set verify off

COLUMN :script_name NEW_VALUE script_name2 NOPRINT
variable script_name VARCHAR2(50)

--Begin Instruction
PROMPT '------------------------------------'
PROMPT the install scripts expects 3 diffrent arguments!
PROMPT these arguments are expected in a certain order
PROMPT 
PROMPT example Usage:
PROMPT @install [1/0] [1/0] [1/0]
PROMPT 
PROMPT Argument 1: 
PROMPT Do you have  already ut_plsql installed?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'
PROMPT Argument 2:
PROMPT Do you have already apex installed?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'
PROMPT Argument 3:
PROMPT Do you pass specific Jenkins parameters to the script? 
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'

SET SERVEROUTPUT ON
-- Block to proceess first Argument
declare
    l_script_name varchar2(100);
    l_arg number;
begin
    l_arg := '~1';
    if    1 = l_arg
    then
        l_script_name := 'install_utplsql_objects.sql';
    elsif 0 = l_arg
    then
        l_script_name := 'null.sql';
    else
        l_script_name := 'null.sql';
        dbms_output.put_line('Wrong Argument! Please use either 1 or 0!');
    end if;
    :script_name := l_script_name;
end;
/

-- Block to proceess second Argument
/*
declare
    l_script_name varchar2(100);
    l_arg number;
begin
    l_arg := '~2';
    if    1 = l_arg
    then
        l_script_name := 'install_apex_objects.sql';
    elsif 0 = l_arg
    then
        l_script_name := 'null.sql';
    end if;
    :script_name := l_script_name;
end;
*/

-- Block to proceess third Argument
/*
declare
    l_script_name varchar2(100);
    l_arg number;
begin
    l_arg := '~3';
    if    1 = l_arg
    then
        l_script_name := 'install_apex_objects.sql';
    elsif 0 = l_arg
    then
        l_script_name := 'null.sql';
    end if;
    :script_name := l_script_name;
end;
*/

select :script_name from dual;
@@~script_name2
--@src/install_quasto_objects.sql
