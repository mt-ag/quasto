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
-- Page: 10 - test page 1 > Page Item: P10_DATE > List of Values > SQL Query

select to_char(qatr_added_on, 'DD-MON-YYYY')||' - '||row_number() over(partition by to_char(qatr_added_on, 'DD.MM.YYYY') order by qatr_added_on)  as d
      ,qatr_added_on as r
from qa_test_results
order by qatr_added_on desc;

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Search Region > Filter: P10_EXECUTION_DATE > List of Values > SQL Query

select execution_date_char  d, execution_date_char r 
from OVERVIEWTESTS_P0001_V 
order by execution_date desc;

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Search Region > Filter: P10_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Search Region > Facet: P10_EXECUTION_DATE > List of Values > SQL Query

select execution_date_char  d, execution_date_char r 
from OVERVIEWTESTS_P0001_V 
order by execution_date desc;

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Search Region > Facet: P10_SCHEME > List of Values > SQL Query

SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V;

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Timeline Chart > Attributes:  > Series: Success > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)
         and (:P10_SCHEME = schemes.schemename
             or :P10_SCHEME is null)
     ) where testcase_status = 'Success'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
);

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Timeline Chart > Attributes:  > Series: Failure > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)
         and (:P10_SCHEME = schemes.schemename
             or :P10_SCHEME is null)
     ) where testcase_status = 'Failure'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
);

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Timeline Chart > Attributes:  > Series: Error > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)
         and (:P10_SCHEME = schemes.schemename
             or :P10_SCHEME is null)
     ) where testcase_status = 'Error'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
);

-- ----------------------------------------
-- Page: 10 - test page 1 > Region: Quota Chart > Attributes:  > Series: Quota > Source > SQL Query

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
    from table(get_faceted_search_data(:APP_PAGE_ID, 'TEST_REPORT'));

-- ----------------------------------------
-- Page: 10 - test page 1 > Page Item: P10_SCHEMEX > List of Values > SQL Query

select username as d
      ,username as r
from QARU_SCHEME_NAMES_FOR_TESTING_V
order by username asc;

