set feedback off;

-- Which project should be exported?
define l_client_name = "&1"
-- Would you like to filter a category. If using null than all categories will be exported
define l_category = "&2"

column filename new_value filename
select 'qa_rules_' || replace('&l_client_name.',' ','_') || '_&l_category..json' as filename from sys.dual;

variable contents  clob;

declare
  c_client_name constant qa_rules.qaru_client_name%type := '&l_client_name.';
  c_category    constant qa_rules.qaru_category%type := '&l_category.';
  file_contents clob := q'[
  @@qa_rules_MT_AG_DDL.json
  ]';
begin
  p_import_clob_to_rules_table(pi_clob => :file_contents)
end;
/