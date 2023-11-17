PROMPT SQL file for installing the utPLSQL and QUASTO objects on a database. Called from install.sql.
set define '~'
set concat on
set concat .
set verify off
set serveroutput on


-- QUASTO upgrade version
variable version varchar2 (50 char)
exec :version := '23.2';

-- script for utPLSQL Objects
COLUMN :script_ut_plsql NEW_VALUE script_name_utplsql NOPRINT
variable script_ut_plsql VARCHAR2(50)

-- script for QUASTO Objects
COLUMN :script_quasto NEW_VALUE script_name_quasto NOPRINT
variable script_quasto VARCHAR2(50)

-- current version installed
COLUMN :version_old NEW_VALUE script_version_old NOPRINT
variable version_old VARCHAR2(50)


-- begin instruction
PROMPT '-------------------------------------------------'
PROMPT The install scripts expects 4 different arguments.
PROMPT Accepted values: Yes = 1 | No = 0
PROMPT '-------------------------------------------------'


-- user input param verifications
ACCEPT argument1_in CHAR PROMPT 'Do you have installed utPLSQL? (yes/no) (1/0)'
ACCEPT argument2_in CHAR PROMPT 'Do you have installed Oracle APEX? (yes/no) (1/0)'
ACCEPT argument3_in CHAR PROMPT 'Do you pass specific Jenkins parameters to the script? (yes/no) (1/0)'
ACCEPT argument4_in CHAR PROMPT 'Do you already have logger installed? (yes/no) (1/0)'

WHENEVER SQLERROR EXIT FAILURE
begin
  if   '~argument1_in' is null or '~argument1_in' not in ('0','1')
    or '~argument2_in' is null or '~argument2_in' not in ('0','1')
    or '~argument3_in' is null or '~argument3_in' not in ('0','1')
    or '~argument4_in' is null or '~argument4_in' not in ('0','1')
  then
    RAISE_APPLICATION_ERROR(-20001, 'ERROR: Wrong number of arguments given or invalid values provided.');
  else
    dbms_output.put_line('INFO: Continue.');
  end if;
end;
/
WHENEVER SQLERROR CONTINUE

-- Block to proceess first Argument
declare
    l_script_name_utplsql         varchar2(100) := 'install_utplsql_objects.sql';
    l_script_name_utplsql_upgrade varchar2(100);
    l_script_name_quasto          varchar2(100) := 'install_quasto_objects.sql';
    l_script_name_quasto_upgrade  varchar2(100);
    l_count                       number;
    l_count_utplsql               number;
    l_version_old                 varchar2 (40 char);
    l_current_version             varchar2 (40 char) := :version;

    function get_version_constant return varchar2 as
      l_ret varchar2 (50 char);
    begin
      select trim(replace(REGEXP_SUBSTR(text, ':=(.*?);', 1, 1, NULL, 1),'''','')) AS version_old
      into l_ret
      from user_source
      where type = 'PACKAGE'
      and name = 'QA_CONSTANT_PKG'
      and upper(text) like upper('%gc_quasto_version constant varchar(50 char) :=%');
      
      if l_ret is null
        then
          l_ret := '1.0';
      end if;

      return l_ret;
    exception
      when others then
        return '1.0';
    end;
begin
    
    l_version_old := get_version_constant;
    if l_version_old = :version
      then 
      l_version_old := '1.1';
    end if;

    l_script_name_utplsql_upgrade := 'install_utplsql_objects_' || replace(l_version_old,'.','_') || '_to_' || replace(:version,'.','_') || '.sql';
    l_script_name_quasto_upgrade  := 'install_quasto_objects_' || replace(l_version_old,'.','_') || '_to_' || replace(:version,'.','_') || '.sql';

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
    
    if '1' = '~argument1_in' and l_count_utplsql > 0
      then 
        l_script_name_utplsql := l_script_name_utplsql_upgrade;
    elsif '0' = '~argument1_in'
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

    if '~argument1_in' is null
      then
        l_script_name_utplsql  := 'null.sql';
        l_script_name_quasto   := 'null.sql';
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
set feedback on
set head on

-- Constant Package Generation with last argument as current Version
@@src/scripts/install_constant_package '~argument1_in' '~argument2_in' '~argument3_in' '~argument4_in' '23.2'

@@src/~script_name_quasto
@@src/~script_name_utplsql