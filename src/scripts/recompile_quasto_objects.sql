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
  
  -- packages
  l_object_name('QA_MAIN_PKG') := 'QA_MAIN_PKG';
  l_object_type('QA_MAIN_PKG') := 'PACKAGE';
  l_object_name('QA_API_PKG') := 'QA_API_PKG';
  l_object_type('QA_API_PKG') := 'PACKAGE';
  l_object_name('QA_EXPORT_IMPORT_RULES_PKG') := 'QA_EXPORT_IMPORT_RULES_PKG';
  l_object_type('QA_EXPORT_IMPORT_RULES_PKG') := 'PACKAGE';
  --trigger
  l_object_name('QARU_IU_TRG') := 'QARU_IU_TRG';
  l_object_type('QARU_IU_TRG') := 'TRIGGER';

  l_object := l_object_name.first;
  while l_object is not null
  loop
    l_action_2 := null;
    if l_object_type(l_object) = 'PACKAGE'
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
        dbms_output.put_line('ERROR: The object ' || l_object_name(l_object) || l_object_type(l_object)  || 'is invalid');
    else
        dbms_output.put_line('INFO: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' recompiled.');
    end if;

    l_object := l_object_name.next(l_object);
  end loop;
    exception
      when others
        then
          dbms_output.put_line('ERROR: There are ' || l_count || 'Invalid Quasto objects');
          raise;
end;
/