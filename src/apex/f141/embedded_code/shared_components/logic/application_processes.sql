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
-- Application Process: getRuleJSONAttachment > Source > PL/SQL Code

BEGIN
  QA_EXPORT_IMPORT_RULES_PKG.p_download_rules_json(:AI_CLIENT_NAME);
END;

-- ----------------------------------------
-- Application Process: getUTXMLAttachment > Source > PL/SQL Code

BEGIN
  QA_UNIT_TESTS_PKG.p_download_unit_test_xml(:AI_XML_TEST_RESULT_ID);
END;

