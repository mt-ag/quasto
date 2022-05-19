PROMPT create constraint SUITE_RUN_FK for table UTPLSQL_TEST_SUITE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'SUITE_RUN_FK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_TEST_SUITE add constraint SUITE_RUN_FK foreign key (SUITE_RUN_ID) references UTPLSQL_TEST_RUN (RUN_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'SUITE_RUN_FK';
    if l_count = 0 then
      dbms_output.put_line('Creation of constraint SUITE_RUN_FK failed.');
    else
      dbms_output.put_line('Constraint SUITE_RUN_FK has been created.');
    end if;
  else
    dbms_output.put_line('Constraint SUITE_RUN_FK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Constraint SUITE_RUN_FK could not been created. ' || SQLERRM);
end;
/
