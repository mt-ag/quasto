PROMPT create constraint CASE_PK for table UTPLSQL_TEST_CASE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'CASE_PK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_TEST_CASE add constraint CASE_PK primary key (CASE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'CASE_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint CASE_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint CASE_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint CASE_PK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraint CASE_PK could not been created. ' || SQLERRM);
end;
/
