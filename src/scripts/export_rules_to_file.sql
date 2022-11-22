--set echo off;
set head off;
set flush off;
--set termout off;
--set trimspool on;
set feedback off;
set linesize 32767;
-- Which project should be exported?
define l_client_name = "&1"
-- Would you like to filter a category. If using null than all categories will be exported
define l_category = "&2"

set long 100000000 longchunksize 32767
column 2 new_value 2
select '' as "2"
  from sys.dual
 where rownum = 0
;

column filename new_value filename
select 'qa_rules_' || lower(replace('&l_client_name.',' ','_')) || case when '&l_category.' is null then '.json' else lower('_&l_category..json') end as filename from sys.dual;

variable contents  clob;
declare
  c_client_name constant qa_rules.qaru_client_name%type := '&l_client_name';
  c_category    constant qa_rules.qaru_category%type := '&l_category.';
  l_clob clob;
begin
  qa_export_import_rules_pkg.g_spool_active := true;
  l_clob := qa_export_import_rules_pkg.f_export_rules_table_to_clob(pi_client_name => c_client_name
                                                                   ,pi_category    => c_category);
  :contents := l_clob; 
end;
/

spool &filename
print contents
spool off