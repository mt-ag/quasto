create or replace package qa_api_pkg authid current_user as

  -- run a single rule and get for every mismatch one line back
  -- %param pi_qaru_rule_number number to identify the rule combined with client name is unique
  -- %param pi_qaru_client_name client or project name
  -- %param pi_target_scheme should it run in one dedicated scheme
  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;

  -- run all rules from a client or project
  -- %param pi_qaru_client_name 
  -- %param pi_target_scheme 
  function tf_run_rules
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;

end qa_api_pkg;
/
create or replace package body qa_api_pkg as

  c_cr constant varchar2(10) := utl_tcp.crlf;

  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
  
    c_unit       constant varchar2(32767) := $$plsql_unit || '.tf_run_rule';
    l_param_list qa_logger_pkg.tab_param;
    
    l_qa_rule  qa_rule_t;
    l_qa_rules qa_rules_t;
  
  begin
  

    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
                              
                              
    l_qa_rule := qa_main_pkg.f_get_rule(pi_qaru_rule_number => pi_qaru_rule_number
                                       ,pi_qaru_client_name => pi_qaru_client_name);

    execute immediate l_qa_rule.qaru_sql bulk collect
      into l_qa_rules
    -- :1 scheme
    -- :2 qaru_id
    -- :3 qaru_category
    -- :4 qaru_error_level
    -- :5 qaru_object_types
    -- :6 qaru_error_message    
    -- :7 qaru_sql
      using pi_target_scheme, l_qa_rule.qaru_id, l_qa_rule.qaru_category, l_qa_rule.qaru_error_level, l_qa_rule.qaru_object_types, l_qa_rule.qaru_error_message, l_qa_rule.qaru_sql;
      
      qa_main_pkg.p_exclude_objects(pi_qa_rules => l_qa_rules);
    return l_qa_rules;
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while selecting from qa_rules'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
 when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to select from qa_rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end tf_run_rule;


  function tf_run_rules
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.tf_run_rules';
    l_param_list qa_logger_pkg.tab_param;
    
    l_qaru_rule_numbers varchar2_tab_t;
    l_qa_rules          qa_rules_t := new qa_rules_t();
    l_qa_rules_temp     qa_rules_t := new qa_rules_t();
    l_running_rules     running_rule_t := NEW running_rule_t();
    
    l_allowed_to_run    NUMBER;
    l_success           VARCHAR2(1);
    
  BEGIN
  
    SELECT running_rule(t.qaru_rule_number,
           trim(regexp_substr(t.qaru_predecessor_ids, '[^:]+', 1, levels.column_value)),
           CASE WHEN t.qaru_is_active <> 1 THEN 'N' ELSE NULL END,
           rownum)
      BULK COLLECT INTO l_running_rules
      from qa_rules t,
           table(cast(multiset(select level 
                                 from dual 
                              connect by  level <= length (regexp_replace(t.qaru_predecessor_ids, '[^:]+'))  + 1) as sys.OdciNumberList)) levels
     where t.qaru_client_name = pi_qaru_client_name;                      
                    
  
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_target_scheme'
                              ,p_val_02  => pi_target_scheme);
                              
    l_qaru_rule_numbers := qa_main_pkg.tf_get_rule_numbers(pi_qaru_client_name => pi_qaru_client_name);

    for i in 1 .. l_qaru_rule_numbers.count
    LOOP
      --count all predecessors that are not run now or where the run was not successfull

      SELECT COUNT(1) 
        INTO l_allowed_to_run
        FROM TABLE(l_running_rules) r
       WHERE r.rule_number IN (SELECT  t.predecessor 
                                 FROM TABLE(l_running_rules) t 
                                WHERE t.rule_number = '29.13'
                                  AND (success_run IS NULL OR success_run <> 'Y'));
                                       
      -- if there is no predecessor not running or not being successfull, run this rule
      IF l_allowed_to_run = 0 THEN
        l_qa_rules_temp := tf_run_rule(pi_qaru_rule_number => l_qaru_rule_numbers(i)
                                      ,pi_qaru_client_name => pi_qaru_client_name
                                      ,pi_target_scheme    => pi_target_scheme);

        l_qa_rules := l_qa_rules multiset union l_qa_rules_temp;
        
        SELECT CASE WHEN qaru_error_message IS NULL THEN 'Y' ELSE 'N' END
          INTO l_success
          FROM TABLE(l_qa_rules_temp)
         WHERE qaru_id = (SELECT qaru_id
                            FROM qa_rules 
                           WHERE qaru_rule_number = l_qaru_rule_numbers(i));
        
        --mark the running test as runned (successfull (Y) or not (N))
        FOR upd IN (SELECT row_val
                      FROM TABLE(l_running_rules) 
                     WHERE rule_number = l_qaru_rule_numbers(i))
        LOOP
          l_running_rules(upd.row_val).success_run := l_success;
        END LOOP;
      ELSE
        -- if this rule is not allowed to run, mark thi rule as not successfull (N)
        FOR upd IN (SELECT row_val
                      FROM TABLE(l_running_rules) 
                     WHERE rule_number = l_qaru_rule_numbers(i))
        LOOP
          l_running_rules(upd.row_val).success_run := 'N';
        END LOOP;
      END IF; 

    end loop;

    return l_qa_rules;
  exception
        when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while Testing Rules'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
 when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to test Rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end tf_run_rules;

end qa_api_pkg;
/
