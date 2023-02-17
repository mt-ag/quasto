PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects.sql.
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

PROMPT PACKAGE
PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql

PROMPT src/plsql/pkg/qa_logger_pkg.sql
@src/plsql/pkg/qa_logger_pkg.sql

PROMPT src/plsql/pkg/qa_api_pkg.sql
@src/plsql/pkg/qa_api_pkg.sql

PROMPT src/plsql/pkg/qa_export_import_rules_pkg.sql
@src/plsql/pkg/qa_export_import_rules_pkg.sql



PROMPT TRIGGER
PROMPT src/plsql/trg/qaru_iu_trg.sql
@src/plsql/trg/qaru_iu_trg.sql

PROMPT GRANT
grant execute on qa_api_pkg to public;
grant execute on qa_rule_t to public;

prompt recompile_quasto_objects.sql 
@src/scripts/recompile_quasto_objects.sql