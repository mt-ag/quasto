PROMPT Running SQL file for installing the utPLSQL objects on the database. Called from install_objects.sql.
PROMPT TABLE
PROMPT src/ddl/tab/qa_test_results.sql 
@src/ddl/tab/qa_test_results.sql
PROMPT src/ddl/tab/qa_test_runs.sql 
@src/ddl/tab/qa_test_runs.sql
PROMPT src/ddl/tab/qa_test_run_invalid_objects.sql 
@src/ddl/tab/qa_test_run_invalid_objects.sql

PROMPT INDEX
PROMPT src/ddl/ind/qa_test_results.sql
@src/ddl/ind/qa_test_results.sql
PROMPT src/ddl/ind/qa_test_runs.sql
@src/ddl/ind/qa_test_runs.sql
PROMPT src/ddl/ind/qa_test_run_invalid_objects.sql
@src/ddl/ind/qa_test_run_invalid_objects.sql

PROMPT CONSTRAINT
PROMPT src/ddl/cons/qa_test_results.sql
@src/ddl/cons/qa_test_results.sql

PROMPT src/ddl/cons/qa_test_runs.sql
@src/ddl/cons/qa_test_runs.sql
PROMPT src/ddl/cons/qa_test_run_invlid_objects.sql
@src/ddl/cons/qa_test_run_invalid_objects.sql

PROMPT SEQUENCE
PROMPT src/ddl/seq/qatr_seq.sql
@src/ddl/seq/qatr_seq.sql
PROMPT src/ddl/seq/qato_seq.sql
@src/ddl/seq/qato_seq.sql
PROMPT src/ddl/seq/qatru_seq.sql
@src/ddl/seq/qatru_seq.sql

PROMPT TRIGGER
PROMPT src/plsql/trg/qatr_i_trg.sql
@src/plsql/trg/qatr_i_trg.sql
PROMPT src/plsql/trg/qato_i_trg.sql
@src/plsql/trg/qato_i_trg.sql
PROMPT src/plsql/trg/qatru_i_trg.sql
@src/plsql/trg/qatru_i_trg.sql

PROMPT SCHEDULER JOBS
PROMPT src/scripts/create_scheduler_job_for_unit_tests.sql
@src/scripts/create_scheduler_job_for_unit_tests.sql