PROMPT create or replace package QA_UNIT_TESTS_PKG

create or replace package qa_unit_tests_pkg is

/**
* create unit test packages
* @param pi_option specifies the creation method
* @param pi_schema_names specifies the comma-separated schema names to be tested
*/
  procedure p_create_unit_test_packages(
    pi_option         in number,
    pi_schema_names   in varchar2 default null
  );

/**
* run unit tests and save xml result in the database
* @param po_result returns the result message
*/
  procedure p_run_unit_tests(
    po_result out varchar2
  );

/**
* wrapper for scheduler job
*/
  procedure p_run_unit_test_job;

end qa_unit_tests_pkg;
/
create or replace package body qa_unit_tests_pkg is

  procedure p_validate_input(
    pi_option         in number,
    pi_schema_names   in varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_validate_input';
    l_param_list qa_logger_pkg.tab_param;

    l_schema_exist number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option
                              ,p_name_02 => 'pi_schema_names'
                              ,p_val_02  => pi_schema_names);

    if pi_option not in ( qa_constant_pkg.gc_utplsql_single_package
                        , qa_constant_pkg.gc_utplsql_single_package_per_rule
                        , qa_constant_pkg.gc_utplsql_single_rule_per_object
                        )
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_option: ' || pi_option);
    elsif not REGEXP_LIKE(upper(pi_schema_names),qa_constant_pkg.gc_utplsql_regexp_schema_names)
    then
      raise_application_error(-20001, 'Invalid input parameter value for pi_schema_names: ' || upper(pi_schema_names));
    elsif pi_schema_names is not null
    then
      for rec_schema_names in (select trim(regexp_substr(upper(pi_schema_names), '[^,]+', 1, level)) as schema_name
                               from dual
                               connect by level <= regexp_count(upper(pi_schema_names), ',')+1
                              )
      loop
        select decode(count(1), 0, 0, 1)
        into l_schema_exist
        from dual
        where exists (select null
                      from qaru_schema_names_for_testing_v
                      where username = rec_schema_names.schema_name
                     );
        if l_schema_exist = 0
        then
          raise_application_error(-20001, 'Invalid input parameter value for pi_schema_names: ' || rec_schema_names.schema_name || ' - schema name does not exist');
        end if;
      end loop;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while validating the input!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_validate_input;

  procedure p_delete_test_packages
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_delete_test_packages';
    l_param_list qa_logger_pkg.tab_param;

    l_package_name varchar2(255);
  begin
    for rec_packages in (select object_name
                         from user_objects
                         where object_type = 'PACKAGE'
                         and object_name like upper(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || '%')
    loop
      l_package_name := rec_packages.object_name;
      execute immediate 'DROP PACKAGE ' || l_package_name;
      dbms_output.put_line('Drop of package ' || l_package_name || ' successful.');
    end loop;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while deleting the packages!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_delete_test_packages;

  function f_transform_schema_names(
    pi_schema_names in varchar2
  ) return varchar2
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_transform_schema_names';
    l_param_list qa_logger_pkg.tab_param;

    l_return varchar2(255);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_schema_names'
                              ,p_val_01  => pi_schema_names);

    l_return := REPLACE(upper(pi_schema_names), ',', ''',''');

    return l_return;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while transforming the schema names!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_transform_schema_names;
  
  function f_generate_table_of_vc_object_types(
    pi_object_types in qa_rules.qaru_object_types%type
  ) return VARCHAR2_TAB_T
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_generate_table_of_vc_object_types';
    l_param_list qa_logger_pkg.tab_param;

    l_object_types VARCHAR2_TAB_T := VARCHAR2_TAB_T();
    l_return varchar2(255);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_object_types'
                              ,p_val_01  => pi_object_types);

    for i in (select regexp_substr(pi_object_types, '[^:]+', 1, level ) as object_type
              from dual
              connect by regexp_substr(pi_object_types, '[^:]+', 1, level ) is not null)
    loop
      l_object_types.extend;
      l_object_types(l_object_types.last) := i.object_type;
    end loop;

    return l_object_types;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while creating table of varchar2 for the object types!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_generate_table_of_vc_object_types;

  procedure p_create_unit_test_packages(
    pi_option         in number,
    pi_schema_names   in varchar2 default null
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_create_unit_test_packages';
    l_param_list qa_logger_pkg.tab_param;

    l_package_name varchar2(255);
    l_clob         clob;
    l_schema_names varchar2(32672);
    l_object_number number;
    l_object_types VARCHAR2_TAB_T := VARCHAR2_TAB_T();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_option'
                              ,p_val_01  => pi_option
                              ,p_name_02 => 'pi_schema_names'
                              ,p_val_02  => pi_schema_names);

    dbms_output.enable(buffer_size => 10000000);

    p_validate_input(pi_option               => pi_option,
                     pi_schema_names         => pi_schema_names);

    p_delete_test_packages;

    if pi_schema_names is not null
    then
      l_schema_names := f_transform_schema_names(pi_schema_names => pi_schema_names);
    end if;

    if pi_option = qa_constant_pkg.gc_utplsql_single_package
    then

    for rec_clients in (select qaru_client_name
                              ,regexp_replace(replace(lower(qaru_client_name)
                                                     ,' '
                                                     ,'_')
                                             ,'[^a-z0-9_]'
                                             ,'_') as qaru_client_name_unified
                        from qa_rules
                        where qaru_is_active = 1 and qaru_layer = 'DATABASE'
                        group by qaru_client_name)
    loop

      l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || rec_clients.qaru_client_name_unified || '_pkg';

      l_clob := 'CREATE OR REPLACE PACKAGE ' || l_package_name || ' IS' || chr(10);
      l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
      l_clob := l_clob || '--%suite(' || rec_clients.qaru_client_name || ')' || chr(10);
      l_clob := l_clob || '--%suitepath(' || rec_clients.qaru_client_name_unified || ')' || chr(10) || chr(10);

      for rec_rules in (select qaru_rule_number
                              ,regexp_replace(replace(lower(qaru_rule_number)
                                                     ,' '
                                                     ,'_')
                                             ,'[^a-z0-9_]'
                                             ,'_') as qaru_rule_number_unified
                        from qa_rules
                        where qaru_client_name = rec_clients.qaru_client_name
                        and qaru_is_active = 1 and qaru_layer = 'DATABASE'
                        order by qaru_id asc)
      loop

        l_clob := l_clob || '--%test(quasto_test_rule_' || rec_rules.qaru_rule_number_unified || ')' || chr(10);
        l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_rules.qaru_rule_number_unified || ';' || chr(10);

      end loop;

      l_clob := l_clob || 'END ' || l_package_name || ';';

      execute immediate l_clob;
      dbms_output.put_line('Package specification for ' || l_package_name || ' created.');

      l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);

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
                        and qaru_is_active = 1 and qaru_layer = 'DATABASE'
                        order by qaru_id asc)
      loop

        l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_rules.qaru_rule_number_unified || chr(10);
        l_clob := l_clob || 'IS' || chr(10);
        l_clob := l_clob || '  l_schema_names varchar2_tab_t := new varchar2_tab_t();' || chr(10);
        l_clob := l_clob || '  l_schema_objects qa_schema_object_amounts_t := new qa_schema_object_amounts_t();' || chr(10);
        l_clob := l_clob || '  l_result NUMBER;' || chr(10);
        l_clob := l_clob || '  l_invalid_objects qa_rules_t := new qa_rules_t();' || chr(10);
        l_clob := l_clob || 'BEGIN' || chr(10);

        if l_schema_names is not null
        then
          l_clob := l_clob || '  for rec_users in ( select username' || chr(10);
          l_clob := l_clob || '                       from qaru_schema_names_for_testing_v' || chr(10);
          l_clob := l_clob || '                      where username in (''' || l_schema_names || ''')' || chr(10);
          l_clob := l_clob || '                   )' || chr(10);
        else
          l_clob := l_clob || '  for rec_users in ( select username' || chr(10);
          l_clob := l_clob || '                       from qaru_schema_names_for_testing_v' || chr(10);
          l_clob := l_clob || '                   )' || chr(10);
        end if;

        l_clob := l_clob || '  loop' || chr(10);
        l_clob := l_clob || '    l_schema_names.extend;' || chr(10);
        l_clob := l_clob || '    l_schema_names(l_schema_names.last) := rec_users.username;' || chr(10);
        l_clob := l_clob || '  end loop;' || chr(10);

        l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || rec_clients.qaru_client_name || ''',' || chr(10);
        l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || rec_rules.qaru_rule_number || ''',' || chr(10);
        l_clob := l_clob || '                          pi_schema_names      => l_schema_names,' || chr(10);
        l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
        l_clob := l_clob || '                          po_schema_objects    => l_schema_objects,' || chr(10);
        l_clob := l_clob || '                          po_invalid_objects   => l_invalid_objects);' || chr(10);

        l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
        
        l_clob := l_clob || '  dbms_output.put_line(''<Results rulenumber="' || rec_rules.qaru_rule_number || '" layer="' || rec_rules.qaru_layer || '" result="''||l_result||''">'');' || chr(10);
        l_clob := l_clob || '  for rec_schema_objects in ( select schema_name' || chr(10);
        l_clob := l_clob || '                                   , object_amount' || chr(10);
        l_clob := l_clob || '                                from table(l_schema_objects)' || chr(10);
        l_clob := l_clob || '                            )' || chr(10);
        
        l_clob := l_clob || '  loop' || chr(10);
        l_clob := l_clob || '    if rec_schema_objects.object_amount = 0 then' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''<Schema name="''||rec_schema_objects.schema_name||''" result="1"></Schema>'');' || chr(10);
        l_clob := l_clob || '    else' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''<Schema name="''||rec_schema_objects.schema_name||''" result="0">'');' || chr(10);
        l_clob := l_clob || '      for rec_schema_invalid_objects in ( select object_name' || chr(10);
        l_clob := l_clob || '                                               , object_path' || chr(10);
        l_clob := l_clob || '                                               , object_details' || chr(10);
        l_clob := l_clob || '                                               , qaru_error_message' || chr(10);
        l_clob := l_clob || '                                            from table(l_invalid_objects)' || chr(10);
        l_clob := l_clob || '                                           where schema_name = rec_schema_objects.schema_name' || chr(10);
        l_clob := l_clob || '                                        )' || chr(10);
        l_clob := l_clob || '      loop' || chr(10);
        l_clob := l_clob || '        dbms_output.put_line(''<Object name="''||rec_schema_invalid_objects.object_name||''" path="''||rec_schema_invalid_objects.object_path||''" details="''||rec_schema_invalid_objects.object_details||''">''||rec_schema_invalid_objects.qaru_error_message||''</Object>'');' || chr(10);
        l_clob := l_clob || '      end loop;' || chr(10);
        l_clob := l_clob || '      dbms_output.put_line(''</Schema>'');' || chr(10);
        l_clob := l_clob || '    end if;' || chr(10);
        l_clob := l_clob || '  end loop;' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''</Results>'');' || chr(10);

        l_clob := l_clob || 'EXCEPTION' || chr(10);
        l_clob := l_clob || '  WHEN OTHERS THEN' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''Execution of test "' || rec_rules.qaru_test_name || '" raised exception.'');' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(SQLERRM);' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);' || chr(10);
        l_clob := l_clob || '    RAISE;' || chr(10);
        l_clob := l_clob || 'END p_ut_rule_' || rec_rules.qaru_rule_number_unified || ';' || chr(10);

      end loop;

      l_clob := l_clob || 'END ' || l_package_name || ';';

    end loop;

    execute immediate l_clob;
    dbms_output.put_line('Package body for ' || l_package_name || ' created.');

    elsif pi_option = qa_constant_pkg.gc_utplsql_single_package_per_rule
    then

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
                              where qaru_is_active = 1 and qaru_layer = 'DATABASE'
                              group by qaru_id
                                      ,qaru_client_name
                                      ,qaru_rule_number
                                      ,qaru_name
                                      ,qaru_layer
                              order by qaru_id asc)
    loop

      l_package_name := lower(qa_constant_pkg.gc_utplsql_ut_test_packages_prefix) || rec_client_rules.qaru_client_name_unified || '_' || rec_client_rules.qaru_name_unified ||'_pkg';

      l_clob := 'CREATE OR REPLACE PACKAGE ' || l_package_name || ' IS' || chr(10);
      l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
      l_clob := l_clob || '--%suite(' || rec_client_rules.qaru_client_name || ')' || chr(10);
      l_clob := l_clob || '--%suitepath(' || rec_client_rules.qaru_client_name_unified || ')' || chr(10) || chr(10);

      l_clob := l_clob || '--%test(quasto_test_rule_' || rec_client_rules.qaru_rule_number_unified || ')' || chr(10);
      l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || ';' || chr(10);

      l_clob := l_clob || 'END ' || l_package_name || ';';

      execute immediate l_clob;
      dbms_output.put_line('Package specification for ' || l_package_name || ' created.');

      l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);

      l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || chr(10);
      l_clob := l_clob || 'IS' || chr(10);
      l_clob := l_clob || '  l_schema_names VARCHAR2_TAB_T := VARCHAR2_TAB_T();' || chr(10);
      l_clob := l_clob || '  l_result NUMBER;' || chr(10);
      l_clob := l_clob || '  l_object_names CLOB;' || chr(10);
      l_clob := l_clob || '  l_object_details CLOB;' || chr(10);
      l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || chr(10);
      l_clob := l_clob || 'BEGIN' || chr(10);

      if l_schema_names is not null
      then
        l_clob := l_clob || '  for i in ( select username' || chr(10);
        l_clob := l_clob || '               from qaru_schema_names_for_testing_v' || chr(10);
        l_clob := l_clob || '              where username in (''' || l_schema_names || ''')' || chr(10);
        l_clob := l_clob || '           )' || chr(10);
      else
        l_clob := l_clob || '  for i in ( select username' || chr(10);
        l_clob := l_clob || '               from qaru_schema_names_for_testing_v' || chr(10);
        l_clob := l_clob || '           )' || chr(10);
      end if;

      l_clob := l_clob || '  loop' || chr(10);
      l_clob := l_clob || '    l_schema_names.extend;' || chr(10);
      l_clob := l_clob || '    l_schema_names(l_schema_names.last) := i.username;' || chr(10);
      l_clob := l_clob || '  end loop;' || chr(10);

      l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || rec_client_rules.qaru_client_name || ''',' || chr(10);
      l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || rec_client_rules.qaru_rule_number || ''',' || chr(10);
      l_clob := l_clob || '                          pi_schema_names      => l_schema_names,' || chr(10);
      l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
      l_clob := l_clob || '                          po_object_names      => l_object_names,' || chr(10);
      l_clob := l_clob || '                          po_object_details    => l_object_details,' || chr(10);
      l_clob := l_clob || '                          po_error_message     => l_error_message);' || chr(10);

      l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
      
      l_clob := l_clob || '  dbms_output.put_line(''<Results rulenumber="' || rec_client_rules.qaru_rule_number || '" layer="' || rec_client_rules.qaru_layer || '" result="''||l_result||''">'');' || chr(10);
      l_clob := l_clob || '  if l_result != 1' || chr(10);
      l_clob := l_clob || '  then' || chr(10);
      l_clob := l_clob || '  l_object_names := replace(l_object_names, ''; '', '';'');' || chr(10);
      l_clob := l_clob || '  l_object_details := replace(l_object_details, ''; '', '';'');' || chr(10);
      l_clob := l_clob || '  for i in ( select trim(regexp_substr(l_object_names, ''[^;]+'', 1, level)) as object_name' || chr(10);
      l_clob := l_clob || '                   ,trim(regexp_substr(l_object_details, ''[^;]+'', 1, level)) as object_details' || chr(10);
      l_clob := l_clob || '               from dual' || chr(10);
      l_clob := l_clob || '            connect by level <= regexp_count(l_object_names, '';'')+1' || chr(10);
      l_clob := l_clob || '           )' || chr(10);
      l_clob := l_clob || '  loop' || chr(10);
      l_clob := l_clob || '    dbms_output.put_line(''<Object objectpath="''||i.object_name||''" objectdetails="''||i.object_details||''">''||l_error_message||''</Object>'');' || chr(10);
      l_clob := l_clob || '  end loop;' || chr(10);
      l_clob := l_clob || '  end if;' || chr(10);
      l_clob := l_clob || '  dbms_output.put_line(''</Results>'');' || chr(10);

      l_clob := l_clob || 'EXCEPTION' || chr(10);
      l_clob := l_clob || '  WHEN OTHERS THEN' || chr(10);
      l_clob := l_clob || '    dbms_output.put_line(''Execution of test "' || rec_client_rules.qaru_test_name || '" raised exception.'');' || chr(10);
      l_clob := l_clob || '    dbms_output.put_line(SQLERRM);' || chr(10);
      l_clob := l_clob || '    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);' || chr(10);
      l_clob := l_clob || '    RAISE;' || chr(10);
      l_clob := l_clob || 'END p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || ';' || chr(10);

      l_clob := l_clob || 'END ' || l_package_name || ';';

      execute immediate l_clob;
      dbms_output.put_line('Package body for ' || l_package_name || ' created.');

    end loop;

    elsif pi_option = qa_constant_pkg.gc_utplsql_single_rule_per_object
    then

    for rec_client_rules in (select qaru_client_name
                                     ,qaru_rule_number
                                     ,qaru_name
                   ,qaru_object_types
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
                               where qaru_is_active = 1 and qaru_layer = 'DATABASE'
                               group by qaru_id
                                       ,qaru_client_name
                                       ,qaru_rule_number
                                       ,qaru_name
                     ,qaru_object_types
                                       ,qaru_layer
                               order by qaru_id asc)
    loop
        l_object_types := f_generate_table_of_vc_object_types(pi_object_types => rec_client_rules.qaru_object_types);

        l_package_name := 'qa_ut_' || rec_client_rules.qaru_client_name_unified || '_' || rec_client_rules.qaru_name_unified ||'_pkg';

        l_clob := 'CREATE OR REPLACE PACKAGE ' || l_package_name || ' IS' || chr(10);
        l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
        l_clob := l_clob || '--%suite(' || rec_client_rules.qaru_client_name || ')' || chr(10);
        l_clob := l_clob || '--%suitepath(' || rec_client_rules.qaru_client_name_unified || ')' || chr(10) || chr(10);

        l_object_number := 1;
        for rec_rule_objects in (select lower(ao.owner) as owner_unified
                                     ,lower(ao.object_name) as object_name_unified
                                 from all_objects ao
                                 join qaru_schema_names_for_testing_v qa
                                 on qa.username = ao.owner
                                 where ao.object_type member of (l_object_types)
                                 and ((l_schema_names is not null and qa.username in (l_schema_names))
                                      or l_schema_names is null
                                     )
                     order by ao.owner asc)    
        loop

        l_clob := l_clob || '--%test(quasto_test_rule_' || rec_client_rules.qaru_rule_number_unified || '_for_"' || rec_rule_objects.owner_unified || '"."' || rec_rule_objects.object_name_unified || '")' || chr(10);
        l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || '_for_object_no_' || to_char(l_object_number) || ';' || chr(10);
        l_object_number := l_object_number + 1;

      end loop;

      l_clob := l_clob || 'END ' || l_package_name || ';';

      execute immediate l_clob;
      dbms_output.put_line('Package specification for ' || l_package_name || ' created.');

      l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);

      l_object_number := 1;
      for rec_rule_objects in (select ao.owner
                                      , lower(ao.owner) as owner_unified
                                    , ao.object_name
                                     ,lower(ao.object_name) as object_name_unified
                                 from all_objects ao
                                 join qaru_schema_names_for_testing_v qa
                                 on qa.username = ao.owner
                                 where ao.object_type member of (l_object_types)
                                 and ((l_schema_names is not null and qa.username in (l_schema_names))
                                      or l_schema_names is null
                                     )
                     order by ao.owner asc)
        loop

          l_clob := l_clob || 'PROCEDURE p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || '_for_object_no_' || to_char(l_object_number) || chr(10);
          l_clob := l_clob || 'IS' || chr(10);
          l_clob := l_clob || '  l_schema_names VARCHAR2_TAB_T := VARCHAR2_TAB_T();' || chr(10);
          l_clob := l_clob || '  l_result NUMBER;' || chr(10);
          l_clob := l_clob || '  l_object_names CLOB;' || chr(10);
          l_clob := l_clob || '  l_object_details CLOB;' || chr(10);
          l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || chr(10);
          l_clob := l_clob || '  l_object_name VARCHAR2(255);' || chr(10);
          l_clob := l_clob || 'BEGIN' || chr(10);

          l_clob := l_clob || '  l_schema_names.extend;' || chr(10);
          l_clob := l_clob || '  l_schema_names(l_schema_names.last) := ''' || rec_rule_objects.owner || ''';' || chr(10);
          l_clob := l_clob || '  l_object_name := ''' || rec_rule_objects.object_name || ''';' || chr(10);

          l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || rec_client_rules.qaru_client_name || ''',' || chr(10);
          l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || rec_client_rules.qaru_rule_number || ''',' || chr(10);
          l_clob := l_clob || '                          pi_schema_names      => l_schema_names,' || chr(10);
          l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
          l_clob := l_clob || '                          po_object_names      => l_object_names,' || chr(10);
          l_clob := l_clob || '                          po_object_details    => l_object_details,' || chr(10);
          l_clob := l_clob || '                          po_error_message     => l_error_message);' || chr(10);

          l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
          
          l_clob := l_clob || '  dbms_output.put_line(''<Results rulenumber="' || rec_client_rules.qaru_rule_number || '" layer="' || rec_client_rules.qaru_layer || '" result="''||l_result||''">'');' || chr(10);
          l_clob := l_clob || '  if l_result != 1' || chr(10);
          l_clob := l_clob || '  then' || chr(10);
          l_clob := l_clob || '  l_object_names := replace(l_object_names, ''; '', '';'');' || chr(10);
          l_clob := l_clob || '  l_object_details := replace(l_object_details, ''; '', '';'');' || chr(10);
          l_clob := l_clob || '  for i in ( select trim(regexp_substr(l_object_names, ''[^;]+'', 1, level)) as object_name' || chr(10);
          l_clob := l_clob || '                   ,trim(regexp_substr(l_object_details, ''[^;]+'', 1, level)) as object_details' || chr(10);
          l_clob := l_clob || '               from dual' || chr(10);
          l_clob := l_clob || '            connect by level <= regexp_count(l_object_names, '';'')+1' || chr(10);
          l_clob := l_clob || '           )' || chr(10);
          l_clob := l_clob || '  loop' || chr(10);
          l_clob := l_clob || '    dbms_output.put_line(''<Object objectpath="''||i.object_name||''" objectdetails="''||i.object_details||''">''||l_error_message||''</Object>'');' || chr(10);
          l_clob := l_clob || '  end loop;' || chr(10);
          l_clob := l_clob || '  end if;' || chr(10);
          l_clob := l_clob || '  dbms_output.put_line(''</Results>'');' || chr(10);

          l_clob := l_clob || 'EXCEPTION' || chr(10);
          l_clob := l_clob || '  WHEN OTHERS THEN' || chr(10);
          l_clob := l_clob || '    dbms_output.put_line(''Execution of test "' || rec_client_rules.qaru_test_name || '" raised exception.'');' || chr(10);
          l_clob := l_clob || '    dbms_output.put_line(SQLERRM);' || chr(10);
          l_clob := l_clob || '    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);' || chr(10);
          l_clob := l_clob || '    RAISE;' || chr(10);
          l_clob := l_clob || 'END p_ut_rule_' || rec_client_rules.qaru_rule_number_unified || '_for_object_no_' || to_char(l_object_number) || ';' || chr(10);
        l_object_number := l_object_number + 1;

        end loop;

        l_clob := l_clob || 'END ' || l_package_name || ';';

        execute immediate l_clob;
        dbms_output.put_line('Package body for ' || l_package_name || ' created.');

    end loop;

    end if;

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while creating the unit test packages!'
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
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while running the unit test packages!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      po_result := 'Execution of unit tests failed with error ' || sqlerrm || ' - ' || dbms_utility.format_error_backtrace;
      raise;
  end p_run_unit_tests;

  procedure p_run_unit_test_job
  is 
    l_result varchar2(4000 char);
  begin
    p_run_unit_tests(l_result);
  end p_run_unit_test_job;

end qa_unit_tests_pkg;
/