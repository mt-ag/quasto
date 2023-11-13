-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page: 8 - Upload Rules > Process: Upload file > Source > PL/SQL Code

declare
    v_clob_content  clob;
begin
  select to_clob(blob_content)
	into v_clob_content
	from APEX_APPLICATION_TEMP_FILES
   where name = :P8_JSON_FILE;
   
   qa_export_import_rules_pkg.p_import_clob_to_rules_table(pi_clob => v_clob_content);
end;

