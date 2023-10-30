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
-- Page: 5 - Upload Test Results > Process: Upload file > Source > PL/SQL Code

declare
    v_clob_content  clob;
begin
  select to_clob(blob_content)
	into v_clob_content
	from APEX_APPLICATION_TEMP_FILES
   where name = :P5_XML_FILE;
   
   insert into qa_test_results (qatr_xml_result)
   values (v_clob_content);
end;

