PROMPT create constraint SUITE_PK for table UTPLSQL_TEST_SUITE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'SUITE_PK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_TEST_SUITE add constraint SUITE_PK primary key (SUITE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'SUITE_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint SUITE_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint SUITE_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint SUITE_PK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraint SUITE_PK could not been created. ' || SQLERRM);
end;
/
