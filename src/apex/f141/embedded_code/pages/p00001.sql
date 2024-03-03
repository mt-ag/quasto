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
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Error > Source > SQL Query

select qatr_result testcase_status, 
       count(1) as status_amount,
       '#7a1616' as color_hex,
       qatr_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where qatr_result = 'Error'
 group by qatr_result, qatr_date
 order by qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Filter: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(ov1.qatr_date, 'DD/MM/YYYY HH24:MI') || ' (' || (select count(1) from OVERVIEWTESTS_P0001_V ov2 where ov2.qatr_date = ov1.qatr_date) || ')' as d,
       ov1.qatr_date r
  from OVERVIEWTESTS_P0001_V ov1
  group by qatr_date
  order by qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Filter: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Facet: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(ov1.qatr_date, 'DD/MM/YYYY HH24:MI') || ' (' || (select count(1) from OVERVIEWTESTS_P0001_V ov2 where ov2.qatr_date = ov1.qatr_date) || ')' as d,
       ov1.qatr_date r
  from OVERVIEWTESTS_P0001_V ov1
  group by qatr_date
  order by qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Filter > Facet: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Quota Chart > Attributes:  > Series: Quota > Source > SQL Query

select qatr_result testcase_status
         , count(*) over (partition by qatr_result) as status_amount
         , case qatr_result
            when 'Failure' then
               '#c42222'
            when 'Error' then
                '#7a1616'
            else
                '#1c6d11'
          end as color_hex
    from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'));

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Success > Source > SQL Query

select qatr_result testcase_status, 
       count(1) as status_amount,
       '#1c6d11' as color_hex,
       qatr_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where qatr_result = 'Success'
 group by qatr_result, qatr_date
 order by qatr_date desc;

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Failure > Source > SQL Query

select qatr_result testcase_status, 
       count(1) as status_amount,
       '#c42222' as color_hex,
       qatr_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where qatr_result = 'Failure'
 group by qatr_result, qatr_date
 order by qatr_date desc;

