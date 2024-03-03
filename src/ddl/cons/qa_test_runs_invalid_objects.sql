PROMPT create constraints QATO_PK and QATO_QATR_ID_FK for table QA_TEST_RUN_INVALID_OBJECTS
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATO_PK';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RUN_INVALID_OBJECTS add constraint QATO_PK primary key (QATO_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATO_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QATO_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint QATO_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QATO_PK was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QATO_QATR_ID_FK';
  if l_count = 0 then
    l_sql := 'alter table QA_TEST_RUN_INVALID_OBJECTS add constraint QATO_QATR_ID_FK foreign key (QATO_QATR_ID) REFERENCES QA_TEST_RUNS (QATR_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QATO_QATR_ID_FK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of fk constraint QATO_QATR_ID_FK failed.');
    else
      dbms_output.put_line('INFO: Fk constraint QATO_QATR_ID_FK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Fk constraint QATO_QATR_ID_FK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraints could not been created. ' || SQLERRM);
end;
/
