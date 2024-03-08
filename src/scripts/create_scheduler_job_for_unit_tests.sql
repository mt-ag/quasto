PROMPT Create Scheduler Job CRONJOB_RUN_UNIT_TESTS

declare
  l_count number;
begin
  select count(1)
  into l_count
  from user_scheduler_jobs
  where job_name = 'CRONJOB_RUN_UNIT_TESTS';

  if l_count = 0
  then
    dbms_scheduler.create_job(job_name            => 'CRONJOB_RUN_UNIT_TESTS'
                             ,job_type            => 'PLSQL_BLOCK'
                             ,job_action          => 'DECLARE v_output VARCHAR2(500); BEGIN qa_unit_tests_pkg.p_run_all_unit_tests(v_output); dbms_output.put_line(v_output); END;'
                             ,number_of_arguments => 0
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
    where job_name = 'CRONJOB_RUN_UNIT_TESTS';
  
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of scheduler job CRONJOB_RUN_UNIT_TESTS failed.');
    else
      dbms_output.put_line('INFO: Scheduler job CRONJOB_RUN_UNIT_TESTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Scheduler job CRONJOB_RUN_UNIT_TESTS was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: Scheduler job CRONJOB_RUN_UNIT_TESTS could not been created.' || sqlerrm);
end;
/
