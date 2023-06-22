PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects_1_1_to_23_2.sql 

set define '~'
set concat on
set concat .
set verify off

PROMPT VIEWS
PROMPT src/plsql/vw/qaru_predecessor_order_v.sql
@src/plsql/vw/qaru_predecessor_order_v.sql

PROMPT PACKAGES
PROMPT src/plsql/pkg/qa_api_pkg.sql
@src/plsql/pkg/qa_api_pkg.sql
PROMPT src/plsql/pkg/qa_main_pkg.sql
@src/plsql/pkg/qa_main_pkg.sql





