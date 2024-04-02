Prompt Recomile UTPLSQL Objects
set serveroutput on;
declare
  type t_object_rec is record (
    object_name varchar2(1000 char),
    object_type varchar2(1000 char)
  );
  type t_object_table is table of t_object_rec index by pls_integer;
  
  l_object      t_object_table;
  l_counter     number := 1;
  l_index       number := 1;
  l_action      varchar2(32767);
  l_action_2    varchar2(32767);
begin
  -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);
  -- utPLSQL Objects
    -- Packages
    l_object(l_index).object_name := 'QA_UNIT_TESTS_PKG';
    l_object(l_index).object_type := 'PACKAGE';
    l_index := l_index + 1;
    
    -- Triggers
    l_object(l_index).object_name := 'QATR_I_TRG';
    l_object(l_index).object_type := 'TRIGGER';
    l_index := l_index + 1;
    
    l_object(l_index).object_name := 'QATO_I_TRG';
    l_object(l_index).object_type := 'TRIGGER';
    l_index := l_index + 1;
    
    l_object(l_index).object_name := 'QATRU_I_TRG';
    l_object(l_index).object_type := 'TRIGGER';
    l_index := l_index + 1;


  while l_counter < l_object.COUNT
  loop
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
      l_counter := l_counter +1;      
    exception
      when others then
        dbms_output.put_line('ERROR: The object ' || l_object(l_counter).object_type || ' ' || l_object(l_counter).object_name || ' is invalid.');
        l_counter := l_counter +1;
    end;
  end loop;
exception
  when others then
    dbms_output.put_line('ERROR: There has been an unexpected Error!');
    raise;
end;
/