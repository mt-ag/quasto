
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_TEST_SCHEME_NAMES_LOV"
  AS 
select username as display_value
     , username as return_value
from QA_SCHEME_NAMES_FOR_TESTING_V
order by username asc
;
/
