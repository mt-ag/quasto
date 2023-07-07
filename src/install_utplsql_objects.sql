PROMPT Running SQL file for installing the utPLSQL objects on the database. Called from install_objects.sql.
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
PROMPT src/plsql/typ/qa_schema_object_amount_t.sql
@src/plsql/typ/qa_schema_object_amount_t.sql

PROMPT PACKAGE
@src/plsql/pkg/qa_unit_tests_pkg.sql

PROMPT TRIGGER
PROMPT src/plsql/trg/qatr_i_trg.sql
@src/plsql/trg/qatr_i_trg.sql

PROMPT VIEWS
PROMPT src/plsql/vw/qa_schema_names_for_testing_v.sql
@src/plsql/vw/qa_schema_names_for_testing_v.sql

PROMPT PROGRAMS
PROMPT src/scripts/create_program_for_unit_tests.sql
--@src/scripts/create_program_for_unit_tests.sql

PROMPT SCHEDULE PLANS
PROMPT src/scripts/create_schedule_plan_for_unit_tests.sql
--@src/scripts/create_schedule_plan_for_unit_tests.sql

PROMPT SCHEDULER JOBS
PROMPT src/scripts/create_scheduler_job_for_unit_tests.sql
-- Asugeklammert weil keine Berechtigung zum Erstellen von Jobs vorhanden ist
--@src/scripts/create_scheduler_job_for_unit_tests.sql

prompt recompile_utplsql_objects.sql 
@src/scripts/recompile_utplsql_objects.sql