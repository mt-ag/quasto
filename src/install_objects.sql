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
PROMPT the install scripts expects 4 diffrent arguments!
PROMPT these arguments are expected in a certain order
PROMPT 
PROMPT example Usage:
PROMPT @install [1/0] [1/0] [1/0] [1/0]
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
PROMPT Argument 4:
PROMPT Do you already have logger installed?
PROMPT (yes/no) (1/0)
PROMPT '------------------------------------'

SET SERVEROUTPUT ON

variable flag char
exec :flag := 'Y';
-- installed Version
variable version_old varchar2 (50 char)
exec :version_old := '1.1';
-- upgrade version
variable version varchar2 (50 char)
exec :version := '23.2';

-- Block to proceess first Argument
declare
    l_script_name_utplsql         varchar2(100) := 'install_utplsql_objects.sql';
    l_script_name_utplsql_upgrade varchar2(100) := 'install_utplsql_objects_' || replace(:version_old,'.','_') || '_to_' || replace(:version,'.','_') || '.sql';
    l_script_name_quasto          varchar2(100) := 'install_quasto_objects.sql';
    l_script_name_quasto_upgrade  varchar2(100) := 'install_quasto_objects_' || replace(:version_old,'.','_') || '_to_' || replace(:version,'.','_') || '.sql';
    l_count                       number;
    l_count_utplsql               number;
    l_current_version             varchar2 (40 char) := :version;
    l_arg                         number := '~1';
begin


    -- Check if Pre Version exists
    select count(1)
    into l_count
    from user_objects
    where object_name = 'QA_MAIN_PKG';

    -- Check if Pre Version exists
    select count(1)
    into l_count_utplsql
    from user_objects
    where object_name = 'CREATE_UT_TEST_PACKAGES_PKG';
    
    if 1 = l_arg and l_count_utplsql > 0
      then 
        l_script_name_utplsql := l_script_name_utplsql_upgrade;
    elsif 0 = l_arg 
      then
        l_script_name_utplsql := 'null.sql'; 
    end if;

    if l_count > 0
      then
        if l_current_version != '1.0'
          then
            l_script_name_quasto  := l_script_name_quasto_upgrade;
        end if;
    end if;

    if l_arg is null
      then
        l_script_name_utplsql  := 'null.sql';
        l_script_name_quasto   := 'null.sql';
        :flag                  := 'N';
        return;
    end if;


    :script_ut_plsql := l_script_name_utplsql;
    :script_quasto   := l_script_name_quasto;
    dbms_output.put_line(l_script_name_utplsql);
    dbms_output.put_line(l_script_name_quasto);
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

-- Constant Package Generation with last argument as current Version
@@src/scripts/install_constant_package '~1' '~2' '~3' '~4' '23.2'

@@src/~script_name_quasto
@@src/~script_name_utplsql
