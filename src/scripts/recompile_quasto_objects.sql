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
  l_object_name('QARU_SCHEME_NAMES_FOR_TESTING_V') := 'QARU_SCHEME_NAMES_FOR_TESTING_V';
  l_object_type('QARU_SCHEME_NAMES_FOR_TESTING_V') := 'VIEW';

  if qa_constant_pkg.gc_apex_flag = 1
    then
      l_object_name('QARU_APEX_BLACKLISTED_APPS_V') := 'QARU_APEX_BLACKLISTED_APPS_V';
      l_object_type('QARU_APEX_BLACKLISTED_APPS_V') := 'VIEW';
  end if;

  l_object_name('QARU_PREDECESSOR_ORDER_V') := 'QARU_PREDECESSOR_ORDER_V';
  l_object_type('QARU_PREDECESSOR_ORDER_V') := 'VIEW';

  -- Types:
  l_object_name('QA_RULE_T') := 'QA_RULE_T';
  l_object_type('QA_RULE_T') := 'TYPE';
  l_object_name('QA_RULES_T') := 'QA_RULES_T';
  l_object_type('QA_RULES_T') := 'TYPE';
  l_object_name('RUNNING_RULE_T') := 'RUNNING_RULE_T';
  l_object_type('RUNNING_RULE_T') := 'TYPE';
  l_object_name('RUNNING_RULES_T') := 'RUNNING_RULES_T';
  l_object_type('RUNNING_RULES_T') := 'TYPE';

  l_object_name('VARCHAR2_TAB_T') := 'VARCHAR2_TAB_T';
  l_object_type('VARCHAR2_TAB_T') := 'TYPE';
  
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
 
  --trigger
  l_object_name('QARU_IU_TRG') := 'QARU_IU_TRG';
  l_object_type('QARU_IU_TRG') := 'TRIGGER';

  l_object := l_object_name.first;
  while l_object is not null
  loop
    l_action_2 := null;
    if l_object_type(l_object) = 'PACKAGE' and l_object_name(l_object) != 'QA_CONSTANT_PKG'
      then
        l_action   := 'alter package ' || l_object_name(l_object) || ' compile';
        l_action_2 := 'alter package ' || l_object_name(l_object) || ' compile body';
    else
        l_action   := 'alter ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' compile';
    end if;
  
      execute immediate (l_action);
      if l_action_2 is not null
        then
          execute immediate (l_action_2);
      end if;
    select count(*)
    into l_count
    from user_objects uo
    where uo.status = 'INVALID'
    and uo.object_name = l_object_name(l_object);
    
    if l_count <> 0
      then
        dbms_output.put_line('ERROR: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' is invalid.');
    else
        dbms_output.put_line('INFO: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' recompiled.');
    end if;

    l_object := l_object_name.next(l_object);
  end loop;
    exception
      when others
        then
          dbms_output.put_line('ERROR: There are ' || l_count || ' invalid QUASTO objects.');
          dbms_output.put_line(SQLERRM);
          raise;
end;
/