PROMPT drop FUNCTION FC_EXPORT_QA_RULES...

declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'FUNCTION'
  and object_name = 'FC_EXPORT_QA_RULES';
  if l_count > 0
  then
    l_action := 'drop function FC_EXPORT_QA_RULES';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop function FC_EXPORT_QA_RULES wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop FUNCTION FC_EXPORT_QA_RULES wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'FUNCTION'
  and object_name = 'FC_EXPORT_QA_RULES';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop FUNCTION FC_EXPORT_QA_RULES ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop function FC_EXPORT_QA_RULES fehlgeschlagen.' || substr(sqlerrm
                                                                                            ,1
                                                                                            ,400));
end;
/
