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
-- Page: 20 - Region Plugin > Page Item: P20_CLIENT_NAME > List of Values > SQL Query

select distinct qaru_client_name as d, qaru_client_name as
from qa_rules
where qaru_category = 'APEX';

-- ----------------------------------------
-- Page: 20 - Region Plugin > Page Item: P20_RULE_SELECTION > List of Values > SQL Query

select qaru_rule_number || ' - ' || qaru_name as d , qaru_rule_number as r
from qa_rules
where qaru_category = 'APEX' 
and (qaru_client_name = :P20_CLIENT_NAME or :P20_CLIENT_NAME is null);

