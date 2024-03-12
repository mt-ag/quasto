
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_TEST_RESULT_FILES_P0005_V"
  AS 
select qatr.qatr_id,
       qatr.qatr_added_on,
       qatr.qatr_added_by
from QA_TEST_RESULTS qatr
;
/
