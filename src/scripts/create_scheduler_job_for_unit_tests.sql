PROMPT Create Scheduler Job JOB_RUN_UNIT_TESTS
/*
-- Temporaer ausgeklammert da skripte nicht lauff�hig sind
Unten Sheduler Job zum anlegen da fehlen aber dem Quasto Schema create Rechte fuer Scheduler
declare
  l_sql varchar2(32767) := 
'dbms_scheduler.create_job('"JOB_RUN_UNIT_TESTS"',
program_name=>'"PROG_RUN_UNIT_TESTS"',
schedule_name=>'"RUN_UNIT_TESTS_DAILY_0100"',
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
''Job runs unit test packages and saves xml result into table QA_TEST_RESULTS''
);
sys.dbms_scheduler.set_attribute('"JOB_RUN_UNIT_TESTS"',''NLS_ENV'',''NLS_LANGUAGE=''GERMAN'' NLS_TERRITORY=''GERMANY'' NLS_CURRENCY=''€'' NLS_ISO_CURRENCY=''GERMANY'' NLS_NUMERIC_CHARACTERS='',.'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD.MM.RR'' NLS_DATE_LANGUAGE=''GERMAN'' NLS_SORT=''GERMAN'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD.MM.RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD.MM.RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''€'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE'''');
';
  l_count number;
begin

  select count(1)
    into l_count
    from user_scheduler_jobs
   where job_name = 'JOB_RUN_UNIT_TESTS';
  
  if l_count = 0
  then
    execute immediate l_sql;
	
    select count(1)
      into l_count
      from user_scheduler_jobs
     where job_name = 'JOB_RUN_UNIT_TESTS';

    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of scheduler job JOB_RUN_UNIT_TESTS failed.');
    else
      dbms_output.put_line('INFO: Scheduler job JOB_RUN_UNIT_TESTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Scheduler job JOB_RUN_UNIT_TESTS was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Scheduler job JOB_RUN_UNIT_TESTS could not been created.' || SQLERRM);
end;
*/

declare
  l_count number;
begin
  select count(1)
  into l_count
  from user_scheduler_jobs
  where job_name = 'JOB_RUN_UNIT_TESTS';

  if l_count = 0
  then
    dbms_scheduler.create_job(job_name            => 'JOB_RUN_UNIT_TESTS'
                             ,job_type            => 'STORED_PROCEDURE'
                             ,job_action          => 'QUASTO.qa_unit_tests_pkg.p_run_unit_test_job'
                             ,number_of_arguments => null
                             ,start_date          => to_date('070720230100'
                                                            ,'DDMMYYYYHH24MI')
                             ,repeat_interval     => 'FREQ=DAILY'
                             ,end_date            => null
                             ,job_class           => 'DEFAULT_JOB_CLASS'
                             ,enabled             => false
                             ,auto_drop           => false
                             ,comments            => 'Job runs unit test packages and saves xml result into table QA_TEST_RESULTS');
  
    select count(1)
    into l_count
    from user_scheduler_jobs
    where job_name = 'JOB_RUN_UNIT_TESTS';
  
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of scheduler job JOB_RUN_UNIT_TESTS failed.');
    else
      dbms_output.put_line('INFO: Scheduler job JOB_RUN_UNIT_TESTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Scheduler job JOB_RUN_UNIT_TESTS was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: Scheduler job JOB_RUN_UNIT_TESTS could not been created.' || sqlerrm);
end;
/