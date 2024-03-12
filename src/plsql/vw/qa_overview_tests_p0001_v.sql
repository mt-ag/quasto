
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_OVERVIEW_TESTS_P0001_V"
  AS 
select qatr.qatr_id, 
       qatr.qatr_scheme_name,
       qatr.qatr_date,
       case qatr.qatr_result
         when 0 then 'Failure'
         when 1 then 'Success'
         when 2 then 'Error'
       end as qatr_result,
       qaru.qaru_client_name,
       case when qatr.qatr_result = 0 then '<a href="' || APEX_PAGE.GET_URL(p_page   => 4,          
										                                   p_items  => 'P4_QATR_ID',
                                                                           p_values => qatr.qatr_id) || 
                                           '">' || '<i class="fa fa-eye"></i>' ||
                                           '</a>'
       end as qatr_details,
       '<a href="' || APEX_PAGE.GET_URL(p_page   => 11,          
										p_items  => 'P11_CLIENT_NAME,P11_SCHEME_NAME,P11_RULE_NUMBER',
                                        p_values =>  qaru.qaru_client_name ||','|| qatr.qatr_scheme_name ||','|| qaru.qaru_rule_number) || 
       '">' || '<i class="fa fa-play-circle"></i>' ||
       '</a>' as qatr_restart_unit_test,
       qaru.qaru_category,
       qaru.qaru_name,
       qaru.qaru_layer,
       qaru.qaru_error_level,
       qaru.qaru_is_active,
       case when qatr.qatr_runtime_error is not null then '<a href="' || APEX_PAGE.GET_URL(p_page   => 3,          
                                                                                           p_items  => 'P3_QATR_ID',
                                                                                           p_values =>  qatr.qatr_id) || 
                                                          '">' || '<i class="fa fa-exclamation-circle"></i>' ||
                                                          '</a>'
       end as qatr_runtime_error,
       qatr.qatr_program_name
from QA_TEST_RUNS qatr
join QA_RULES qaru
on qaru.qaru_id = qatr.qatr_qaru_id
;
/
