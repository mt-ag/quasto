PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects_1_0_to_1_1.sql 

set define '~'
set concat on
set concat .
set verify off



PROMPT DDL

PROMPT TYPES
PROMPT src/plsql/typ/qa_rule_t.sql
@src/plsql/typ/qa_rule_t.sql
PROMPT src/plsql/typ/running_rule_t.sql
@src/plsql/typ/running_rule_t.sql
PROMPT src/plsql/typ/varchar2_tab_t.sql
@src/plsql/typ/varchar2_tab_t.sql

PROMPT TABLES
PROMPT src/ddl/utplsql_calendar_drop.sql
@src/ddl/utplsql_calendar_drop.sql
PROMPT src/ddl/utplsql_test_case_drop.sql
@src/ddl/utplsql_test_case_drop.sql
PROMPT src/ddl/utplsql_test_run_drop.sql
@src/ddl/utplsql_test_run_drop.sql
PROMPT src/ddl/utplsql_test_suite_drop.sql

PROMPT SEQUENCES
@src/ddl/utplsql_test_suite_drop.sql
PROMPT src/ddl/case_seq_drop.sql
@src/ddl/case_seq_drop.sql
PROMPT src/ddl/cldr_seq_drop.sql
@src/ddl/cldr_seq_drop.sql
PROMPT src/ddl/run_seq_drop.sql
@src/ddl/run_seq_drop.sql
PROMPT src/ddl/suite_seq_drop.sql
@src/ddl/suite_seq_drop.sql

PROMPT PACKAGES
PROMPT src/plsql/pkg/create_ut_test_packages_pkg.sql
@src/plsql/pkg/qa_apex_pkg.sql
PROMPT src/plsql/pkg/qa_api_pkg.sql
@src/plsql/pkg/qa_api_pkg.sql
PROMPT src/plsql/pkg/qa_export_import_rules_pkg.sql
@src/plsql/pkg/qa_export_import_rules_pkg.sql
PROMPT src/plsql/pkg/qa_logger_pkg.sql
@src/plsql/pkg/qa_logger_pkg.sql
PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql

PROMPT src/ddl/fc_export_qa_rules_drop.sql
@src/ddl/fc_export_qa_rules_drop.sql
PROMPT src/ddl/prepare_test_results_pkg_drop.sql
@src/ddl/prepare_test_results_pkg_drop.sql

PROMPT VIEWS
PROMPT src/plsql/vw/qaru_predecessor_order_v.sql
@src/plsql/vw/qaru_predecessor_order_v.sql




