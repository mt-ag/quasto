PROMPT create constraints QATR_PK and QATR_CHK_ADDED_ON for table QA_TEST_RESULTS
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATR_PK';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RESULTS add constraint QATR_PK primary key (QATR_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATR_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QATR_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint QATR_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QATR_PK was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATR_CHK_ADDED_ON';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RESULTS add constraint QATR_CHK_ADDED_ON UNIQUE (QATR_CHK_ADDED_ON)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATR_CHK_ADDED_ON';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of unique constraint QATR_CHK_ADDED_ON failed.');
    else
      dbms_output.put_line('INFO: Unique constraint QATR_CHK_ADDED_ON has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Unique constraint QATR_CHK_ADDED_ON was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraints could not been created. ' || SQLERRM);
end;
/
