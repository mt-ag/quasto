Prompt Recomile QUASTO Objects
set serveroutput on;
declare
  type t_vc2_array is table of varchar2(1000) index by varchar2(100);

  l_object_name t_vc2_array;
  l_object_type t_vc2_array;
  l_object      varchar2(100 char);
  l_key         varchar2(100 char);
  l_action      varchar2(32767);
  l_action_2    varchar2(32767);
  l_count       number;
begin
   -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);
  -- objects:
  -- QASTO Objects

  -- Views:
  l_object_name('QA_SCHEME_NAMES_FOR_TESTING_V') := 'QA_SCHEME_NAMES_FOR_TESTING_V';
  l_object_type('QA_SCHEME_NAMES_FOR_TESTING_V') := 'VIEW';

  if qa_constant_pkg.gc_apex_flag = 1
    then
      l_object_name('QA_APEX_BLACKLISTED_APPS_V') := 'QA_APEX_BLACKLISTED_APPS_V';
      l_object_type('QA_APEX_BLACKLISTED_APPS_V') := 'VIEW';
  end if;

  l_object_name('QA_PREDECESSOR_ORDER_V') := 'QA_PREDECESSOR_ORDER_V';
  l_object_type('QA_PREDECESSOR_ORDER_V') := 'VIEW';
  l_object_name('QA_APPLICATION_OWNER_V') := 'QA_APPLICATION_OWNER_V';
  l_object_type('QA_APPLICATION_OWNER_V') := 'VIEW';

  l_object_name('QA_OVERVIEW_TESTS_P0001_V') := 'QA_OVERVIEW_TESTS_P0001_V';
  l_object_type('QA_OVERVIEW_TESTS_P0001_V') := 'VIEW';
  l_object_name('QA_OVERVIEW_QUOTA_P0001_V') := 'QA_OVERVIEW_QUOTA_P0001_V';
  l_object_type('QA_OVERVIEW_QUOTA_P0001_V') := 'VIEW';
  l_object_name('QA_OVERVIEW_TIMELINE_ERROR_P0001_V') := 'QA_OVERVIEW_TIMELINE_ERROR_P0001_V';
  l_object_type('QA_OVERVIEW_TIMELINE_ERROR_P0001_V') := 'VIEW';
  l_object_name('QA_OVERVIEW_TIMELINE_FAILURE_P0001_V') := 'QA_OVERVIEW_TIMELINE_FAILURE_P0001_V';
  l_object_type('QA_OVERVIEW_TIMELINE_FAILURE_P0001_V') := 'VIEW';
  l_object_name('QA_OVERVIEW_TIMELINE_SUCCESS_P0001_V') := 'QA_OVERVIEW_TIMELINE_SUCCESS_P0001_V';
  l_object_type('QA_OVERVIEW_TIMELINE_SUCCESS_P0001_V') := 'VIEW';
  l_object_name('QA_TEST_RUNTIME_ERROR_P0003_V') := 'QA_TEST_RUNTIME_ERROR_P0003_V';
  l_object_type('QA_TEST_RUNTIME_ERROR_P0003_V') := 'VIEW';
  l_object_name('QA_TEST_RUN_DETAILS_P0004_V') := 'QA_TEST_RUN_DETAILS_P0004_V';
  l_object_type('QA_TEST_RUN_DETAILS_P0004_V') := 'VIEW';
  l_object_name('QA_TEST_RESULT_FILES_P0005_V') := 'QA_TEST_RESULT_FILES_P0005_V';
  l_object_type('QA_TEST_RESULT_FILES_P0005_V') := 'VIEW';
  l_object_name('QA_RULES_P0006_V') := 'QA_RULES_P0006_V';
  l_object_type('QA_RULES_P0006_V') := 'VIEW';
  l_object_name('QA_RULES_P0007_V') := 'QA_RULES_P0007_V';
  l_object_type('QA_RULES_P0007_V') := 'VIEW';
  l_object_name('QA_CLIENT_NAMES_P0008_V') := 'QA_CLIENT_NAMES_P0008_V';
  l_object_type('QA_CLIENT_NAMES_P0008_V') := 'VIEW';
  l_object_name('QA_JOB_DETAILS_P0009_V') := 'QA_JOB_DETAILS_P0009_V';
  l_object_type('QA_JOB_DETAILS_P0009_V') := 'VIEW';
  l_object_name('QA_JOB_RUN_DETAILS_P0009_V') := 'QA_JOB_RUN_DETAILS_P0009_V';
  l_object_type('QA_JOB_RUN_DETAILS_P0009_V') := 'VIEW';
  l_object_name('QA_JOB_RUN_DETAILS_P0011_V') := 'QA_JOB_RUN_DETAILS_P0011_V';
  l_object_type('QA_JOB_RUN_DETAILS_P0011_V') := 'VIEW';

  l_object_name('QA_RULE_CATEGORIES_LOV') := 'QA_RULE_CATEGORIES_LOV';
  l_object_type('QA_RULE_CATEGORIES_LOV') := 'VIEW';
  l_object_name('QA_RULE_ERROR_LEVELS_LOV') := 'QA_RULE_ERROR_LEVELS_LOV';
  l_object_type('QA_RULE_ERROR_LEVELS_LOV') := 'VIEW';
  l_object_name('QA_RULE_LAYERS_LOV') := 'QA_RULE_LAYERS_LOV';
  l_object_type('QA_RULE_LAYERS_LOV') := 'VIEW';
  l_object_name('QA_TEST_EXECUTION_DATES_LOV') := 'QA_TEST_EXECUTION_DATES_LOV';
  l_object_type('QA_TEST_EXECUTION_DATES_LOV') := 'VIEW';
  l_object_name('QA_TEST_SCHEME_NAMES_LOV') := 'QA_TEST_SCHEME_NAMES_LOV';
  l_object_type('QA_TEST_SCHEME_NAMES_LOV') := 'VIEW';

  -- Types:
  l_object_name('QA_RULE_T') := 'QA_RULE_T';
  l_object_type('QA_RULE_T') := 'TYPE';
  l_object_name('QA_RULES_T') := 'QA_RULES_T';
  l_object_type('QA_RULES_T') := 'TYPE';
  l_object_name('QA_RUNNING_RULE_T') := 'QA_RUNNING_RULE_T';
  l_object_type('QA_RUNNING_RULE_T') := 'TYPE';
  l_object_name('QA_RUNNING_RULES_T') := 'QA_RUNNING_RULES_T';
  l_object_type('QA_RUNNING_RULES_T') := 'TYPE';

  l_object_name('VARCHAR2_TAB_T') := 'VARCHAR2_TAB_T';
  l_object_type('VARCHAR2_TAB_T') := 'TYPE';
  l_object_name('QA_TEST_RESULTS_TABLE_T') := 'QA_TEST_RESULTS_TABLE_T';
  l_object_type('QA_TEST_RESULTS_TABLE_T') := 'TYPE';
  l_object_name('QA_TEST_RESULTS_ROW_T') := 'QA_TEST_RESULTS_ROW_T';
  l_object_type('QA_TEST_RESULTS_ROW_T') := 'TYPE';
  
  -- packages
  l_object_name('QA_CONSTANT_PKG') := 'QA_CONSTANT_PKG';
  l_object_type('QA_CONSTANT_PKG') := 'PACKAGE';
  l_object_name('QA_MAIN_PKG') := 'QA_MAIN_PKG';
  l_object_type('QA_MAIN_PKG') := 'PACKAGE';
  l_object_name('QA_API_PKG') := 'QA_API_PKG';
  l_object_type('QA_API_PKG') := 'PACKAGE';
  l_object_name('QA_EXPORT_IMPORT_RULES_PKG') := 'QA_EXPORT_IMPORT_RULES_PKG';
  l_object_type('QA_EXPORT_IMPORT_RULES_PKG') := 'PACKAGE';
  l_object_name('QA_LOGGER_PKG') := 'QA_LOGGER_PKG';
  l_object_type('QA_LOGGER_PKG') := 'PACKAGE';
  l_object_name('QA_UTILS_PKG') := 'QA_UTILS_PKG';
  l_object_type('QA_UTILS_PKG') := 'PACKAGE';
  l_object_name('QA_APEX_APP_PKG') := 'QA_APEX_APP_PKG';
  l_object_type('QA_APEX_APP_PKG') := 'PACKAGE';
  l_object_name('QA_APEX_API_PKG') := 'QA_APEX_API_PKG';
  l_object_type('QA_APEX_API_PKG') := 'PACKAGE';
 
  --trigger
  l_object_name('QARU_IU_TRG') := 'QARU_IU_TRG';
  l_object_type('QARU_IU_TRG') := 'TRIGGER';
  l_object_name('QAIF_I_TRG') := 'QAIF_I_TRG';
  l_object_type('QAIF_I_TRG') := 'TRIGGER';

  l_object := l_object_name.first;
  while l_object is not null
  loop
    l_action_2 := null;
    if l_object_type(l_object) = 'PACKAGE'
    then
      l_action   := 'alter package ' || l_object_name(l_object) || ' compile';
      l_action_2 := 'alter package ' || l_object_name(l_object) || ' compile body';
    else
      l_action := 'alter ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' compile';
    end if;
    begin
      execute immediate (l_action);
      if l_action_2 is not null
      then
        execute immediate (l_action_2);
      end if;
      dbms_output.put_line('INFO: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' recompiled.');
    exception
      when others then
        dbms_output.put_line('ERROR: The object ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' is invalid.');
    end;
    l_object := l_object_name.next(l_object);
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR: There has been an unexpected Error!');
    raise;
end;
/