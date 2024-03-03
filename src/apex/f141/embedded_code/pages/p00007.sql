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
-- Page: 7 - Add/Edit Rule > Region: Add/Edit Rule Form > Source > SQL Query

select QARU_ID,
QARU_RULE_NUMBER,
QARU_CLIENT_NAME,
QARU_NAME,
QARU_CATEGORY,
QARU_OBJECT_TYPES,
QARU_ERROR_MESSAGE,
QARU_COMMENT,
QARU_EXCLUDE_OBJECTS,
QARU_ERROR_LEVEL,
QARU_IS_ACTIVE,
QARU_SQL,
QARU_LAYER
from QA_RULES;

