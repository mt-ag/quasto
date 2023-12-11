
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QUASTO"."OVERVIEWTESTS_P0001_V" ("QATR_ID", "DETAILS", "STATUS", "UTPLSQL_INFO", "TEST_NAME", "SCHEME", "RESTART_UNIT_TEST", "PROJECT", "CATEGORY", "NAME", "LAYER", "ERRORLEVEL", "ACTIVE", "EXECUTION_DATE") AS 
  with xml_result as
(select qatr_id,
        qatr_added_on,
        replace(
                
                          replace(
                                   QATR_XML_RESULT,
                                   '<![CDATA['
                                 ),
                                 ']]>'
                         )
                      
                 as xml_raw
from QA_TEST_RESULTS)
select "QATR_ID","DETAILS","STATUS","UTPLSQL_INFO","TEST_NAME","SCHEME","RESTART_UNIT_TEST","PROJECT","CATEGORY","NAME","LAYER","ERRORLEVEL","ACTIVE","EXECUTION_DATE" from 
(
    select t.qatr_id, 
            case
		    when testcases.testcase_status = 'Failure' then 
			  
				  '<i class="fa fa-search"></i>' 

           end as  Details
         , nvl(testcases.testcase_status, 'Success') as status

         , case
		   when testcases.testcase_status = 'Failure' then 
			  '<a href="' || APEX_PAGE.GET_URL (p_page   => 2,          
											    p_items  => 'P2_QATR_ID,P2_QUASTO_TESTCASE_NAME',
											    p_values =>  t.qatr_id ||','|| testcases.quasto_test_name) || 
			  '">' || 
				  '<i class="fa fa-exclamation-circle"></i>' ||
			  '</a>'
           end as utplsql_info
         ,testcases.quasto_test_name as test_name
         ,schemes.schemename as scheme
         ,'<a href="' || APEX_PAGE.GET_URL (p_page   => 11,          
											p_items  => 'P11_CLIENT_NAME,P11_SCHEME_NAME,P11_RULE_NUMBER',
											p_values =>  qaru.qaru_client_name ||','|| schemes.schemename ||','|| qaru.qaru_rule_number) || 
		  '">' || 
			  '<i class="fa fa-play-circle"></i>' ||
		  '</a>' as restart_unit_test
         ,qaru.qaru_client_name as Project
         ,qaru.qaru_category as Category
         ,qaru.qaru_name as Name
         ,qaru.qaru_layer as Layer
         ,case qaru.qaru_error_level
         when 1 then 
         'ERROR'
         when 2 then 
         'WARNING'
         when 4 then 
         'INFO'
        end as ErrorLevel
         ,case qaru.qaru_is_active when 1 then 'Yes' when 0 then 'No' end as Active
          , t.qatr_added_on   as Execution_Date

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
         order by QARU.QARU_CLIENT_NAME asc, t.qatr_added_on asc,schemes.schemename asc, QARU.qaru_category asc, qaru.qaru_name asc
);

