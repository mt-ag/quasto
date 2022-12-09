PROMPT create indices SUITE_PK_I and SUITE_RUN_FK_I for table UTPLSQL_TEST_SUITE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_indexes
   where index_name = 'SUITE_PK_I';
  if l_count = 0 then
    l_sql := 'create unique index SUITE_PK_I on UTPLSQL_TEST_SUITE (SUITE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'SUITE_PK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of index SUITE_PK_I failed.');
    else
      dbms_output.put_line('INFO: Index SUITE_PK_I has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Index SUITE_PK_I was already created.');
  end if;

  select count(1)
    into l_count
    from user_indexes
   where index_name = 'SUITE_RUN_FK_I';
  if l_count = 0 then
    l_sql := 'create index SUITE_RUN_FK_I on UTPLSQL_TEST_SUITE (SUITE_RUN_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'SUITE_RUN_FK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of index SUITE_RUN_FK_I failed.');
    else
      dbms_output.put_line('INFO: Index SUITE_RUN_FK_I has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Index SUITE_RUN_FK_I was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Indices could not been created. ' || SQLERRM);
end;
/
