PROMPT SQL file for installing the constant package
set define '~'
set concat on
set concat .
set verify off

declare
  l_count        number;
  l_action       varchar2(32767);
  l_utplsql_flag number := '~1';
  l_apex_flag    number := '~2';
  l_jenkins_flag number := '~3';
  l_logger_flag  number := '~4';
  l_apex_version varchar2(50) := '~5';

  l_utplsql_single_package number := 1;
  l_utplsql_single_package_per_rule number := 2;
  l_utplsql_ut_test_packages_prefix varchar2(10) := 'QA_UT_';
  l_utplsql_scheduler_job_name varchar2(30) := 'JOB_RUN_UNIT_TESTS';
begin
  l_action := 'create or replace package qa_constant_pkg
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
  ******************************************************************************/

    gc_quasto_name               constant varchar(50 char)     := ''QUASTO'';
    gc_quasto_version            constant varchar(50 char)     := ' || '''' || l_apex_version || '''' || ';
    gc_utplsql_flag              constant number               := ' || l_utplsql_flag || ';
    gc_apex_flag                 constant number               := ' || l_apex_flag || ';
    gc_logger_flag               constant number               := ' || l_logger_flag || ';
    gc_black_list_exception_text constant varchar2 (5000 char) := ' || '''' || 'A User has tried to be tested that is blacklisted in the View qa_scheme_names_for_testing_v!' || '''' || '|| chr(13) ||' || '''' || 'To edit blacklisted users please edit the View mentioned above!' || '''' || ' || chr(13) ||' || '''' || 'User:' || '''' || ';

    gc_utplsql_single_package          constant number := ' || l_utplsql_single_package || ';
    gc_utplsql_single_package_per_rule constant number := ' || l_utplsql_single_package_per_rule || ';
    gc_utplsql_ut_test_packages_prefix constant varchar2(10) := ' || '''' || l_utplsql_ut_test_packages_prefix || '''' || ';
    gc_utplsql_scheduler_job_name      constant varchar2(30) := ' || '''' || l_utplsql_scheduler_job_name || '''' || ';

end;';

    dbms_output.put_line(l_action);
    execute immediate l_action;

    select count(1)
    into l_count
    from user_objects
    where object_name = upper('qa_constant_pkg');

    if l_count = 0
      then
        dbms_output.put_line('ERROR: qa_constant_pkg could not be created');
    else
        dbms_output.put_line('INFO: qa_constant_pkg was succesfully created');
    end if;
  exception
    when others then
      raise;
end;
/