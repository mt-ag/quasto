create or replace package qa_api_pkg
  authid current_user
as

/******************************************************************************
   NAME:       qa_api_pkg
   PURPOSE:    Methods for executing QUASTO rules

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   0.91       29.08.2022  olemm            Package has been added to QUASTO
   1.1        21.04.2023  sprang           Added predecessor logic
******************************************************************************/
 
/** 
 * function to run a single rule by given rule number and client name
 * @param  pi_qaru_rule_number specifies the number of the rule from table QA_RULES
 * @param  pi_qaru_client_name specifies the client or project name
 * @param  pi_target_scheme specifies the scheme name to be tested
 * @throws NO_DATA_FOUND if rule does not exist
 * @return returns objects as type qa_rules_t
*/ 
  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;


/** 
 * function to run all rules by given client name in the selected scheme
 * @param  pi_qaru_client_name specifies the client or project name
 * @param  pi_target_scheme specifies the scheme name to be tested
 * @throws NO_DATA_FOUND if rule does not exist
 * @return returns objects as type qa_rules_t
*/
  function tf_run_rules
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;

end qa_api_pkg;
/
create or replace package body qa_api_pkg as

  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
  
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qa_rule  qa_rule_t;
    l_qa_rules qa_rules_t;
  
  begin
    if qa_main_pkg.f_is_owner_black_listed(pi_user_name => pi_target_scheme) = false
    then
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
      --Remove entries that dont belong to the current owner
      if l_qa_rule.qaru_category != 'APEX'
      then
        qa_main_pkg.p_exclude_not_owned_entries(pi_current_user => pi_target_scheme
                                               ,pi_qa_rules_t   => l_qa_rules);
      end if;
      if l_qa_rule.qaru_category = 'APEX'
      then
        qa_main_pkg.p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t => l_qa_rules);
      end if;
      qa_main_pkg.p_exclude_objects(pi_qa_rules => l_qa_rules);
      return l_qa_rules;
    else
      return null;
    end if;
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
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_rules';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_rule_numbers varchar2_tab_t;
    l_qa_rules          qa_rules_t := new qa_rules_t();
    l_qa_rules_temp     qa_rules_t := new qa_rules_t();
    l_running_rules     running_rules_t := new running_rules_t();
  
    l_allowed_to_run number;
    l_success        varchar2(1);
    l_no_loop        qa_rules.qaru_rule_number%type;
  
  begin
    --check for loops in predecessor order (raises error if cycle is detected so no if clause is needed)
    l_no_loop := qa_main_pkg.f_check_for_loop(pi_qaru_rule_number => null
                                             ,pi_client_name      => pi_qaru_client_name);
    if l_no_loop is not null
    then
      return null;
    end if;
  
    select running_rule_t(t.qaru_rule_number
                         ,trim(regexp_substr(t.qaru_predecessor_ids
                                            ,'[^:]+'
                                            ,1
                                            ,levels.column_value))
                         ,case
                            when t.qaru_is_active <> 1 then
                             'N'
                            else
                             null
                          end
                         ,rownum)
    bulk collect
    into l_running_rules
    from qa_rules t
        ,table(cast(multiset (select level
                     from dual
                     connect by level <= length(regexp_replace(t.qaru_predecessor_ids
                                                              ,'[^:]+')) + 1) as sys.odcinumberlist)) levels
    where t.qaru_client_name = pi_qaru_client_name;
  
  
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_target_scheme'
                              ,p_val_02  => pi_target_scheme);
  
    l_qaru_rule_numbers := qa_main_pkg.tf_get_rule_numbers(pi_qaru_client_name => pi_qaru_client_name);
  
    for i in 1 .. l_qaru_rule_numbers.count
    loop
      --count all predecessors that are not run now or where the run was not successfull
      select count(1)
      into l_allowed_to_run
      from table(l_running_rules) r
      where r.rule_number in (select t.predecessor
                              from table(l_running_rules) t
                              where t.rule_number = l_qaru_rule_numbers(i)
                              and (success_run is null or success_run <> 'Y'));
    
      -- if there is no predecessor not running or not being successfull, run this rule
      if l_allowed_to_run = 0
      then
        dbms_output.put_line(l_qaru_rule_numbers(i));
        l_qa_rules_temp := tf_run_rule(pi_qaru_rule_number => l_qaru_rule_numbers(i)
                                      ,pi_qaru_client_name => pi_qaru_client_name
                                      ,pi_target_scheme    => pi_target_scheme);
      
        l_qa_rules := l_qa_rules multiset union l_qa_rules_temp;
      
        l_success := case
                       when l_qa_rules.count = 0 then
                        'Y'
                       else
                        'N'
                     end;
        --mark the running test as runned (successfull (Y) or not (N))
        for upd in (select row_val
                    from table(l_running_rules)
                    where rule_number = l_qaru_rule_numbers(i))
        loop
          l_running_rules(upd.row_val).success_run := l_success;
        end loop;
      else
        -- if this rule is not allowed to run, mark thi rule as not successfull (N)
        for upd in (select row_val
                    from table(l_running_rules)
                    where rule_number = l_qaru_rule_numbers(i))
        loop
          l_running_rules(upd.row_val).success_run := 'N';
        end loop;
      end if;
    
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
