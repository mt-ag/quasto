
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_RULE_LAYERS_LOV"
  AS 
select display_value, return_value
  from (
      select 'PAGE' as display_value
           , 'PAGE' as return_value
      from dual
      union all
      select 'APPLICATION' as display_value
           , 'APPLICATION' as return_value
      from dual
      union all
      select 'DATABASE' as display_value
           , 'DATABASE' as return_value
      from dual
  )
group by display_value, return_value
order by 1 asc
;
/
