PROMPT alter Package src/plsql/pkg/create_ut_test_packages_pkg.sql COMPILE
alter package create_ut_test_packages_pkg compile;
PROMPT alter Package src/plsql/pkg/create_ut_test_packages_pkg.sql  COMPILE BODY
alter package create_ut_test_packages_pkg compile body;

declare
    l_count number;
begin 
    select count(*)
    into l_count
    from user_objects uo
    where uo.status = 'INVALID' 
    and uo.object_name in upper(('create_ut_test_packages_pkg'));
    if l_count > 0 
      then
        dmbs_output.put_line('ERROR: There are ' || l_count || 'Invalid utplsql objects');
      else
        dmbs_output.put_line('INFO: There are no invalid utplsql objects');
    end if;


 end;
