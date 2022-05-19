PROMPT create constraint RUN_PK for table UTPLSQL_TEST_RUN
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'RUN_PK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_TEST_RUN add constraint RUN_PK primary key (RUN_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'RUN_PK';
    if l_count = 0 then
      dbms_output.put_line('Creation of constraint RUN_PK failed.');
    else
      dbms_output.put_line('Constraint RUN_PK has been created.');
    end if;
  else
    dbms_output.put_line('Constraint RUN_PK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Constraint RUN_PK could not been created. ' || SQLERRM);
end;
/
