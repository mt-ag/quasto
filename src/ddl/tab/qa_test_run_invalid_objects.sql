PROMPT create table QA_TEST_RUN_INVALID_OBJECTS
declare
  l_sql varchar2(32767) := 
'create table QA_TEST_RUN_INVALID_OBJECTS
(
  QATO_ID              NUMBER not null,
  QATO_OBJECT_NAME     VARCHAR2(4000 CHAR) not null,
  QATO_OBJECT_DETAILS  VARCHAR2(4000 CHAR) not null,
  QATO_QATR_ID	       NUMBER not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'QA_TEST_RUN_INVALID_OBJECTS';
  
  if l_count = 0
  then
    execute immediate l_sql;

	  execute immediate q'#comment on table QA_TEST_RUN_INVALID_OBJECTS is 'table for the invalid objects of test runs'#';
	  execute immediate q'#comment on column QA_TEST_RUN_INVALID_OBJECTS.QATO_ID is 'pk column'#';
	  execute immediate q'#comment on column QA_TEST_RUN_INVALID_OBJECTS.QATO_OBJECT_NAME is 'name of the invalid object'#';
	  execute immediate q'#comment on column QA_TEST_RUN_INVALID_OBJECTS.QATO_OBJECT_DETAILS is 'details about the object'#';
	  execute immediate q'#comment on column QA_TEST_RUN_INVALID_OBJECTS.QATO_QATR_ID is 'foreign key column to QA_TEST_RUNS.QATR_ID'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'QA_TEST_RUN_INVALID_OBJECTS';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table QA_TEST_RUN_INVALID_OBJECTS failed.');
    else
      dbms_output.put_line('INFO: Table QA_TEST_RUN_INVALID_OBJECTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table QA_TEST_RUN_INVALID_OBJECTS was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table QA_TEST_RUN_INVALID_OBJECTS could not been created.' || SQLERRM);
end;
/
