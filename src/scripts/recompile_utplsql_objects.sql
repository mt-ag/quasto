PROMPT Recompile UTPLSQL Objects
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
  -- utPLSQL Objects

  -- Types:
  l_object_name('QA_SCHEME_OBJECT_AMOUNT_T') := 'QA_SCHEME_OBJECT_AMOUNT_T';
  l_object_type('QA_SCHEME_OBJECT_AMOUNT_T') := 'TYPE';
  l_object_name('QA_SCHEME_OBJECT_AMOUNTS_T') := 'QA_SCHEME_OBJECT_AMOUNTS_T';
  l_object_type('QA_SCHEME_OBJECT_AMOUNTS_T') := 'TYPE';

  -- Packages:
  l_object_name('QA_UNIT_TESTS_PKG') := 'QA_UNIT_TESTS_PKG';
  l_object_type('QA_UNIT_TESTS_PKG') := 'PACKAGE';

  -- Triggers:
  l_object_name('QATR_I_TRG') := 'QATR_I_TRG';
  l_object_type('QATR_I_TRG') := 'TRIGGER';

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
        dbms_output.put_line('ERROR: The object ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' is invalid.');
    else
        dbms_output.put_line('INFO: ' || l_object_type(l_object) || ' ' || l_object_name(l_object) || ' recompiled.');
    end if;

    l_object := l_object_name.next(l_object);
  end loop;
    exception
      when others
        then
          dbms_output.put_line('ERROR: There are ' || l_count || ' invalid utPLSQL objects.');
          dbms_output.put_line(SQLERRM);
          raise;
end;
/