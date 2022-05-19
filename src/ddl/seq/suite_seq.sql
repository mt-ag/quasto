PROMPT create sequence SUITE_SEQ for table UTPLSQL_TEST_SUITE
declare 
  l_count number;
begin

  select count(1)
    into l_count
    from user_sequences
   where sequence_name = 'SUITE_SEQ';

  if l_count = 0
  then
    execute immediate 'create sequence SUITE_SEQ start with 1 increment by 1 minvalue 1 maxvalue 9999999999999999999999999999 nocycle noorder nocache';

    select count(1)
      into l_count
      from user_objects
     where object_name = 'SUITE_SEQ';

    if l_count = 0
    then
      dbms_output.put_line('Creation of sequence SUITE_SEQ failed.');
    else
      dbms_output.put_line('Sequence SUITE_SEQ has been created.');
    end if;
  else
    dbms_output.put_line('Sequence SUITE_SEQ was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('Sequence SUITE_SEQ could not been created.' || SQLERRM);
end;
/
