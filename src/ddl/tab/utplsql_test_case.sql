PROMPT create table UTPLSQL_TEST_CASE
declare
  l_sql varchar2(32767) := 
'create table UTPLSQL_TEST_CASE
(
  case_id              	  NUMBER not null,
  case_suite_id        	  NUMBER,
  case_testcase_path      VARCHAR2(255 CHAR),
  case_testcase_name      VARCHAR2(255 CHAR),
  case_test_status        VARCHAR2(20 CHAR),
  case_assertions      	  NUMBER,
  case_duration_sec	  VARCHAR2(20 CHAR),
  case_executed_on	  DATE,
  case_error_statement	  VARCHAR2(4000 CHAR),
  case_failure_statement  VARCHAR2(4000 CHAR),
  case_system_out	  VARCHAR2(4000 CHAR),
  case_system_err	  VARCHAR2(4000 CHAR),
  case_schema		  VARCHAR2(50 CHAR),
  case_create_date     	  DATE not null,
  case_create_user     	  VARCHAR2(255 CHAR) not null,
  case_change_date     	  DATE not null,
  case_change_user     	  VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'UTPLSQL_TEST_CASE';
  
  if l_count = 0
  then
    execute immediate l_sql;

	execute immediate q'#comment on table UTPLSQL_TEST_CASE is 'table for specific testcases and their results'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_id is 'primary key'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_suite_id is 'foreign key on utplsql_test_suite'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_testcase_path is 'path/Package of the testcase'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_testcase_name is 'name of the testcase'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_test_status is 'status of this testrun'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_assertions is 'assertions of testcase'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_duration_sec is 'duration of testcase run in seconds'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_executed_on is 'date of testcase run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_error_statement is 'comments when testcase has an error'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_failure_statement is 'comments when testcase has a failure'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_system_out is 'system output of testcase run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_system_err is 'error output of testcase run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_schema is 'schema for which the testcase was run'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_create_user is 'when is the case entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_create_date is 'who has the case entry created'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_change_user is 'when is the case entry updated'#';
	execute immediate q'#comment on column UTPLSQL_TEST_CASE.case_change_date is 'who has the case entry updated'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'UTPLSQL_TEST_CASE';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of table UTPLSQL_TEST_CASE failed.');
    else
      dbms_output.put_line('Table UTPLSQL_TEST_CASE has been created.');
    end if;
  else
    dbms_output.put_line('Table UTPLSQL_TEST_CASE was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('Table UTPLSQL_TEST_CASE could not been created.' || SQLERRM);
end;
/
