PROMPT Create Program PROG_RUN_UNIT_TESTS for Scheduler Job JOB_RUN_UNIT_TESTS

BEGIN 
dbms_scheduler.create_program('"PROG_RUN_UNIT_TESTS"','PLSQL_BLOCK',
'declare l_result varchar2(1000); begin qa_unit_tests_pkg.p_run_unit_tests(l_result); dbms_output.put_line(l_result); end;'
,0, TRUE,
'Procedure to run the unit tests'
);
COMMIT; 
END;
/
