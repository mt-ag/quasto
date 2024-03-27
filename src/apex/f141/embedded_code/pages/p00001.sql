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
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Failure > Source > SQL Query

select qatr_result as testcase_status,
       '#c42222' as color_hex,
       to_char(qatr_date, 'MM/DD/YYYY') as testcase_date,
       to_char(qatr_date, 'fmMM/DD/YYYY') as filter_date,
       status_amount
from (
        select q2.qatr_result, 
               trunc(q2.qatr_date) as qatr_date,
               count(1) as status_amount
        from (
            select trunc(qatr_date) as qatr_date
              from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT'))
              group by trunc(qatr_date)
              order by trunc(qatr_date) desc
              fetch first 10 rows only
             ) q1
        join table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT')) q2
        on trunc(q2.qatr_date) = q1.qatr_date
        where q2.qatr_result = 'Failure'
        group by q2.qatr_result, trunc(q2.qatr_date)
)
order by qatr_date asc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Filter: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(v.qatr_date, 'MM/DD/YYYY') as d,
       to_char(v.qatr_date, 'fmMM/DD/YYYY') as r
  from (select trunc(qatr_date) as qatr_date
        from QA_OVERVIEW_TESTS_P0001_V
        group by trunc(qatr_date)) v
order by v.qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Filter: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QA_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Facet: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(v.qatr_date, 'MM/DD/YYYY') as d,
       to_char(v.qatr_date, 'fmMM/DD/YYYY') as r
  from (select trunc(qatr_date) as qatr_date
        from QA_OVERVIEW_TESTS_P0001_V
        group by trunc(qatr_date)) v
order by v.qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Facet: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QA_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Error > Source > SQL Query

select qatr_result as testcase_status,
       '#7a1616' as color_hex,
       to_char(qatr_date, 'MM/DD/YYYY') as testcase_date,
       to_char(qatr_date, 'fmMM/DD/YYYY') as filter_date,
       status_amount
from (
        select q2.qatr_result, 
               trunc(q2.qatr_date) as qatr_date,
               count(1) as status_amount
        from (
            select trunc(qatr_date) as qatr_date
              from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT'))
              group by trunc(qatr_date)
              order by trunc(qatr_date) desc
              fetch first 10 rows only
             ) q1
        join table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT')) q2
        on trunc(q2.qatr_date) = q1.qatr_date
        where q2.qatr_result = 'Error'
        group by q2.qatr_result, trunc(q2.qatr_date)
)
order by qatr_date asc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Quota Chart > Attributes:  > Series: Quota > Source > SQL Query

select qatr_result testcase_status
         , count(1) over (partition by qatr_result) as status_amount
         , case qatr_result
            when 'Failure' then
               '#c42222'
            when 'Error' then
                '#7a1616'
            else
                '#1c6d11'
          end as color_hex
    from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT'));

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Success > Source > SQL Query

select qatr_result as testcase_status,
       '#1c6d11' as color_hex,
       to_char(qatr_date, 'MM/DD/YYYY') as testcase_date,
       to_char(qatr_date, 'fmMM/DD/YYYY') as filter_date,
       status_amount
from (
        select q2.qatr_result, 
               trunc(q2.qatr_date) as qatr_date,
               count(1) as status_amount
        from (
            select trunc(qatr_date) as qatr_date
              from table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT'))
              group by trunc(qatr_date)
              order by trunc(qatr_date) desc
              fetch first 10 rows only
             ) q1
        join table(qa_apex_app_pkg.get_faceted_search_dashboard_data(:APP_PAGE_ID, 'TEST_REPORT')) q2
        on trunc(q2.qatr_date) = q1.qatr_date
        where q2.qatr_result = 'Success'
        group by q2.qatr_result, trunc(q2.qatr_date)
)
order by qatr_date asc;

