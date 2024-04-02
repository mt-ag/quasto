
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_TEST_EXECUTION_DATES_LOV"
  AS 
select to_char(v.qatr_date, 'MM/DD/YYYY') as display_value
     , to_char(v.qatr_date, 'fmMM/DD/YYYY') as return_value
  from (select trunc(qatr_date) as qatr_date
        from QA_OVERVIEW_TESTS_P0001_V
        group by trunc(qatr_date)) v
order by v.qatr_date desc
;
/
