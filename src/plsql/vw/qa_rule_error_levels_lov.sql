
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_RULE_ERROR_LEVELS_LOV"
  AS 
select case QARU_ERROR_LEVEL
         when 1 then 'Error'
         when 2 then 'Warning'
         when 4 then 'Info'
         else to_char(QARU_ERROR_LEVEL)
       end as display_value
     , QARU_ERROR_LEVEL as return_value
from QA_RULES
group by QARU_ERROR_LEVEL
order by QARU_ERROR_LEVEL asc
;
/
