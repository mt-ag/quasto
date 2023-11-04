PROMPT create or replace package QA_UNIT_TESTS_PKG

create or replace package qa_unit_tests_pkg 
  authid definer
is

/**
* create unit test packages
* @param pi_option specifies the creation method
* @param pi_scheme_names specifies the comma-separated scheme names to be tested
* @param pi_delete_test_packages specifies if packages for the specified scheme names should be deleted
*/
  procedure p_create_unit_test_packages(
    pi_option               in number,
    pi_scheme_names         in VARCHAR2_TAB_T default null,
    pi_delete_test_packages in varchar2 default 'N'
  );

/**
* delete unit test packages
* @param pi_scheme_names specifies the comma-separated scheme names for which packages should be deleted
*/
  procedure p_delete_unit_test_packages(
    pi_scheme_names  in VARCHAR2_TAB_T default null
  );

/**
* run unit tests and save xml result in the database
* @param po_result returns the result message
*/
  procedure p_run_unit_tests(
    po_result out varchar2
  );

/**
* returns if scheduler job for execution of unit tests is enabled
*/
  function f_is_scheduler_job_enabled
  return varchar2;

/**
* enable or disable the scheduler job
* @param pi_status defines the enable status of the scheduler job
*/
  procedure p_enable_scheduler_job(
    pi_status in varchar2
  );

end qa_unit_tests_pkg;
/
create or replace package body qa_unit_tests_pkg is

  procedure p_validate_input(
    pi_option               in number,
    pi_scheme_names         in VARCHAR2_TAB_T,
    pi_delete_test_packages in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_validate_input';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_exist number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option
                              ,p_name_02 => 'pi_delete_test_packages'
                              ,p_val_02  => pi_delete_test_packages);

    if pi_option not in ( qa_constant_pkg.gc_utplsql_single_package
                        , qa_constant_pkg.gc_utplsql_single_package_per_rule
                        )
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
                      where username = upper(pi_scheme_names(rec_scheme_names))
                     );
        if l_scheme_exist = 0
        then
          raise_application_error(-20001, 'Invalid input parameter value for pi_scheme_names: ' || pi_scheme_names(rec_scheme_names) || ' - scheme name does not exist');
        end if;
      end loop;
    elsif pi_delete_test_packages not in ( 'Y'
                                         , 'N'
                                         )
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_delete_test_packages: ' || pi_delete_test_packages);
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

  function f_get_all_scheme_names
  return VARCHAR2_TAB_T
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_all_scheme_names';
    l_param_list qa_logger_pkg.tab_param;

    l_scheme_names varchar2_tab_t := new varchar2_tab_t();
  begin

     for rec_users in ( select username
                          from qaru_scheme_names_for_testing_v
                      )
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
    pi_package_name             in varchar2,
    pi_scheme_name              in varchar2,
    pi_qaru_client_name         in varchar2,
    pi_qaru_client_name_unified in varchar2
  )
  return clob
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_package_spec_header';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
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

      l_clob := 'CREATE OR REPLACE PACKAGE ' || pi_package_name || ' IS' || chr(10);
      l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
      l_clob := l_clob || '--TIMESTAMP OF CREATION: ' || systimestamp || chr(10);
      l_clob := l_clob || '--SCHEME NAME: ' || upper(pi_scheme_name) || chr(10);
      l_clob := l_clob || '--%suite(' || pi_qaru_client_name || ')' || chr(10);
      l_clob := l_clob || '--%suitepath(' || pi_qaru_client_name_unified || ')' || chr(10) || chr(10);
      
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
    pi_previous_clob            in clob,
    pi_qaru_rule_number_unified in varchar2
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

      l_clob := pi_previous_clob || '--%test(quasto_test_rule_' || pi_qaru_rule_number_unified || ')' || chr(10);
      l_clob := l_clob || 'PROCEDURE p_ut_rule_' || pi_qaru_rule_number_unified || ';' || chr(10);
      
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
    pi_previous_clob in clob,
    pi_package_name  in varchar2
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
    pi_previous_clob            in clob,
    pi_qaru_rule_number         in varchar2,
    pi_qaru_rule_number_unified in varchar2,
    pi_scheme_name              in varchar2,
    pi_qaru_client_name         in varchar2,
    pi_qaru_layer               in varchar2,
    pi_qaru_test_name           in varchar2
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
                                ,p_name_04 => 'pi_qaru_client_name'
                                ,p_val_04  => pi_qaru_client_name
                                ,p_name_05 => 'pi_qaru_layer'
                                ,p_val_05  => pi_qaru_layer
                                ,p_name_06 => 'pi_qaru_test_name'
                                ,p_val_06  => pi_qaru_test_name);

        l_clob := pi_previous_clob || 'PROCEDURE p_ut_rule_' || pi_qaru_rule_number_unified || chr(10);
        l_clob := l_clob || 'IS' || chr(10);
        l_clob := l_clob || '  l_scheme_names varchar2_tab_t := new varchar2_tab_t();' || chr(10);
        l_clob := l_clob || '  l_scheme_objects qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();' || chr(10);
        l_clob := l_clob || '  l_result NUMBER;' || chr(10);
        l_clob := l_clob || '  l_invalid_objects qa_rules_t := new qa_rules_t();' || chr(10);
        l_clob := l_clob || 'BEGIN' || chr(10);

        l_clob := l_clob || '  for rec_users in ( select username' || chr(10);
        l_clob := l_clob || '                       from qaru_scheme_names_for_testing_v' || chr(10);
        l_clob := l_clob || '                      where username = ''' || upper(pi_scheme_name) || '''' || chr(10);
        l_clob := l_clob || '                   )' || chr(10);

        l_clob := l_clob || '  loop' || chr(10);
        l_clob := l_clob || '    l_scheme_names.extend;' || chr(10);
        l_clob := l_clob || '    l_scheme_names(l_scheme_names.last) := rec_users.username;' || chr(10);
        l_clob := l_clob || '  end loop;' || chr(10);

        l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || pi_qaru_client_name || ''',' || chr(10);
        l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || pi_qaru_rule_number || ''',' || chr(10);
        l_clob := l_clob || '                          pi_scheme_names      => l_scheme_names,' || chr(10);
        l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
        l_clob := l_clob || '                          po_scheme_objects    => l_scheme_objects,' || chr(10);
        l_clob := l_clob || '                          po_invalid_objects   => l_invalid_objects);' || chr(10);

        l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);

        l_clob := l_clob || '  dbms_output.put_line(''<Results rulenumber="' || pi_qaru_rule_number || '" layer="' || pi_qaru_layer || '" result="''||l_result||''">'');' || chr(10);
        l_clob := l_clob || '  for rec_scheme_objects in ( select scheme_name' || chr(10);
        l_clob := l_clob || '                                   , object_amount' || chr(10);
        l_clob := l_clob || '                                from table(l_scheme_objects)' || chr(10);
        l_clob := l_clob || '                            )' || chr(10);

        l_clob := l_clob || '  loop' || chr(10);
        l_clob := l_clob || '    if rec_scheme_objects.object_amount = 0 then' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''<Scheme name="''||rec_scheme_objects.scheme_name||''" result="1"></Scheme>'');' || chr(10);
        l_clob := l_clob || '    else' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''<Scheme name="''||rec_scheme_objects.scheme_name||''" result="0">'');' || chr(10);
        l_clob := l_clob || '      for rec_scheme_invalid_objects in ( select object_name' || chr(10);
        l_clob := l_clob || '                                               , object_details' || chr(10);
        l_clob := l_clob || '                                               , qaru_error_message' || chr(10);
        l_clob := l_clob || '                                            from table(l_invalid_objects)' || chr(10);
        l_clob := l_clob || '                                           where scheme_name = rec_scheme_objects.scheme_name' || chr(10);
        l_clob := l_clob || '                                        )' || chr(10);
        l_clob := l_clob || '      loop' || chr(10);
        l_clob := l_clob || '        dbms_output.put_line(''<Object name="''||rec_scheme_invalid_objects.object_name||''" details="''||rec_scheme_invalid_objects.object_details||''">''||rec_scheme_invalid_objects.qaru_error_message||''</Object>'');' || chr(10);
        l_clob := l_clob || '      end loop;' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''</Scheme>'');' || chr(10);
        l_clob := l_clob || '    end if;' || chr(10);
        l_clob := l_clob || '  end loop;' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''</Results>'');' || chr(10);

        l_clob := l_clob || 'EXCEPTION' || chr(10);
        l_clob := l_clob || '  WHEN OTHERS THEN' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''Execution of test "' || pi_qaru_test_name || '" raised exception.'');' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(SQLERRM);' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);' || chr(10);
        l_clob := l_clob || '    RAISE;' || chr(10);
        l_clob := l_clob || 'END p_ut_rule_' || pi_qaru_rule_number_unified || ';' || chr(10);

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
    pi_previous_clob in clob,
    pi_package_name  in varchar2
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
    pi_option               in number,
    pi_scheme_names         in VARCHAR2_TAB_T default null,
    pi_delete_test_packages in varchar2 default 'N'
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
                              ,p_val_01  => pi_option
                              ,p_name_02 => 'pi_delete_test_packages'
                              ,p_val_02  => pi_delete_test_packages);
    dbms_output.enable(buffer_size => 10000000);

    p_validate_input(pi_option               => pi_option,
                     pi_scheme_names         => pi_scheme_names,
                     pi_delete_test_packages => pi_delete_test_packages);

    if pi_delete_test_packages = 'Y'
    then
      p_delete_unit_test_packages(pi_scheme_names  => pi_scheme_names);
    end if;

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
                                  ,regexp_replace(replace(lower(qaru_client_name)
                                                         ,' '
                                                         ,'_')
                                                 ,'[^a-z0-9_]'
                                                 ,'_') as qaru_client_name_unified
                           from qa_rules
                           where qaru_is_active = 1 
                           group by qaru_client_name)
       loop

         l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || lower(l_scheme_names(rec_schemes)) || '_' || rec_clients.qaru_client_name_unified || '_pkg';

         l_clob := f_get_package_spec_header(pi_package_name => l_package_name
                                            ,pi_scheme_name => l_scheme_names(rec_schemes)
                                            ,pi_qaru_client_name => rec_clients.qaru_client_name
                                            ,pi_qaru_client_name_unified => rec_clients.qaru_client_name_unified);

         for rec_rules in (select qaru_rule_number
                                 ,regexp_replace(replace(lower(qaru_rule_number)
                                                        ,' '
                                                        ,'_')
                                                ,'[^a-z0-9_]'
                                                ,'_') as qaru_rule_number_unified
                           from qa_rules
                           where qaru_client_name = rec_clients.qaru_client_name
                           and qaru_is_active = 1 
                           order by qaru_id asc)
         loop
      
           l_clob := f_get_package_spec_content(pi_previous_clob => l_clob
                                               ,pi_qaru_rule_number_unified => rec_rules.qaru_rule_number_unified);

         end loop;

         l_clob := f_get_package_spec_footer(pi_previous_clob => l_clob
                                         ,pi_package_name => l_package_name);

         execute immediate l_clob;
         dbms_output.put_line('Package specification for ' || l_package_name || ' created.');

         l_clob := f_get_package_body_header(pi_package_name => l_package_name);

         for rec_rules in (select qaru_rule_number
                                 ,replace(qaru_name
                                         ,'' || chr(39) || ''
                                         ,'' || chr(39) || chr(39) || '') as qaru_test_name
                                 ,regexp_replace(replace(lower(qaru_rule_number)
                                                        ,' '
                                                        ,'_')
                                                ,'[^a-z0-9_]'
                                                ,'_') as qaru_rule_number_unified
                                 ,qaru_layer
                           from qa_rules
                           where qaru_client_name = rec_clients.qaru_client_name
                           and qaru_is_active = 1 
                           order by qaru_id asc)
         loop

           l_clob := f_get_package_body_content(pi_previous_clob  => l_clob
                                               ,pi_qaru_rule_number => rec_rules.qaru_rule_number
                                               ,pi_qaru_rule_number_unified => rec_rules.qaru_rule_number_unified
                                               ,pi_scheme_name => l_scheme_names(rec_schemes)
                                               ,pi_qaru_client_name => rec_clients.qaru_client_name
                                               ,pi_qaru_layer => rec_rules.qaru_layer
                                               ,pi_qaru_test_name =>  rec_rules.qaru_test_name);

         end loop;

         l_clob := f_get_package_body_footer(pi_previous_clob => l_clob
                                            ,pi_package_name => l_package_name);

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
                                       ,regexp_replace(replace(lower(qaru_client_name)
                                                              ,' '
                                                              ,'_')
                                                      ,'[^a-z0-9_]'
                                                      ,'_') as qaru_client_name_unified
                                       ,regexp_replace(replace(lower(qaru_name)
                                                              ,' '
                                                              ,'_')
                                                      ,'[^a-z0-9_]'
                                                      ,'_') as qaru_name_unified
                                       ,regexp_replace(replace(lower(qaru_rule_number)
                                                              ,' '
                                                              ,'_')
                                                      ,'[^a-z0-9_]'
                                                      ,'_') as qaru_rule_number_unified
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

          l_clob := f_get_package_spec_header(pi_package_name => l_package_name
                                             ,pi_scheme_name => l_scheme_names(rec_schemes)
                                             ,pi_qaru_client_name => rec_client_rules.qaru_client_name
                                             ,pi_qaru_client_name_unified => rec_client_rules.qaru_client_name_unified);

          l_clob := f_get_package_spec_content(pi_previous_clob => l_clob
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified);

          l_clob := f_get_package_spec_footer(pi_previous_clob => l_clob
                                             ,pi_package_name => l_package_name);

          execute immediate l_clob;
          dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
      
          l_clob := f_get_package_body_header(pi_package_name => l_package_name);

          l_clob := f_get_package_body_content(pi_previous_clob  => l_clob
                                              ,pi_qaru_rule_number => rec_client_rules.qaru_rule_number
                                              ,pi_qaru_rule_number_unified => rec_client_rules.qaru_rule_number_unified
                                              ,pi_scheme_name => l_scheme_names(rec_schemes)
                                              ,pi_qaru_client_name => rec_client_rules.qaru_client_name
                                              ,pi_qaru_layer => rec_client_rules.qaru_layer
                                              ,pi_qaru_test_name =>  rec_client_rules.qaru_test_name);

          l_clob := f_get_package_body_footer(pi_previous_clob => l_clob
                                             ,pi_package_name => l_package_name);

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

  procedure p_run_unit_tests(
    po_result out varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_run_unit_tests';
    l_param_list qa_logger_pkg.tab_param;

    l_xml_result clob;
    l_timestamp_begin timestamp(6);
    l_timestamp_end timestamp(6);
    l_running_time_seconds number;
  begin
    l_timestamp_begin := systimestamp;
    select DBMS_XMLGEN.CONVERT(XMLAGG(XMLELEMENT(E,column_value).EXTRACT('//text()')).GetClobVal(),1)
    into l_xml_result
    from table(ut.run(ut_junit_reporter()));
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
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to run the unit tests!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      po_result := 'Execution of unit tests failed with error ' || sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      raise;
  end p_run_unit_tests;

  function f_is_scheduler_job_enabled
  return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_is_scheduler_job_enabled';
    l_param_list qa_logger_pkg.tab_param;

    l_result number;
  begin
    select decode(count(1), 0, 0, 1)
    into l_result
    from dual
    where exists (select null
                  from user_scheduler_jobs
                  where job_name = qa_constant_pkg.gc_utplsql_scheduler_job_name
                  and enabled = 'TRUE'
                 );

    if l_result = 1
    then
      return 'Y';
    else
      return 'N';
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the status of the ut scheduler job!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_is_scheduler_job_enabled;

  procedure p_enable_scheduler_job(
    pi_status in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_enable_scheduler_job';
    l_param_list qa_logger_pkg.tab_param;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_status'
                              ,p_val_01  => pi_status);

    if pi_status not in ( 'Y'
                        , 'N'
                        )
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_status: ' || pi_status);
    end if;

    if pi_status = 'Y'
    then
      dbms_scheduler.enable(qa_constant_pkg.gc_utplsql_scheduler_job_name);
    else
      dbms_scheduler.disable(qa_constant_pkg.gc_utplsql_scheduler_job_name);
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to enable the ut scheduler job!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_enable_scheduler_job;

end qa_unit_tests_pkg;
/
