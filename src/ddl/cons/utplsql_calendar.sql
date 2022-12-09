PROMPT create constraint CLDR_PK for table UTPLSQL_CALENDAR
declare
  l_count number;
  l_sql   varchar2(32767);
begin
  select count(1)
    into l_count
    from user_constraints
   where constraint_name = 'CLDR_PK';
  if l_count = 0 then
    l_sql := 'alter table UTPLSQL_CALENDAR add constraint CLDR_PK primary key (CLDR_ID)';
    execute immediate l_sql;
    select count(1)
      into l_count
      from user_constraints 
     where constraint_name = 'CLDR_PK';
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of constraint CLDR_PK failed.');
    else
      dbms_output.put_line('INFO: Constraint CLDR_PK has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Constraint CLDR_PK was already created.');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Constraint CLDR_PK could not been created. ' || SQLERRM);
end;
/
