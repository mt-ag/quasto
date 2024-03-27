
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_RULE_LAYERS_LOV"
  AS 
select QARU_LAYER as display_value
     , QARU_LAYER as return_value
from QA_RULES
group by QARU_LAYER
order by QARU_LAYER asc
;
/
