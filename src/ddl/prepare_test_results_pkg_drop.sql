PROMPT drop PACKAGE PREPARE_TEST_RESULTS_PKG...

declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'PREPARE_TEST_RESULTS_PKG';
  if l_count > 0
  then
    l_action := 'drop package PREPARE_TEST_RESULTS_PKG';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop package PREPARE_TEST_RESULTS_PKG wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop PACKAGE PREPARE_TEST_RESULTS_PKG wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'PREPARE_TEST_RESULTS_PKG';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop PACKAGE PREPARE_TEST_RESULTS_PKG ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop package PREPARE_TEST_RESULTS_PKG fehlgeschlagen.' || substr(sqlerrm
                                                                                                 ,1
                                                                                                 ,400));
end;
/
