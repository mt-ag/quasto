PROMPT create indices QARU_PK_I, QARU_RULE_NUMBER_UK_I and QARU_NAME_UK_I for table QA_RULES
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_indexes
   where index_name = 'QARU_PK_I';
  if l_count = 0 then
    l_sql := 'create unique index QARU_PK_I on QA_RULES (QARU_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'QARU_PK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index QARU_PK_I failed.');
    else
      dbms_output.put_line('Index QARU_PK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index QARU_PK_I was already created.');
  end if;

  select count(1)
    into l_count
    from user_indexes
   where index_name = 'QARU_RULE_NUMBER_UK_I';
  if l_count = 0 then
    l_sql := 'create unique index QARU_RULE_NUMBER_UK_I on QA_RULES (QARU_RULE_NUMBER)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'QARU_RULE_NUMBER_UK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index QARU_RULE_NUMBER_UK_I failed.');
    else
      dbms_output.put_line('Index QARU_RULE_NUMBER_UK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index QARU_RULE_NUMBER_UK_I was already created.');
  end if;

  select count(1)
    into l_count
    from user_indexes
   where index_name = 'QARU_NAME_UK_I';
  if l_count = 0 then
    l_sql := 'create unique index QARU_NAME_UK_I on QA_RULES (QARU_NAME)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_indexes
     where index_name = 'QARU_NAME_UK_I';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of index QARU_NAME_UK_I failed.');
    else
      dbms_output.put_line('Index QARU_NAME_UK_I has been created.');
    end if;
  else
    dbms_output.put_line('Index QARU_NAME_UK_I was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('Indices could not been created. ' || SQLERRM);
end;
/
