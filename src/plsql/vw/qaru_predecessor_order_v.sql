CREATE OR REPLACE VIEW qaru_predecessor_order_v 
AS
SELECT qaru_rule_number, 
       predec, 
       step
FROM (SELECT qaru_rule_number, 
             predec, 
             step,
             max(step) over (partition by qaru_rule_number) max_step
        FROM (WITH splitted_pred AS
                 ( SELECT DISTINCT t.qaru_rule_number,
                          trim(regexp_substr(t.qaru_predecessor_ids, '[^:]+', 1, levels.column_value))  as predec
                     from qa_rules t,
                          table(cast(multiset(select level 
                                                from dual 
                                             connect by  level <= length (regexp_replace(t.qaru_predecessor_ids, '[^:]+'))  + 1) as sys.OdciNumberList)) levels
                    order by qaru_rule_number
                 )
              SELECT qaru_rule_number, 
                     predec, 
                     LEVEL step
                FROM splitted_pred
             connect by NOCYCLE prior qaru_rule_number = predec
               START WITH predec IS NULL
             )
     )
 WHERE max_step = step
 ORDER BY step ASC;
 /
