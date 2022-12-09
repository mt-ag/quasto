PROMPT create table UTPLSQL_TEST_RUN
declare
  l_sql varchar2(32767) := 
'create table UTPLSQL_TEST_RUN
(
  run_id              	  NUMBER not null,
  run_start_date          DATE,
  run_end_date      	  DATE,
  run_test_result_xml     CLOB,
  run_total_tests         NUMBER,
  run_disabled_tests      NUMBER,
  run_errored_tests	  NUMBER,
  run_failed_tests	  NUMBER,
  run_duration_sec	  VARCHAR2(20 CHAR),
  run_create_date     	  DATE not null,
  run_create_user     	  VARCHAR2(255 CHAR) not null,
  run_change_date     	  DATE not null,
  run_change_user     	  VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'UTPLSQL_TEST_RUN';
  
  if l_count = 0
  then
    execute immediate l_sql;

	execute immediate q'#comment on table UTPLSQL_TEST_RUN is 'table for testruns and their results'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_id is 'primary key'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_start_date is 'beginning of test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_end_date is 'end of test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_test_result_xml is 'test results in xml'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_total_tests is 'number of total tests in this test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_disabled_tests is 'number of disabled tests in this test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_errored_tests is 'number of errored tests in this test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_failed_tests is 'number of failed tests in this test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_duration_sec is 'duration of testrun in seconds'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_create_user is 'when is the testrun entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_create_date is 'who has the testrun entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_change_user is 'when is the testrun entry updated'#';
	execute immediate q'#comment on column UTPLSQL_TEST_RUN.run_change_date is 'who has the testrun entry updated'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'UTPLSQL_TEST_RUN';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table UTPLSQL_TEST_RUN failed.');
    else
      dbms_output.put_line('INFO: Table UTPLSQL_TEST_RUN has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table UTPLSQL_TEST_RUN was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table UTPLSQL_TEST_RUN could not been created.' || SQLERRM);
end;
/
