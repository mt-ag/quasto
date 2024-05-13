
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_OVERVIEW_QUOTA_P0001_V"
  AS 
select qatr_result testcase_status
     , count(1) over (partition by qatr_result) as status_amount
     , case qatr_result
         when 'Failure' then '#c42222'
         when 'Error' then '#7a1616'
         else '#1c6d11'
       end as color_hex
from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(nv('APP_PAGE_ID'), 'TEST_REPORT'))
;
/
