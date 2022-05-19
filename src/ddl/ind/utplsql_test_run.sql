PROMPT create unique index RUN_PK_I for table UTPLSQL_TEST_RUN
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_indexes
   where index_name = 'RUN_PK_I';
  if l_count = 0 then
    l_sql := 'create unique index RUN_PK_I on UTPLSQL_TEST_RUN (RUN_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'RUN_PK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index RUN_PK_I failed.');
    else
      dbms_output.put_line('Index RUN_PK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index RUN_PK_I was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Index RUN_PK_I could not been created. ' || SQLERRM);
end;
/
