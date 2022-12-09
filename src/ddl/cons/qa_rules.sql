PROMPT create constraints QARU_PK, QARU_RULE_NUMBER_UK, QARU_NAME_UK, QARU_CHK_CATEGORY, QARU_CHK_ERROR_LEVEL, QARU_CHK_IS_ACTIVE, QARU_CHK_SQL and QARU_CHK_LAYER for table QA_RULES
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_PK';
  if l_count = 0 then
    l_sql := 'alter table QA_RULES add constraint QARU_PK primary key (QARU_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_PK';
    if l_count = 0 then
      dbms_output.put_line('Creation of constraint QARU_PK failed.');
    else
      dbms_output.put_line('Constraint QARU_PK has been created.');
    end if;
  else
    dbms_output.put_line('Constraint QARU_PK was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_CHK_CATEGORY';
  if l_count = 0 then
    l_sql := q'#alter table QA_RULES add constraint QARU_CHK_CATEGORY check (QARU_CATEGORY in ('APEX','DDL','DATA'))#';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_CHK_CATEGORY';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QARU_CHK_CATEGORY failed.');
    else
      dbms_output.put_line('INFO: Constraint QARU_CHK_CATEGORY has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QARU_CHK_CATEGORY was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_CHK_ERROR_LEVEL';
  if l_count = 0 then
    l_sql := 'alter table QA_RULES add constraint QARU_CHK_ERROR_LEVEL check (QARU_ERROR_LEVEL in (1,2,4))';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_CHK_ERROR_LEVEL';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QARU_CHK_ERROR_LEVEL failed.');
    else
      dbms_output.put_line('INFO: Constraint QARU_CHK_ERROR_LEVEL has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QARU_CHK_ERROR_LEVEL was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_CHK_IS_ACTIVE';
  if l_count = 0 then
    l_sql := 'alter table QA_RULES add constraint QARU_CHK_IS_ACTIVE check (QARU_IS_ACTIVE in (0,1))';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_CHK_IS_ACTIVE';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QARU_CHK_IS_ACTIVE failed.');
    else
      dbms_output.put_line('INFO: Constraint QARU_CHK_IS_ACTIVE has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QARU_CHK_IS_ACTIVE was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_CHK_SQL';
  if l_count = 0 then
    l_sql := 'alter table QA_RULES add constraint QARU_CHK_SQL check (length(QARU_SQL) <= 32767)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_CHK_SQL';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QARU_CHK_SQL failed.');
    else
      dbms_output.put_line('INFO: Constraint QARU_CHK_SQL has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QARU_CHK_SQL was already created.');
  end if;

  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'QARU_CHK_LAYER';
  if l_count = 0 then
    l_sql := q'#alter table QA_RULES add constraint QARU_CHK_LAYER check (QARU_LAYER in ('PAGE','APPLICATION','DATABASE'))#';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'QARU_CHK_LAYER';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint QARU_CHK_LAYER failed.');
    else
      dbms_output.put_line('INFO: Constraint QARU_CHK_LAYER has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint QARU_CHK_LAYER was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraints could not been created. ' || SQLERRM);
end;
/
