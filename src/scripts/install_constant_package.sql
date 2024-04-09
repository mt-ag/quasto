PROMPT SQL file for installing the constant package
set define '~'
set concat on
set concat .
set verify off

declare
  l_count           number;
  l_action_pkg_spec varchar2(32767);
  l_action_pkg_body varchar2(32767);
  l_utplsql_flag    number := '~1';
  l_apex_flag       number := '~2';
  l_jenkins_flag    number := '~3';
  l_logger_flag     number := '~4';
  l_apex_version    varchar2(50) := '~5';

  l_utplsql_single_package number := 1;
  l_utplsql_single_package_per_rule number := 2;
  l_utplsql_ut_test_packages_prefix varchar2(10) := 'QA_UT_';
  l_utplsql_scheduler_cronjob_name varchar2(30) := 'CRONJOB_RUN_UNIT_TESTS';
  l_utplsql_custom_scheduler_job_name varchar2(30) := 'JOB_RUN_UNIT_TEST';
  l_utplsql_scheme_result_failure number := 0;
  l_utplsql_scheme_result_success number := 1;
  l_utplsql_scheme_result_error number := 2;
begin
  l_action_pkg_spec := 'create or replace package qa_constant_pkg
    authid definer
  is

  /******************************************************************************
     NAME:       qa_constant_pkg
     PURPOSE:    Global constants for QUASTO

     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.1        21.04.2023  pdahlem          Package has been added to QUASTO
     23.2       05.11.2023  mwilhelm         Added new constants for utPLSQL objects
     24.1       08.04.2024  mwilhelm         Added functions to get constant values
  ******************************************************************************/

    gc_quasto_name               constant varchar(50 char)     := ''QUASTO'';
    gc_quasto_version            constant varchar(50 char)     := ' || '''' || l_apex_version || '''' || ';
    gc_utplsql_flag              constant number               := ' || l_utplsql_flag || ';
    gc_apex_flag                 constant number               := ' || l_apex_flag || ';
    gc_logger_flag               constant number               := ' || l_logger_flag || ';
    gc_black_list_exception_text constant varchar2 (5000 char) := ' || '''' || 'A User has tried to be tested that is blacklisted in the View qa_scheme_names_for_testing_v!' || '''' || '|| chr(13) ||' || '''' || 'To edit blacklisted users please edit the View mentioned above!' || '''' || ' || chr(13) ||' || '''' || 'User:' || '''' || ';

    gc_utplsql_single_package             constant number := ' || l_utplsql_single_package || ';
    gc_utplsql_single_package_per_rule    constant number := ' || l_utplsql_single_package_per_rule || ';
    gc_utplsql_ut_test_packages_prefix    constant varchar2(10) := ' || '''' || l_utplsql_ut_test_packages_prefix || '''' || ';
    gc_utplsql_scheduler_cronjob_name     constant varchar2(30) := ' || '''' || l_utplsql_scheduler_cronjob_name || '''' || ';
    gc_utplsql_custom_scheduler_job_name  constant varchar2(30) := ' || '''' || l_utplsql_custom_scheduler_job_name || '''' || ';

    gc_utplsql_scheme_result_failure      constant number := ' || '''' || l_utplsql_scheme_result_failure || '''' || ';
    gc_utplsql_scheme_result_success      constant number := ' || '''' || l_utplsql_scheme_result_success || '''' || ';
    gc_utplsql_scheme_result_error        constant number := ' || '''' || l_utplsql_scheme_result_error || '''' || ';

    function f_get_constant_string_value (
      pi_constant_name in varchar2
    ) return varchar2;

    function f_get_constant_number_value (
      pi_constant_name in varchar2
    ) return number;

end;';

  l_action_pkg_body := 'create or replace package body qa_constant_pkg as

  function f_get_constant_string_value (
    pi_constant_name in varchar2
  ) return varchar2
  as
    l_constant_value varchar2(4000);
  begin
    case upper(pi_constant_name)
      -- core constants
      when upper(''gc_quasto_name'')                       then l_constant_value := gc_quasto_name;
      when upper(''gc_quasto_version'')                    then l_constant_value := gc_quasto_version;
      when upper(''gc_black_list_exception_text'')         then l_constant_value := gc_black_list_exception_text;
      
      -- utPLSQL Unit test constants
      when upper(''gc_utplsql_ut_test_packages_prefix'')   then l_constant_value := gc_utplsql_ut_test_packages_prefix;
      when upper(''gc_utplsql_scheduler_cronjob_name'')    then l_constant_value := gc_utplsql_scheduler_cronjob_name;
      when upper(''gc_utplsql_custom_scheduler_job_name'') then l_constant_value := gc_utplsql_custom_scheduler_job_name;

      else raise_application_error(-20001, ''Invalid input parameter value for pi_constant_name: '' || pi_constant_name);
    end case;
     
    return l_constant_value;
  end f_get_constant_string_value;

  function f_get_constant_number_value (
    pi_constant_name in varchar2
  ) return number
  as
    l_constant_value number;
  begin
    case upper(pi_constant_name)
      -- core constants
      when upper(''gc_utplsql_flag'')                      then l_constant_value := gc_utplsql_flag;
      when upper(''gc_apex_flag'')                         then l_constant_value := gc_apex_flag;
      when upper(''gc_logger_flag'')                       then l_constant_value := gc_logger_flag;

      -- utPLSQL Unit test constants
      when upper(''gc_utplsql_single_package'')            then l_constant_value := gc_utplsql_single_package;
      when upper(''gc_utplsql_single_package_per_rule'')   then l_constant_value := gc_utplsql_single_package_per_rule;
      when upper(''gc_utplsql_scheme_result_failure'')     then l_constant_value := gc_utplsql_scheme_result_failure;
      when upper(''gc_utplsql_scheme_result_success'')     then l_constant_value := gc_utplsql_scheme_result_success;
      when upper(''gc_utplsql_scheme_result_error'')       then l_constant_value := gc_utplsql_scheme_result_error;

      else raise_application_error(-20001, ''Invalid input parameter value for pi_constant_name: '' || pi_constant_name);
    end case;
     
    return l_constant_value;
  end f_get_constant_number_value;

end qa_constant_pkg;';

    dbms_output.put_line(l_action_pkg_spec);
    execute immediate l_action_pkg_spec;

    dbms_output.put_line(l_action_pkg_body);
    execute immediate l_action_pkg_body;

    select count(1)
    into l_count
    from user_objects
    where object_name = upper('qa_constant_pkg');

    if l_count = 2
      then
        dbms_output.put_line('INFO: qa_constant_pkg was succesfully created');
    else
        dbms_output.put_line('ERROR: qa_constant_pkg could not be created');
    end if;
  exception
    when others then
      raise;
end;
/