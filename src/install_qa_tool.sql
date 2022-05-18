PROMPT SQL file for installing the QA Tool on a database. Called from install.sql.
PROMPT create table utplsql_test_run
@src/ddl/tab/utplsql_test_run.sql
PROMPT create table utplsql_test_suite
@src/ddl/tab/utplsql_test_suite.sql
PROMPT create table utplsql_calendar
@src/ddl/tab/utplsql_calendar.sql
PROMPT create table utplsql_test_case
@src/ddl/tab/utplsql_test_case.sql
PROMPT create table qa_rules
@src/ddl/tab/qa_rules.sql
PROMPT create sequence cldr_seq
@src/ddl/seq/cldr_seq.sql
PROMPT create sequence case_seq
@src/ddl/seq/case_seq.sql
PROMPT create sequence run_seq
@src/ddl/seq/run_seq.sql
PROMPT create sequence suite_seq
@src/ddl/seq/suite_seq.sql
PROMPT create type t_varchar2_tab
@src/plsql/typ/t_varchar2_tab.sql
PROMPT create type qa_rule_t
@src/plsql/typ/qa_rule_t.sql
PROMPT create type qa_rules_t
@src/plsql/typ/qa_rules_t.sql
PROMPT create foreign key index utplsql_test_case
@src/ddl/ind/utplsql_test_case.sql
PROMPT create foreign key index utplsql_test_run
@src/ddl/ind/utplsql_test_run.sql
PROMPT create foreign key index utplsql_test_suite
@src/ddl/ind/utplsql_test_suite.sql
PROMPT create package prepare_test_results_pkg
@src/plsql/pkg/prepare_test_results_pkg.sql
PROMPT create package qa_main_pkgg
@src/plsql/pkg/qa_main_pkg.sql
PROMPT create trigger cldr_iu_trg
@src/plsql/trg/cldr_iu_trg.sql
PROMPT create trigger case_iu_trg
@src/plsql/trg/case_iu_trg.sql
PROMPT create trigger run_iu_trg
@src/plsql/trg/run_iu_trg.sql
PROMPT create trigger suite_ui_trg
@src/plsql/trg/suite_ui_trg.sql