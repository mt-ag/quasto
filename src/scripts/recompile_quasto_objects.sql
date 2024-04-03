Prompt Recomile QUASTO Objects
set serveroutput on;

declare
  type t_object_rec is record(
     object_name varchar2(1000 char)
    ,object_type varchar2(1000 char));
  type t_object_table is table of t_object_rec index by pls_integer;

  l_object   t_object_table;
  l_count    number;
  l_counter  number := 1;
  l_index    number := 1;
  l_action   varchar2(32767);
  l_action_2 varchar2(32767);
begin
  -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);
  -- objects:
  -- QASTO Objects

  if qa_constant_pkg.gc_apex_flag = 1
  then
    l_object(l_index).object_name := 'QA_APEX_BLACKLISTED_APPS_V';
    l_object(l_index).object_type := 'VIEW';
    l_index := l_index + 1;
  end if;

  -- types
  l_object(l_index).object_name := 'QA_RULE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_RULES_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_RUNNING_RULE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_RUNNING_RULES_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'VARCHAR2_TAB_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_TEST_RESULTS_TABLE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_TEST_RESULTS_ROW_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_SCHEME_OBJECT_AMOUNT_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_SCHEME_OBJECT_AMOUNTS_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  -- packages
  l_object(l_index).object_name := 'QA_UNIT_TESTS_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
    

  l_object(l_index).object_name := 'QA_CONSTANT_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_MAIN_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_API_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_EXPORT_IMPORT_RULES_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_LOGGER_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_UTILS_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_APEX_APP_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_APEX_API_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;

  -- triggers
  l_object(l_index).object_name := 'QARU_IU_TRG';
  l_object(l_index).object_type := 'TRIGGER';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QAIF_I_TRG';
  l_object(l_index).object_type := 'TRIGGER';
  l_index := l_index + 1;


  -- views
  l_object(l_index).object_name := 'QA_SCHEME_NAMES_FOR_TESTING_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_PREDECESSOR_ORDER_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_APPLICATION_OWNER_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_JOB_RUN_DETAILS_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_OVERVIEW_TESTS_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_TEST_RUNTIME_ERROR_P0003_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_TEST_RUN_DETAILS_P0004_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_TEST_RESULT_FILES_P0005_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_JOB_DETAILS_P0009_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;


  while l_counter < l_object.count
  loop
    select count(1)
    into l_count
    from user_objects
    where name = l_object(l_counter).object_name;

    if l_count = 0
      then
        dbms_output.put_line('WARNING: object does not exist: ' || l_object(l_counter).object_name);
        l_counter := l_counter + 1;
        continue;
    end if;

    l_action_2 := null;
    if l_object(l_counter).object_type = 'PACKAGE'
    then
      l_action   := 'alter package ' || l_object(l_counter).object_name || ' compile';
      l_action_2 := 'alter package ' || l_object(l_counter).object_name || ' compile body';
    else
      l_action := 'alter ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' compile';
    end if;
    begin
      execute immediate (l_action);
      if l_action_2 is not null
      then
        execute immediate (l_action_2);
      end if;
      dbms_output.put_line('INFO: ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' recompiled.');
      l_counter := l_counter + 1;
    exception
      when others then
        dbms_output.put_line('ERROR: The object ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' is invalid.');
        l_counter := l_counter + 1;
    end;
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR: There has been an unexpected Error!');
    raise;
end;
/