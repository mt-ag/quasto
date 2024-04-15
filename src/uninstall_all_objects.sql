set serveroutput on;

PROMPT #########################
PROMPT   Uninstall all objects
PROMPT #########################
declare
  type t_object_rec is record (
    object_name varchar2(1000 char),
    object_type varchar2(1000 char)
  );
  type t_object_table is table of t_object_rec index by pls_integer;
  
  l_object      t_object_table;
  l_counter     number := 1;
  l_count       number;
  l_index       number := 1;
  l_action      varchar2(32767);
  l_action_2    varchar2(32767);
begin
  -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);
  -- objects:
  -- tables
  l_object(l_index).object_name := 'QA_TEST_RUN_INVALID_OBJECTS';
  l_object(l_index).object_type := 'TABLE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_RUNS';
  l_object(l_index).object_type := 'TABLE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_RESULTS';
  l_object(l_index).object_type := 'TABLE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULES';
  l_object(l_index).object_type := 'TABLE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_IMPORT_FILES';
  l_object(l_index).object_type := 'TABLE';
  l_index := l_index + 1;


  -- packages
  l_object(l_index).object_name := 'QA_EXPORT_IMPORT_RULES_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_MAIN_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_API_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_LOGGER_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_CONSTANT_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_UNIT_TESTS_PKG';
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
  l_object(l_index).object_name := 'QA_APEX_PLUGIN_PKG';
  l_object(l_index).object_type := 'PACKAGE';
  l_index := l_index + 1;



  -- types
  l_object(l_index).object_name := 'VARCHAR2_TAB_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULES_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RUNNING_RULE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RUNNING_RULES_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_SCHEME_OBJECT_AMOUNTS_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_SCHEME_OBJECT_AMOUNT_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_RESULTS_TABLE_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_RESULTS_ROW_T';
  l_object(l_index).object_type := 'TYPE';
  l_index := l_index + 1;

  -- sequences
  l_object(l_index).object_name := 'QARU_SEQ';
  l_object(l_index).object_type := 'SEQUENCE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QAIF_SEQ';
  l_object(l_index).object_type := 'SEQUENCE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QATR_SEQ';
  l_object(l_index).object_type := 'SEQUENCE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QATO_SEQ';
  l_object(l_index).object_type := 'SEQUENCE';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QATRU_SEQ';
  l_object(l_index).object_type := 'SEQUENCE';
  l_index := l_index + 1;

  -- views
  l_object(l_index).object_name := 'QA_PREDECESSOR_ORDER_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_SCHEME_NAMES_FOR_TESTING_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_APEX_BLACKLISTED_APPS_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_APPLICATION_OWNER_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;

  l_object(l_index).object_name := 'QA_OVERVIEW_TESTS_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_OVERVIEW_QUOTA_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_OVERVIEW_TIMELINE_ERROR_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_OVERVIEW_TIMELINE_FAILURE_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_OVERVIEW_TIMELINE_SUCCESS_P0001_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_UNIT_TEST_PACKAGES_P0002_V';
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
  l_object(l_index).object_name := 'QA_RULES_P0006_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULES_P0007_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_CLIENT_NAMES_P0008_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_JOB_DETAILS_P0009_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_JOB_RUN_DETAILS_P0009_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_JOB_RUN_DETAILS_P0011_V';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULE_CATEGORIES_LOV';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULE_ERROR_LEVELS_LOV';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_RULE_LAYERS_LOV';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_EXECUTION_DATES_LOV';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;
  l_object(l_index).object_name := 'QA_TEST_SCHEME_NAMES_LOV';
  l_object(l_index).object_type := 'VIEW';
  l_index := l_index + 1;


  while l_counter < l_object.count
  loop
    if l_object(l_counter).object_type = 'TABLE'
    then
      for i in (select constraint_name
                from user_constraints
                where table_name = l_object(l_counter).object_name
                and constraint_type = 'R')
      loop
        l_action := 'alter table ' || l_object(l_counter).object_name || ' drop constraint ' || i.constraint_name;
    
        select count(1)
        into l_count
        from user_constraints s
        where constraint_name = i.constraint_name;
    
        if l_count <> 0
        then
          dbms_output.put_line(l_action);
          execute immediate (l_action);
          dbms_output.put_line('INFO: ' || i.constraint_name || ' dropped.');
        else
          dbms_output.put_line('WARNING: ' || i.constraint_name || ' does not exist.');
        end if;
    
        select count(1)
        into l_count
        from user_constraints s
        where constraint_name = i.constraint_name;
    
        if l_count <> 0
        then
          dbms_output.put_line('WARNING: ' || i.constraint_name || ' has not been dropped correctly.');
        end if;
      
      end loop;
    end if;
    
    
    l_action := 'drop ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name;
    if l_object(l_counter).object_type = 'TYPE'
      then
        -- Sortierung aller Objekt Namen kann zu dependency Errors fuehren
        l_action := l_action || ' force';
    end if;

    select count(1)
    into l_count
    from user_objects s
    where object_name = l_object(l_counter).object_name
    and object_type = l_object(l_counter).object_type;
  
    if l_count <> 0
    then
      execute immediate (l_action);
      dbms_output.put_line('INFO: ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' dropped.');
    else
      dbms_output.put_line('WARNING: ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' does not exist.');
    end if;
  
    select count(1)
    into l_count
    from user_objects s
    where object_name = l_object(l_counter).object_name
    and object_type = l_object(l_counter).object_type;
  
    if l_count <> 0
    then
      dbms_output.put_line('WARNING: ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' has not been dropped correctly.');
    end if;
    l_counter := l_counter +1;
  end loop;

exception
  when others then
    dbms_output.put_line('ERROR: ' || l_action || ' drop failed!' || substr(sqlerrm
                                                                           ,0
                                                                           ,200));
end;
/
/

PROMPT DROP SCHEDULER JOB JOB_RUN_UNIT_TESTS
DECLARE
  l_count number;
BEGIN
  select count(1)
  into l_count
  from user_scheduler_jobs
  where job_name = 'JOB_RUN_UNIT_TESTS';

  if l_count > 0
    then 
      dbms_scheduler.drop_job(job_name => 'JOB_RUN_UNIT_TESTS');
      dbms_output.put_line('Job JOB_RUN_UNIT_TESTS dropped');
  end if;

END;
/
-- Empty recyclebin because of lobs in user_objects after dropping objects with lobs
purge recyclebin;

PROMPT #########################
PROMPT  Uninstallation finished
PROMPT #########################