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
-- Page: 2 - Unit Test Generation > Page Item: P2_SCHEME_NAMES > List of Values > SQL Query

select username as d
     , username as r
from QARU_SCHEME_NAMES_FOR_TESTING_V
order by 1;

-- ----------------------------------------
-- Page: 2 - Unit Test Generation > Process: Delete Unit Tests > Source > PL/SQL Code

QA_UNIT_TESTS_PKG.p_delete_unit_tests_for_schemes(pi_scheme_names => :P2_SCHEME_NAMES);

-- ----------------------------------------
-- Page: 2 - Unit Test Generation > Process: Create Unit Tests > Source > PL/SQL Code

QA_UNIT_TESTS_PKG.p_create_unit_tests_for_schemes(pi_option => :P2_OPTION
                                                , pi_scheme_names => :P2_SCHEME_NAMES);

