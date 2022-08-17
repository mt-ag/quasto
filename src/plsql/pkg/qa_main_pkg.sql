create or replace package qa_main_pkg authid definer as

  -- get sql and id from rule
  -- %param pi_qaru_rule_number 
  -- %param pi_qaru_client_name 
  -- %param po_qaru_id 
  -- %param po_qaru_sql 
  procedure p_get_rule_sql_and_id
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,po_qaru_id          out qa_rules.qaru_id%type
   ,po_qaru_sql         out qa_rules.qaru_sql%type
  );

  -- get all rulenumbers from one client/project
  -- %param pi_qaru_client_name 
  function tf_get_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t;

  -- procedure for testing a qa rule
  -- %param pi_qaru_client_name 
  -- %param pi_qaru_rule_number 
  -- %param po_result 
  -- %param po_object_names 
  -- %param po_error_message 
  procedure p_test_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,po_result           out number
   ,po_object_names     out clob
   ,po_error_message    out varchar2
  );

  -- function for inserting a new rule
  -- the function determines the next id and encapsulates the insert operation for new rules
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

end qa_main_pkg;
/
create or replace package body qa_main_pkg as

  c_cr constant varchar2(10) := utl_tcp.crlf;

  procedure p_get_rule_sql_and_id
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,po_qaru_id          out qa_rules.qaru_id%type
   ,po_qaru_sql         out qa_rules.qaru_sql%type
  ) is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.p_get_rule_sql_and_id';
    c_param_list constant varchar2(32767) := 'pi_qaru_rule_number=' || pi_qaru_rule_number || c_cr || --
                                             'pi_qaru_client_name=' || pi_qaru_client_name;
  begin
    select qaru_id
          ,qaru.qaru_sql
    into po_qaru_id
        ,po_qaru_sql
    from qa_rules qaru
    where qaru.qaru_rule_number = pi_qaru_rule_number
    and qaru.qaru_client_name = pi_qaru_client_name;
  exception
    when no_data_found then
      dbms_output.put_line(c_unit);
      dbms_output.put_line('Rule not found');
      dbms_output.put_line(c_param_list);
    when others then
      dbms_output.put_line(c_unit);
      dbms_output.put_line('Error by getting rule');
      dbms_output.put_line(c_param_list);
      raise;
  end p_get_rule_sql_and_id;


  function tf_get_rule_numbers(pi_qaru_client_name in qa_rules.qaru_client_name%type) return varchar2_tab_t is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.tf_get_rule_numbers';
    c_param_list constant varchar2(32767) := 'pi_qaru_client_name=' || pi_qaru_client_name;
  
    l_qaru_rule_numbers varchar2_tab_t;
  begin
    select q.qaru_rule_number
    bulk collect
    into l_qaru_rule_numbers
    from qa_rules q
    where q.qaru_client_name = pi_qaru_client_name
    and q.qaru_is_active = 1
    and q.qaru_error_level <= 4
    order by q.qaru_error_level
            ,q.qaru_predecessor_ids nulls first;
  
    return l_qaru_rule_numbers;
  exception
    when no_data_found then
      dbms_output.put_line(c_unit);
      dbms_output.put_line('No rules not found');
      dbms_output.put_line(c_param_list);
      raise;
    when others then
      dbms_output.put_line(c_unit);
      dbms_output.put_line('Error by getting rules from client/project');
      dbms_output.put_line(c_param_list);
      raise;
  end tf_get_rule_numbers;

  -- get excluded objects for a rule
  function f_get_excluded_objects
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rules.qaru_exclude_objects%type result_cache is
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
  begin
    select p.qaru_exclude_objects
    into l_qaru_exclude_objects
    from qa_rules p
    where p.qaru_rule_number = pi_qaru_rule_number
    and p.qaru_client_name = pi_qaru_client_name;
  
    return l_qaru_exclude_objects;
  exception
    when others then
      raise;
  end f_get_excluded_objects;

  -- @see spec
  procedure p_test_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,po_result           out number
   ,po_object_names     out clob
   ,po_error_message    out varchar2
  ) is
    l_qa_rules             qa_rules_t;
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
    l_count_objects        number;
    l_object_names         clob;
    l_qaru_error_message   qa_rules.qaru_error_message%type;
  begin
    l_qaru_exclude_objects := f_get_excluded_objects(pi_qaru_rule_number => pi_qaru_rule_number
                                                    ,pi_qaru_client_name => pi_qaru_client_name);
  
    select count(1)
    into l_count_objects
    from table(l_qa_rules) rule
    join qa_rules qaru on qaru.qaru_id = rule.qaru_id
    where qaru.qaru_exclude_objects is null
    or not (rule.object_name in (select regexp_substr(l_qaru_exclude_objects
                                                    ,'[^,]+'
                                                    ,1
                                                    ,level) as data
                                from dual
                                connect by regexp_substr(l_qaru_exclude_objects
                                                        ,'[^,]+'
                                                        ,1
                                                        ,level) is not null));
  
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
      where qaru.qaru_exclude_objects is null
      or not (rule.object_name in (select regexp_substr(l_qaru_exclude_objects
                                                      ,'[^,]+'
                                                      ,1
                                                      ,level) as data
                                  from dual
                                  connect by regexp_substr(l_qaru_exclude_objects
                                                          ,'[^,]+'
                                                          ,1
                                                          ,level) is not null))
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
    l_qaru_id qa_rules.qaru_id%type;
  begin
  
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
      raise;
  end f_insert_rule;

end qa_main_pkg;
/
