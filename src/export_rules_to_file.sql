set feedback off;
-- Which project should be exported?
define l_client_name = &client_name
-- Would you like to filter a category. If using null than all categories will be exported
define l_category = &category

-- name of the file which will be created based on client_name and category
spool qa_rules &l_client_name. &l_category..json
declare
  c_client_name constant qa_rules.qaru_client_name%type := '&l_client_name.';
  c_category    constant qa_rules.qaru_category%type := '&l_category.';
  l_clob clob;
begin
  qa_export_import_rules_pkg.g_spool_active := true;
  l_clob := qa_export_import_rules_pkg.f_export_rules_table_to_clob(pi_client_name => c_client_name
                                                                   ,pi_category    => c_category);
  qa_export_import_rules_pkg.p_clob_to_output(pi_clob => l_clob);
end;
/
spool off;
