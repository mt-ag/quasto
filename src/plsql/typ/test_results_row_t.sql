create or replace type test_results_row_t as object (
  qatr_id              number,
  execution_date       date,
  scheme               varchar2(50),
  category             varchar2(100 char),
  details              varchar2(50 char),
  status               varchar2(4000),
  name                 varchar2(100 char),
  layer                varchar2(100 char),
  errorlevel           varchar2(10),
  active               varchar2(10),
  utplsql_info         varchar2(4000),
  test_name            varchar2(4000),
  project              varchar2(100 char)
);
/