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
    c_param_list constant varchar2(32767) := 'pi_qaru_rule_number=' || pi_qaru_rule_number || c_cr || --
                                             'pi_qaru_client_name=' || pi_qaru_client_name || c_cr || --
                                             'pi_target_scheme=' || pi_target_scheme;

    l_qa_rule  qa_rule_t;
    l_qa_rules qa_rules_t;
  begin
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
    when others then
      dbms_output.put_line(c_unit);
      dbms_output.put_line(c_param_list);
      raise;
  end tf_run_rule;


  function tf_run_rules
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.tf_run_rules';
    c_param_list constant varchar2(32767) := 'pi_qaru_client_name=' || pi_qaru_client_name || c_cr || --
                                             'pi_target_scheme=' || pi_target_scheme;

    l_qaru_rule_numbers varchar2_tab_t;
    l_qa_rules          qa_rules_t := new qa_rules_t();
    l_qa_rules_temp     qa_rules_t := new qa_rules_t();
  begin
    l_qaru_rule_numbers := qa_main_pkg.tf_get_rule_numbers(pi_qaru_client_name => pi_qaru_client_name);

    for i in 1 .. l_qaru_rule_numbers.count
    loop
      l_qa_rules_temp := tf_run_rule(pi_qaru_rule_number => l_qaru_rule_numbers(i)
                                    ,pi_qaru_client_name => pi_qaru_client_name
                                    ,pi_target_scheme    => pi_target_scheme);

      l_qa_rules := l_qa_rules multiset union l_qa_rules_temp;

    end loop;

    return l_qa_rules;
  exception
    when others then
      dbms_output.put_line(c_unit);
      dbms_output.put_line('Error while running all rules from one client/project');
      dbms_output.put_line(c_param_list);
      raise;
  end tf_run_rules;

end qa_api_pkg;
/
