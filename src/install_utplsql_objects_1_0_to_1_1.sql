PROMPT Running SQL file for installing the UTPLSQL objects on the database. Called from install_objects.sql 

set define '~'
set concat on
set concat .
set verify off

PROMPT PACKAGES
PROMPT src/plsql/pkg/create_ut_test_packages_pkg.sql
@src/plsql/pkg/create_ut_test_packages_pkg.sql

