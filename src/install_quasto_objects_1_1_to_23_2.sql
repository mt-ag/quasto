PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects_1_0_to_1_1.sql 

set define '~'
set concat on
set concat .
set verify off


PROMPT VIEWS
PROMPT src/plsql/vw/qaru_scheme_names_for_testing_v.sql
@src/plsql/vw/qaru_scheme_names_for_testing_v.sql
PROMPT src/plsql/vw/qaru_apex_blacklisted_apps_v.sql
@src/plsql/vw/qaru_apex_blacklisted_apps_v.sql

PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql

PROMPT TYPE
PROMPT src/plsql/typ/qa_rule_t.sql
@src/plsql/typ/qa_rule_t.sql
PROMPT src/plsql/typ/qa_scheme_object_amount_t.sql
@src/plsql/typ/qa_scheme_object_amount_t.sql
PROMPT src/plsql/typ/qa_scheme_object_amounts_t.sql
@src/plsql/typ/qa_scheme_object_amounts_t.sql

prompt recompile_quasto_objects.sql 
@src/scripts/recompile_quasto_objects.sql

PROMPT src/ddl/qa_rules_add_column_23_2.sql
@src/ddl/qa_rules_add_column_23_2.sql
