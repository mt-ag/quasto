PROMPT create constraints QATRU_PK and QATR_QARU_ID_FK for table QA_TEST_RUNS
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATRU_PK';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RUNS add constraint QATRU_PK primary key (QATR_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATRU_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QATRU_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint QATRU_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QATRU_PK was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATR_QARU_ID_FK';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RUNS add constraint QATR_QARU_ID_FK foreign key (QATR_QARU_ID) REFERENCES QA_RULES (QARU_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATR_QARU_ID_FK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of fk constraint QATR_QARU_ID_FK failed.');
    else
      dbms_output.put_line('INFO: Fk constraint QATR_QARU_ID_FK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Fk constraint QATR_QARU_ID_FK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraints could not been created. ' || SQLERRM);
end;
/
