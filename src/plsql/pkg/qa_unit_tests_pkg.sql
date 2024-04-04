create or replace package qa_unit_tests_pkg authid definer is

  /******************************************************************************
     NAME:       qa_unit_tests_pkg
     PURPOSE:    Methods for generating, modifying and running utPLSQL-compliant unit test procedures for QUASTO
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     23.2       05.11.2023  mwilhelm         Package has been added to QUASTO
     24.1       01.03.2024  mwilhelm         New Data model/tests can be triggered over APEX UI
  ******************************************************************************/

  /**
   * procedure to create unit test packages
   * @param pi_option specifies the creation method
   * @param pi_scheme_names specifies scheme names for which unit test packages should be created
  */
  procedure p_create_unit_test_packages
  (
    pi_option       in number
   ,pi_scheme_names in varchar2_tab_t default null
  );

  /**
   * procedure to delete unit test packages
   * @param pi_scheme_names specifies the scheme names for which packages should be deleted
  */
  procedure p_delete_unit_test_packages(pi_scheme_names in varchar2_tab_t default null);

  /**
   * procedure to create a custom job to run a single unit test
   * @param pi_qaru_rule_number defines the rule number to be executed
   * @param pi_qaru_client_name defines the client name for which the unit test should be executed
   * @param pi_scheme_name defines the scheme name for which the unit test should be executed
  */
  procedure p_create_custom_unit_test_job
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
  );

  /**
   * procedure to run all unit tests and save the xml result in the database - used by scheduler cronjob
  */
  procedure p_run_all_unit_tests;

  /**
   * function to run all unit tests, save the xml result in the database and return the xml result
   * @param  pi_qaru_client_name defines the client name for which the unit tests should be executed
   * @param  pi_scheme_name defines the scheme name for which the unit tests should be executed
   * @param  pi_quasto_scheme defines the scheme name in which the quasto unit tests are saved
   * @param  pi_character_set defines the character set which is used as encoding tag value of the xml
   * @return clob returns the xml
  */
  function f_run_all_unit_tests
  (
    pi_qaru_client_name  in qa_rules.qaru_client_name%type default null
   ,pi_scheme_name       in varchar2 default null
   ,pi_quasto_scheme     in varchar2 default SYS_CONTEXT('USERENV', 'CURRENT_USER')
   ,pi_character_set     in varchar2 default 'Windows-1251'
  ) return clob;

  /**
   * procedure to run a single unit test and save xml result in database
   * @param pi_qaru_rule_number defines the rule number to be executed
   * @param pi_qaru_client_name defines the client name for which the unit test should be executed
   * @param pi_scheme_name defines the scheme name for which the unit test should be executed
  */
  procedure p_run_custom_unit_test
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
   ,pi_character_set    in varchar2 default 'Windows-1251'
  );

  /**
   * procedure to handle the unit test result, generate xml and save the data in database - called by generated test packages
   * @param pi_qaru_rule_number defines the rule number
   * @param pi_qaru_client_name defines the client name of the rule
   * @param pi_qaru_layer defines the layer
   * @param pi_scheme_objects defines schemes with amount of invalid objects
   * @param pi_invalid_objects defines invalid object details and their schemes
   * @param pi_result defines the test result
   * @param pi_program_name defines the qualified program name (package.procedure) of the unit test procedure
  */
  procedure p_handle_test_result
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_layer       in varchar2
   ,pi_scheme_objects   in qa_scheme_object_amounts_t
   ,pi_invalid_objects  in qa_rules_t
   ,pi_result           in number
   ,pi_program_name     in varchar2
  );

  /**
   * procedure to save any occured runtime errors - called by generated test packages
   * @param pi_qaru_rule_number defines the rule number
   * @param pi_qaru_client_name defines the client name
   * @param pi_scheme_name defines the scheme name
   * @param pi_program_name defines the qualified program name (package.procedure)
   * @param pi_runtime_error defines the error backtrace information
  */
  procedure p_handle_test_exception
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2_tab_t
   ,pi_program_name     in varchar2
   ,pi_runtime_error    in varchar2
  );

  /**
   * function to get the name format of a scheduler job
   * @param  pi_qaru_rule_number defines the rule number
   * @param  pi_qaru_client_name defines the client name
   * @param  pi_scheme_name defines the scheme name
   * @param  pi_is_cronjob defines whether to return the name of a custom or the cronjob
   * @return varchar2 returns the job name
  */
  function f_get_job_name
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type default null
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type default null
   ,pi_scheme_name      in varchar2 default null
   ,pi_is_cronjob       in varchar2
  ) return varchar2 deterministic;

  /**
   * function to check if a custom unit test job exists
   * @param  pi_qaru_rule_number defines the rule number
   * @param  pi_qaru_client_name defines the client name
   * @param  pi_scheme_name defines the scheme name
   * @return varchar2 returns the result
  */
  function f_exists_custom_job
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
  ) return varchar2;

  /**
   * function to check if a job is running
   * @param  pi_job_name defines the job name
   * @return varchar2 returns the result
  */
  function f_is_job_running(pi_job_name in varchar2) return varchar2;

  /**
   * function to get status of scheduler cronjob
   * @return varchar2 returns whether scheduler job for execution of unit tests is enabled or not
  */
  function f_is_scheduler_cronjob_enabled return varchar2;

  /**
   * procedure to enable or disable the scheduler cronjob
   * @param pi_status defines the status of the scheduler job
  */
  procedure p_enable_scheduler_cronjob(pi_status in varchar2);

  /**
   * procedure to trigger the scheduler cronjob
  */
  procedure p_trigger_scheduler_cronjob;

  /**
   * function to import an unit test file clob
   * @param pi_xml_clob defines the clob
   * @return number returns the id
  */
  function f_import_test_result(pi_xml_clob in clob) return number;

  /**
   * function to export an unit test clob
   * @param pi_qatr_id defines the id of the unit test result
   * @return clob returns the clob
  */
  function f_export_test_result(pi_qatr_id in qa_test_results.qatr_id%type) return clob;

  /**
   * procedure to create unit tests for given schemes
   * @param pi_option specifies the creation method
   * @param pi_scheme_names defines the scheme names for which untit tests should be created
  */
  procedure p_create_unit_tests_for_schemes
  (
    pi_option       in number
   ,pi_scheme_names in varchar2
  );

  /**
   * procedure to delete unit tests for given schemes
   * @param pi_scheme_names defines the scheme names for which untit tests should be deleted
  */
  procedure p_delete_unit_tests_for_schemes(pi_scheme_names in varchar2);

end qa_unit_tests_pkg;
/
create or replace package body qa_unit_tests_pkg is

  function f_get_suitepath(
    pi_qaru_client_name in qa_rules.qaru_client_name%type default null
   ,pi_scheme_name      in varchar2 default null
   ,pi_get_root_only    in varchar2 default 'N'
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_suitepath';
    l_param_list qa_logger_pkg.tab_param;

    l_client_name_unified varchar2(1000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_get_root_only'
                              ,p_val_03  => pi_get_root_only);
    
    if pi_qaru_client_name is not null and pi_scheme_name is not null and pi_get_root_only = 'N'
    then
      l_client_name_unified := qa_utils_pkg.f_get_unified_string(pi_string => pi_qaru_client_name);
      return lower(qa_constant_pkg.gc_quasto_name || '.' || l_client_name_unified || '.' || pi_scheme_name);
    else
      return lower(qa_constant_pkg.gc_quasto_name);
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the suitepath for unit tests!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_suitepath;

  function f_get_unit_test_call(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_unit_test_call';
    l_param_list qa_logger_pkg.tab_param;

    l_qaru_name_unified varchar2(1000);
    l_client_name_unified varchar2(1000);
    l_rule_number_unified varchar2(1000);
    l_package_name varchar2(1000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_scheme_name'
                              ,p_val_03  => pi_scheme_name);
    
    select qa_utils_pkg.f_get_unified_string(pi_string => qaru_name)
    into l_qaru_name_unified
    from qa_rules
    where qaru_client_name = pi_qaru_client_name
    and qaru_rule_number = pi_qaru_rule_number;

    l_client_name_unified := qa_utils_pkg.f_get_unified_string(pi_string => pi_qaru_client_name, pi_transform_case => 'u');
    l_rule_number_unified := qa_utils_pkg.f_get_unified_string(pi_string => pi_qaru_rule_number);
    
    select object_name
    into l_package_name
    from user_objects
    where object_type = 'PACKAGE'
    and object_name in (upper(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix || pi_scheme_name || '_' || l_client_name_unified || '_pkg')
                       ,upper(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix || pi_scheme_name || '_' || l_client_name_unified || '_' || l_qaru_name_unified || '_pkg'));
    
    return lower(l_package_name || '.p_ut_rule_' || l_rule_number_unified);
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the direct call of a unit test!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_unit_test_call;

  procedure p_validate_input(
    pi_option         in number
   ,pi_scheme_names   in VARCHAR2_TAB_T
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_validate_input';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_exist number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option);

    if pi_option not in (qa_constant_pkg.gc_utplsql_single_package
                        ,qa_constant_pkg.gc_utplsql_single_package_per_rule)
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_option: ' || pi_option);
    elsif pi_scheme_names is not null
    then
      for rec_scheme_names in pi_scheme_names.FIRST .. pi_scheme_names.LAST
      loop
        select decode(count(1), 0, 0, 1)
        into l_scheme_exist
        from dual
        where exists (select null
                      from qa_scheme_names_for_testing_v
                      where username = upper(pi_scheme_names(rec_scheme_names)));
        if l_scheme_exist = 0
        then
          raise_application_error(-20001, 'Invalid input parameter value for pi_scheme_names: ' || pi_scheme_names(rec_scheme_names) || ' - scheme name does not exist');
        end if;
      end loop;
    end if;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Validation of input pi_option=' || pi_option || ' and pi_scheme_names raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to validate the input!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_validate_input;

  procedure p_verify_rules
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_verify_rules';
    l_param_list qa_logger_pkg.tab_param;

    l_exist_rules boolean;
  begin
    l_exist_rules := qa_main_pkg.f_exist_rules;

    if l_exist_rules = false
    then
      raise_application_error(-20001, 'Verification of rules failed: No rules defined.');
    end if;
  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Verification of rules raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to verify rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_verify_rules;

  function f_get_all_scheme_names
  return VARCHAR2_TAB_T
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_all_scheme_names';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names varchar2_tab_t := new varchar2_tab_t();
  begin

     for rec_users in (select username
                       from qa_scheme_names_for_testing_v)
     loop
       l_scheme_names.extend;
       l_scheme_names(l_scheme_names.last) := rec_users.username;
     end loop;
     
     return l_scheme_names;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of all scheme names raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get all scheme names!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_all_scheme_names;

  function f_get_package_spec_header(
    pi_package_name             in varchar2
   ,pi_scheme_name              in varchar2
   ,pi_qaru_client_name         in qa_rules.qaru_client_name%type
   ,pi_qaru_client_name_unified in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_spec_header';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
    l_package_purpose varchar(500) := 'This package contains procedures for utPLSQL to check the QUASTO rules of client ' || pi_qaru_client_name || ' on schema ' || upper(pi_scheme_name);
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_package_name'
                                ,p_val_01  => pi_package_name
                                ,p_name_02 => 'pi_scheme_name'
                                ,p_val_02  => pi_scheme_name
                                ,p_name_03 => 'pi_qaru_client_name'
                                ,p_val_03  => pi_qaru_client_name
                                ,p_name_04 => 'pi_qaru_client_name_unified'
                                ,p_val_04  => pi_qaru_client_name_unified);

      l_clob := 'CREATE OR REPLACE PACKAGE ' || pi_package_name || ' IS' || chr(10) || chr(10);
      l_clob := l_clob || '/******************************************************************************' || chr(10);
      l_clob := l_clob || '   THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10) || chr(10);
      l_clob := l_clob || '   NAME:                  ' || pi_package_name || chr(10);
      l_clob := l_clob || '   PURPOSE:               ' || l_package_purpose || chr(10) || chr(10);

      l_clob := l_clob || '   TIMESTAMP OF CREATION: ' || systimestamp || chr(10);
      l_clob := l_clob || '   SCHEME NAME:           ' || upper(pi_scheme_name) || chr(10);
      l_clob := l_clob || '   CLIENT NAME:           ' || pi_qaru_client_name || chr(10);
      l_clob := l_clob || '******************************************************************************/' || chr(10) || chr(10);

      l_clob := l_clob || '  --%suite(Tests of ' || pi_qaru_client_name || ' on ' || upper(pi_scheme_name) || ')' || chr(10);
      l_clob := l_clob || '  --%suitepath(' || f_get_suitepath(pi_qaru_client_name => pi_qaru_client_name_unified, pi_scheme_name => pi_scheme_name, pi_get_root_only => 'N') || ')' || chr(10) || chr(10);

      l_clob := l_clob || '  c_scheme_name constant varchar2_tab_t := new varchar2_tab_t(''' || upper(pi_scheme_name) || ''');' || chr(10);
      l_clob := l_clob || '  c_client_name constant qa_rules.qaru_client_name%type := ''' || pi_qaru_client_name || ''';' || chr(10) || chr(10);
      
      return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package specification header raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package specification header!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_spec_header;

  function f_get_package_spec_content(
    pi_previous_clob            in clob
   ,pi_qaru_rule_number_unified in varchar2
   ,pi_qaru_name_unified        in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_spec_content';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_qaru_rule_number_unified'
                                ,p_val_01  => pi_qaru_rule_number_unified);

      l_clob := pi_previous_clob || '  --%test(quasto_test_rule_' || pi_qaru_rule_number_unified || '_' || pi_qaru_name_unified || ')' || chr(10);
      l_clob := l_clob || '  PROCEDURE p_ut_rule_' || pi_qaru_rule_number_unified || ';' || chr(10);
      
      return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package specification content raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package specification content!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_spec_content;

  function f_get_package_spec_footer(
    pi_previous_clob in clob
   ,pi_package_name  in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_spec_footer';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_package_name'
                                ,p_val_01  => pi_package_name);

      l_clob := pi_previous_clob || 'END ' || pi_package_name || ';';
      
      return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package specification footer raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package specification footer!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_spec_footer;

  function f_get_package_body_header(
    pi_package_name  in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_body_header';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_package_name'
                                ,p_val_01  => pi_package_name);

      l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || pi_package_name || ' IS' || chr(10);
      
      return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package body header raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package body header!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_body_header;

  function f_get_package_body_content(
    pi_previous_clob            in clob
   ,pi_qaru_rule_number         in qa_rules.qaru_rule_number%type
   ,pi_qaru_rule_number_unified in varchar2
   ,pi_scheme_name              in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_body_content';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_qaru_rule_number'
                                ,p_val_01  => pi_qaru_rule_number
                                ,p_name_02 => 'pi_qaru_rule_number_unified'
                                ,p_val_02  => pi_qaru_rule_number_unified
                                ,p_name_03 => 'pi_scheme_name'
                                ,p_val_03  => pi_scheme_name);

        l_clob := pi_previous_clob || '  PROCEDURE p_ut_rule_' || pi_qaru_rule_number_unified || chr(10);
        l_clob := l_clob || '  IS' || chr(10);
        l_clob := l_clob || '    l_scheme_objects qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();' || chr(10);
        l_clob := l_clob || '    l_invalid_objects qa_rules_t := new qa_rules_t();' || chr(10);
        l_clob := l_clob || '    l_program_name varchar2(4000) := utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(1));' || chr(10);
        l_clob := l_clob || '    l_qaru_rule_number qa_rules.qaru_rule_number%type := ''' || pi_qaru_rule_number || ''';' || chr(10);
        l_clob := l_clob || '    l_result NUMBER;' || chr(10);
        l_clob := l_clob || '  BEGIN' || chr(10);

        l_clob := l_clob || '    qa_main_pkg.p_test_rule(pi_qaru_client_name  => c_client_name,' || chr(10);
        l_clob := l_clob || '                            pi_qaru_rule_number  => l_qaru_rule_number,' || chr(10);
        l_clob := l_clob || '                            pi_scheme_names      => c_scheme_name,' || chr(10);
        l_clob := l_clob || '                            po_result            => l_result,' || chr(10);
        l_clob := l_clob || '                            po_scheme_objects    => l_scheme_objects,' || chr(10);
        l_clob := l_clob || '                            po_invalid_objects   => l_invalid_objects);' || chr(10) || chr(10);

        l_clob := l_clob || '    qa_unit_tests_pkg.p_handle_test_result(pi_qaru_rule_number => l_qaru_rule_number' || chr(10);
        l_clob := l_clob || '                                          ,pi_qaru_client_name => c_client_name' || chr(10);
        l_clob := l_clob || '                                          ,pi_qaru_layer       => l_qaru_rule_number' || chr(10);
        l_clob := l_clob || '                                          ,pi_scheme_objects   => l_scheme_objects' || chr(10);
        l_clob := l_clob || '                                          ,pi_invalid_objects  => l_invalid_objects' || chr(10);
        l_clob := l_clob || '                                          ,pi_result           => l_result' || chr(10);
        l_clob := l_clob || '                                          ,pi_program_name     => l_program_name);' || chr(10);

        l_clob := l_clob || '  EXCEPTION' || chr(10);
        l_clob := l_clob || '    WHEN OTHERS THEN' || chr(10);
        l_clob := l_clob || '      qa_unit_tests_pkg.p_handle_test_exception(pi_qaru_rule_number => l_qaru_rule_number' || chr(10);
        l_clob := l_clob || '                                               ,pi_qaru_client_name => c_client_name' || chr(10);
        l_clob := l_clob || '                                               ,pi_scheme_name      => c_scheme_name' || chr(10);
        l_clob := l_clob || '                                               ,pi_program_name     => l_program_name' || chr(10);
        l_clob := l_clob || '                                               ,pi_runtime_error    => SQLERRM || '' - '' || DBMS_UTILITY.format_error_backtrace);' || chr(10);
        l_clob := l_clob || '      RAISE;' || chr(10);
        l_clob := l_clob || '  END p_ut_rule_' || pi_qaru_rule_number_unified || ';' || chr(10);

        return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package body content raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package body content!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_body_content;

  function f_get_package_body_footer(
    pi_previous_clob in clob
   ,pi_package_name  in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_body_footer';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
      qa_logger_pkg.append_param(p_params  => l_param_list
                                ,p_name_01 => 'pi_package_name'
                                ,p_val_01  => pi_package_name);

      l_clob := pi_previous_clob || 'END ' || pi_package_name || ';';
      
      return l_clob;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Getting of the package body footer raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the package body footer!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_package_body_footer;

  procedure p_create_unit_test_packages(
    pi_option          in number
   ,pi_scheme_names    in VARCHAR2_TAB_T default null
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_create_unit_test_packages';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names VARCHAR2_TAB_T := new VARCHAR2_TAB_T();
    l_package_name varchar2(255);
    l_clob clob;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option);
    dbms_output.enable(buffer_size => 10000000);

    p_validate_input(pi_option         => pi_option
                    ,pi_scheme_names   => pi_scheme_names);

    p_verify_rules;

    p_delete_unit_test_packages(pi_scheme_names  => pi_scheme_names);

    l_scheme_names := pi_scheme_names;
    if l_scheme_names is null
    then
      l_scheme_names := f_get_all_scheme_names;
    end if;

    if pi_option = qa_constant_pkg.gc_utplsql_single_package
    then

      for rec_schemes in l_scheme_names.FIRST .. l_scheme_names.LAST
      loop

        for rec_clients in (select qaru_client_name
                                  ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_client_name, pi_transform_case => 'l') as qaru_client_name_unified
                           from qa_rules
                           where qaru_is_active = 1 
                           group by qaru_client_name)
       loop

         l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || lower(l_scheme_names(rec_schemes)) || '_' || rec_clients.qaru_client_name_unified || '_pkg';

         l_clob := f_get_package_spec_header(pi_package_name             => l_package_name
                                            ,pi_scheme_name              => l_scheme_names(rec_schemes)
                                            ,pi_qaru_client_name         => rec_clients.qaru_client_name
                                            ,pi_qaru_client_name_unified => rec_clients.qaru_client_name_unified);

         for rec_rules in (select qaru_rule_number
                                 ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                                 ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_name, pi_transform_case => 'l') as qaru_name_unified
                           from qa_rules
                           where qaru_client_name = rec_clients.qaru_client_name
                           and qaru_is_active = 1 
                           order by qaru_id asc)
         loop
      
           l_clob := f_get_package_spec_content(pi_previous_clob            => l_clob
                                               ,pi_qaru_rule_number_unified => rec_rules.qaru_rule_number_unified
                                               ,pi_qaru_name_unified        => rec_rules.qaru_name_unified);

         end loop;

         l_clob := f_get_package_spec_footer(pi_previous_clob => l_clob
                                            ,pi_package_name  => l_package_name);

         execute immediate l_clob;
         dbms_output.put_line('Package specification for ' || l_package_name || ' created.');

         l_clob := f_get_package_body_header(pi_package_name => l_package_name);

         for rec_rules in (select qaru_rule_number
                                 ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                           from qa_rules
                           where qaru_client_name = rec_clients.qaru_client_name
                           and qaru_is_active = 1 
                           order by qaru_id asc)
         loop

           l_clob := f_get_package_body_content(pi_previous_clob            => l_clob
                                               ,pi_qaru_rule_number         => rec_rules.qaru_rule_number
                                               ,pi_qaru_rule_number_unified => rec_rules.qaru_rule_number_unified
                                               ,pi_scheme_name              => l_scheme_names(rec_schemes));

         end loop;

         l_clob := f_get_package_body_footer(pi_previous_clob => l_clob
                                            ,pi_package_name  => l_package_name);

       end loop;

       execute immediate l_clob;
       dbms_output.put_line('Package body for ' || l_package_name || ' created.');
    
      end loop;

    elsif pi_option = qa_constant_pkg.gc_utplsql_single_package_per_rule
    then

      for rec_schemes in l_scheme_names.FIRST .. l_scheme_names.LAST
      loop

        for rec_client_rules in (select qaru_client_name
                                       ,qaru_rule_number
                                       ,qaru_name
                                       ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_client_name, pi_transform_case => 'l') as qaru_client_name_unified
                                       ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                                       ,qa_utils_pkg.f_get_unified_string(pi_string => qaru_name, pi_transform_case => 'l') as qaru_name_unified
                                 from qa_rules
                                 where qaru_is_active = 1 
                                 group by qaru_id
                                         ,qaru_client_name
                                         ,qaru_rule_number
                                         ,qaru_name
                                 order by qaru_id asc)
        loop

          l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || lower(l_scheme_names(rec_schemes)) || '_' || rec_client_rules.qaru_client_name_unified || '_' || rec_client_rules.qaru_name_unified ||'_pkg';

          l_clob := f_get_package_spec_header(pi_package_name             => l_package_name
                                             ,pi_scheme_name              => l_scheme_names(rec_schemes)
                                             ,pi_qaru_client_name         => rec_client_rules.qaru_client_name
                                             ,pi_qaru_client_name_unified => rec_client_rules.qaru_client_name_unified);

          l_clob := f_get_package_spec_content(pi_previous_clob            => l_clob
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified
                                              ,pi_qaru_name_unified        => rec_client_rules.qaru_name_unified);

          l_clob := f_get_package_spec_footer(pi_previous_clob => l_clob
                                             ,pi_package_name  => l_package_name);

          execute immediate l_clob;
          dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
      
          l_clob := f_get_package_body_header(pi_package_name => l_package_name);

          l_clob := f_get_package_body_content(pi_previous_clob            => l_clob
                                              ,pi_qaru_rule_number         => rec_client_rules.qaru_rule_number
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified
                                              ,pi_scheme_name              => l_scheme_names(rec_schemes));

          l_clob := f_get_package_body_footer(pi_previous_clob => l_clob
                                             ,pi_package_name  => l_package_name);

          execute immediate l_clob;
          dbms_output.put_line('Package body for ' || l_package_name || ' created.');

        end loop;
    
      end loop;

    end if;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Creation of package ' || l_package_name || ' raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to create the unit test packages!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      dbms_output.disable();
      raise;
  end p_create_unit_test_packages;

  procedure p_delete_unit_test_packages(
    pi_scheme_names  in VARCHAR2_TAB_T
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_delete_unit_test_packages';
    l_param_list qa_logger_pkg.tab_param;

    l_package_name varchar2(255);
  begin

    if pi_scheme_names is not null
    then
      for rec_scheme_names in pi_scheme_names.FIRST .. pi_scheme_names.LAST
      loop
        for rec_packages in (select object_name
                             from user_objects
                             where object_type = 'PACKAGE'
                             and object_name like upper(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix || pi_scheme_names(rec_scheme_names) || '_%'))
        loop
          l_package_name := rec_packages.object_name;
          execute immediate 'DROP PACKAGE ' || l_package_name;
          dbms_output.put_line('Drop of package ' || l_package_name || ' successful.');
        end loop;
     end loop;
   else
     for rec_packages in (select object_name
                          from user_objects
                          where object_type = 'PACKAGE'
                          and object_name like upper(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix || '%'))
     loop
       l_package_name := rec_packages.object_name;
       execute immediate 'DROP PACKAGE ' || l_package_name;
       dbms_output.put_line('Drop of package ' || l_package_name || ' successful.');
     end loop;
   end if;

  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Drop of package ' || l_package_name || ' raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to delete the unit tests!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_delete_unit_test_packages;

  procedure p_create_custom_unit_test_job(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_create_custom_unit_test_job';
    l_param_list qa_logger_pkg.tab_param;

    l_job_start_date date;
    l_job_name varchar2(500);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_scheme_name'
                              ,p_val_03  => pi_scheme_name);
    
    l_job_start_date := systimestamp + interval '5' second;
    l_job_name := f_get_job_name(pi_qaru_rule_number => pi_qaru_rule_number
                                ,pi_qaru_client_name => pi_qaru_client_name
                                ,pi_scheme_name      => pi_scheme_name
                                ,pi_is_cronjob       => 'N');
    l_job_name := l_job_name || '_' || to_char(l_job_start_date,'YYYYMMDDHH24MISS');
    
    dbms_scheduler.create_job(
      job_name   => l_job_name
    , job_type   => 'PLSQL_BLOCK'
    , job_action => 'BEGIN qa_unit_tests_pkg.p_run_custom_unit_test(pi_qaru_rule_number => '''|| pi_qaru_rule_number || ''', pi_qaru_client_name => '''|| pi_qaru_client_name || ''', pi_scheme_name => '''|| pi_scheme_name || '''); END;'
    , start_date => l_job_start_date
    , enabled    => true
    , auto_drop  => true
    , comments   => 'Custom Job to run an Unit Test triggered by APEX app (rule number: '||pi_qaru_rule_number||' - client name: '||pi_qaru_client_name||' - scheme name: '||pi_scheme_name||')'
   );

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to create a custom scheduler job to run an unit test procedure!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_create_custom_unit_test_job;

  procedure p_run_all_unit_tests
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_run_all_unit_tests';
    l_param_list qa_logger_pkg.tab_param;

    l_xml_result clob;
  begin
    l_xml_result := f_run_all_unit_tests;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to run all unit tests!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_run_all_unit_tests;

  function f_run_all_unit_tests(
    pi_qaru_client_name  in qa_rules.qaru_client_name%type default null
   ,pi_scheme_name       in varchar2 default null
   ,pi_quasto_scheme     in varchar2 default SYS_CONTEXT('USERENV', 'CURRENT_USER')
   ,pi_character_set     in varchar2 default 'Windows-1251'
  ) return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_run_all_unit_tests';
    l_param_list qa_logger_pkg.tab_param;

    l_suitepath varchar2(1000);
    l_xml_result clob;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_quasto_scheme'
                              ,p_val_03  => pi_quasto_scheme
                              ,p_name_04 => 'pi_character_set'
                              ,p_val_04  => pi_character_set);
    
    if pi_quasto_scheme is null or pi_character_set is null
    then
      raise_application_error(-20001, 'Missing input parameter value for pi_quasto_scheme: ' || pi_quasto_scheme || ' or pi_character_set: ' || pi_character_set);
    end if;
    
    if pi_qaru_client_name is not null and pi_scheme_name is not null
    then
      l_suitepath := f_get_suitepath(pi_qaru_client_name => pi_qaru_client_name, pi_scheme_name => pi_scheme_name, pi_get_root_only => 'N');
    else
      l_suitepath := f_get_suitepath(pi_get_root_only => 'Y');
    end if;

    dbms_output.enable(buffer_size => 1000000);
    select DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E,column_value).EXTRACT('//text()')).GetClobVal(),1)
    into l_xml_result
    from table(ut.run(a_path => pi_quasto_scheme || ':' || l_suitepath, a_reporter => ut_junit_reporter(), a_client_character_set => pi_character_set));
    dbms_output.disable();

    insert into QA_TEST_RESULTS(QATR_XML_RESULT)
    values (l_xml_result);

    return l_xml_result;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to run all unit tests!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      dbms_output.disable();
      raise;
  end f_run_all_unit_tests;

  procedure p_run_custom_unit_test(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
   ,pi_character_set    in varchar2 default 'Windows-1251'
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_run_custom_unit_test';
    l_param_list qa_logger_pkg.tab_param;

    l_utplsql_call varchar2(1000);
    l_xml_result clob;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_scheme_name'
                              ,p_val_03  => pi_scheme_name
                              ,p_name_04 => 'pi_character_set'
                              ,p_val_04  => pi_character_set);

    if pi_qaru_rule_number is null or pi_qaru_client_name is null or pi_scheme_name is null or pi_character_set is null
    then
      raise_application_error(-20001, 'Missing input parameter value for pi_qaru_rule_number: ' || pi_qaru_rule_number || ' or pi_qaru_client_name: ' || pi_qaru_client_name || ' or pi_scheme_name: ' || pi_scheme_name || ' or pi_character_set: ' || pi_character_set);
    end if;

    l_utplsql_call := f_get_unit_test_call(pi_qaru_rule_number => pi_qaru_rule_number, pi_qaru_client_name => pi_qaru_client_name, pi_scheme_name => pi_scheme_name);

    dbms_output.enable(buffer_size => 1000000);
    select DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E,column_value).EXTRACT('//text()')).GetClobVal(),1)
    into l_xml_result
    from table(ut.run(a_path => l_utplsql_call, a_reporter => ut_junit_reporter(), a_client_character_set => pi_character_set));
    dbms_output.disable();
    
    insert into QA_TEST_RESULTS(QATR_XML_RESULT)
    values (l_xml_result);

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while running a single unit test!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      dbms_output.disable();
      raise;
  end p_run_custom_unit_test;

  function f_save_scheme_result(
    pi_scheme_name  in varchar2
   ,pi_program_name in varchar2
   ,pi_qaru_id      in number
   ,pi_result       in number
  ) return number
  is
  pragma autonomous_transaction;  
    l_qatr_id number;
  begin
    if pi_result not in (qa_constant_pkg.gc_utplsql_scheme_result_failure
                        ,qa_constant_pkg.gc_utplsql_scheme_result_success
                        ,qa_constant_pkg.gc_utplsql_scheme_result_error
                        )
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_result: ' || pi_result);
    end if;

    insert into QA_TEST_RUNS (qatr_scheme_name, qatr_date, qatr_result, qatr_qaru_id, qatr_program_name)
    values (pi_scheme_name, sysdate, pi_result, pi_qaru_id, pi_program_name)
    returning qatr_id into l_qatr_id;
    commit;
    
    return l_qatr_id;
  exception
    when others then
      raise;
  end f_save_scheme_result;

  procedure p_save_scheme_faulty_objects(
    pi_object_name    in varchar2
   ,pi_object_details in varchar2
   ,pi_qatr_id        in number
  ) is
  pragma autonomous_transaction;
  begin
    insert into QA_TEST_RUN_INVALID_OBJECTS (qato_object_name, qato_object_details, qato_qatr_id)
    values (pi_object_name, pi_object_details, pi_qatr_id);
    commit;
  exception
    when others then
      raise;
  end p_save_scheme_faulty_objects;

  procedure p_handle_test_result(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_layer       in varchar2
   ,pi_scheme_objects   in qa_scheme_object_amounts_t
   ,pi_invalid_objects  in qa_rules_t
   ,pi_result           in number
   ,pi_program_name     in varchar2
  )
  is
    l_qaru_id number;
    l_qatr_id number;
  begin

    ut.expect(pi_result).to_equal(1);
    l_qaru_id := qa_main_pkg.f_get_rule_pk(pi_qaru_rule_number => pi_qaru_rule_number
                                          ,pi_qaru_client_name => pi_qaru_client_name);

    dbms_output.put_line('<Results rulenumber="' || DBMS_XMLGEN.CONVERT(pi_qaru_rule_number) || '" layer="' || DBMS_XMLGEN.CONVERT(pi_qaru_layer) || '" result="'||pi_result||'">');
    for rec_scheme_objects in ( select scheme_name
                                      ,object_amount
                                from table(pi_scheme_objects)
                              )
    loop
      if rec_scheme_objects.object_amount = 0
      then
        dbms_output.put_line('<Scheme name="'||DBMS_XMLGEN.CONVERT(rec_scheme_objects.scheme_name)||'" result="'||qa_constant_pkg.gc_utplsql_scheme_result_success||'"></Scheme>');
        l_qatr_id := f_save_scheme_result(pi_scheme_name  => rec_scheme_objects.scheme_name
                                         ,pi_program_name => pi_program_name
                                         ,pi_qaru_id      => l_qaru_id
                                         ,pi_result       => qa_constant_pkg.gc_utplsql_scheme_result_success);
      else
        dbms_output.put_line('<Scheme name="'||DBMS_XMLGEN.CONVERT(rec_scheme_objects.scheme_name)||'" result="'||qa_constant_pkg.gc_utplsql_scheme_result_failure||'">');
        l_qatr_id := f_save_scheme_result(pi_scheme_name  => rec_scheme_objects.scheme_name
                                         ,pi_program_name => pi_program_name
                                         ,pi_qaru_id      => l_qaru_id
                                         ,pi_result       => qa_constant_pkg.gc_utplsql_scheme_result_failure);
        
        for rec_scheme_invalid_objects in ( select object_name
                                                  ,object_details
                                                  ,qaru_error_message
                                            from table(pi_invalid_objects)
                                            where scheme_name = rec_scheme_objects.scheme_name
                                          )
        loop
          dbms_output.put_line('<Object name="'||DBMS_XMLGEN.CONVERT(rec_scheme_invalid_objects.object_name)||'" details="'||DBMS_XMLGEN.CONVERT(rec_scheme_invalid_objects.object_details)||'">'||rec_scheme_invalid_objects.qaru_error_message||'</Object>');
          p_save_scheme_faulty_objects(pi_object_name    => rec_scheme_invalid_objects.object_name
                                      ,pi_object_details => rec_scheme_invalid_objects.object_details
                                      ,pi_qatr_id        => l_qatr_id);
        
        end loop;
        dbms_output.put_line('</Scheme>');
      end if;
    end loop;
    dbms_output.put_line('</Results>');

  exception
    when others then
      raise;
  end p_handle_test_result;

  procedure p_handle_test_exception(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2_tab_t
   ,pi_program_name     in varchar2
   ,pi_runtime_error    in varchar2
  )
  is
  pragma autonomous_transaction;
    l_scheme_name varchar2(100);
    l_qaru_id number;
    l_qatr_id number;
  begin    
    l_scheme_name := qa_utils_pkg.f_get_table_as_string(pi_table     => pi_scheme_name
                                                       ,pi_separator => ',');
    l_qaru_id := qa_main_pkg.f_get_rule_pk(pi_qaru_rule_number => pi_qaru_rule_number
                                          ,pi_qaru_client_name => pi_qaru_client_name);
    l_qatr_id := f_save_scheme_result(pi_scheme_name  => l_scheme_name
                                     ,pi_program_name => pi_program_name
                                     ,pi_qaru_id      => l_qaru_id
                                     ,pi_result       => qa_constant_pkg.gc_utplsql_scheme_result_error);
    update QA_TEST_RUNS
    set qatr_runtime_error = pi_runtime_error
    where qatr_id = l_qatr_id;
    commit;
  exception
    when others then
      raise;
  end p_handle_test_exception;

  function f_get_job_name(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type default null
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type default null
   ,pi_scheme_name      in varchar2 default null
   ,pi_is_cronjob       in varchar2
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_job_name';
    l_param_list qa_logger_pkg.tab_param;

    l_client_name varchar2(500);
    l_scheme_name varchar2(500);
    l_rule_number varchar2(5);
    l_job_name varchar2(500);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_scheme_name'
                              ,p_val_03  => pi_scheme_name
                              ,p_name_04 => 'pi_is_cronjob'
                              ,p_val_04  => pi_is_cronjob);
    
    if ((pi_qaru_rule_number is null or pi_qaru_client_name is null or pi_scheme_name is null) and pi_is_cronjob != 'Y')
    or pi_is_cronjob not in ('Y','N')
    then
      raise_application_error(-20001, 'Missing or invalid input parameter value for pi_qaru_rule_number: ' || pi_qaru_rule_number || ', pi_qaru_client_name: ' || pi_qaru_client_name || ', pi_scheme_name: ' || pi_scheme_name || ', pi_is_cronjob: ' || pi_is_cronjob);
    end if;
    
    if pi_is_cronjob = 'Y'
    then
      l_job_name := qa_constant_pkg.gc_utplsql_scheduler_cronjob_name;
    else
      l_client_name := qa_utils_pkg.f_get_unified_string(pi_string => pi_qaru_client_name, pi_transform_case => 'u');
      l_scheme_name := qa_utils_pkg.f_get_unified_string(pi_string => pi_scheme_name, pi_transform_case => 'u');
      l_rule_number := qa_utils_pkg.f_get_unified_string(pi_string => pi_qaru_rule_number);

      l_job_name := qa_constant_pkg.gc_utplsql_custom_scheduler_job_name || '_' || l_scheme_name || '_' || l_client_name || '_' || l_rule_number;
    end if;
   
   return l_job_name;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get a custom job name!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_job_name;

  function f_exists_custom_job(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_exists_custom_job';
    l_param_list qa_logger_pkg.tab_param;

    l_job_name varchar2(500);
    l_exists number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_scheme_name'
                              ,p_val_03  => pi_scheme_name);

    l_job_name := f_get_job_name(pi_qaru_rule_number => pi_qaru_rule_number
                                ,pi_qaru_client_name => pi_qaru_client_name
                                ,pi_scheme_name      => pi_scheme_name
                                ,pi_is_cronjob       => 'N');

    select decode(count(1), 0, 0, 1)
    into l_exists
    from dual
    where exists (select null
                  from USER_SCHEDULER_JOBS
                  where job_name like l_job_name || '_%');

   if l_exists = 0
   then
      return 'N';
   else
      return 'Y';
   end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to check if custom unit test jobs exist!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_exists_custom_job;

  function f_is_job_running(
    pi_job_name      in varchar2
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_is_job_running';
    l_param_list qa_logger_pkg.tab_param;

    l_exist number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_job_name'
                              ,p_val_01  => pi_job_name);

    select decode(count(1), 0, 0, 1)
    into l_exist
    from dual
    where exists (select null
                  from USER_SCHEDULER_RUNNING_JOBS
                  where job_name = pi_job_name);

   if l_exist = 0
   then
      return 'N';
   else
      return 'Y';
   end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to check if a unit test job is running!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_is_job_running;

  function f_is_scheduler_cronjob_enabled
  return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_is_scheduler_cronjob_enabled';
    l_param_list qa_logger_pkg.tab_param;

    l_result number;
  begin
    select decode(count(1), 0, 0, 1)
    into l_result
    from dual
    where exists (select null
                  from user_scheduler_jobs
                  where job_name = qa_constant_pkg.gc_utplsql_scheduler_cronjob_name
                  and enabled = 'TRUE');

    if l_result = 1
    then
      return 'Y';
    else
      return 'N';
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the status of the ut scheduler cronjob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_is_scheduler_cronjob_enabled;

  procedure p_enable_scheduler_cronjob(
    pi_status in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_enable_scheduler_cronjob';
    l_param_list qa_logger_pkg.tab_param;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_status'
                              ,p_val_01  => pi_status);

    if pi_status not in ('Y'
                        ,'N')
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_status: ' || pi_status);
    end if;

    if pi_status = 'Y'
    then
      dbms_scheduler.enable(qa_constant_pkg.gc_utplsql_scheduler_cronjob_name);
    else
      dbms_scheduler.disable(qa_constant_pkg.gc_utplsql_scheduler_cronjob_name);
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to enable the ut scheduler cronjob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_enable_scheduler_cronjob;

  procedure p_trigger_scheduler_cronjob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_trigger_scheduler_cronjob';
    l_param_list qa_logger_pkg.tab_param;
  begin

    if f_is_job_running(pi_job_name => qa_constant_pkg.gc_utplsql_scheduler_cronjob_name) = 'N'
    then
      dbms_scheduler.run_job(job_name => qa_constant_pkg.gc_utplsql_scheduler_cronjob_name, use_current_session => false);
    else
      raise_application_error(-20001, 'Scheduler Cronjob is currently running: ' || qa_constant_pkg.gc_utplsql_scheduler_cronjob_name);
    end if;

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to trigger the ut scheduler cronjob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_trigger_scheduler_cronjob;

  function f_import_test_result
  (
    pi_xml_clob in clob
  ) return number
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_import_test_result';
    l_param_list qa_logger_pkg.tab_param;
  begin
    
    insert into qa_test_results(qatr_xml_result)
    values (pi_xml_clob);
    
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to import a xml test result!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_import_test_result;

  function f_export_test_result
  (
    pi_qatr_id in qa_test_results.qatr_id%type
  ) return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_export_test_result';
    l_param_list qa_logger_pkg.tab_param;

    l_return clob;
  begin
    
    select qatr_xml_result
    into l_return
    from qa_test_results
    where qatr_id = pi_qatr_id;
    
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to export a xml test result!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_export_test_result;

  procedure p_create_unit_tests_for_schemes(
    pi_option       in number
   ,pi_scheme_names in varchar2
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_create_unit_tests_for_schemes';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names varchar2_tab_t := new varchar2_tab_t();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option
                              ,p_name_02 => 'pi_scheme_names'
                              ,p_val_02  => pi_scheme_names);

    if pi_scheme_names is null
    then
      p_create_unit_test_packages(pi_option => pi_option);
    else
      l_scheme_names := qa_utils_pkg.f_get_string_as_table(pi_string    => pi_scheme_names
                                                          ,pi_separator => ':');
      p_create_unit_test_packages(pi_option       => pi_option
                                 ,pi_scheme_names => l_scheme_names);
    end if;

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to create unit tests for schemes!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_create_unit_tests_for_schemes;

  procedure p_delete_unit_tests_for_schemes(
    pi_scheme_names in varchar2
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_delete_unit_tests_for_schemes';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names varchar2_tab_t := new varchar2_tab_t();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_scheme_names'
                              ,p_val_01  => pi_scheme_names);

    if pi_scheme_names is null
    then
      p_delete_unit_test_packages;
    else
      l_scheme_names := qa_utils_pkg.f_get_string_as_table(pi_string    => pi_scheme_names
                                                          ,pi_separator => ':');
      p_delete_unit_test_packages(pi_scheme_names => l_scheme_names);
    end if;

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to delete unit tests for schemes!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_delete_unit_tests_for_schemes;

end qa_unit_tests_pkg;
/
