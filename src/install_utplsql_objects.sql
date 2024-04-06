PROMPT ################################
PROMPT  Installation: utPLSQL objects
PROMPT ################################

PROMPT ################
PROMPT      TABLES
PROMPT ################
PROMPT src/ddl/tab/qa_test_results.sql 
@src/ddl/tab/qa_test_results.sql
PROMPT src/ddl/tab/qa_test_runs.sql 
@src/ddl/tab/qa_test_runs.sql
PROMPT src/ddl/tab/qa_test_run_invalid_objects.sql 
@src/ddl/tab/qa_test_run_invalid_objects.sql

PROMPT ################
PROMPT     INDEXES
PROMPT ################
PROMPT src/ddl/ind/qa_test_results.sql
@src/ddl/ind/qa_test_results.sql
PROMPT src/ddl/ind/qa_test_runs.sql
@src/ddl/ind/qa_test_runs.sql
PROMPT src/ddl/ind/qa_test_run_invalid_objects.sql
@src/ddl/ind/qa_test_run_invalid_objects.sql

PROMPT ################
PROMPT   CONSTRAINTS
PROMPT ################
PROMPT src/ddl/cons/qa_test_results.sql
@src/ddl/cons/qa_test_results.sql
PROMPT src/ddl/cons/qa_test_runs.sql
@src/ddl/cons/qa_test_runs.sql
PROMPT src/ddl/cons/qa_test_run_invlid_objects.sql
@src/ddl/cons/qa_test_run_invalid_objects.sql

PROMPT ################
PROMPT    SEQUENCES
PROMPT ################
PROMPT src/ddl/seq/qatr_seq.sql
@src/ddl/seq/qatr_seq.sql
PROMPT src/ddl/seq/qato_seq.sql
@src/ddl/seq/qato_seq.sql
PROMPT src/ddl/seq/qatru_seq.sql
@src/ddl/seq/qatru_seq.sql

PROMPT ################
PROMPT     TRIGGERS
PROMPT ################
PROMPT src/plsql/trg/qatr_i_trg.sql
@src/plsql/trg/qatr_i_trg.sql
PROMPT src/plsql/trg/qato_i_trg.sql
@src/plsql/trg/qato_i_trg.sql
PROMPT src/plsql/trg/qatru_i_trg.sql
@src/plsql/trg/qatru_i_trg.sql

PROMPT ################
PROMPT     PACKAGES
PROMPT ################
@src/plsql/pkg/qa_unit_tests_pkg.sql

PROMPT ################
PROMPT  SCHEDULER JOBS
PROMPT ################
PROMPT src/scripts/create_scheduler_job_for_unit_tests.sql
@src/scripts/create_scheduler_job_for_unit_tests.sql

PROMPT ##########################################
PROMPT  Installation of utPLSQL objects finished
PROMPT ##########################################