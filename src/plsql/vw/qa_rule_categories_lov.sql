
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_RULE_CATEGORIES_LOV"
  AS 
select display_value, return_value
  from (
      select 'APEX' as display_value
           , 'APEX' as return_value
      from dual
      union all
      select 'DDL' as display_value
           , 'DDL' as return_value
      from dual
      union all
      select 'DATA' as display_value
           , 'DATA' as return_value
      from dual
  )
group by display_value, return_value
order by 1 asc
;
/
