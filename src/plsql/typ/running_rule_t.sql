create or replace type running_rule_t as object
(
  rule_number varchar2(10),
  predecessor varchar2(100),
  success_run varchar2(1),
  row_val     number
)
;
/