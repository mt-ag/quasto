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
-- Page: 1 - Dashboard > Page Item: P1_DATE > List of Values > SQL Query

select to_char(qatr_added_on, 'DD-MON-YYYY')||' - '||row_number() over(partition by to_char(qatr_added_on, 'DD.MM.YYYY') order by qatr_added_on)  as d
      ,qatr_added_on as r
from qa_test_results
order by qatr_added_on desc

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Search Region > Filter: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(qatr_added_on, 'DD/MM/YYYY') ||' - '||row_number() over(partition by to_char(qatr_added_on, 'DD.MM.YYYY') order by qatr_added_on) d ,
       execution_date r
  from (select distinct qatr_id, execution_date
          from OVERVIEWTESTS_P0001_V 
         order by execution_date desc
       ) v
join qa_test_results r on v.qatr_id = r.qatr_id
order by qatr_added_on desc


-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Search Region > Filter: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V


-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Search Region > Facet: P1_EXECUTION_DATE > List of Values > SQL Query

select to_char(qatr_added_on, 'DD/MM/YYYY') ||' - '||row_number() over(partition by to_char(qatr_added_on, 'DD.MM.YYYY') order by qatr_added_on) d ,
       execution_date r
  from (select distinct qatr_id, execution_date
          from OVERVIEWTESTS_P0001_V 
         order by execution_date desc
       ) v
join qa_test_results r on v.qatr_id = r.qatr_id
order by qatr_added_on desc


-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Search Region > Facet: P1_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V


-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Error > Source > SQL Query

select status testcase_status, 
       count(1) as status_amount,
       '#7a1616' as color_hex,
       execution_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where status = 'Error'
 group by status, execution_date
 order by execution_date desc


/*with xml_result as
(select qatr_id,
        qatr_added_on,
        replace(
                 replace(
                          replace(
                                   QATR_XML_RESULT,
                                   '<![CDATA['
                                 ),
                                 ']]>'
                         ),
                         '&quot;',
                         ''''
                ) as xml_raw
from QA_TEST_RESULTS)
select execution_date, testcase_status, status_amount, color_hex from 
(
    select testcase_status
         , count(1) as status_amount
         , '#7a1616' as color_hex
         , execution_date
    from 
     ( select nvl(testcases.testcase_status, 'Success') as testcase_status
            , t.qatr_added_on as execution_date
     from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           testcase_status VARCHAR2(4000) PATH '@status',
           schemes xmltype path 'system-out/Results/Scheme'
         ) testcases on 1=1
         left join XMLTABLE('/Scheme'
         PASSING testcases.schemes
         COLUMNS
           schemename VARCHAR2(50) PATH '@name'
         ) schemes on 1=1
         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)
         and (:P1_SCHEME = schemes.schemename
             or :P1_SCHEME is null)
     ) where testcase_status = 'Error'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)*/

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Failure > Source > SQL Query

select status testcase_status, 
       count(1) as status_amount,
       '#c42222' as color_hex,
       execution_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where status = 'Failure'
 group by status, execution_date
 order by execution_date desc



/*with xml_result as
(select qatr_id,
        qatr_added_on,
        replace(
                 replace(
                          replace(
                                   QATR_XML_RESULT,
                                   '<![CDATA['
                                 ),
                                 ']]>'
                         ),
                         '&quot;',
                         ''''
                ) as xml_raw
from QA_TEST_RESULTS)
select execution_date, testcase_status, status_amount, color_hex from 
(
    select testcase_status
         , count(1) as status_amount
         , '#c42222' as color_hex
         , execution_date
    from 
     ( select nvl(testcases.testcase_status, 'Success') as testcase_status
            , t.qatr_added_on as execution_date
     from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           testcase_status VARCHAR2(4000) PATH '@status',
           schemes xmltype path 'system-out/Results/Scheme'
         ) testcases on 1=1
         left join XMLTABLE('/Scheme'
         PASSING testcases.schemes
         COLUMNS
           schemename VARCHAR2(50) PATH '@name'
         ) schemes on 1=1
         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)
         and (:P1_SCHEME = schemes.schemename
             or :P1_SCHEME is null)
     ) where testcase_status = 'Failure'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)*/

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Timeline Chart > Attributes:  > Series: Success > Source > SQL Query

select status testcase_status, 
       count(1) as status_amount,
       '#1c6d11' as color_hex,
       execution_date
  from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
 where status = 'Success'
 group by status, execution_date
 order by execution_date desc


/*
with xml_result as
(select qatr_id,
        qatr_added_on,
        replace(
                 replace(
                          replace(
                                   QATR_XML_RESULT,
                                   '<![CDATA['
                                 ),
                                 ']]>'
                         ),
                         '&quot;',
                         ''''
                ) as xml_raw
from QA_TEST_RESULTS)
select execution_date, testcase_status, status_amount, color_hex from 
(
    select testcase_status
         , count(1) as status_amount
         , '#1c6d11' as color_hex
         , execution_date
    from 
     ( select nvl(testcases.testcase_status, 'Success') as testcase_status
            , t.qatr_added_on as execution_date
     from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           testcase_status VARCHAR2(4000) PATH '@status',
           schemes xmltype path 'system-out/Results/Scheme'
         ) testcases on 1=1
         left join XMLTABLE('/Scheme'
         PASSING testcases.schemes
         COLUMNS
           schemename VARCHAR2(50) PATH '@name'
         ) schemes on 1=1
         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)
         and (:P1_SCHEME = schemes.schemename
             or :P1_SCHEME is null)
     ) where testcase_status = 'Success'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)*/

-- ----------------------------------------
-- Page: 1 - Dashboard > Region: Quota Chart > Attributes:  > Series: Quota > Source > SQL Query

    select status testcase_status
         , count(*) over (partition by status) as status_amount
         , case status
            when 'Failure' then
               '#c42222'
            when 'Error' then
                '#7a1616'
            else
                '#1c6d11'
          end as color_hex
    from table(qa_helper_pkg.p0001_get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'))
     

-- ----------------------------------------
-- Page: 1 - Dashboard > Page Item: P1_SCHEME_OLD > List of Values > SQL Query

select username as d
      ,username as r
from QARU_SCHEME_NAMES_FOR_TESTING_V
order by username asc

