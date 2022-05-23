PROMPT drop PKG QA_PKG...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'QA_PKG';
  if l_count > 0
  then
    l_action := 'drop package QA_PKG';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop PACKAGE QA_PKG wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop PACKAGE QA_PKG wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'QA_PKG';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop PACKAGE QA_PKG ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop PACKAGE QA_PKG fehlgeschlagen.' || substr(sqlerrm
                                                                                ,1
                                                                                ,400));
end;
/
