create or replace type qa_running_rule_t force as

/******************************************************************************
   NAME:       qa_running_rule_t
   PURPOSE:    Attributes for objects of type qa_running_rule_t

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   23.2       05.11.2023  sprang           Type has been added to QUASTO
******************************************************************************/

  object
  (
    rule_number VARCHAR2(10)
   ,predecessor VARCHAR2(100)
   ,success_run VARCHAR2(1)
   ,row_val     NUMBER
  )
;
/
