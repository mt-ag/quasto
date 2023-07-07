PROMPT Create Program PROG_RUN_UNIT_TESTS for Scheduler Job JOB_RUN_UNIT_TESTS

declare
  l_sql varchar2(32767) := 
'dbms_scheduler.create_program('"PROG_RUN_UNIT_TESTS"',''PLSQL_BLOCK'',
''declare l_result varchar2(1000); begin qa_unit_tests_pkg.p_run_unit_tests(l_result); dbms_output.put_line(l_result); end;''
,0, TRUE,
''Procedure to run the unit tests''
);';
  l_count number;
begin

  select count(1)
    into l_count
    from user_scheduler_programs
   where program_name = 'PROG_RUN_UNIT_TESTS';
  
  if l_count = 0
  then
    execute immediate l_sql;
	
    select count(1)
      into l_count
      from user_scheduler_programs
     where program_name = 'PROG_RUN_UNIT_TESTS';

    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of program PROG_RUN_UNIT_TESTS failed.');
    else
      dbms_output.put_line('INFO: Program PROG_RUN_UNIT_TESTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Program PROG_RUN_UNIT_TESTS was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Program PROG_RUN_UNIT_TESTS could not been created.' || SQLERRM);
end;
/
