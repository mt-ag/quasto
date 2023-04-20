PROMPT create or replace package CREATE_UT_TEST_PACKAGES_PKG
create or replace package create_ut_test_packages_pkg is

  c_single_package          constant number := 1;
  c_single_package_per_rule constant number := 2;
  c_single_rule_per_object  constant number := 3;

  procedure p_create_test_packages_for_qa_rules(
    pi_option in number
  );
function f_get_logger_exception(pi_package_name in varchar2 )
return varchar2;

function f_get_logger_spec(pi_package_name in varchar2) return varchar2;
end create_ut_test_packages_pkg;
/
create or replace package body create_ut_test_packages_pkg is

  function f_get_logger_spec(pi_package_name in varchar2) return varchar2 is
    l_varchar varchar2(32767);
  begin
    l_varchar := q'{  c_unit constant varchar2(32767 char) := $$plsql_unit || '.}' || pi_package_name || chr(39) || chr(59) || chr(10);
  
    l_varchar := l_varchar || '  l_param_list qa_logger_pkg.tab_param' || chr(59) || chr(10);
  
    return l_varchar;
  end f_get_logger_spec;

  function f_get_logger_exception(pi_package_name in varchar2) return varchar2 is
    l_varchar varchar2(32767);
  begin
  
    l_varchar := '  exception' || chr(10);
    l_varchar := l_varchar || '    when others then' || chr(10);
    l_varchar := l_varchar || q'{      qa_logger_pkg.p_qa_log(p_text   => 'There has been an Error in Package }' || pi_package_name || chr(39) || chr(10);
    l_varchar := l_varchar || '                            ,p_scope  => c_unit ' || chr(10);
    l_varchar := l_varchar || '                            ,p_extra  => sqlerrm' || chr(10);
    l_varchar := l_varchar || '                            ,p_params => l_param_list);' || chr(10);
    return l_varchar;
  end f_get_logger_exception;

  procedure p_create_test_packages_for_qa_rules(pi_option in number) is
    c_unit constant varchar2(32767 char) := $$plsql_unit || '.p_create_test_package_for_qa_rules';
    l_param_list   qa_logger_pkg.tab_param;
    l_package_name varchar2(255);
    l_clob         clob;
  begin
    dbms_output.enable(buffer_size => 10000000);
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name   => 'pi_option'
                              ,p_val    => pi_option);
  
    if pi_option not in (c_single_package
                        ,c_single_package_per_rule
                        ,c_single_rule_per_object)
    then
      raise_application_error(-20001
                             ,'Invalid input parameter value: ' || pi_option);
    end if;
  
    if pi_option = c_single_package
    then
    
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
      
        l_package_name := 'qa_ut_' || rec_clients.qaru_client_name_unified || '_pkg';
      
        l_clob := 'CREATE OR REPLACE PACKAGE ' || l_package_name || ' IS' || chr(10);
        l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
        l_clob := l_clob || '--%suite(' || rec_clients.qaru_client_name || ')' || chr(10);
        l_clob := l_clob || '--%suitepath(' || rec_clients.qaru_client_name_unified || ')' || chr(10) || chr(10);
      
        for rec_rules in (select qaru_name
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
        
          l_clob := l_clob || '--%test(is qa rule "' || rec_rules.qaru_name || '" observed)' || chr(10);
          l_clob := l_clob || 'PROCEDURE p_ut_test_' || rec_rules.qaru_name_unified || ';' || chr(10);
        
        end loop;
      
        l_clob := l_clob || 'END ' || l_package_name || ';';
      
        execute immediate l_clob;
        dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
      
        l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);
      
        for rec_rules in (select qaru_rule_number
                                ,replace(qaru_name
                                        ,'' || chr(39) || ''
                                        ,'' || chr(39) || chr(39) || '') as qaru_test_name
                                ,regexp_replace(replace(lower(qaru_name)
                                                       ,' '
                                                       ,'_')
                                               ,'[^a-z0-9_]'
                                               ,'_') as qaru_name_unified
                                ,qaru_category
                                ,qaru_layer
                          from qa_rules
                          where qaru_client_name = rec_clients.qaru_client_name
                          and qaru_is_active = 1
                          order by qaru_id asc)
        loop
        
          l_clob := l_clob || 'PROCEDURE p_ut_test_' || rec_rules.qaru_name_unified || chr(10);
          l_clob := l_clob || 'IS' || chr(10);
          l_clob := l_clob || '  l_schema_names VARCHAR2_TAB_T := VARCHAR2_TAB_T();' || chr(10);
          l_clob := l_clob || '  l_layer qa_rules.qaru_layer%type;' || chr(10);
          l_clob := l_clob || '  l_result NUMBER;' || chr(10);
          l_clob := l_clob || '  l_object_names CLOB;' || chr(10);
          l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || chr(10);
          l_clob := l_clob || f_get_logger_spec(l_package_name);
        
          l_clob := l_clob || 'BEGIN' || chr(10);
          l_clob := l_clob || '  l_layer := ''' || rec_rules.qaru_layer || ''';' || chr(10);
          l_clob := l_clob || '  for i in ( select au.username' || chr(10);
          l_clob := l_clob || '               from all_users au' || chr(10);
          l_clob := l_clob || '              where ( au.username not like ''%SYS%'' and au.username not like ''%APEX%'' )' || chr(10);
          l_clob := l_clob || '           )' || chr(10);
          l_clob := l_clob || '  loop' || chr(10);
          l_clob := l_clob || '    l_schema_names.extend;' || chr(10);
          l_clob := l_clob || '    l_schema_names(l_schema_names.last) := i.username;' || chr(10);
          l_clob := l_clob || '  end loop;' || chr(10);
        
          l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || rec_clients.qaru_client_name || ''',' || chr(10);
          l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || rec_rules.qaru_rule_number || ''',' || chr(10);
          l_clob := l_clob || '                          pi_schema_names      => l_schema_names,' || chr(10);
          l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
          l_clob := l_clob || '                          po_object_names      => l_object_names,' || chr(10);
          l_clob := l_clob || '                          po_error_message     => l_error_message);' || chr(10);
        
          l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
          l_clob := l_clob || '  dbms_output.put_line(''  --INFO-- Test "' || rec_rules.qaru_test_name || '" completed with result ''||l_result);' || chr(10);
          l_clob := l_clob || '  dbms_output.put_line(''           Layer: ''||l_layer);' || chr(10);
          l_clob := l_clob || '  dbms_output.put_line(''           Error message: ''||l_error_message);' || chr(10);
          l_clob := l_clob || '  dbms_output.put_line(''           Invalid objects: ''||l_object_names);' || chr(10);
        
          l_clob := l_clob || f_get_logger_exception(l_package_name);
          l_clob := l_clob || '    RAISE;' || chr(10);
          l_clob := l_clob || 'END p_ut_test_' || rec_rules.qaru_name_unified || ';' || chr(10);
        
        end loop;
      
        l_clob := l_clob || 'END ' || l_package_name || ';';
      
      end loop;
    
      execute immediate l_clob;
      dbms_output.put_line('Package body for ' || l_package_name || ' created.');
    
    elsif pi_option = c_single_package_per_rule
    then
    
      for rec_client_rules in (select qaru_client_name
                                     ,qaru_rule_number
                                     ,qaru_name
                                     ,qaru_category
                                     ,qaru_layer
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
                                     ,replace(qaru_name
                                             ,'' || chr(39) || ''
                                             ,'' || chr(39) || chr(39) || '') as qaru_test_name
                               from qa_rules
                               where qaru_is_active = 1
                               group by qaru_id
                                       ,qaru_client_name
                                       ,qaru_rule_number
                                       ,qaru_name
                                       ,qaru_category
                                       ,qaru_layer
                               order by qaru_id asc)
      loop
      
        l_package_name := 'qa_ut_' || rec_client_rules.qaru_client_name_unified || '_' || rec_client_rules.qaru_name_unified || '_pkg';
      
        l_clob := 'CREATE OR REPLACE PACKAGE ' || l_package_name || ' IS' || chr(10);
        l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || chr(10);
        l_clob := l_clob || '--%suite(' || rec_client_rules.qaru_client_name || ')' || chr(10);
        l_clob := l_clob || '--%suitepath(' || rec_client_rules.qaru_client_name_unified || ')' || chr(10) || chr(10);
      
        l_clob := l_clob || '--%test(is qa rule "' || rec_client_rules.qaru_name || '" observed)' || chr(10);
        l_clob := l_clob || 'PROCEDURE p_ut_test_' || rec_client_rules.qaru_name_unified || ';' || chr(10);
      
        l_clob := l_clob || 'END ' || l_package_name || ';';
      
        execute immediate l_clob;
        dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
      
        l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);
      
        l_clob := l_clob || 'PROCEDURE p_ut_test_' || rec_client_rules.qaru_name_unified || chr(10);
        l_clob := l_clob || 'IS' || chr(10);
        l_clob := l_clob || '  l_schema_names VARCHAR2_TAB_T := VARCHAR2_TAB_T();' || chr(10);
        l_clob := l_clob || '  l_layer qa_rules.qaru_layer%type;' || chr(10);
        l_clob := l_clob || '  l_result NUMBER;' || chr(10);
        l_clob := l_clob || '  l_object_names CLOB;' || chr(10);
        l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || chr(10);
        l_clob := l_clob || f_get_logger_spec(l_package_name) || chr(10);
        l_clob := l_clob || 'BEGIN' || chr(10);
      
        l_clob := l_clob || '  l_layer := ''' || rec_client_rules.qaru_layer || ''';' || chr(10);
        l_clob := l_clob || '  for i in ( select au.username' || chr(10);
        l_clob := l_clob || '               from all_users au' || chr(10);
        l_clob := l_clob || '              where ( au.username not like ''%SYS%'' and au.username not like ''%APEX%'' )' || chr(10);
        l_clob := l_clob || '           )' || chr(10);
        l_clob := l_clob || '  loop' || chr(10);
        l_clob := l_clob || '    l_schema_names.extend;' || chr(10);
        l_clob := l_clob || '    l_schema_names(l_schema_names.last) := i.username;' || chr(10);
        l_clob := l_clob || '  end loop;' || chr(10);
      
        l_clob := l_clob || '  qa_main_pkg.p_test_rule(pi_qaru_client_name  => ''' || rec_client_rules.qaru_client_name || ''',' || chr(10);
        l_clob := l_clob || '                          pi_qaru_rule_number  => ''' || rec_client_rules.qaru_rule_number || ''',' || chr(10);
        l_clob := l_clob || '                          pi_schema_names      => l_schema_names,' || chr(10);
        l_clob := l_clob || '                          po_result            => l_result,' || chr(10);
        l_clob := l_clob || '                          po_object_names      => l_object_names,' || chr(10);
        l_clob := l_clob || '                          po_error_message     => l_error_message);' || chr(10);
      
      
        l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''  --INFO-- Test "' || rec_client_rules.qaru_test_name || '" completed with result ''||l_result);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Layer: ''||l_layer);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Error message: ''||l_error_message);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Invalid objects: ''||l_object_names);' || chr(10);
      
      
        l_clob := l_clob || f_get_logger_exception(l_package_name);
        l_clob := l_clob || '    RAISE;' || chr(10);
        l_clob := l_clob || 'END p_ut_test_' || rec_client_rules.qaru_name_unified || ';' || chr(10);
      
        l_clob := l_clob || 'END ' || l_package_name || ';';
      
        execute immediate l_clob;
        dbms_output.put_line('Package body for ' || l_package_name || ' created.');
      
      end loop;
    
    elsif pi_option = c_single_rule_per_object
    then
    
      null;
    
    end if;
  
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while generated the Rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_create_test_packages_for_qa_rules;

end create_ut_test_packages_pkg;
/
