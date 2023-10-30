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
-- Page: 2 - utPLSQL Failure > Page Item: P2_UTPLSQL_FAILURE > Source > SQL Query

with xml_result as
(select qatr_id,
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
from QA_TEST_RESULTS
where qatr_id = :P2_QATR_ID)
select utplsql_info from 
(
    select testcases.utplsql_info
    from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           testcase_name VARCHAR2(4000) PATH '@name',
           utplsql_info VARCHAR2(4000) PATH 'failure/text()'
         ) testcases on 1=1
         where testcases.testcase_name = :P2_QUASTO_TESTCASE_NAME
)

