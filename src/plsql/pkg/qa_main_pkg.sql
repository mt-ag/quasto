create or replace package qa_main_pkg authid definer as

  /******************************************************************************
     NAME:       qa_main_pkg
     PURPOSE:    Methods for creating and testing the QUASTO rules
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     0.91       29.08.2022  olemm/mwilhelm   Package has been added to QUASTO
     1.1        21.04.2023  sprang/pdahlem   Added predecessor and exclude objects logic
  ******************************************************************************/

  /**
  * function to get rule attributes by rule number and client name
  * @param  pi_qaru_rule_number specifies the rule number
  * @param  pi_qaru_client_name specifies the client name
  * @throws NO_DATA_FOUND if rule number and client name do not exist
  * @return qa_rule_t returns the rule entity
  */
  function f_get_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rule_t;

  /**
  * function to get the rule pk by rule number and client name
  * @param  pi_qaru_rule_number specifies the rule number
  * @param  pi_qaru_client_name specifies the client name
  * @throws NO_DATA_FOUND if rule number and client name do not exist
  * @return qa_rule_t returns the rule entity
  */
  function f_get_rule_pk
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return number;

  /**
  * function to check whether rules exists or not
  * @param  pi_qaru_client_name specifies the client name
  * @return boolean returns the result
  */
  function f_exist_rules(pi_qaru_client_name in qa_rules.qaru_client_name%type default null) return boolean;

  /**
  * function to get all rule numbers from one client/project
  * @param  pi_qaru_client_name specifies the client name
  * @throws NO_DATA_FOUND if client name does not exist
  * @return varchar2_tab_t returns the rule numbers
  */
  function tf_get_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t;

  /**
  * procedure for testing a qa rule
  * @param pi_qaru_client_name specifies the client name
  * @param pi_qaru_rule_number specifies the rule number
  * @param pi_scheme_names specifies the scheme names to be tested
  * @param po_result returns the rule result
  * @param po_scheme_objects returns the amount of invalid objects per scheme name
  * @param po_invalid_objects returns all invalid objects with scheme name
  */
  procedure p_test_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_scheme_names     in varchar2_tab_t
   ,po_result           out number
   ,po_scheme_objects   out qa_scheme_object_amounts_t
   ,po_invalid_objects  out qa_rules_t
  );

  /**
  * function for inserting a new rule
  * @param  pi_qaru_rule_number specifies the rule number
  * @param  pi_qaru_client_name specifies the client name
  * @param  pi_qaru_name specifies the rule name
  * @param  pi_qaru_category specifies the rule category
  * @param  pi_qaru_object_types specifies the object types for the rule to be tested
  * @param  pi_qaru_error_message specifies the rule error message
  * @param  pi_qaru_comment specifies a comment for the rule
  * @param  pi_qaru_exclude_objects specifies object names to be ignored
  * @param  pi_qaru_error_level specifies the error level for the rule
  * @param  pi_qaru_is_active specifies whether the rule is activated
  * @param  pi_qaru_sql specifies the SQL query in QUASTO format
  * @param  pi_qaru_predecessor_ids specifies all rule ids to be executed preliminary
  * @param  pi_qaru_layer specifies the layer of the rule
  * @return number returns the rule number
  */
  function f_insert_rule
  (
    pi_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name     in qa_rules.qaru_client_name%type
   ,pi_qaru_name            in qa_rules.qaru_name%type
   ,pi_qaru_category        in qa_rules.qaru_category%type
   ,pi_qaru_object_types    in qa_rules.qaru_object_types%type
   ,pi_qaru_error_message   in qa_rules.qaru_error_message%type
   ,pi_qaru_comment         in qa_rules.qaru_comment%type default null
   ,pi_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,pi_qaru_error_level     in qa_rules.qaru_error_level%type
   ,pi_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,pi_qaru_sql             in qa_rules.qaru_sql%type
   ,pi_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,pi_qaru_layer           in qa_rules.qaru_layer%type
  ) return qa_rules.qaru_id%type;

  /**
  * procedure for deleting entries in given ruleset for which exists an entry in quaru_excluded_ebjects
  * @param pi_qa_rules specifies the rule entity
  */
  procedure p_exclude_objects(pi_qa_rules in out nocopy qa_rules_t);

  /**
  * function for checking if a loop exists for the predecessor logic for the given rule identified by rule number and client name
  * @param  pi_qaru_rule_number specifies the rule number
  * @param  pi_client_name specifies the client name
  * @throws LOOP_DETECT_E if loop was detected
  * @return varchar2 returns the rule number
  */
  function f_check_for_loop
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type default null
   ,pi_client_name      in qa_rules.qaru_client_name%type default null
  ) return qa_rules.qaru_rule_number%type;

  /**
  * function for getting all predecessor ids for the given rule number
  * @param  pi_rule_number specifies the rule number
  * @return varchar2 returns the predecessor ids in a comma separated list
  */
  function f_get_full_rule_pred(pi_rule_number in qa_rules.qaru_rule_number%type) return varchar2;

  /**
  * procedure for removing all objects from a given rule entity which do not belong to the given user
  * @param pi_current_user specifies the user
  * @param pi_qa_rules_t specifies the rule entity
  */
  procedure p_exclude_not_owned_entries
  (
    pi_current_user in varchar2
   ,pi_qa_rules_t   in out qa_rules_t
  );

  /**
  * function to check if given user is black listed in qa_scheme_names_for_testing_v
  * @param  pi_user_name specifies the user
  * @throws E_USER_BLACKLISTED if given user is blacklisted
  * @return boolean returns whether user is blacklisted or not
  */
  function f_is_owner_black_listed(pi_user_name varchar2) return boolean;

end qa_main_pkg;
/
create or replace package body qa_main_pkg as
  -- Flag to filter out Apex Rules depending on constant package entry
  gc_apex_flag varchar2(10 char) := case
                                      when qa_constant_pkg.gc_apex_flag = 0 then
                                       'APEX'
                                      else
                                       null
                                    end;

  function f_get_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rule_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qa_rule qa_rule_t;
  
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
  
    select qa_rule_t(pi_qaru_id            => q.qaru_id
                    ,pi_qaru_category      => q.qaru_category
                    ,pi_qaru_error_level   => q.qaru_error_level
                    ,pi_qaru_error_message => q.qaru_error_message
                    ,pi_qaru_object_types  => q.qaru_object_types
                    ,pi_qaru_sql           => q.qaru_sql)
    into l_qa_rule
    from qa_rules q
    where q.qaru_rule_number = pi_qaru_rule_number
    and q.qaru_client_name = pi_qaru_client_name
    and (q.qaru_category != gc_apex_flag or gc_apex_flag is null);
  
    return l_qa_rule;
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
  end f_get_rule;

  function f_get_rule_pk
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return number is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_rule_pk';
    l_param_list qa_logger_pkg.tab_param;
    
    l_qaru_id number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
  
    select qaru_id
    into l_qaru_id
    from QA_RULES
    where qaru_client_name = pi_qaru_client_name
    and qaru_rule_number = pi_qaru_rule_number;
  
    return l_qaru_id;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the pk of a given rule number and client name!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_rule_pk;

  function f_exist_rules(pi_qaru_client_name in qa_rules.qaru_client_name%type default null) return boolean is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_exist_rules';
    l_param_list qa_logger_pkg.tab_param;
  
    l_result number;
  begin
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name   => 'pi_qaru_client_name'
                              ,p_val    => pi_qaru_client_name);
  
    select decode(count(1), 0, 0, 1)
    into l_result
    from dual
    where exists (select null
                  from QA_RULES
                  where qaru_client_name = pi_qaru_client_name
                  or pi_qaru_client_name is null);

    if l_result = 0
    then
      return false;
    else
      return true;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to count rules from qa_rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_exist_rules;

  function tf_get_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_get_rule_numbers';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_rule_numbers varchar2_tab_t;
  begin
  
    -- Logging Paramter:
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name   => 'pi_qaru_client_name'
                              ,p_val    => pi_qaru_client_name);
  
    --Joining with qa_predecessor_order_v to get the right order based on predecessor list
    select q.qaru_rule_number
    bulk collect
    into l_qaru_rule_numbers
    from qa_rules q
    join qa_predecessor_order_v p on p.qaru_rule_number = q.qaru_rule_number
    where q.qaru_client_name = pi_qaru_client_name
    and q.qaru_is_active = 1
    and q.qaru_error_level <= 4
    and (q.qaru_category != gc_apex_flag or gc_apex_flag is null)
    order by p.step asc;
  
    return l_qaru_rule_numbers;
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while selecting from qa_rules'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to select from qa_rules!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end tf_get_rule_numbers;

  -- get excluded objects for a rule
  function f_get_excluded_objects
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rules.qaru_exclude_objects%type result_cache is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_excluded_objects';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
  begin
    -- Logging Paramter:
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
  
    select p.qaru_exclude_objects
    into l_qaru_exclude_objects
    from qa_rules p
    where p.qaru_rule_number = pi_qaru_rule_number
    and p.qaru_client_name = pi_qaru_client_name
    and (p.qaru_category != gc_apex_flag or gc_apex_flag is null);
  
    return l_qaru_exclude_objects;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to select from qaru_exclude_objects!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_excluded_objects;

  -- get invalid objects for a rule by providing one or more scheme
  function f_get_invalid_objects
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_scheme_names     in varchar2_tab_t
  ) return qa_rules_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_invalid_objects';
    l_param_list qa_logger_pkg.tab_param;
  
    l_scheme_names         varchar2(32767);
    l_qa_rules_temp        qa_rules_t := new qa_rules_t();
    l_qa_rules             qa_rules_t := new qa_rules_t();
    l_invalid_objects      qa_rules_t := new qa_rules_t();
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
  begin
  
    -- Logging Parameter:
    -- build scheme names string:
    l_scheme_names := qa_utils_pkg.f_get_table_as_string(pi_table     => pi_scheme_names
                                                        ,pi_separator => ',');
  
    -- Logging Parameter:
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_qaru_rule_number'
                              ,p_val_02  => pi_qaru_rule_number
                              ,p_name_03 => 'pi_scheme_names'
                              ,p_val_03  => l_scheme_names);
  
  
    for i in pi_scheme_names.first .. pi_scheme_names.last
    loop
      l_qa_rules_temp := qa_api_pkg.tf_run_rule(pi_qaru_client_name => pi_qaru_client_name
                                               ,pi_qaru_rule_number => pi_qaru_rule_number
                                               ,pi_target_scheme    => pi_scheme_names(i));
    
      l_qa_rules := l_qa_rules multiset union l_qa_rules_temp;
    end loop;
  
    l_qaru_exclude_objects := f_get_excluded_objects(pi_qaru_rule_number => pi_qaru_rule_number
                                                    ,pi_qaru_client_name => pi_qaru_client_name);
  
    select qa_rule_t(pi_scheme_name    => scheme_name
                    ,pi_object_name    => object_name
                    ,pi_object_details => object_details
                    ,pi_error_message  => error_message)
    bulk collect
    into l_invalid_objects
    from (select rule.scheme_name        as scheme_name
                ,rule.object_name        as object_name
                ,rule.object_details     as object_details
                ,rule.qaru_error_message as error_message
          from table(l_qa_rules) rule
          join qa_rules qaru on qaru.qaru_id = rule.qaru_id
          where qaru.qaru_exclude_objects is null
          or not (rule.object_name in (select regexp_substr(l_qaru_exclude_objects
                                                          ,'[^:]+'
                                                          ,1
                                                          ,level) as data
                                      from dual
                                      connect by regexp_substr(l_qaru_exclude_objects
                                                              ,'[^:]+'
                                                              ,1
                                                              ,level) is not null))
          group by rule.qaru_id
                  ,rule.scheme_name
                  ,rule.object_name
                  ,rule.object_details
                  ,rule.qaru_error_message);
  
    return l_invalid_objects;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get invalid scheme objects!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_invalid_objects;

  -- get invalid objects for a rule by providing one or more schemes
  function f_get_amount_invalid_objects_per_scheme
  (
    pi_qa_rules     in qa_rules_t
   ,pi_scheme_names in varchar2_tab_t
  ) return qa_scheme_object_amounts_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_amount_invalid_objects_per_scheme';
    l_param_list qa_logger_pkg.tab_param;
  
    l_scheme_object_amounts_temp qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();
    l_scheme_object_amounts      qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();
  begin
  
    for i in pi_scheme_names.first .. pi_scheme_names.last
    loop
    
      select qa_scheme_object_amount_t(pi_scheme_name   => pi_scheme_names(i)
                                      ,pi_object_amount => object_amount)
      bulk collect
      into l_scheme_object_amounts_temp
      from (select count(1) as object_amount
            from table(pi_qa_rules) rule
            where rule.scheme_name = pi_scheme_names(i));
    
      l_scheme_object_amounts := l_scheme_object_amounts multiset union l_scheme_object_amounts_temp;
    end loop;
  
    return l_scheme_object_amounts;
  exception
    when others then
      raise;
  end f_get_amount_invalid_objects_per_scheme;

  -- @see spec
  procedure p_test_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_scheme_names     in varchar2_tab_t
   ,po_result           out number
   ,po_scheme_objects   out qa_scheme_object_amounts_t
   ,po_invalid_objects  out qa_rules_t
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_test_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_scheme_names          varchar2(32767);
    l_qa_rules              qa_rules_t := new qa_rules_t();
    l_scheme_object_amounts qa_scheme_object_amounts_t := new qa_scheme_object_amounts_t();
    l_count_objects         number;
  
  begin
  
    -- Logging Paramter:
    -- build scheme names string:
    l_scheme_names := qa_utils_pkg.f_get_table_as_string(pi_table     => pi_scheme_names
                                                        ,pi_separator => ',');

    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_qaru_rule_number'
                              ,p_val_02  => pi_qaru_rule_number
                              ,p_name_03 => 'pi_scheme_names'
                              ,p_val_03  => l_scheme_names);
  
    l_qa_rules := f_get_invalid_objects(pi_qaru_client_name => pi_qaru_client_name
                                       ,pi_qaru_rule_number => pi_qaru_rule_number
                                       ,pi_scheme_names     => pi_scheme_names);
  
    l_scheme_object_amounts := f_get_amount_invalid_objects_per_scheme(pi_qa_rules     => l_qa_rules
                                                                      ,pi_scheme_names => pi_scheme_names);
  
    select count(1)
    into l_count_objects
    from table(l_qa_rules);
  
    if l_qa_rules is not null and
       l_qa_rules.count > 0 and
       l_count_objects > 0
    then
      po_result := 0;
    else
      po_result := 1;
    end if;
  
    po_scheme_objects  := l_scheme_object_amounts;
    po_invalid_objects := l_qa_rules;
  
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to test a rule!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_test_rule;

  -- @see spec
  function f_insert_rule
  (
    pi_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name     in qa_rules.qaru_client_name%type
   ,pi_qaru_name            in qa_rules.qaru_name%type
   ,pi_qaru_category        in qa_rules.qaru_category%type
   ,pi_qaru_object_types    in qa_rules.qaru_object_types%type
   ,pi_qaru_error_message   in qa_rules.qaru_error_message%type
   ,pi_qaru_comment         in qa_rules.qaru_comment%type default null
   ,pi_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,pi_qaru_error_level     in qa_rules.qaru_error_level%type
   ,pi_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,pi_qaru_sql             in qa_rules.qaru_sql%type
   ,pi_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,pi_qaru_layer           in qa_rules.qaru_layer%type
  ) return qa_rules.qaru_id%type is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_insert_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_id qa_rules.qaru_id%type;
  begin
    -- Logging Paramter:
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_qaru_name'
                              ,p_val_03  => pi_qaru_name
                              ,p_name_04 => 'pi_qaru_category'
                              ,p_val_04  => pi_qaru_category
                              ,p_name_05 => 'pi_qaru_object_types'
                              ,p_val_05  => pi_qaru_object_types
                              ,p_name_06 => 'pi_qaru_error_message'
                              ,p_val_06  => pi_qaru_error_message
                              ,p_name_07 => 'pi_qaru_comment'
                              ,p_val_07  => pi_qaru_comment
                              ,p_name_08 => 'pi_qaru_exclude_objects'
                              ,p_val_09  => pi_qaru_exclude_objects
                              ,p_name_10 => 'pi_qaru_error_level'
                              ,p_val_10  => pi_qaru_error_level
                              ,p_name_11 => 'pi_qaru_is_active'
                              ,p_val_11  => pi_qaru_is_active
                              ,p_name_12 => 'pi_qaru_sql'
                              ,p_val_12  => pi_qaru_sql
                              ,p_name_13 => 'pi_qaru_predecessor_ids'
                              ,p_val_13  => pi_qaru_predecessor_ids
                              ,p_name_14 => 'pi_qaru_layer'
                              ,p_val_14  => pi_qaru_layer);
  
  
    insert into qa_rules
      (qaru_rule_number
      ,qaru_client_name
      ,qaru_name
      ,qaru_category
      ,qaru_object_types
      ,qaru_error_message
      ,qaru_comment
      ,qaru_exclude_objects
      ,qaru_error_level
      ,qaru_is_active
      ,qaru_sql
      ,qaru_predecessor_ids
      ,qaru_layer)
    values
      (pi_qaru_rule_number
      ,pi_qaru_client_name
      ,pi_qaru_name
      ,pi_qaru_category
      ,pi_qaru_object_types
      ,pi_qaru_error_message
      ,pi_qaru_comment
      ,pi_qaru_exclude_objects
      ,pi_qaru_error_level
      ,pi_qaru_is_active
      ,pi_qaru_sql
      ,pi_qaru_predecessor_ids
      ,pi_qaru_layer)
    returning qaru_id into l_qaru_id;
  
    return l_qaru_id;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to insert a rule!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_insert_rule;


  -- deletes the entries in qa_rules_t for which exists an entry in quaru_excluded_ebjects for the belonging rule
  procedure p_exclude_objects(pi_qa_rules in out nocopy qa_rules_t) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.exclude_objects';
    l_param_list qa_logger_pkg.tab_param;
  
    type t_exluded_obj is table of varchar2(32676) index by binary_integer;
    l_excluded_objects t_exluded_obj;
    l_excluded         varchar2(32676);
  
  begin
    if pi_qa_rules.count > 0
    then
      for i in pi_qa_rules.first .. pi_qa_rules.last
      loop
        null;
      
        select qaru_exclude_objects
        into l_excluded
        from qa_rules q
        where q.qaru_id = pi_qa_rules(i).qaru_id;
      
        select regexp_substr(l_excluded
                            ,'[^:]+'
                            ,1
                            ,level)
        bulk collect
        into l_excluded_objects
        from dual
        connect by regexp_substr(l_excluded
                                ,'[^:]+'
                                ,1
                                ,level) is not null;
      
        if l_excluded_objects.count > 0
        then
          for excl in l_excluded_objects.first .. l_excluded_objects.last
          loop
            if upper(l_excluded_objects(excl)) = upper(pi_qa_rules(i).object_name)
            then
              pi_qa_rules.delete(i);
              exit;
            end if;
          
          end loop;
        end if;
        l_excluded_objects.delete;
        l_excluded := null;
      
      end loop;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while checking for excluded Objects!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
  end p_exclude_objects;

  function f_check_for_loop
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type default null
   ,pi_client_name      in qa_rules.qaru_client_name%type default null
  ) return qa_rules.qaru_rule_number%type is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_check_for_loop';
    l_param_list qa_logger_pkg.tab_param;
  
    l_no_loop          number;
    l_loop_rule_number qa_rules.qaru_rule_number%type;
    loop_detect_e      exception;
    pragma exception_init(loop_detect_e
                         ,-1436);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number);
  
    for i in (select qaru_rule_number as rule_number
              from qa_rules q
              where q.qaru_predecessor_ids is not null
              and (pi_qaru_rule_number is null or pi_qaru_rule_number = q.qaru_rule_number)
              and (pi_client_name is null or pi_client_name = q.qaru_client_name))
    loop
      l_loop_rule_number := i.rule_number;
      with splitted_pred as
       (select distinct t.qaru_rule_number
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
      select distinct 1
      into l_no_loop
      from splitted_pred
      connect by prior qaru_rule_number = predec
      start with qaru_rule_number = i.rule_number;
    
    end loop;
    return null;
  
  exception
    when loop_detect_e then
      qa_logger_pkg.p_qa_log(p_text   => 'A loop in the predecessor order is detected for the rule_number: ' || l_loop_rule_number || ' Please resolve and start the testrun again!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      dbms_output.put_line('The Rule Number contains a predecessor Loop: ' || l_loop_rule_number);
      raise;
      return l_loop_rule_number;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'Something went wrong when searching for loops in the predecessor order for rule_number: ' || l_loop_rule_number
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
      return l_loop_rule_number;
  end f_check_for_loop;

  function f_get_full_rule_pred(pi_rule_number in qa_rules.qaru_rule_number%type) return varchar2 is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_full_rule_pred';
    l_param_list qa_logger_pkg.tab_param;
  
    l_rule_predecessors varchar2(4000 char);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_rule_number'
                              ,p_val_01  => pi_rule_number);
    for i in (select distinct trim(regexp_substr(q.qaru_predecessor_ids
                                                ,'[^:]+'
                                                ,1
                                                ,level)) pred
              from qa_rules q
              where qaru_rule_number = pi_rule_number
              connect by nocycle instr(q.qaru_predecessor_ids
                              ,':'
                              ,1
                              ,level - 1) > 0
              order by pred desc)
    loop
      if i.pred is not null
      then
        if f_check_for_loop(pi_qaru_rule_number => pi_rule_number) is null
        then
          l_rule_predecessors := l_rule_predecessors || i.pred || ', ' || f_get_full_rule_pred(pi_rule_number => i.pred);
        else
          return null;
        end if;
      else
        return null;
      end if;
    end loop;
    return regexp_replace(l_rule_predecessors
                         ,',[^[:digit:]]*$');
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'Could not create predecessor list!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_full_rule_pred;

  procedure p_exclude_not_owned_entries
  (
    pi_current_user in varchar2
   ,pi_qa_rules_t   in out qa_rules_t
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_exclude_not_owned_entries';
  
    l_param_list qa_logger_pkg.tab_param;
    l_count      number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_current_user'
                              ,p_val_01  => pi_current_user);
  
    if pi_qa_rules_t.count > 0
    then
      for i in pi_qa_rules_t.first .. pi_qa_rules_t.last
      loop
        select count(1)
        into l_count
        from all_objects
        where object_name = pi_qa_rules_t(i).object_name
        and owner = upper(pi_current_user);
        if l_count = 0
        then
          dbms_output.put_line('remove obsolete entries');
          pi_qa_rules_t.delete(i);
        end if;
      end loop;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'Cant remove Objects from qa_rules Table Record that dont belong to the current owner!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_exclude_not_owned_entries;

  function f_is_owner_black_listed(pi_user_name varchar2) return boolean is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_is_owner_black_listed';
  
    l_param_list qa_logger_pkg.tab_param;
  
    l_count            number;
    l_result           boolean;
    e_user_blacklisted exception;
    pragma exception_init(e_user_blacklisted
                         ,-20006);
  begin
  
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_user_name'
                              ,p_val_01  => pi_user_name);
  
    if pi_user_name is not null
    then
      select count(1)
      into l_count
      from qa_scheme_names_for_testing_v v
      where upper(v.username) = upper(pi_user_name);
    
      if l_count = 0
      then
        l_result := true;
        raise e_user_blacklisted;
      else
        l_result := false;
      end if;
    
      return l_result;
    
    else
      return false;
    end if;
  exception
    when e_user_blacklisted then
      raise_application_error(-20007
                             ,qa_constant_pkg.gc_black_list_exception_text || pi_user_name);
      qa_logger_pkg.p_qa_log(p_text   => qa_constant_pkg.gc_black_list_exception_text || pi_user_name
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error trying to determine if a User is Blacklisted'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_is_owner_black_listed;

end qa_main_pkg;
/