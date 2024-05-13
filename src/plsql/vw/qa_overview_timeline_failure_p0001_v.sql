
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_OVERVIEW_TIMELINE_FAILURE_P0001_V"
  AS 
select qatr_result as testcase_status,
       '#c42222' as color_hex,
       to_char(qatr_date, 'MM/DD/YYYY') as testcase_date,
       to_char(qatr_date, 'fmMM/DD/YYYY') as filter_date,
       status_amount
from (
        select q2.qatr_result, 
               q2.qatr_date,
               count(1) as status_amount
        from (
            select qatr_date
              from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(nv('APP_PAGE_ID'), 'TEST_REPORT'))
              group by qatr_date
              order by qatr_date desc
              fetch first 10 rows only
             ) q1
        join table(qa_apex_app_pkg.get_faceted_search_dashboard_data(nv('APP_PAGE_ID'), 'TEST_REPORT')) q2
        on q2.qatr_date = q1.qatr_date
        where q2.qatr_result = 'Failure'
        group by q2.qatr_result, q2.qatr_date
)
order by qatr_date asc
;
/
