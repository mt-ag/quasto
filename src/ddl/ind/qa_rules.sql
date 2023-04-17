PROMPT create indices for table QA_RULES
declare
  l_name  varchar2(100);
  l_count number;
  l_sql   varchar2(32767);
begin
  l_name := 'QARU_PK_I';
  select count(1)
  into l_count
  from user_indexes
  where index_name = l_name;

  if l_count = 0
  then
    l_sql := 'create unique index ' || l_name || ' on QA_RULES (QARU_ID)';
    execute immediate l_sql;
  
    select count(1)
    into l_count
    from user_indexes
    where index_name = l_name;
  
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of index ' || l_name || ' failed.');
    else
      dbms_output.put_line('INFO: Index ' || l_name || ' has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Index ' || l_name || ' was already created.');
  end if;

  -- ################################

  l_name := 'QARU_RULE_UNIQUE_I';
  select count(1)
  into l_count
  from user_indexes
  where index_name = l_name;
  
  if l_count = 0
  then
    l_sql := 'create unique index ' || l_name || ' on QA_RULES (QARU_RULE_NUMBER, QARU_CLIENT_NAME)';
    execute immediate l_sql;
  
    select count(1)
    into l_count
    from user_indexes
    where index_name = l_name;
  
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of index ' || l_name || ' failed.');
    else
      dbms_output.put_line('INFO: Index ' || l_name || ' has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Index ' || l_name || ' was already created.');
  end if;

  -- ################################

  l_name := 'QARU_NAME_UNIQUE_I';
  select count(1)
  into l_count
  from user_indexes
  where index_name = l_name;
  
  if l_count = 0
  then
    l_sql := 'create unique index ' || l_name || ' on QA_RULES (QARU_NAME, QARU_CLIENT_NAME)';
    execute immediate l_sql;
    
    select count(1)
    into l_count
    from user_indexes
    where index_name = l_name;
    
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of index ' || l_name || ' failed.');
    else
      dbms_output.put_line('INFO: Index ' || l_name || ' has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Index ' || l_name || ' was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Indices could not been created. ' || sqlerrm);
end;
/
