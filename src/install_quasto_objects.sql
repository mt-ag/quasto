PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects.sql.

set define '~'
set concat on
set concat .
set verify off

COLUMN :script_apex NEW_VALUE script_name_apex NOPRINT
variable script_apex VARCHAR2(50)

PROMPT TABLE
PROMPT src/ddl/tab/qa_rules.sql 
@src/ddl/tab/qa_rules.sql
PROMPT src/ddl/qa_import_files.sql
@src/ddl/tab/qa_import_files.sql

PROMPT INDEX
PROMPT src/ddl/ind/qa_rules.sql
@src/ddl/ind/qa_rules.sql
PROMPT src/ddl/ind/qa_import_files.sql
@src/ddl/ind/qa_import_files.sql

PROMPT CONSTRAINT
PROMPT src/ddl/cons/qa_rules.sql
@src/ddl/cons/qa_rules.sql
PROMPT src/ddl/cons/qa_import_files.sql
@src/ddl/cons/qa_import_files.sql

PROMPT SEQUENCE
PROMPT src/ddl/seq/qaru_seq.sql
@src/ddl/seq/qaru_seq.sql
PROMPT src/ddl/seq/qaif_seq.sql
@src/ddl/seq/qaif_seq.sql

PROMPT TYPE
PROMPT src/plsql/typ/varchar2_tab_t.sql
@src/plsql/typ/varchar2_tab_t.sql
PROMPT src/plsql/typ/qa_rule_t.sql
@src/plsql/typ/qa_rule_t.sql
PROMPT src/plsql/typ/qa_rules_t.sql
@src/plsql/typ/qa_rules_t.sql
PROMPT src/plsql/typ/qa_running_rule_t.sql
@src/plsql/typ/qa_running_rule_t.sql
PROMPT src/plsql/typ/qa_running_rules_t.sql
@src/plsql/typ/qa_running_rules_t.sql
PROMPT src/plsql/typ/qa_scheme_object_amount_t.sql
@src/plsql/typ/qa_scheme_object_amount_t.sql
PROMPT src/plsql/typ/qa_scheme_object_amounts_t.sql
@src/plsql/typ/qa_scheme_object_amounts_t.sql
PROMPT src/plsql/typ/qa_test_results_row_t.sql
@src/plsql/typ/qa_test_results_row_t.sql
PROMPT src/plsql/typ/qa_test_results_table_t.sql
@src/plsql/typ/qa_test_results_table_t.sql

PROMPT VIEWS
PROMPT src/plsql/vw/qa_predecessor_order_v.sql
@src/plsql/vw/qa_predecessor_order_v.sql
PROMPT src/plsql/vw/qa_scheme_names_for_testing_v.sql
@src/plsql/vw/qa_scheme_names_for_testing_v.sql
PROMPT src/plsql/vw/qa_application_owner_v.sql
@src/plsql/vw/qa_application_owner_v.sql

PROMPT src/plsql/vw/qa_overview_tests_p0001_v.sql
@src/plsql/vw/qa_overview_tests_p0001_v.sql
PROMPT src/plsql/vw/qa_overview_quota_p0001_v.sql
@src/plsql/vw/qa_overview_quota_p0001_v.sql
PROMPT src/plsql/vw/qa_overview_timeline_error_p0001_v.sql
@src/plsql/vw/qa_overview_timeline_error_p0001_v.sql
PROMPT src/plsql/vw/qa_overview_timeline_failure_p0001_v.sql
@src/plsql/vw/qa_overview_timeline_failure_p0001_v.sql
PROMPT src/plsql/vw/qa_overview_timeline_success_p0001_v.sql
@src/plsql/vw/qa_overview_timeline_success_p0001_v.sql
PROMPT src/plsql/vw/qa_test_runtime_error_p0003_v.sql
@src/plsql/vw/qa_test_runtime_error_p0003_v.sql
PROMPT src/plsql/vw/qa_test_run_details_p0004_v.sql
@src/plsql/vw/qa_test_run_details_p0004_v.sql
PROMPT src/plsql/vw/qa_test_result_files_p0005_v.sql
@src/plsql/vw/qa_test_result_files_p0005_v.sql
PROMPT src/plsql/vw/qa_rules_p0006_v.sql
@src/plsql/vw/qa_rules_p0006_v.sql
PROMPT src/plsql/vw/qa_rules_p0007_v.sql
@src/plsql/vw/qa_rules_p0007_v.sql
PROMPT src/plsql/vw/qa_client_names_p0008_v.sql
@src/plsql/vw/qa_client_names_p0008_v.sql
PROMPT src/plsql/vw/qa_job_details_P0009_v.sql
@src/plsql/vw/qa_job_details_P0009_v.sql
PROMPT src/plsql/vw/qa_job_run_details_p0009_v.sql
@src/plsql/vw/qa_job_run_details_p0009_v.sql
PROMPT src/plsql/vw/qa_job_run_details_p0011_v.sql
@src/plsql/vw/qa_job_run_details_p0011_v.sql

PROMPT src/plsql/vw/qa_rule_categories_lov.sql
@src/plsql/vw/qa_rule_categories_lov.sql
PROMPT src/plsql/vw/qa_rule_error_levels_lov.sql
@src/plsql/vw/qa_rule_error_levels_lov.sql
PROMPT src/plsql/vw/qa_rule_layers_lov.sql
@src/plsql/vw/qa_rule_layers_lov.sql
PROMPT src/plsql/vw/qa_test_execution_dates_lov.sql
@src/plsql/vw/qa_test_execution_dates_lov.sql
PROMPT src/plsql/vw/qa_test_scheme_names_lov.sql
@src/plsql/vw/qa_test_scheme_names_lov.sql

PROMPT src/plsql/vw/qa_apex_blacklisted_apps_v.sql
declare
    l_script_name varchar2(100);
begin
  if qa_constant_pkg.gc_apex_flag = 1
    then
      l_script_name := 'plsql/vw/qa_apex_blacklisted_apps_v.sql';
    else
      l_script_name := 'null.sql';
  end if;
  :script_apex := l_script_name;
end;
/
select :script_apex from dual;
@@src/~script_name_apex

PROMPT PACKAGE
@src/plsql/pkg/qa_unit_tests_pkg.sql
PROMPT src/plsql/pkg/qa_logger_pkg.sql
@src/plsql/pkg/qa_logger_pkg.sql
PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql
PROMPT src/plsql/pkg/qa_api_pkg.sql
@src/plsql/pkg/qa_api_pkg.sql
PROMPT src/plsql/pkg/qa_export_import_rules_pkg.sql
@src/plsql/pkg/qa_export_import_rules_pkg.sql
PROMPT src/plsql/pkg/qa_utils_pkg.sql
@src/plsql/pkg/qa_utils_pkg.sql
PROMPT src/plsql/pkg/qa_apex_app_pkg.sql
@src/plsql/pkg/qa_apex_app_pkg.sql
PROMPT src/plsql/pkg/qa_apex_api_pkg.sql
@src/plsql/pkg/qa_apex_api_pkg.sql

PROMPT TRIGGER
PROMPT src/plsql/trg/qaru_iu_trg.sql
@src/plsql/trg/qaru_iu_trg.sql
PROMPT src/plsql/trg/qaif_i_trg.sql
@src/plsql/trg/qaif_i_trg.sql

PROMPT GRANT
grant execute on qa_api_pkg to public;
grant execute on qa_rule_t to public;