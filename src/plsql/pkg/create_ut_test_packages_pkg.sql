PROMPT create or replace package CREATE_UT_TEST_PACKAGES_PKG
create or replace PACKAGE create_ut_test_packages_pkg IS 

PROCEDURE create_test_packages_for_qa_rules;

END create_ut_test_packages_pkg;
/
create or replace PACKAGE BODY create_ut_test_packages_pkg IS

PROCEDURE pr_create_test_packages_for_qa_rules
  IS
    l_package_name VARCHAR2(255);
    l_clob clob;
  BEGIN
    dbms_output.enable(buffer_size => 10000000);

    FOR rec_clients IN (SELECT qaru_client_name
                             , regexp_replace(replace(lower(qaru_client_name), ' ', '_'), '[^a-z0-9_]', '_') as qaru_client_name_unified
                          FROM qa_rules
                         WHERE qaru_is_active = 1
                      GROUP BY qaru_client_name)
    LOOP

    l_package_name := 'ut_qa_test_'||rec_clients.qaru_client_name_unified||'_pkg';

    l_clob := 'CREATE OR REPLACE PACKAGE '||l_package_name||' IS' || CHR(10);
    l_clob := l_clob || '--THIS PACKAGE IS GENERATED AUTOMATICALLY. DO NOT MAKE ANY MANUAL CHANGES.' || CHR(10);
    l_clob := l_clob || '--%suite('||rec_clients.qaru_client_name||')' || CHR(10);
    l_clob := l_clob || '--%suitepath('||rec_clients.qaru_client_name_unified||')' || CHR(10) || CHR(10);

    FOR rec_rules IN (SELECT qaru_name    
                           , regexp_replace(replace(lower(qaru_name), ' ', '_'), '[^a-z0-9_]', '_') as qaru_name_unified
                        FROM qa_rules
                       WHERE qaru_client_name = rec_clients.qaru_client_name
                         AND qaru_is_active = 1
                    ORDER BY qaru_id asc)
    LOOP

      l_clob := l_clob || '--%test(is qa rule "'||rec_rules.qaru_name||'" observed)' || CHR(10);
      l_clob := l_clob || 'PROCEDURE pr_ut_test_'||rec_rules.qaru_name_unified||';' || CHR(10);

    END LOOP;

    l_clob := l_clob || 'END '||l_package_name||';';

    EXECUTE IMMEDIATE l_clob;
    dbms_output.put_line('Package specification for '||l_package_name||' created.');

    l_clob := 'CREATE OR REPLACE PACKAGE BODY '||l_package_name||' IS' || CHR(10);

    FOR rec_rules IN (SELECT qaru_id
                           , replace(qaru_name, ''||chr(39)||'', ''||chr(39)||chr(39)||'') as qaru_test_name
                           , regexp_replace(replace(lower(qaru_name), ' ', '_'), '[^a-z0-9_]', '_') as qaru_name_unified
                           , qaru_category
                           , qaru_layer
                        FROM qa_rules
                       WHERE qaru_client_name = rec_clients.qaru_client_name
                         AND qaru_is_active = 1
                    ORDER BY qaru_id asc)
    LOOP

      l_clob := l_clob || 'PROCEDURE pr_ut_test_'||rec_rules.qaru_name_unified || CHR(10);
      l_clob := l_clob || 'IS' || CHR(10);
      l_clob := l_clob || '  l_app_id NUMBER;' || CHR(10);
      l_clob := l_clob || '  l_app_page_id NUMBER;' || CHR(10);
      l_clob := l_clob || '  l_layer qa_rules.qaru_layer%type;' || CHR(10);
      l_clob := l_clob || '  l_result NUMBER;' || CHR(10);
      l_clob := l_clob || '  l_object_names CLOB;' || CHR(10);
      l_clob := l_clob || '  l_error_message qa_rules.qaru_error_message%type;' || CHR(10);
      l_clob := l_clob || 'BEGIN' || CHR(10);

      if rec_rules.qaru_category = 'APEX'
      then
        if rec_rules.qaru_layer = 'PAGE'
        then

        l_clob := l_clob || 'FOR rec IN (SELECT aapp.application_id' || CHR(10);
        l_clob := l_clob || '                 , aapp.page_id' || CHR(10);
        l_clob := l_clob || '              FROM apex_application_pages aapp' || CHR(10);
        l_clob := l_clob || '          ORDER BY aapp.application_id, aapp.page_id ASC)' || CHR(10);
        l_clob := l_clob || 'LOOP' || CHR(10);
        l_clob := l_clob || '  l_app_id := rec.application_id;' || CHR(10);
        l_clob := l_clob || '  l_app_page_id := rec.page_id;' || CHR(10);
        l_clob := l_clob || '  l_layer := '''||rec_rules.qaru_layer||' (Application: ''||rec.application_id||'' - Page: ''||rec.page_id||'')'';' || CHR(10);

        elsif rec_rules.qaru_layer = 'APPLICATION'
        then

        l_clob := l_clob || 'FOR rec IN (SELECT apap.application_id' || CHR(10);
        l_clob := l_clob || '              FROM apex_applications apap' || CHR(10);
        l_clob := l_clob || '          ORDER BY apap.application_id ASC)' || CHR(10);
        l_clob := l_clob || 'LOOP' || CHR(10);
        l_clob := l_clob || '  l_app_id := rec.application_id;' || CHR(10);
        l_clob := l_clob || '  l_app_page_id := null;' || CHR(10);
        l_clob := l_clob || '  l_layer := '''||rec_rules.qaru_layer||' (Application: ''||rec.application_id||'')'';' || CHR(10);

        end if;
    else

        l_clob := l_clob || '  l_app_id := null;' || CHR(10);
        l_clob := l_clob || '  l_app_page_id := null;' || CHR(10);
        l_clob := l_clob || '  l_layer := '''||rec_rules.qaru_layer||''';' || CHR(10);

    end if;

      l_clob := l_clob || '  qa_pkg.test_rule(pi_qaru_id        => '||to_char(rec_rules.qaru_id)||',' || CHR(10);
      l_clob := l_clob || '                   pi_app_id         => l_app_id,' || CHR(10);
      l_clob := l_clob || '                   pi_app_page_id    => l_app_page_id,' || CHR(10);
      l_clob := l_clob || '                   po_result         => l_result,' || CHR(10);
      l_clob := l_clob || '                   po_object_names   => l_object_names,' || CHR(10);
      l_clob := l_clob || '                   po_error_message  => l_error_message);' || CHR(10);
      l_clob := l_clob || '  ut.expect(l_result).to_(equal(1));' || CHR(10);
      l_clob := l_clob || '  dbms_output.put_line(''  --INFO-- Test "'||rec_rules.qaru_test_name||'" completed with result ''||l_result);' || CHR(10);
      l_clob := l_clob || '  dbms_output.put_line(''           Layer: ''||l_layer);' || CHR(10);
      l_clob := l_clob || '  dbms_output.put_line(''           Error message: ''||l_error_message);' || CHR(10);
      l_clob := l_clob || '  dbms_output.put_line(''           Invalid objects: ''||l_object_names);' || CHR(10);

    if rec_rules.qaru_category = 'APEX'
    then

        l_clob := l_clob || 'END LOOP;' || CHR(10);

    end if;

      l_clob := l_clob || 'EXCEPTION' || CHR(10);
      l_clob := l_clob || '  WHEN OTHERS THEN' || CHR(10);
      l_clob := l_clob || '    dbms_output.put_line(''  --ERROR-- Execution of test "'||rec_rules.qaru_test_name||'" raised exception.'');' || CHR(10);
      l_clob := l_clob || '    dbms_output.put_line(''            ''||SQLERRM);' || CHR(10);
      l_clob := l_clob || '    dbms_output.put_line(''            ''||DBMS_UTILITY.format_error_backtrace);' || CHR(10);
      l_clob := l_clob || '    RAISE;' || CHR(10);
      l_clob := l_clob || 'END pr_ut_test_'||rec_rules.qaru_name_unified||';' || CHR(10);

    END LOOP;

    l_clob := l_clob || 'END '||l_package_name||';';

    END LOOP;

    EXECUTE IMMEDIATE l_clob;
    dbms_output.put_line('Package body for '||l_package_name||' created.');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('--ERROR--');
    dbms_output.put_line('Creation of package '||l_package_name||' raised exception.');
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line(DBMS_UTILITY.format_error_backtrace);
END pr_create_test_packages_for_qa_rules;

END CREATE_UT_TEST_PACKAGES_PKG;
/
