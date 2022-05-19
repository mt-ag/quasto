PROMPT create constraint CASE_SUITE_FK for table UTPLSQL_TEST_CASE
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'CASE_SUITE_FK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_TEST_CASE add constraint CASE_SUITE_FK foreign key (CASE_SUITE_ID) references UTPLSQL_TEST_SUITE (SUITE_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'CASE_SUITE_FK';
    if l_count = 0 then
      dbms_output.put_line('Creation of constraint CASE_SUITE_FK failed.');
    else
      dbms_output.put_line('Constraint CASE_SUITE_FK has been created.');
    end if;
  else
    dbms_output.put_line('Constraint CASE_SUITE_FK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Constraint CASE_SUITE_FK could not been created. ' || SQLERRM);
end;
/
