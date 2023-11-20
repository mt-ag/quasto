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
-- Page: 3 - System Error > Page Item: P3_SYSTEM_ERROR > Source > SQL Query

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
where qatr_id = :P3_QATR_ID)
select system_error from 
(
    select testcases.system_error
    from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           testcase_name VARCHAR2(4000) PATH '@name',
           system_error VARCHAR2(4000) PATH 'error/text()'
         ) testcases on 1=1
         where testcases.testcase_name = :P3_QUASTO_TESTCASE_NAME
)

