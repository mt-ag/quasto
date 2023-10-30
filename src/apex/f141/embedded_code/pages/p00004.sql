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
-- Page: 4 - Invalid Objects > Region: Invalid Objects Report > Source > SQL Query

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
from QA_TEST_RESULTS
where qatr_id = :P4_QATR_ID)
select * from 
(
    select t.qatr_id
         , schemes.schemename
         , objects.objectname
         , objects.objectdetails
         , objects.error_message
    from xml_result t
         join XMLTABLE('/testsuites/testsuite/testsuite/testcase'
         PASSING XMLTYPE( t.xml_raw )
         COLUMNS
           quasto_test_name VARCHAR2(50) PATH '@name',
           schemes xmltype path 'system-out/Results/Scheme'
         ) testcase on 1=1
         join XMLTABLE('/Scheme'
         PASSING testcase.schemes
         COLUMNS
           schemename VARCHAR2(50) PATH '@name',
           objects xmltype path 'Object'
         ) schemes on 1=1
         join XMLTABLE('/Object'
         PASSING schemes.objects
         COLUMNS
           objectname VARCHAR2(50) PATH '@name',
           objectdetails VARCHAR2(500) PATH '@details',
           error_message VARCHAR2(500) PATH 'text()'
         ) objects on 1=1
         where (to_date(t.qatr_added_on) = :P4_DATE or :P4_DATE is null)
         and (:P4_SCHEME = schemes.schemename or :P4_SCHEME is null)
         and testcase.quasto_test_name = :P4_TESTCASE_NAME
         order by t.qatr_added_on desc
)

