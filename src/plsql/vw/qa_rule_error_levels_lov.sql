
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_RULE_ERROR_LEVELS_LOV"
  AS 
select display_value, return_value
  from (
      select 'Error' as display_value
           , 1 as return_value
      from dual
      union all
      select 'Warning' as display_value
           , 2 as return_value
      from dual
      union all
      select 'Info' as display_value
           , 4 as return_value
      from dual
  )
group by display_value, return_value
order by 1 asc
;
/
