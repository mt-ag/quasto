create or replace package qa_apex_api_pkg authid definer as

  /******************************************************************************
     NAME:       qa_apex_api_pkg
     PURPOSE:    Methods for executing QUASTO rules for APEX
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     0.91       29.08.2022  pdahlem          Package has been added to QUASTO
  ******************************************************************************/

  /**
  * procedure for deleting entries in given ruleset for which exists an entry in qa_apex_blacklisted_apps_v
  * @param pi_qa_rules_t specifies the rule entity
  */
  procedure p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t in out qa_rules_t);

  function tf_run_rule
  (
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;

  function tf_run_rules
  (
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
   ,pi_rule_number      in qa_rules.qaru_rule_number%type
  ) return qa_rules_t;

end qa_apex_api_pkg;
/
create or replace package body qa_apex_api_pkg as

  procedure p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t in out qa_rules_t) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_exclude_not_whitelisted_apex_entries';
  
    l_param_list qa_logger_pkg.tab_param;
    l_count      number;
    l_app_ids    varchar2(4000 char);
    l_page_ids   varchar2(4000 char);
  begin
    if pi_qa_rules_t.count > 0
    then
      select q.qaru_app_id
            ,q.qaru_page_id
      into l_app_ids
          ,l_page_ids
      from qa_rules q
      where q.qaru_id = pi_qa_rules_t(1).qaru_id;
    
      for i in pi_qa_rules_t.first .. pi_qa_rules_t.last
      loop
        select count(1)
        into l_count
        from qa_apex_blacklisted_apps_v v
        where v.application_id = nvl(pi_qa_rules_t(i).apex_app_id
                                    ,-99999);
      
        if (l_app_ids is not null and instr(',' || l_app_ids || ','
                                           ,',' || pi_qa_rules_t(i).apex_app_id || ',') = 0) or
          -- Apex Application welche geblacklisted wurden in der View qa_apex_blacklisted_apps_v rausfiltern
           l_count > 0
        then
          pi_qa_rules_t.delete(i);
        elsif l_page_ids is not null
        then
          for s in (select *
                    from apex_string.split(pi_qa_rules_t(i).apex_page_id
                                          ,','))
          loop
            if (instr(',' || l_page_ids || ','
                     ,',' || s.column_value || ',') > 0)
            then
              exit;
            else
              pi_qa_rules_t.delete(i);
            end if;
          end loop;
        end if;
      end loop;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'Cant remove Apex App or Pages from qa_rules Table Record that dont belong to the current owner!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_exclude_not_whitelisted_apex_entries;


  function tf_run_rule
  (
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
  
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_rule_active boolean;
    l_qa_rule     qa_rule_t;
    l_qa_rules    qa_rules_t := new qa_rules_t();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_target_scheme'
                              ,p_val_03  => pi_target_scheme);
  
    if pi_qaru_rule_number is null or
       pi_qaru_client_name is null
    then
      raise_application_error(-20001
                             ,'Missing input parameter value for pi_qaru_rule_number: ' || pi_qaru_rule_number || ' or pi_qaru_client_name: ' || pi_qaru_client_name || ' or pi_target_scheme: ' || pi_target_scheme);
    end if;
  
    l_rule_active := qa_main_pkg.f_is_rule_active(pi_qaru_rule_number => pi_qaru_rule_number
                                                 ,pi_qaru_client_name => pi_qaru_client_name);
    if l_rule_active = false
    then
      raise_application_error(-20001
                             ,'Rule is not set to active for rule number: ' || pi_qaru_rule_number || ' and client name: ' || pi_qaru_client_name);
    end if;
  
    l_qa_rule := qa_main_pkg.f_get_rule(pi_qaru_rule_number => pi_qaru_rule_number
                                       ,pi_qaru_client_name => pi_qaru_client_name);
  
    if l_qa_rule.qaru_category = 'APEX'
    then
      execute immediate l_qa_rule.qaru_sql bulk collect
        into l_qa_rules
      -- :1 scheme
      -- :2 qaru_id
      -- :3 qaru_category
      -- :4 qaru_error_level
      -- :5 qaru_object_types
      -- :6 qaru_error_message    
      -- :7 qaru_sql
      -- :8 app_id
      -- :9 page_id
        using pi_target_scheme, l_qa_rule.qaru_id, l_qa_rule.qaru_category, l_qa_rule.qaru_error_level, l_qa_rule.qaru_object_types, l_qa_rule.qaru_error_message, l_qa_rule.qaru_sql, pi_app_id, pi_page_id;
      --Remove entries that dont belong to the current owner
      qa_apex_api_pkg.p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t => l_qa_rules);
    else
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
    end if;
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
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
   ,pi_rule_number      in qa_rules.qaru_rule_number%type
  ) return qa_rules_t is
  
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_rules';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qa_rules      qa_rules_t := new qa_rules_t();
    l_qa_rules_temp qa_rules_t := new qa_rules_t();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_app_id'
                              ,p_val_01  => pi_app_id
                              ,p_name_02 => 'pi_page_id'
                              ,p_val_02  => pi_page_id
                              ,p_name_03 => 'pi_target_scheme');
  
    for i in (select qaru_rule_number,qaru_client_name
              from qa_rules
              where qaru_category = 'APEX'
              and qaru_is_active = 1
              and (qaru_client_name = pi_qaru_client_name or pi_qaru_client_name is null)
              and (qaru_rule_number = pi_rule_number or pi_rule_number is null))
    loop
      l_qa_rules_temp := tf_run_rule(pi_app_id           => pi_app_id
                                    ,pi_page_id          => pi_page_id
                                    ,pi_qaru_rule_number => i.qaru_rule_number
                                    ,pi_qaru_client_name => i.qaru_client_name
                                    ,pi_target_scheme    => pi_target_scheme);
      l_qa_rules      := l_qa_rules multiset union l_qa_rules_temp;
    end loop;
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
  end tf_run_rules;

end qa_apex_api_pkg;
/