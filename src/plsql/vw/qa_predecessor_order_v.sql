create or replace force view QA_PREDECESSOR_ORDER_V AS
select qaru_rule_number
      ,predec
      ,step
      ,qa_main_pkg.f_get_full_rule_pred(pi_rule_number => qaru_rule_number) as predecessor_list
from (select qaru_rule_number
            ,predec
            ,step
            ,max(step) over(partition by qaru_rule_number) max_step
      from (with splitted_pred as (select distinct t.qaru_rule_number
                                                  ,trim(regexp_substr(t.qaru_predecessor_ids
                                                                     ,'[^:]+'
                                                                     ,1
                                                                     ,levels.column_value)) as predec
                                   from qa_rules t
                                       ,table(cast(multiset (select level
                                                    from dual
                                                    connect by level <= length(regexp_replace(t.qaru_predecessor_ids
                                                                                             ,'[^:]+')) + 1) as sys.odcinumberlist)) levels
                                   order by qaru_rule_number)
             select qaru_rule_number
                   ,predec
                   ,level step
             from splitted_pred
             connect by nocycle prior qaru_rule_number = predec
             start with predec is null)
      )
where max_step = step
order by step asc;
/
