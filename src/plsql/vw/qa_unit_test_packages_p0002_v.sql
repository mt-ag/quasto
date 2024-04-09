
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_UNIT_TEST_PACKAGES_P0002_V"
  AS 
select object_name as package_name
      ,status as package_status
      ,to_char(last_ddl_time, 'MM/DD/YYYY') as last_compilation
from user_objects
where object_type = 'PACKAGE'
and object_name like replace(qa_constant_pkg.f_get_constant_string_value('gc_utplsql_ut_test_packages_prefix'), '_', '\_') || '%' escape '\'
order by object_name asc
;
/
