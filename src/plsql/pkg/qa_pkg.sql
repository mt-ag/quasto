create or replace package qa_pkg as
  -- procedure for testing a qa rule
  procedure test_rule
  (
    pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,po_result           out number
   ,po_object_names     out clob
   ,po_error_message    out varchar2
  );

  -- function for inserting a new rule
  -- the function determines the next id and encapsulates the insert operation for new rules
  function insert_rule
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
  
  -- Function to eveluate a rule for one client
  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rules_t
    pipelined;
  function run_rules(pi_qaru_client_name in qa_rules.qaru_client_name%type) return qa_rules_t;

end qa_pkg;
/
create or replace package body qa_pkg as

  c_cr constant varchar2(10) := utl_tcp.crlf;

  -- merge rule results
  -- $param pio_rule_results complete list of results
  -- $param pi_rule_results2 talbe of one ruleset
  procedure p_merge_rule_results
  (
    pio_rule_results in out qa_rules_t
   ,pi_rule_results2 in qa_rules_t
  ) is
    l_next number;
  begin
    -- if first Result-Array is empty and second Result-Array is not, then assign the second Array to the first
    if pio_rule_results is null and
       pi_rule_results2 is not null and
       pi_rule_results2.count > 0
    then
      pio_rule_results := pi_rule_results2;
      -- if first and second Result-Array are not empty then merge both entrys
    elsif pio_rule_results is not null and
          pi_rule_results2 is not null and
          pi_rule_results2.count > 0
    then
      for i in pi_rule_results2.first .. pi_rule_results2.last
      loop
        pio_rule_results.extend;
        l_next := pio_rule_results.last;
        pio_rule_results(l_next) := pi_rule_results2(i);
      end loop;
    end if;
  exception
    when others then
      dbms_output.put_line('could not merge rule results');
      raise;
  end p_merge_rule_results;
  -- run a single rule
  -- %param pi_qaru_rule_number number to identify the rule combined with client name is unique
  -- %param pi_qaru_client_name client name 
  function tf_run_rule
  (
    pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
  ) return qa_rules_t
    pipelined is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.tf_run_rule';
    c_param_list constant varchar2(32767) := 'pi_qaru_rule_number=' || pi_qaru_rule_number || c_cr || --
                                             'pi_qaru_client_name=' || pi_qaru_client_name;
  
    l_qaru_sql   varchar2(32767);
    l_qaru_layer qa_rules.qaru_layer%type;
    l_qa_rules   qa_rules_t;
  
    l_qaru_id      number;
    l_apex_app_id  number;
    l_apex_page_id number;
  
  
  
  begin
  
    select qaru_id
          ,qaru.qaru_sql
          ,qaru.qaru_layer
    into l_qaru_id
        ,l_qaru_sql
        ,l_qaru_layer
    from qa_rules qaru
    where qaru.qaru_rule_number = pi_qaru_rule_number
    and qaru.qaru_client_name = pi_qaru_client_name;
  
    execute immediate l_qaru_sql bulk collect
      into l_qa_rules
      using l_qaru_id, l_apex_app_id, l_apex_page_id;
    for i in 1 .. l_qa_rules.count
    loop
      pipe row(l_qa_rules(i));
    end loop;
    return;
  exception
    when no_data_needed then
      -- table function mit Zeilen die nicht benoetigt werden werfen diesen Fehler
      null;
    when others then
      dbms_output.put_line(l_qaru_sql);
      dbms_output.put_line(c_unit);
      dbms_output.put_line(c_param_list);
      raise;
  end tf_run_rule;

  -- run all rules which are active
  function run_rules(pi_qaru_client_name in qa_rules.qaru_client_name%type) return qa_rules_t is
    l_qa_rules      qa_rules_t := new qa_rules_t();
    l_qa_rules_temp qa_rules_t := new qa_rules_t();
  begin
    for r in (select qaru.qaru_rule_number
                    ,qaru.qaru_client_name
              from qa_rules qaru
              where qaru.qaru_client_name = pi_qaru_client_name
              and qaru.qaru_is_active = 1
              and qaru.qaru_error_level <= 4
              order by qaru.qaru_error_level
                      ,qaru.qaru_predecessor_ids nulls first)
    loop
      select tf_run_rule(pi_qaru_rule_number => r.qaru_rule_number, pi_qaru_client_name => pi_qaru_client_name)
      into l_qa_rules_temp
      from dual;
      p_merge_rule_results(pio_rule_results => l_qa_rules
      ,pi_rule_results2 => l_qa_rules_temp);

    end loop;
    return l_qa_rules;
  exception
    when others then
      raise;
  end run_rules;

  -- get excluded objects for a rule
  function fc_get_excluded_objects
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
  end fc_get_excluded_objects;

  -- @see spec
  procedure test_rule
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
    l_qaru_exclude_objects := fc_get_excluded_objects(pi_qaru_rule_number => pi_qaru_rule_number
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
  end test_rule;

  -- @see spec
  function insert_rule
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
  end insert_rule;

end qa_pkg;
/