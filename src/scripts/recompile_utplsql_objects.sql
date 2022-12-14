PROMPT alter Package src/plsql/pkg/prepare_test_results_pkg.sql COMPILE
alter package prepare_test_results_pkg compile;
PROMPT alter Package src/plsql/pkg/prepare_test_results_pkg.sql  COMPILE BODY
alter package prepare_test_results_pkg compile body;
PROMPT alter Package src/plsql/pkg/create_ut_test_packages_pkg.sql COMPILE
alter package create_ut_test_packages_pkg compile;
PROMPT alter Package src/plsql/pkg/create_ut_test_packages_pkg.sql  COMPILE BODY
alter package create_ut_test_packages_pkg compile body;

Prompt alter trigger src/plsql/trg/cldr_iu_trg.sql compile
alter trigger cldr_iu_trg compile;
Prompt alter trigger src/plsql/trg/case_iu_trg.sql compile
alter trigger case_iu_trg compile;
Prompt alter trigger src/plsql/trg/run_iu_trg.sql compile
alter trigger run_iu_trg compile;
Prompt alter trigger src/plsql/trg/suite_iu_trg.sql compile
alter trigger suite_iu_trg compile;

declare
    l_count number;
begin 
    select count(*)
    into l_count
    from user_objects uo
    where uo.status = 'INVALID' 
    and uo.object_name in upper(('prepare_test_results_pkg'
                                ,'create_ut_test_packages_pkg'
                                ,'cldr_iu_trg'
                                ,'case_iu_trg'
                                ,'run_iu_trg'
                                ,'suite_iu_trg'));
    if l_count > 0 
      then
        dmbs_output.put_line('ERROR: There are ' || l_count || 'Invalid utplsql objects');
      else
        dmbs_output.put_line('INFO: There are no invalid utplsql objects');
    end if;


 end;
