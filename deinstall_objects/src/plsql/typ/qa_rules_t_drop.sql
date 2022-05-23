PROMPT drop TYPE QA_RULES_T...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'TYPE'
  and object_name = 'QA_RULES_T';
  if l_count > 0
  then
    l_action := 'drop type QA_RULES_T';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop type QA_RULES_T wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop TYPE QA_RULES_T wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'TYPE'
  and object_name = 'QA_RULES_T';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop TYPE QA_RULES_T ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop type QA_RULES_T fehlgeschlagen.' || substr(sqlerrm
                                                                                ,1
                                                                                ,400));
end;
/