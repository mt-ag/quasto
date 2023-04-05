PROMPT create or replace package CREATE_UT_TEST_PACKAGES_PKG
create or replace package create_ut_test_packages_pkg is

  procedure pr_create_test_packages_for_qa_rules;

end create_ut_test_packages_pkg;
/
create or replace package body create_ut_test_packages_pkg is

  procedure pr_create_test_packages_for_qa_rules is
    l_package_name varchar2(255);
    l_clob         clob;
  begin
    dbms_output.enable(buffer_size => 10000000);
  
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
    
      l_package_name := 'ut_qa_test_' || rec_clients.qaru_client_name_unified || '_pkg';
    
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
        l_clob := l_clob || 'PROCEDURE pr_ut_test_' || rec_rules.qaru_name_unified || ';' || chr(10);
      
      end loop;
    
      l_clob := l_clob || 'END ' || l_package_name || ';';
    
      execute immediate l_clob;
      dbms_output.put_line('Package specification for ' || l_package_name || ' created.');
    
      l_clob := 'CREATE OR REPLACE PACKAGE BODY ' || l_package_name || ' IS' || chr(10);
    
      for rec_rules in (select qaru_id
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
      
        l_clob := l_clob || 'PROCEDURE pr_ut_test_' || rec_rules.qaru_name_unified || chr(10);
        l_clob := l_clob || 'IS' || chr(10);
        l_clob := l_clob || '  l_app_id NUMBER;' || chr(10);
        l_clob := l_clob || '  l_app_page_id NUMBER;' || chr(10);
        l_clob := l_clob || '  l_layer qa_rules.qaru_layer%type;' || chr(10);
        l_clob := l_clob || '  l_result NUMBER;' || chr(10);
        l_clob := l_clob || '  l_object_names CLOB;' || chr(10);
        l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || chr(10);
        l_clob := l_clob || 'BEGIN' || chr(10);
      
        if rec_rules.qaru_category = 'APEX'
        then
          if rec_rules.qaru_layer = 'PAGE'
          then
          
            l_clob := l_clob || 'FOR rec IN (SELECT aapp.application_id' || chr(10);
            l_clob := l_clob || '                 , aapp.page_id' || chr(10);
            l_clob := l_clob || '              FROM apex_application_pages aapp' || chr(10);
            l_clob := l_clob || '          ORDER BY aapp.application_id, aapp.page_id ASC)' || chr(10);
            l_clob := l_clob || 'LOOP' || chr(10);
            l_clob := l_clob || '  l_app_id := rec.application_id;' || chr(10);
            l_clob := l_clob || '  l_app_page_id := rec.page_id;' || chr(10);
            l_clob := l_clob || '  l_layer := ''' || rec_rules.qaru_layer || ' (Application: ''||rec.application_id||'' - Page: ''||rec.page_id||'')'';' || chr(10);
          
          elsif rec_rules.qaru_layer = 'APPLICATION'
          then
          
            l_clob := l_clob || 'FOR rec IN (SELECT apap.application_id' || chr(10);
            l_clob := l_clob || '              FROM apex_applications apap' || chr(10);
            l_clob := l_clob || '          ORDER BY apap.application_id ASC)' || chr(10);
            l_clob := l_clob || 'LOOP' || chr(10);
            l_clob := l_clob || '  l_app_id := rec.application_id;' || chr(10);
            l_clob := l_clob || '  l_app_page_id := null;' || chr(10);
            l_clob := l_clob || '  l_layer := ''' || rec_rules.qaru_layer || ' (Application: ''||rec.application_id||'')'';' || chr(10);
          
          end if;
        else
        
          l_clob := l_clob || '  l_app_id := null;' || chr(10);
          l_clob := l_clob || '  l_app_page_id := null;' || chr(10);
          l_clob := l_clob || '  l_layer := ''' || rec_rules.qaru_layer || ''';' || chr(10);
        
        end if;
      
        l_clob := l_clob || '  qa_pkg.test_rule(pi_qaru_id        => ' || to_char(rec_rules.qaru_id) || ',' || chr(10);
        l_clob := l_clob || '                   pi_app_id         => l_app_id,' || chr(10);
        l_clob := l_clob || '                   pi_app_page_id    => l_app_page_id,' || chr(10);
        l_clob := l_clob || '                   po_result         => l_result,' || chr(10);
        l_clob := l_clob || '                   po_object_names   => l_object_names,' || chr(10);
        l_clob := l_clob || '                   po_error_message  => l_error_message);' || chr(10);
        l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''  --INFO-- Test "' || rec_rules.qaru_test_name || '" completed with result ''||l_result);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Layer: ''||l_layer);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Error message: ''||l_error_message);' || chr(10);
        l_clob := l_clob || '  dbms_output.put_line(''           Invalid objects: ''||l_object_names);' || chr(10);
      
        if rec_rules.qaru_category = 'APEX'
        then
        
          l_clob := l_clob || 'END LOOP;' || chr(10);
        
        end if;
      
        l_clob := l_clob || 'EXCEPTION' || chr(10);
        l_clob := l_clob || '  WHEN OTHERS THEN' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''  --ERROR-- Execution of test "' || rec_rules.qaru_test_name || '" raised exception.'');' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''            ''||SQLERRM);' || chr(10);
        l_clob := l_clob || '    dbms_output.put_line(''            ''||DBMS_UTILITY.format_error_backtrace);' || chr(10);
        l_clob := l_clob || '    RAISE;' || chr(10);
        l_clob := l_clob || 'END pr_ut_test_' || rec_rules.qaru_name_unified || ';' || chr(10);
      
      end loop;
    
      l_clob := l_clob || 'END ' || l_package_name || ';';
    
    end loop;
  
    execute immediate l_clob;
    dbms_output.put_line('Package body for ' || l_package_name || ' created.');
  exception
    when others then
      dbms_output.put_line('--ERROR--');
      dbms_output.put_line('Creation of package ' || l_package_name || ' raised exception.');
      dbms_output.put_line(sqlerrm);
      dbms_output.put_line(dbms_utility.format_error_backtrace);
  end pr_create_test_packages_for_qa_rules;

end create_ut_test_packages_pkg;
/