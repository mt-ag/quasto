
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TESTRUNTIMEERROR_P0003_V"
  AS 
select qatr.qatr_id, 
       qatr.qatr_runtime_error
from QA_TEST_RUNS qatr
;
/
