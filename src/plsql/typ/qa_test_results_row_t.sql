create or replace type qa_test_results_row_t as

/******************************************************************************
   NAME:       qa_running_rule_t
   PURPOSE:    Attributes for objects of type qa_running_rule_t

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       11.12.2023  sprang           Type has been added to QUASTO
******************************************************************************/

  object (
    qatr_id                   number,
    qatr_date                 date,
    qatr_scheme_name          varchar2(100),
    qatr_category             varchar2(100),
    qatr_result               varchar2(20),
    qaru_name                 varchar2(100),
    qaru_layer                varchar2(20),
    qaru_error_level          varchar2(20),
    qaru_is_active            varchar2(10),
    qaru_client_name          varchar2(4000),
    qatr_program_name         varchar2(500)
  )
;
/