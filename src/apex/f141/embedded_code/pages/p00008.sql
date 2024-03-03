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
    v_blob_content  blob;
    v_filename      varchar2(100);
begin
  select blob_content,
         filename
	into v_blob_content,
         v_filename
	from APEX_APPLICATION_TEMP_FILES
   where name = :P8_JSON_FILE;
   
   qa_export_import_rules_pkg.f_import_clob_to_qa_import_files(pi_clob => v_blob_content,
                                                               pi_filename => v_filename,
                                                               pi_mimetype => 'application/json');
end;

