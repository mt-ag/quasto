PROMPT drop TABLE QA_RULES...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'TABLE'
  and object_name = 'QA_RULES';
  if l_count > 0
  then
    l_action := 'drop table QA_RULES';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop table QA_RULES wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop TABLE QA_RULES wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'TABLE'
  and object_name = 'QA_RULES';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop TABLE QA_RULES ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop table QA_RULES fehlgeschlagen.' || substr(sqlerrm
                                                                               ,1
                                                                               ,400));
end;
/

PROMPT drop SEQUENCE QARU_SEQ...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'SEQUENCE'
  and object_name = 'QARU_SEQ';
  if l_count > 0
  then
    l_action := 'drop sequence QARU_SEQ';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop sequence QARU_SEQ wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop SEQUENCE QARU_SEQ wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'SEQUENCE'
  and object_name = 'QARU_SEQ';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop SEQUENCE QARU_SEQ ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop sequence QARU_SEQ fehlgeschlagen.' || substr(sqlerrm
                                                                                  ,1
                                                                                  ,400));
end;
/