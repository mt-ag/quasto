PROMPT drop TYPE VARCHAR2_TAB_T...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'TYPE'
  and object_name = 'VARCHAR2_TAB_T';
  if l_count > 0
  then
    l_action := 'drop type VARCHAR2_TAB_T';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop type VARCHAR2_TAB_T wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop TYPE VARCHAR2_TAB_T wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'TYPE'
  and object_name = 'VARCHAR2_TAB_T';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop TYPE VARCHAR2_TAB_T ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop type VARCHAR2_TAB_T fehlgeschlagen.' || substr(sqlerrm
                                                                                    ,1
                                                                                    ,400));
end;
/
