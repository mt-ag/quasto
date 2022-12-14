PROMPT alter Package src/plsql/pkg/qa_main_pkg.sql compile
alter package qa_main_pkg compile;
Prompt alter Package src/plsql/pkg/qa_main_pkg.sql compile body
alter package qa_main_pkg compile body;

PROMPT alter Package src/plsql/pkg/qa_api_pkg.sql compile
alter package qa_api_pkg compile;
PROMPT alter Package src/plsql/pkg/qa_api_pkg.sql compile body
alter package qa_api_pkg compile body;

PROMPT alter Package src/plsql/pkg/qa_export_import_rules_pkg.sql compile
alter package qa_export_import_rules_pkg compile;
PROMPT alter Package src/plsql/pkg/qa_export_import_rules_pkg.sql compile body
alter package qa_export_import_rules_pkg compile body;

PROMPT alter Trigger src/plsql/trg/qaru_iu_trg.sql compile
alter trigger qaru_iu_trg compile;
PROMPT alter Trigger src/plsql/trg/qaif_iu_trg.sql compile
alter trigger qaif_iu_trg compile;

declare
    l_count number;
begin 
    select count(*)
    from user_objects uo
    where uo.status = 'INVALID' 
    and uo.object_name in upper(('qa_api_pkg'
                                ,'qa_export_import_rules_pkg'
                                ,'qaru_iu_trg'
                                ,'qaif_iu_trg'));
    if l_count > 0 
      then
        dmbs_output.put_line('ERROR: There are ' || l_count || 'Invalid Quasto objects');
      else
        dmbs_output.put_line('INFO: There are no invalid Quasto objects');
    end if;
end;