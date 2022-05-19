PROMPT create indices CASE_PK_I and CASE_SUITE_FK_I for table UTPLSQL_TEST_CASE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_indexes
   where index_name = 'CASE_PK_I';
  if l_count = 0 then
    l_sql := 'create unique index CASE_PK_I on UTPLSQL_TEST_CASE (CASE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'CASE_PK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index CASE_PK_I failed.');
    else
      dbms_output.put_line('Index CASE_PK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index CASE_PK_I was already created.');
  end if;

  select count(1)
    into l_count
    from user_indexes
   where index_name = 'CASE_SUITE_FK_I';
  if l_count = 0 then
    l_sql := 'create index CASE_SUITE_FK_I on UTPLSQL_TEST_CASE (CASE_SUITE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'CASE_SUITE_FK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index CASE_SUITE_FK_I failed.');
    else
      dbms_output.put_line('Index CASE_SUITE_FK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index CASE_SUITE_FK_I was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Indices could not been created. ' || SQLERRM);
end;
/
