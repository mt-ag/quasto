PROMPT deinstalling utplsql Database Objects

PROMPT drop table utplsql_calendar
@src/ddl/tab/utplsql_calendar_drop.sql
PROMPT drop table utplsql_test_case_drop
@src/ddl/tab/utplsql_test_case_drop.sql
PROMPT drop table utplsql_test_suite_drop
@src/ddl/tab/utplsql_test_suite_drop.sql
PROMPT drop table utplsql_test_run_drop
@src/ddl/tab/utplsql_test_run_drop.sql

PROMPT drop package prepare_test_results_pkg
@src/plsql/pkg/prepare_test_results_pkg_drop.sql
PROMPT drop package create_ut_test_packages_pkg
@src/plsql/pkg/create_ut_test_packages_pkg_drop.sql

PROMPT drop type varchar2_tab_t
@src/plsql/typ/varchar2_tab_t_drop.sql
