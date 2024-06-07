PROMPT SQL file for installing all necessary objects on the database. Called from install.sql.
set define '~'
set concat on
set concat .
set verify off

-- Script for UTPLSQL Objects
COLUMN :script_ut_plsql NEW_VALUE script_name_utplsql NOPRINT
variable script_ut_plsql VARCHAR2(50)

COLUMN :script_ut_plsql_recompile NEW_VALUE script_name_utplsql_recompile NOPRINT
variable script_ut_plsql_recompile VARCHAR2(50)

-- Script for Apex Objects
COLUMN :script_apex NEW_VALUE script_name_apex NOPRINT
variable script_apex VARCHAR2(50)

COLUMN :script_apex_recompile NEW_VALUE script_name_apex_recompile NOPRINT
variable script_apex_recompile VARCHAR2(50)

-- current Version installed
COLUMN :version_old NEW_VALUE script_version_old NOPRINT
variable version_old VARCHAR2(50)

--Begin Instruction
PROMPT '------------------------------------'
PROMPT The install scripts expects 4 diffrent arguments.
PROMPT These arguments are expected in a certain order, as follows:
PROMPT 
PROMPT example usage:
PROMPT @install [1/0] [1/0] [1/0] [1/0]
PROMPT 
PROMPT Argument 1: 
PROMPT Do you want to install supporting objects for utPLSQL?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'
PROMPT Argument 2:
PROMPT Do you want to install supporting objects for Oracle APEX?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'
PROMPT Argument 3:
PROMPT Do you want to install supporting objects for Jenkins? 
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'
PROMPT Argument 4:
PROMPT Do you wish to install a lightweight logger functionality for debugging?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'

SET SERVEROUTPUT ON

variable flag char
exec :flag := 'Y';

-- upgrade version
variable version varchar2 (50 char)
exec :version := '24.1';

-- Check if Required Permissions are granted to the current User

@src/scripts/install_prereqs.sql


-- Block to proceess first Argument
declare
    l_script_name_utplsql           varchar2(100) := 'install_utplsql_objects.sql';
    l_script_name_utplsql_recompile varchar2(100) := 'scripts/recompile_utplsql_objects.sql';
    l_script_name_apex              varchar2(100) := 'install_apex_objects.sql';
    l_script_name_apex_recompile    varchar2(100) := 'scripts/recompile_apex_objects.sql';
    l_arg_utplsq                    number := '~1';
    l_arg_apex                      number := '~2';

begin

    if 1 != l_arg_utplsq
      then 
        l_script_name_utplsql := 'null.sql'; 
        l_script_name_utplsql_recompile := 'null.sql'; 
    end if;

    if 1 != l_arg_apex
      then 
        l_script_name_apex := 'null.sql'; 
        l_script_name_apex_recompile := 'null.sql'; 
    end if;

    :script_ut_plsql := l_script_name_utplsql;
    :script_ut_plsql_recompile := l_script_name_utplsql_recompile;
    :script_apex := l_script_name_apex;
    :script_apex_recompile := l_script_name_apex_recompile;
    dbms_output.put_line(l_script_name_utplsql);
    dbms_output.put_line(l_script_name_utplsql_recompile);
    dbms_output.put_line(l_script_name_apex_recompile);
    dbms_output.put_line(l_script_name_apex);
end;
/

-- Optional status message at the end of the script, for DBA info
set feedback off
set head off
select :script_ut_plsql from dual;
select :script_ut_plsql_recompile from dual;
select :script_apex from dual;
select :script_apex_recompile from dual;

-- DML only does anything if flag stayed Y
select sysdate from dual
where :flag = 'Y';
select 'Wrong Argument or no Argument has been passed correctly!' from dual where :flag != 'Y';
set feedback on
set head on

spool install.log

PROMPT ####################
PROMPT Installation started
PROMPT ####################

-- Constant Package Generation with last argument as current Version
@@src/scripts/install_constant_package '~1' '~2' '~3' '~4' '23.2'

@src/install_quasto_objects.sql
@@src/~script_name_utplsql
@@src/~script_name_apex
@src/scripts/recompile_quasto_objects.sql
@@src/~script_name_utplsql_recompile
@@src/~script_name_apex_recompile

PROMPT #####################
PROMPT Installation finished
PROMPT #####################

column text format a100
column error_count noprint new_value error_count

PROMPT #######################
PROMPT Validating Installation
PROMPT #######################

set heading on
select type, name, sequence, line, position, text, count(1) over() error_count
  from user_errors
 where name not like 'BIN$%' -- not recycled
   and (name = 'VARCHAR2_TAB_T' or name like 'QA\_%' escape '\')
   -- errors only. ignore warnings
   and attribute = 'ERROR'
 order by name, type, sequence
/

begin
  if to_number('~error_count') > 0 then
    dbms_output.put_line('ERROR: Not all sources were successfully installed.');
  else
    dbms_output.put_line('Installation completed successfully.');
  end if;
  dbms_output.put_line('Please check the output written into log file install.log');
end;
/

spool off