PROMPT Running SQL file for installing the UTPLSQL objects on the database. Called from install_objects.sql

set define '~'
set concat on
set concat .
set verify off

PROMPT PACKAGES
PROMPT src/plsql/pkg/create_ut_test_packages_pkg.sql
@src/plsql/pkg/create_ut_test_packages_pkg.sql

PROMPT TABLES
PROMPT src/ddl/utplsql_calendar_drop.sql
@src/ddl/utplsql_calendar_drop.sql
PROMPT src/ddl/utplsql_test_case_drop.sql
@src/ddl/utplsql_test_case_drop.sql
PROMPT src/ddl/utplsql_test_suite_drop.sql
@src/ddl/utplsql_test_suite_drop.sql
PROMPT src/ddl/utplsql_test_run_drop.sql
@src/ddl/utplsql_test_run_drop.sql

PROMPT SEQUENCES
PROMPT src/ddl/cldr_seq_drop.sql
@src/ddl/cldr_seq_drop.sql
PROMPT src/ddl/run_seq_drop.sql
@src/ddl/run_seq_drop.sql
PROMPT src/ddl/case_seq_drop.sql
@src/ddl/case_seq_drop.sql
PROMPT src/ddl/suite_seq_drop.sql
@src/ddl/suite_seq_drop.sql

PROMPT src/ddl/prepare_test_results_pkg_drop.sql
@src/ddl/prepare_test_results_pkg_drop.sql