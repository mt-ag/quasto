PROMPT 
PROMPT Installation: QUASTO objects
PROMPT ############################

set define '~'
set concat on
set concat .
set verify off

COLUMN :script_apex NEW_VALUE script_name_apex NOPRINT
variable script_apex VARCHAR2(50)

PROMPT 
PROMPT # TABLES
PROMPT 
PROMPT src/ddl/tab/qa_rules.sql 
@src/ddl/tab/qa_rules.sql
PROMPT src/ddl/qa_import_files.sql
@src/ddl/tab/qa_import_files.sql

PROMPT 
PROMPT # INDEXES
PROMPT 
PROMPT src/ddl/ind/qa_rules.sql
@src/ddl/ind/qa_rules.sql
PROMPT src/ddl/ind/qa_import_files.sql
@src/ddl/ind/qa_import_files.sql

PROMPT 
PROMPT # CONSTRAINTS
PROMPT 
PROMPT src/ddl/cons/qa_rules.sql
@src/ddl/cons/qa_rules.sql
PROMPT src/ddl/cons/qa_import_files.sql
@src/ddl/cons/qa_import_files.sql

PROMPT 
PROMPT # SEQUENCES
PROMPT 
PROMPT src/ddl/seq/qaru_seq.sql
@src/ddl/seq/qaru_seq.sql
PROMPT src/ddl/seq/qaif_seq.sql
@src/ddl/seq/qaif_seq.sql

PROMPT 
PROMPT # TYPES
PROMPT 
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

PROMPT 
PROMPT # VIEWS
PROMPT 
PROMPT src/plsql/vw/qa_predecessor_order_v.sql
@src/plsql/vw/qa_predecessor_order_v.sql
PROMPT src/plsql/vw/qa_scheme_names_for_testing_v.sql
@src/plsql/vw/qa_scheme_names_for_testing_v.sql

PROMPT 
PROMPT # PACKAGES
PROMPT 
PROMPT src/plsql/pkg/qa_logger_pkg.sql
@src/plsql/pkg/qa_logger_pkg.sql
PROMPT src/plsql/pkg/qa_utils_pkg.sql
@src/plsql/pkg/qa_utils_pkg.sql
PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql
PROMPT src/plsql/pkg/qa_api_pkg.sql
@src/plsql/pkg/qa_api_pkg.sql
PROMPT src/plsql/pkg/qa_export_import_rules_pkg.sql
@src/plsql/pkg/qa_export_import_rules_pkg.sql

PROMPT 
PROMPT # TRIGGERS
PROMPT 
PROMPT src/plsql/trg/qaru_iu_trg.sql
@src/plsql/trg/qaru_iu_trg.sql
PROMPT src/plsql/trg/qaif_i_trg.sql
@src/plsql/trg/qaif_i_trg.sql

PROMPT 
PROMPT # GRANTS
PROMPT 
grant execute on qa_api_pkg to public;
grant execute on qa_rule_t to public;

PROMPT 
PROMPT Installation of QUASTO objects finished
PROMPT #######################################