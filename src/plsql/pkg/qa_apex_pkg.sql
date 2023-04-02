create or replace package qa_apex_pkg authid definer as

  -- get sql and id from rule
  -- %param pi_qaru_rule_number 
  -- %param pi_qaru_client_name 
  -- %param po_qaru_id 
  -- %param po_qaru_sql 
  function f_get_apex_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rule_t;

  -- get all rulenumbers from one client/project
  -- %param pi_qaru_client_name 
  function tf_get_apex_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t;

  -- procedure for testing a qa rule
  -- %param pi_qaru_client_name 
  -- %param pi_qaru_rule_number 
  -- %param po_result 
  -- %param po_object_names 
  -- %param po_error_message 
  procedure p_test_apex_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_schema_names     in varchar2_tab_t
   ,po_result           out number
   ,po_object_names     out clob
   ,po_error_message    out varchar2
  );

  -- function for inserting a new rule
  -- the function determines the next id and encapsulates the insert operation for new rules
  function f_insert_apex_rule
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


  procedure p_exclude_apex_objects(pi_qa_rules in out nocopy qa_rules_t);

end qa_apex_pkg;
/
create or replace package body qa_apex_pkg as

  function f_get_apex_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rule_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_apex_rule';
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
    and q.qaru_category = 'Apex';
  
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
  end f_get_apex_rule;

  function tf_get_apex_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_get_apex_rule_numbers';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_rule_numbers varchar2_tab_t;
  begin
  
    -- Logging Paramter:
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name   => 'pi_qaru_client_name'
                              ,p_val    => pi_qaru_client_name);
  
    --Joining with qaru_predecessor_order_v to get the right order based on predecessor list
    select q.qaru_rule_number
    bulk collect
    into l_qaru_rule_numbers
    from qa_rules q
    join qaru_predecessor_order_v p on p.qaru_rule_number = q.qaru_rule_number
    where q.qaru_client_name = pi_qaru_client_name
    and q.qaru_category = 'APEX'
    and q.qaru_is_active = 1
    and q.qaru_error_level <= 4
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
  end tf_get_apex_rule_numbers;

  -- get excluded objects for a rule
  function f_get_excluded_apex_objects
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rules.qaru_exclude_objects%type result_cache is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_excluded_apex_objects';
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
    and p.qaru_category = 'APEX';
  
    return l_qaru_exclude_objects;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to select from qaru_exclude_objects!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_excluded_apex_objects;

  -- @see spec
  procedure p_test_apex_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_schema_names     in varchar2_tab_t
   ,po_result           out number
   ,po_object_names     out clob
   ,po_error_message    out varchar2
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_test_apex_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_schema_names       varchar2(32767);
    l_qa_rules           qa_rules_t := qa_rules_t();
    l_qa_rules_temp      qa_rules_t := new qa_rules_t();
    l_count_objects      number;
    l_object_names       clob;
    l_qaru_error_message qa_rules.qaru_error_message%type;
  
  begin
  
    -- Logging Paramter:
    -- build schema names string:
    for i in pi_schema_names.first .. pi_schema_names.last
    loop
      l_schema_names := pi_schema_names(i) || ',' || l_schema_names;
    
    end loop;
    l_schema_names := substr(l_schema_names
                            ,0
                            ,length(l_schema_names) - 1);
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_client_name'
                              ,p_val_01  => pi_qaru_client_name
                              ,p_name_02 => 'pi_qaru_rule_number'
                              ,p_val_02  => pi_qaru_rule_number
                              ,p_name_03 => 'pi_schema_names'
                              ,p_val_03  => l_schema_names);
    if pi_schema_names.count <> 0
    then
      for i in pi_schema_names.first .. pi_schema_names.last
      loop
        l_qa_rules_temp := qa_api_pkg.tf_run_rule(pi_qaru_client_name => pi_qaru_client_name
                                                 ,pi_qaru_rule_number => pi_qaru_rule_number
                                                 ,pi_target_scheme    => pi_schema_names(i));
        l_qa_rules      := l_qa_rules multiset union l_qa_rules_temp;
      end loop;
      -- Exclude Objects is taking the Table Type in and deleting all Entries that need to be excluded
      p_exclude_apex_objects(pi_qa_rules => l_qa_rules);
    end if;
  
    select count(1)
    into l_count_objects
    from table(l_qa_rules) rule
    join qa_rules qaru on qaru.qaru_id = rule.qaru_id;
  
    if l_qa_rules is not null and
       l_qa_rules.count > 0 and
       l_count_objects > 0
    then
      select rtrim(xmlagg(xmlelement(e, rule.object_name, '; ').extract('//text()') order by rule.object_name).getclobval()
                  ,'; ') as object_names
            ,qaru.qaru_error_message
      into l_object_names
          ,l_qaru_error_message
      from table(l_qa_rules) rule
      join qa_rules qaru on qaru.qaru_id = rule.qaru_id
                     and qaru.qaru_category = 'APEX'
      group by rule.qaru_id
              ,qaru.qaru_error_message;
    
      po_result        := 0;
      po_object_names  := l_object_names;
      po_error_message := l_qaru_error_message;
    else
      po_result        := 1;
      po_object_names  := 'None.';
      po_error_message := 'No Errors.';
    end if;
  
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to test a rule!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_test_apex_rule;

  -- @see spec
  function f_insert_apex_rule
  (
    pi_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name     in qa_rules.qaru_client_name%type
   ,pi_qaru_name            in qa_rules.qaru_name%type
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
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_insert_apex_rule';
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
                              ,p_val_04  => 'APEX'
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
      ,'APEX'
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
  end f_insert_apex_rule;

  -- deletes the entries in qa_rules_t for which exists an entry in quaru_excluded_ebjects for the belonging rule
  procedure p_exclude_apex_objects(pi_qa_rules in out nocopy qa_rules_t) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_exclude_apex_objects';
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
  end p_exclude_apex_objects;

  function tf_run_apex_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
  
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_apex_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qa_rule  qa_rule_t;
    l_qa_rules qa_rules_t;
  
  begin
  
  
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name);
  
  
    l_qa_rule := f_get_apex_rule(pi_qaru_rule_number => pi_qaru_rule_number
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
    -- :8 apex_app_id
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
  end tf_run_apex_rule;


  function tf_run_apex_rules
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_apex_rules';
    l_param_list qa_logger_pkg.tab_param;
  
    l_qaru_rule_numbers varchar2_tab_t;
    l_qa_rules          qa_rules_t := new qa_rules_t();
    l_qa_rules_temp     qa_rules_t := new qa_rules_t();
    l_running_rules     running_rule_t := new running_rule_t();
  
    l_allowed_to_run number;
    l_success        varchar2(1);
  
  begin
  
    select running_rule(t.qaru_rule_number
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
        -- if this rule is not allowed to run, mark this rule as not successfull (N)
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
  end tf_run_apex_rules;

end qa_apex_pkg;
/