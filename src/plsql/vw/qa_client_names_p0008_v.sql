
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_CLIENT_NAMES_P0008_V"
  AS 
with clients
as (select qaru_client_name
from QA_RULES
group by qaru_client_name
)
select rownum as clientid
      ,cn.qaru_client_name
from dual
    ,clients cn
where 1=1
;
/
