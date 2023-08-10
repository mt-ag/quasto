PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects_1_0_to_1_1.sql 

set define '~'
set concat on
set concat .
set verify off


PROMPT VIEWS
PROMPT src/plsql/vw/qaru_schema_names_for_testing_v.sql
@src/plsql/vw/qaru_schema_names_for_testing_v.sql

PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql

PROMPT TYPE
PROMPT src/plsql/typ/qa_schema_object_amount_t.sql
@src/plsql/typ/qa_schema_object_amount_t.sql
PROMPT src/plsql/typ/qa_schema_object_amounts_t.sql
@src/plsql/typ/qa_schema_object_amounts_t.sql




