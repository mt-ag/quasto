PROMPT create sequence RUN_SEQ for table UTPLSQL_TEST_RUN
declare
  l_count number;
begin

  select count(1)
    into l_count
    from user_sequences
   where sequence_name = 'RUN_SEQ';

  if l_count = 0
  then
    execute immediate 'create sequence RUN_SEQ start with 1 increment by 1 minvalue 1 maxvalue 9999999999999999999999999999 nocycle noorder nocache';

    select count(1)
      into l_count
      from user_objects
     where object_name = 'RUN_SEQ';

    if l_count = 0
    then
      dbms_output.put_line('Creation of sequence RUN_SEQ failed.');
    else
      dbms_output.put_line('Sequence RUN_SEQ has been created.');
    end if;
  else
    dbms_output.put_line('Sequence RUN_SEQ was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('Sequence RUN_SEQ could not been created.' || SQLERRM);
end;
/
