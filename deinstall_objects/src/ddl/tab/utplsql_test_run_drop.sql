PROMPT drop TABLE UTPLSQL_TEST_RUN...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'TABLE'
  and object_name = 'UTPLSQL_TEST_RUN';
  if l_count > 0
  then
    l_action := 'drop table UTPLSQL_TEST_RUN';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop table UTPLSQL_TEST_RUN wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop TABLE UTPLSQL_TEST_RUN wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'TABLE'
  and object_name = 'UTPLSQL_TEST_RUN';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop TABLE UTPLSQL_TEST_RUN ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop table UTPLSQL_TEST_RUN fehlgeschlagen.' || substr(sqlerrm
                                                                                       ,1
                                                                                       ,400));
end;
/

PROMPT drop SEQUENCE RUN_SEQ...
declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'SEQUENCE'
  and object_name = 'RUN_SEQ';
  if l_count > 0
  then
    l_action := 'drop sequence RUN_SEQ';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop sequence RUN_SEQ wurde erfolgreich ausgefuehrt.');
  else
    dbms_output.put_line('WARNING: drop SEQUENCE RUN_SEQ wurde schon ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'SEQUENCE'
  and object_name = 'RUN_SEQ';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop SEQUENCE RUN_SEQ ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop sequence RUN_SEQ fehlgeschlagen.' || substr(sqlerrm
                                                                                 ,1
                                                                                 ,400));
end;
/