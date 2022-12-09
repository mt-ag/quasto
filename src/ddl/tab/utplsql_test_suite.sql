PROMPT create table UTPLSQL_TEST_SUITE
declare
  l_sql varchar2(32767) := 
'create table UTPLSQL_TEST_SUITE
(
  suite_id                NUMBER not null,
  suite_run_id            NUMBER,
  suite_package_path      VARCHAR2(100 CHAR),
  suite_testsuite_name    VARCHAR2(255 CHAR),
  suite_testsuite_id      NUMBER,
  suite_total_tests       NUMBER,
  suite_disabled_tests	  NUMBER,
  suite_errored_tests	  NUMBER,
  suite_failed_tests	  NUMBER,
  suite_duration_sec	  VARCHAR2(20 CHAR),
  suite_system_out	  VARCHAR2(4000 CHAR),
  suite_system_err	  VARCHAR2(4000 CHAR),
  suite_tsu_id	  	  NUMBER,
  suite_schema	  	  VARCHAR2(50 CHAR),
  suite_create_date       DATE not null,
  suite_create_user       VARCHAR2(255 CHAR) not null,
  suite_change_date       DATE not null,
  suite_change_user       VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'UTPLSQL_TEST_SUITE';
  
  if l_count = 0
  then
    execute immediate l_sql;

	execute immediate q'#comment on table UTPLSQL_TEST_SUITE is 'table for test suite results'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_id is 'primary key'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_run_id is 'foreign key on utplsql_test_run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_package_path is 'package name of the test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_testsuite_name is 'name of test suite/package name'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_testsuite_id is 'id of the testsuite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_total_tests is 'number of total tests in this test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_disabled_tests is 'number of disabled tests in this test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_errored_tests is 'number of errored tests in this test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_failed_tests is 'number of failed tests in this test run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_duration_sec is 'duration in Seconds this test suite runs'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_system_out is 'system output of this test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_system_err is 'error output of this test suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_tsu_id is 'tsu id'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_schema is 'schema this test suite belongs to'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_create_date is 'when is the suite entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_create_user is 'who has the suite entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_change_date is 'when is the suite entry updated'#';
	execute immediate q'#comment on column UTPLSQL_TEST_SUITE.suite_change_user is 'who has the suite entry updated'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'UTPLSQL_TEST_SUITE';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table UTPLSQL_TEST_SUITE failed.');
    else
      dbms_output.put_line('INFO: Table UTPLSQL_TEST_SUITE has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table UTPLSQL_TEST_SUITE was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table UTPLSQL_TEST_SUITE could not be created.' || SQLERRM);
end;
/
