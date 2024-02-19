create or replace package qa_unit_tests_pkg authid definer is

  /******************************************************************************
     NAME:       qa_unit_tests_pkg
     PURPOSE:    Methods for generating, modifying and running utPLSQL-compliant unit test procedures for QUASTO
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     23.2       05.11.2023  mwilhelm         Package has been added to QUASTO
  ******************************************************************************/

  /**
   * procedure to create unit test packages
   * @param pi_option specifies the creation method
   * @param pi_scheme_names specifies scheme names to be tested
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
   * procedure to run unit tests from scheduler cronjob
   * @param po_result returns the result message
  */
  procedure p_run_unit_tests_from_cronjob(po_result out varchar2);

  /**
   * procedure to enable or disable the scheduler cronjob
   * @param pi_status defines the status of the scheduler job
  */
  procedure p_enable_scheduler_cronjob(pi_status in varchar2);

  /**
   * procedure to create a custom job to run a single unit test
   * @param pi_client_name defines the client name for which the unit test should be executed
   * @param pi_scheme_name defines the scheme name for which the unit test should be executed
   * @param pi_qaru_rule_number defines the rule number to be executed
  */
  procedure p_create_custom_unit_test_job
  (
    pi_client_name      in varchar2
   ,pi_scheme_name      in varchar2
   ,pi_qaru_rule_number in varchar2
  );

  /**
   * procedure to run an unit test from custom scheduler job
   * @param pi_client_name defines the client name for which the unit test should be executed
   * @param pi_scheme_name defines the scheme name for which the unit test should be executed
   * @param pi_qaru_rule_number defines the rule number to be executed
  */
  procedure p_run_custom_unit_test
  (
    pi_client_name      in varchar2
   ,pi_scheme_name      in varchar2
   ,pi_qaru_rule_number in varchar2
  );

  /**
   * function to save the failed result of a scheme - called from generated test packages
   * @param pi_scheme_name defines the scheme name for which faulty objects were found
   * @param pi_qaru_id defines the rule id of the tested rule
   * @param pi_result defines the result as number
   * @return number returns the qatr_id
  */
  function f_save_scheme_error_result
  (
    pi_scheme_name in varchar2
   ,pi_qaru_id     in number
   ,pi_result      in number
  ) return number;

  /**
   * procedure to save the details of faulty scheme objects - called from generated test packages
   * @param pi_object_name defines the name of the object
   * @param pi_object_details defines details about the object
   * @param pi_qatr_id defines the test result id to which the objects belong to
  */
  procedure p_save_scheme_faulty_objects
  (
    pi_object_name    in varchar2
   ,pi_object_details in varchar2
   ,pi_qatr_id        in number
  );

  /**
   * procedure to save any occured runtime errors - called from generated test packages
   * @param pi_qaru_rule_number defines the rule number
   * @param pi_qaru_client_name defines the client name
   * @param pi_scheme_name defines the scheme name
  */
  procedure p_save_scheme_result_with_runtime_error
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2_tab_t
  );

  /**
   * function to run all unit tests from scheduler cronjob
   * @param  pi_client_name defines the client name for which the unit tests should be executed
   * @param  pi_scheme_name defines the scheme name for which the unit tests should be executed
   * @return clob returns the xml
  */
  function f_run_unit_tests_from_scheduler_cronjob
  (
    pi_client_name in varchar2 default null
   ,pi_scheme_name in varchar2 default null
  ) return clob;

  /**
   * function to get status of scheduler cronjob
   * @return varchar2 returns whether scheduler job for execution of unit tests is enabled or not
  */
  function f_is_scheduler_cronjob_enabled return varchar2;

  /**
   * function to convert and unify a given string - for internal use only
   * @param  pi_string defines the string to be converted
   * @param  pi_transform_case defines the transformation as l - lowercase - or u - uppercase
   * @return varchar2 returns the unified string
  */
  function f_get_unified_string
  (
    pi_string         in varchar2
   ,pi_transform_case in varchar2 default null
  ) return varchar2 deterministic;

  /**
   * function to get the name format of a scheduler job
   * @param  pi_scheme_name defines the scheme name
   * @param  pi_client_name defines the client name
   * @param  pi_qaru_rule_number defines the rule number
   * @param  pi_is_cronjob defines whether to return the name of a custom or the cronjob
   * @param  pi_job_start_date defines a start date which to include
   * @return varchar2 returns the job name
  */
  function f_get_job_name
  (
    pi_scheme_name      in varchar2 default null
   ,pi_client_name      in varchar2 default null
   ,pi_qaru_rule_number in varchar2 default null
   ,pi_is_cronjob       in varchar2
   ,pi_job_start_date   in date default null
  ) return varchar2 deterministic;

end qa_unit_tests_pkg;
/
create or replace package body qa_unit_tests_pkg is

  function f_get_unified_string(
    pi_string          in varchar2
   ,pi_transform_case  in varchar2 default null
  ) return varchar2 deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_unified_string';
    l_param_list qa_logger_pkg.tab_param;

    v_string varchar2(500);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_string'
                              ,p_val_01  => pi_string
                              ,p_name_02 => 'pi_transform_case'
                              ,p_val_02  => pi_transform_case);
                              
    if pi_string is null
    or (pi_transform_case is not null and lower(pi_transform_case) not in ('l','u'))
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_string: ' || pi_string || ' or pi_transform_case: ' || pi_transform_case);
    end if;
    
    v_string := regexp_replace(replace(pi_string
                                      ,' '
                                      ,'_')
                              ,'[^a-zA-Z0-9_]'
                              ,'_');

    if lower(pi_transform_case) = 'l'
    then
      v_string := lower(v_string);
    elsif lower(pi_transform_case) = 'u'
    then
      v_string := upper(v_string);
    end if;
    
    return v_string;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to generate an unified string!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_unified_string;

  function f_get_job_name(
    pi_scheme_name       in varchar2 default null
   ,pi_client_name       in varchar2 default null
   ,pi_qaru_rule_number  in varchar2 default null
   ,pi_is_cronjob        in varchar2
   ,pi_job_start_date    in date default null
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
                              ,p_name_01 => 'pi_scheme_name'
                              ,p_val_01  => pi_scheme_name
                              ,p_name_02 => 'pi_client_name'
                              ,p_val_02  => pi_client_name
                              ,p_name_03 => 'pi_qaru_rule_number'
                              ,p_val_03  => pi_qaru_rule_number
                              ,p_name_04 => 'pi_is_cronjob'
                              ,p_val_04  => pi_is_cronjob
                              ,p_name_05 => 'pi_job_start_date'
                              ,p_val_05  => pi_job_start_date);
    
    if ((pi_scheme_name is null or pi_client_name is null or pi_qaru_rule_number is null) and pi_is_cronjob != 'Y')
    or pi_is_cronjob not in ('Y','N')
    then
      raise_application_error(-20001, 'Invalid input parameter value or value missing for pi_scheme_name: ' || pi_scheme_name || ', pi_client_name: ' || pi_client_name || ', pi_qaru_rule_number: ' || pi_qaru_rule_number || ', pi_is_cronjob: ' || pi_is_cronjob);
    end if;
    
    if pi_is_cronjob = 'Y'
    then
      l_job_name := qa_constant_pkg.gc_utplsql_scheduler_cronjob_name;
    else
      l_client_name := f_get_unified_string(pi_string => pi_client_name, pi_transform_case => 'u');
      l_scheme_name := f_get_unified_string(pi_string => pi_scheme_name, pi_transform_case => 'u');
      l_rule_number := f_get_unified_string(pi_string => pi_qaru_rule_number);

      l_job_name := qa_constant_pkg.gc_utplsql_custom_scheduler_job_name || '_' || l_scheme_name || '_' || l_client_name || '_' || l_rule_number;
    
      if pi_job_start_date is not null
      then
        l_job_name := l_job_name || '_' || to_char(pi_job_start_date,'YYYYMMDDHH24MISS');
      end if;
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

  function f_get_suitepath(
    pi_client_name   in varchar2 default null
   ,pi_scheme_name   in varchar2 default null
   ,pi_get_root_only in varchar2 default 'N'
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_suitepath';
    l_param_list qa_logger_pkg.tab_param;

    l_client_name_unified varchar2(1000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_get_root_only'
                              ,p_val_03  => pi_get_root_only);
    
    if pi_client_name is not null and pi_scheme_name is not null and pi_get_root_only = 'N'
    then
      l_client_name_unified := f_get_unified_string(pi_string => pi_client_name);
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
    pi_client_name      in varchar2
   ,pi_scheme_name      in varchar2
   ,pi_qaru_rule_number in varchar2
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
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_qaru_rule_number'
                              ,p_val_03  => pi_qaru_rule_number);
    
    select f_get_unified_string(pi_string => qaru_name)
    into l_qaru_name_unified
    from qa_rules
    where qaru_client_name = pi_client_name
    and qaru_rule_number = pi_qaru_rule_number;

    l_client_name_unified := f_get_unified_string(pi_string => pi_client_name, pi_transform_case => 'u');
    l_rule_number_unified := f_get_unified_string(pi_string => pi_qaru_rule_number);
    
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
                      from qaru_scheme_names_for_testing_v
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

  function f_get_all_scheme_names
  return VARCHAR2_TAB_T
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_all_scheme_names';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names varchar2_tab_t := new varchar2_tab_t();
  begin

     for rec_users in (select username
                       from qaru_scheme_names_for_testing_v)
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
   ,pi_qaru_client_name         in varchar2
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
      l_clob := l_clob || '  --%suitepath(' || f_get_suitepath(pi_client_name => pi_qaru_client_name_unified, pi_scheme_name => pi_scheme_name, pi_get_root_only => 'N') || ')' || chr(10) || chr(10);

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
   ,pi_qaru_name_unified        in varchar2 default null
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
   ,pi_qaru_rule_number         in varchar2
   ,pi_qaru_rule_number_unified in varchar2
   ,pi_scheme_name              in varchar2
   ,pi_qaru_layer               in varchar2
   ,pi_qaru_test_name           in varchar2
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
                                ,p_val_03  => pi_scheme_name
                                ,p_name_04 => 'pi_qaru_layer'
                                ,p_val_04  => pi_qaru_layer
                                ,p_name_05 => 'pi_qaru_test_name'
                                ,p_val_05  => pi_qaru_test_name);

        l_clob := pi_previous_clob || '  PROCEDURE p_ut_rule_' || pi_qaru_rule_number_unified || chr(10);
        l_clob := l_clob || '  IS' || chr(10);
        l_clob := l_clob || '    l_scheme_objects qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();' || chr(10);
        l_clob := l_clob || '    l_result NUMBER;' || chr(10);
        l_clob := l_clob || '    l_invalid_objects qa_rules_t := new qa_rules_t();' || chr(10);
        l_clob := l_clob || '    l_qaru_id number;' || chr(10);
        l_clob := l_clob || '    l_qatr_id number;' || chr(10);
        l_clob := l_clob || '  BEGIN' || chr(10);

        l_clob := l_clob || '    qa_main_pkg.p_test_rule(pi_qaru_client_name  => c_client_name,' || chr(10);
        l_clob := l_clob || '                            pi_qaru_rule_number  => ''' || pi_qaru_rule_number || ''',' || chr(10);
        l_clob := l_clob || '                            pi_scheme_names      => c_scheme_name,' || chr(10);
        l_clob := l_clob || '                            po_result            => l_result,' || chr(10);
        l_clob := l_clob || '                            po_scheme_objects    => l_scheme_objects,' || chr(10);
        l_clob := l_clob || '                            po_invalid_objects   => l_invalid_objects);' || chr(10);

        l_clob := l_clob || '    ut.expect(l_result).to_(equal(1));' || chr(10);

        l_clob := l_clob || '    dbms_output.put_line(''<Results rulenumber="' || DBMS_XMLGEN.CONVERT(pi_qaru_rule_number) || '" layer="' || DBMS_XMLGEN.CONVERT(pi_qaru_layer) || '" result="''||l_result||''">'');' || chr(10);
        l_clob := l_clob || '    for rec_scheme_objects in ( select scheme_name' || chr(10);
        l_clob := l_clob || '                                     , object_amount' || chr(10);
        l_clob := l_clob || '                                  from table(l_scheme_objects)' || chr(10);
        l_clob := l_clob || '                              )' || chr(10);

        l_clob := l_clob || '    loop' || chr(10);
        l_clob := l_clob || '      if rec_scheme_objects.object_amount = 0 then' || chr(10);
        l_clob := l_clob || '        dbms_output.put_line(''<Scheme name="''||DBMS_XMLGEN.CONVERT(rec_scheme_objects.scheme_name)||''" result="1"></Scheme>'');' || chr(10);
        l_clob := l_clob || '      else' || chr(10);
        l_clob := l_clob || '        dbms_output.put_line(''<Scheme name="''||DBMS_XMLGEN.CONVERT(rec_scheme_objects.scheme_name)||''" result="0">'');' || chr(10);
        l_clob := l_clob || '        l_qaru_id := qa_main_pkg.f_get_rule_pk(pi_qaru_rule_number => ''' || pi_qaru_rule_number || ''', pi_qaru_client_name => c_client_name);' || chr(10);
        l_clob := l_clob || '        l_qatr_id := qa_unit_tests_pkg.f_save_scheme_error_result(pi_scheme_name => rec_scheme_objects.scheme_name, pi_qaru_id => l_qaru_id, pi_result => l_result);' || chr(10);
        l_clob := l_clob || '        for rec_scheme_invalid_objects in ( select object_name' || chr(10);
        l_clob := l_clob || '                                                 , object_details' || chr(10);
        l_clob := l_clob || '                                                 , qaru_error_message' || chr(10);
        l_clob := l_clob || '                                              from table(l_invalid_objects)' || chr(10);
        l_clob := l_clob || '                                             where scheme_name = rec_scheme_objects.scheme_name' || chr(10);
        l_clob := l_clob || '                                          )' || chr(10);
        l_clob := l_clob || '        loop' || chr(10);
        l_clob := l_clob || '          dbms_output.put_line(''<Object name="''||DBMS_XMLGEN.CONVERT(rec_scheme_invalid_objects.object_name)||''" details="''||DBMS_XMLGEN.CONVERT(rec_scheme_invalid_objects.object_details)||''">''||rec_scheme_invalid_objects.qaru_error_message||''</Object>'');' || chr(10);
        l_clob := l_clob || '          qa_unit_tests_pkg.p_save_scheme_faulty_objects(pi_object_name => rec_scheme_invalid_objects.object_name, pi_object_details => rec_scheme_invalid_objects.object_details, pi_qatr_id => l_qatr_id);' || chr(10);
        l_clob := l_clob || '        end loop;' || chr(10);
        l_clob := l_clob || '        dbms_output.put_line(''</Scheme>'');' || chr(10);
        l_clob := l_clob || '      end if;' || chr(10);
        l_clob := l_clob || '    end loop;' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''</Results>'');' || chr(10);

        l_clob := l_clob || '  EXCEPTION' || chr(10);
        l_clob := l_clob || '    WHEN OTHERS THEN' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''Execution of test "' || pi_qaru_test_name || '" raised exception.'');' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(SQLERRM);' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);' || chr(10);
        l_clob := l_clob || '      qa_unit_tests_pkg.p_save_scheme_result_with_runtime_error(pi_qaru_rule_number => ''' || pi_qaru_rule_number || ''', pi_qaru_client_name => c_client_name, pi_scheme_name => c_scheme_name);' || chr(10);
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
    l_clob         clob;
    l_object_number number;
    l_object_types VARCHAR2_TAB_T := new VARCHAR2_TAB_T();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option);
    dbms_output.enable(buffer_size => 10000000);

    p_validate_input(pi_option         => pi_option
                    ,pi_scheme_names   => pi_scheme_names);

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
                                  ,f_get_unified_string(pi_string => qaru_client_name, pi_transform_case => 'l') as qaru_client_name_unified
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
                                 ,f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                                 ,regexp_replace(replace(lower(qaru_name)
                                                        ,' '
                                                        ,'_')
                                                ,'[^a-z0-9_]'
                                                ,'_') as qaru_name_unified
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
                                 ,replace(qaru_name
                                         ,'' || chr(39) || ''
                                         ,'' || chr(39) || chr(39) || '') as qaru_test_name
                                 ,f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                                 ,qaru_layer
                           from qa_rules
                           where qaru_client_name = rec_clients.qaru_client_name
                           and qaru_is_active = 1 
                           order by qaru_id asc)
         loop

           l_clob := f_get_package_body_content(pi_previous_clob            => l_clob
                                               ,pi_qaru_rule_number         => rec_rules.qaru_rule_number
                                               ,pi_qaru_rule_number_unified => rec_rules.qaru_rule_number_unified
                                               ,pi_scheme_name              => l_scheme_names(rec_schemes)
                                               ,pi_qaru_layer               => rec_rules.qaru_layer
                                               ,pi_qaru_test_name           => rec_rules.qaru_test_name);

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
                                       ,f_get_unified_string(pi_string => qaru_client_name, pi_transform_case => 'l') as qaru_client_name_unified
                                       ,f_get_unified_string(pi_string => qaru_name, pi_transform_case => 'l') as qaru_name_unified
                                       ,f_get_unified_string(pi_string => qaru_rule_number, pi_transform_case => 'l') as qaru_rule_number_unified
                                       ,replace(qaru_name
                                               ,'' || chr(39) || ''
                                               ,'' || chr(39) || chr(39) || '') as qaru_test_name
                                       ,qaru_layer
                                 from qa_rules
                                 where qaru_is_active = 1 
                                 group by qaru_id
                                         ,qaru_client_name
                                         ,qaru_rule_number
                                         ,qaru_name
                                         ,qaru_layer
                                 order by qaru_id asc)
        loop

          l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || lower(l_scheme_names(rec_schemes)) || '_' || rec_client_rules.qaru_client_name_unified || '_' || rec_client_rules.qaru_name_unified ||'_pkg';

          l_clob := f_get_package_spec_header(pi_package_name             => l_package_name
                                             ,pi_scheme_name              => l_scheme_names(rec_schemes)
                                             ,pi_qaru_client_name         => rec_client_rules.qaru_client_name
                                             ,pi_qaru_client_name_unified => rec_client_rules.qaru_client_name_unified);

          l_clob := f_get_package_spec_content(pi_previous_clob            => l_clob
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified);

          l_clob := f_get_package_spec_footer(pi_previous_clob => l_clob
                                             ,pi_package_name  => l_package_name);

          execute immediate l_clob;
          dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
      
          l_clob := f_get_package_body_header(pi_package_name => l_package_name);

          l_clob := f_get_package_body_content(pi_previous_clob            => l_clob
                                              ,pi_qaru_rule_number         => rec_client_rules.qaru_rule_number
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified
                                              ,pi_scheme_name              => l_scheme_names(rec_schemes)
                                              ,pi_qaru_layer               => rec_client_rules.qaru_layer
                                              ,pi_qaru_test_name           => rec_client_rules.qaru_test_name);

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

  procedure p_run_unit_tests_from_cronjob(
    po_result out varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_run_unit_tests_from_cronjob';
    l_param_list qa_logger_pkg.tab_param;

    l_xml_result clob;
    l_timestamp_begin timestamp(6);
    l_timestamp_end timestamp(6);
    l_running_time_seconds number;
  begin
    l_timestamp_begin := systimestamp;
    l_xml_result := f_run_unit_tests_from_scheduler_cronjob;
    l_timestamp_end := systimestamp;

    insert into QA_TEST_RESULTS(QATR_XML_RESULT)
    values (l_xml_result);

    l_running_time_seconds := extract(second from(l_timestamp_end-l_timestamp_begin));
    po_result := 'Execution of unit tests finished successful after ' || l_running_time_seconds || ' seconds';

    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'po_result'
                              ,p_val_01  => po_result);
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to run the unit tests from scheduler cronjob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      po_result := 'Execution of unit tests failed with error ' || sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      raise;
  end p_run_unit_tests_from_cronjob;

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

  procedure p_create_custom_unit_test_job(
    pi_client_name      in varchar2
   ,pi_scheme_name      in varchar2
   ,pi_qaru_rule_number in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_create_custom_unit_test_job';
    l_param_list qa_logger_pkg.tab_param;

    l_job_start_date date;
    l_job_name varchar2(500);
    l_utplsql_call varchar2(1000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_qaru_rule_number'
                              ,p_val_03  => pi_qaru_rule_number);
    
    l_job_start_date := systimestamp + interval '1' minute;
    l_job_name := f_get_job_name(pi_scheme_name => pi_scheme_name, pi_client_name => pi_client_name, pi_qaru_rule_number => pi_qaru_rule_number, pi_is_cronjob => 'N', pi_job_start_date => l_job_start_date);
    
    dbms_scheduler.create_job(
      job_name   => l_job_name
    , job_type   => 'PLSQL_BLOCK'
    , job_action => 'BEGIN qa_unit_tests_pkg.p_run_custom_unit_test(pi_client_name => '''|| pi_client_name || ''', pi_scheme_name => '''|| pi_scheme_name || ''', pi_qaru_rule_number => '''|| pi_qaru_rule_number || '''); END;'
    , start_date => l_job_start_date
    , enabled    => true
    , auto_drop  => true
    , comments   => 'Custom Job to run an Unit Test triggered by APEX app (rule number: '||pi_qaru_rule_number||' - client name: '||pi_client_name||' - scheme name: '||pi_scheme_name||')'
   );

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to create a custom scheduler job to run an unit test procedure!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_create_custom_unit_test_job;

  procedure p_run_custom_unit_test(
    pi_client_name      in varchar2
   ,pi_scheme_name      in varchar2
   ,pi_qaru_rule_number in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_run_custom_unit_test';
    l_param_list qa_logger_pkg.tab_param;

    l_utplsql_call varchar2(1000);
    l_xml_result clob;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name
                              ,p_name_03 => 'pi_qaru_rule_number'
                              ,p_val_03  => pi_qaru_rule_number);

    l_utplsql_call := f_get_unit_test_call(pi_client_name => pi_client_name, pi_scheme_name => pi_scheme_name, pi_qaru_rule_number => pi_qaru_rule_number);
    
    select DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E,column_value).EXTRACT('//text()')).GetClobVal(),1)
    into l_xml_result
    from table(ut.run(l_utplsql_call, ut_junit_reporter()));
    
    insert into QA_TEST_RESULTS(QATR_XML_RESULT)
    values (l_xml_result);

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while running an unit test from custom scheduler job!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_run_custom_unit_test;

  function f_save_scheme_error_result(
    pi_scheme_name in varchar2
   ,pi_qaru_id     in number
   ,pi_result      in number
  ) return number
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_save_scheme_error_result';
    l_param_list qa_logger_pkg.tab_param;
    
    l_qatr_id number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_scheme_name'
                              ,p_val_01  => pi_scheme_name
                              ,p_name_02 => 'pi_qaru_id'
                              ,p_val_02  => pi_qaru_id
                              ,p_name_03 => 'pi_result'
                              ,p_val_03  => pi_result);

    insert into QA_TEST_RUNS (qatr_schema_name, qatr_date, qatr_result, qatr_qaru_id)
    values (pi_scheme_name, sysdate, pi_result, pi_qaru_id)
    returning qatr_id into l_qatr_id;
    
    return l_qatr_id;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while saving the failed result of a scheme!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_save_scheme_error_result;

  procedure p_save_scheme_faulty_objects(
    pi_object_name    in varchar2
   ,pi_object_details in varchar2
   ,pi_qatr_id        in number
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_save_scheme_faulty_objects';
    l_param_list qa_logger_pkg.tab_param;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_object_name'
                              ,p_val_01  => pi_object_name
                              ,p_name_02 => 'pi_object_details'
                              ,p_val_02  => pi_object_details
                              ,p_name_03 => 'pi_qatr_id'
                              ,p_val_03  => pi_qatr_id);

    insert into QA_TEST_RUN_INVALID_OBJECTS (qato_object_name, qato_object_details, qato_qatr_id)
    values (pi_object_name, pi_object_details, pi_qatr_id);
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while saving the details of faulty scheme object!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_save_scheme_faulty_objects;

  procedure p_save_scheme_result_with_runtime_error(
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_scheme_name      in varchar2_tab_t
  )
  is
    pragma autonomous_transaction;
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_save_scheme_result_with_runtime_error';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_name varchar2(100);
    l_qaru_id number;
    l_qatr_id number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
    
    for i in pi_scheme_name.first .. pi_scheme_name.last
    loop
      l_scheme_name := pi_scheme_name(i) || ',' || l_scheme_name;
    end loop;

    l_qaru_id := qa_main_pkg.f_get_rule_pk(pi_qaru_rule_number => pi_qaru_rule_number
                                         , pi_qaru_client_name => pi_qaru_client_name);
    l_qatr_id := f_save_scheme_error_result(pi_scheme_name => l_scheme_name
                                           ,pi_qaru_id => l_qaru_id
                                           ,pi_result => 0);
    update QA_TEST_RUNS
    set runtime_error = dbms_utility.format_error_backtrace
    where qatr_id = l_qatr_id;
    commit;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while saving the scheme result with runtime error for a test result!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_save_scheme_result_with_runtime_error;

  function f_run_unit_tests_from_scheduler_cronjob(
    pi_client_name in varchar2 default null
   ,pi_scheme_name in varchar2 default null
  ) return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_run_unit_tests_from_scheduler_cronjob';
    l_param_list qa_logger_pkg.tab_param;

    l_suitepath varchar2(1000);
    l_package_owner varchar2(1000) := SYS_CONTEXT('USERENV', 'CURRENT_USER');
    l_xml_result clob;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_scheme_name'
                              ,p_val_02  => pi_scheme_name);
    
    if pi_client_name is not null and pi_scheme_name is not null
    then
      l_suitepath := f_get_suitepath(pi_client_name => pi_client_name, pi_scheme_name => pi_scheme_name, pi_get_root_only => 'N');
    else
      l_suitepath := f_get_suitepath(pi_get_root_only => 'Y');
    end if;

    select DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E,column_value).EXTRACT('//text()')).GetClobVal(),1)
    into l_xml_result
    from table(ut.run(l_package_owner || ':' || l_suitepath, ut_junit_reporter()));

    return l_xml_result;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to run the unit tests from scheduler cronjob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_run_unit_tests_from_scheduler_cronjob;

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

end qa_unit_tests_pkg;
/