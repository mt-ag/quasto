PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
set define '~'
set concat on
set concat .
set verify off

COLUMN :script_ut_plsql NEW_VALUE script_name_utplsql NOPRINT
variable script_ut_plsql VARCHAR2(50)

-- Skript for QUASTO Objects
COLUMN :script_quasto NEW_VALUE script_name_quasto NOPRINT
variable script_quasto VARCHAR2(50)

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

PROMPT src/plsql/pkg/qa_logger_pkg.sql
@src/plsql/pkg/qa_logger_pkg.sql

SET SERVEROUTPUT ON

variable flag char
exec :flag := 'Y';

-- Block to proceess first Argument
declare
    l_script_name varchar2(100);
    l_script_name_quasto varchar2(100) := 'install_quasto_objects.sql';
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
        :script_ut_plsql := 'null.sql';
        :script_quasto   := 'null.sql';
        :flag := 'N';
        return;
    end if;
    :script_ut_plsql := l_script_name;
    :script_quasto  := l_script_name_quasto;

end;
/

-- Optional status message at the end of the script, for DBA info
set feedback off
set head off
select :script_ut_plsql from dual;
select :script_quasto from dual;
-- DML only does anything if flag stayed Y
select sysdate from dual
where :flag = 'Y';
select 'Wrong Argument or no Argument has been passed correctly!' from dual where :flag != 'Y';
set feedback on
set head on

@@src/~script_name_utplsql
@@src/~script_name_quasto
