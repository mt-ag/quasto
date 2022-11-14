set feed off;
set echo off;
set head off;
set flush off;
--set termout off;
set trimspool on;
set feedback off;
-- Which project should be exported?
define l_client_name = &client_name
-- Would you like to filter a category. If using null than all categories will be exported
define l_category = &category

set long 100000000 longchunksize 32767
column 2 new_value 2
select '' as "2"
  from sys.dual
 where rownum = 0
;

--define file_name = qa_rules &l_client_name. &l_category..json;
define file_name = qa_rules&l_client_name.&l_category..json;
variable contents  clob
declare
  c_client_name constant qa_rules.qaru_client_name%type := '&l_client_name.';
  c_category    constant qa_rules.qaru_category%type := '&l_category.';
  l_clob clob;
begin
  dbms_output.put_line('&l_category.');
  dbms_output.put_line('&l_client_name.');
  qa_export_import_rules_pkg.g_spool_active := true;
  l_clob := qa_export_import_rules_pkg.f_export_rules_table_to_clob(pi_client_name => c_client_name
                                                                      ,pi_category    => c_category);
  :contents := l_clob; 
end;
/

spool &file_name.
print contents
spool off