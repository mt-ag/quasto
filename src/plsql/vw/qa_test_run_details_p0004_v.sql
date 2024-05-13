
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_TEST_RUN_DETAILS_P0004_V"
  AS 
select qato.qato_id, 
       qatr.qatr_scheme_name,
       qato.qato_object_name,
       qato.qato_object_details,
       qato.qato_qatr_id
from QA_TEST_RUNS qatr
join QA_TEST_RUN_INVALID_OBJECTS qato
on qato.qato_qatr_id = qatr.qatr_id
;
/
