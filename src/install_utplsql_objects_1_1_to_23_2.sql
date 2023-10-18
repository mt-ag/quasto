PROMPT Running SQL file for installing the UTPLSQL objects on the database. Called from install_objects.sql

set define '~'
set concat on
set concat .
set verify off

PROMPT TABLE
PROMPT src/ddl/tab/qa_test_results.sql 
@src/ddl/tab/qa_test_results.sql
PROMPT INDEX
PROMPT src/ddl/ind/qa_test_results.sql
@src/ddl/ind/qa_test_results.sql
PROMPT CONSTRAINT
PROMPT src/ddl/cons/qa_test_results.sql
@src/ddl/cons/qa_test_results.sql
PROMPT SEQUENCE
PROMPT src/ddl/seq/qatr_seq.sql
@src/ddl/seq/qatr_seq.sql
PROMPT TYPE
PROMPT src/plsql/typ/qa_scheme_object_amount_t.sql
@src/plsql/typ/qa_scheme_object_amount_t.sql
PROMPT src/plsql/typ/qa_scheme_object_amounts_t.sql
@src/plsql/typ/qa_scheme_object_amounts_t.sql
PROMPT PACKAGE
@src/plsql/pkg/qa_unit_tests_pkg.sql
PROMPT TRIGGER
PROMPT src/plsql/trg/qatr_i_trg.sql
@src/plsql/trg/qatr_i_trg.sql

PROMPT PROGRAMS
PROMPT src/scripts/create_program_for_unit_tests.sql
--@src/scripts/create_program_for_unit_tests.sql
PROMPT SCHEDULE PLANS
PROMPT src/scripts/create_schedule_plan_for_unit_tests.sql
--@src/scripts/create_schedule_plan_for_unit_tests.sql
PROMPT SCHEDULER JOBS
PROMPT src/scripts/create_scheduler_job_for_unit_tests.sql
--@src/scripts/create_scheduler_job_for_unit_tests.sql