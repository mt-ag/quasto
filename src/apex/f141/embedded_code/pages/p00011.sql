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
-- Page: 11 - test new Page design > Region: Test Executions Report > Source > SQL Query

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
select * from 
(
    select t.qatr_id
         ,case
		    when testcases.testcase_status = 'Failure' then 
			  '<a href="' || APEX_PAGE.GET_URL (p_page   => 4,          
											    p_items  => 'P4_QATR_ID,P4_TESTCASE_NAME,P4_DATE,P4_SCHEME',
											    p_values =>  t.qatr_id ||','|| testcases.quasto_test_name || ',' || :P11_DATE || ',' || :P11_SCHEME) || 
			  '">' || 
				  '<i class="fa fa-search"></i>' ||
			  '</a>'
           end as testcase_scheme_invalid_objects
         , testsuite.quasto_test_suite
         , testcases.quasto_test_name
         , nvl(testcases.testcase_status, 'Success') as testcase_status
         , case
		   when testcases.testcase_status = 'Error' then 
			  '<a href="' || APEX_PAGE.GET_URL (p_page   => 3,          
											    p_items  => 'P3_QATR_ID,P3_QUASTO_TESTCASE_NAME',
											    p_values =>  t.qatr_id ||','|| testcases.quasto_test_name) || 
			  '">' || 
				  '<i class="fa fa-exclamation-circle"></i>' ||
			  '</a>'
           end as testcase_system_error_info
         , case
		   when testcases.testcase_status = 'Failure' then 
			  '<a href="' || APEX_PAGE.GET_URL (p_page   => 2,          
											    p_items  => 'P2_QATR_ID,P2_QUASTO_TESTCASE_NAME',
											    p_values =>  t.qatr_id ||','|| testcases.quasto_test_name) || 
			  '">' || 
				  '<i class="fa fa-exclamation-circle"></i>' ||
			  '</a>'
           end as utplsql_info
         , testresult.quasto_layer
         ,qaru.qaru_category
         , testresult.quasto_rulenumber
         , qaru.qaru_comment
         , t.qatr_added_on
    from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testsuite/testsuite'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           quasto_test_suite VARCHAR2(50) PATH '@name',
           cases xmltype path 'testcase'
         ) testsuite on 1=1
         join XMLTABLE('/testcase'
         PASSING testsuite.cases
         COLUMNS
           quasto_test_name VARCHAR2(4000) PATH '@name',
           testcase_status VARCHAR2(4000) PATH '@status',
           results xmltype path 'system-out/Results'
         ) testcases on 1=1
         left join XMLTABLE('/Results'
         PASSING testcases.results
         COLUMNS
           quasto_layer VARCHAR2(50) PATH '@layer',
           quasto_rulenumber VARCHAR2(10) PATH '@rulenumber',
           schemes xmltype path 'Scheme'
         ) testresult on 1=1
         left join XMLTABLE('/Scheme'
         PASSING testresult.schemes
         COLUMNS
           schemename VARCHAR2(50) PATH '@name',
           schemeresult VARCHAR2(10) PATH '@result'
         ) schemes on 1=1
         left join QA_RULES qaru
         on qaru.qaru_rule_number = testresult.quasto_rulenumber
         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)
         and (schemes.schemename = :P11_SCHEME or :P11_SCHEME is null)
         order by t.qatr_added_on desc, testresult.quasto_rulenumber
)

-- ----------------------------------------
-- Page: 11 - test new Page design > Region: Timeline Chart > Attributes:  > Series: Failure > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)
         and (:P11_SCHEME = schemes.schemename
             or :P11_SCHEME is null)
     ) where testcase_status = 'Failure'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)

-- ----------------------------------------
-- Page: 11 - test new Page design > Region: Timeline Chart > Attributes:  > Series: Success > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)
         and (:P11_SCHEME = schemes.schemename
             or :P11_SCHEME is null)
     ) where testcase_status = 'Success'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)

-- ----------------------------------------
-- Page: 11 - test new Page design > Region: Timeline Chart > Attributes:  > Series: Error > Source > SQL Query

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
         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)
         and (:P11_SCHEME = schemes.schemename
             or :P11_SCHEME is null)
     ) where testcase_status = 'Error'
     group by testcase_status, execution_date
     order by execution_date desc
     fetch first 10 rows only
)

-- ----------------------------------------
-- Page: 11 - test new Page design > Region: Quota Chart > Attributes:  > Series: Quota > Source > SQL Query

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
select testcase_status, status_amount, color_hex from 
(
    select testcase_status
         , count(*) over (partition by testcase_status) as status_amount
         , case testcase_status
            when 'Failure' then
               '#c42222'
            when 'Error' then
                '#7a1616'
            else
                '#1c6d11'
          end as color_hex
    from 
     ( select nvl(testcases.testcase_status, 'Success') as testcase_status
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
         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)
         and (:P11_SCHEME = schemes.schemename
             or :P11_SCHEME is null)
     )
) order by status_amount desc

-- ----------------------------------------
-- Page: 11 - test new Page design > Page Item: P11_DATE > List of Values > SQL Query

select to_char(qatr_added_on, 'DD-MON-YYYY HH24:MI') as d
      ,qatr_added_on as r
from qa_test_results

-- ----------------------------------------
-- Page: 11 - test new Page design > Page Item: P11_SCHEME > List of Values > SQL Query

select username as d
      ,username as r
from QARU_SCHEME_NAMES_FOR_TESTING_V
order by username asc

