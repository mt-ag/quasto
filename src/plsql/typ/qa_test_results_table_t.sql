create or replace type qa_test_results_table_t as

/******************************************************************************
   NAME:       qa_test_results_table_t
   PURPOSE:    PL/SQL table of type qa_test_results_row_t

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       11.12.2023  sprang           Type has been added to QUASTO
******************************************************************************/

table of qa_test_results_row_t
;
/