PROMPT create table QA_TEST_RUNS
declare
  l_sql varchar2(32767) := 
'create table QA_TEST_RUNS
(
  QATR_ID              NUMBER not null,
  QATR_SCHEME_NAME     VARCHAR2(255 CHAR) not null,
  QATR_DATE            DATE not null,
  QATR_RESULT	         NUMBER not null,
  QATR_QARU_ID         NUMBER not null,
  QATR_ADDED_BY        VARCHAR2(255 CHAR) not null,
  QATR_RUNTIME_ERROR   VARCHAR2(4000 CHAR),
  QATR_PROGRAM_NAME    VARCHAR2(4000 CHAR)
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'QA_TEST_RUNS';
  
  if l_count = 0
  then
    execute immediate l_sql;

	  execute immediate q'#comment on table QA_TEST_RUNS is 'table for the invalid objects of test runs'#';
	  execute immediate q'#comment on column QA_TEST_RUNS.QATR_ID is 'pk column'#';
	  execute immediate q'#comment on column QA_TEST_RUNS.QATR_SCHEME_NAME is 'name of the scheme for which the test has run'#';
	  execute immediate q'#comment on column QA_TEST_RUNS.QATR_DATE is 'when is the test run added'#';
	  execute immediate q'#comment on column QA_TEST_RUNS.QATR_RESULT is 'result of the test run'#';
    execute immediate q'#comment on column QA_TEST_RUNS.QATR_QARU_ID is 'foreign key column to QA_RULES.QARU_ID'#';
    execute immediate q'#comment on column QA_TEST_RUNS.QATR_ADDED_BY is 'who has the test run added'#';
    execute immediate q'#comment on column QA_TEST_RUNS.QATR_RUNTIME_ERROR is 'runtime error backtrace information'#';
    execute immediate q'#comment on column QA_TEST_RUNS.QATR_PROGRAM_NAME is 'name of the unit test procedure'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'QA_TEST_RUNS';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table QA_TEST_RUNS failed.');
    else
      dbms_output.put_line('INFO: Table QA_TEST_RUNS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table QA_TEST_RUNS was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table QA_TEST_RUNS could not been created.' || SQLERRM);
end;
/
