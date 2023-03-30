CREATE OR REPLACE TYPE running_rule_t AS OBJECT
( rule_number VARCHAR2(10),
  predecessor VARCHAR2(100),
  success_run VARCHAR2(1),
  row_val     NUMBER
);


CREATE OR REPLACE TYPE running_rules_t IS TABLE OF running_rule_t;
