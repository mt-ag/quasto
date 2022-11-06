create or replace function f_export_qa_rules
(
  pi_client_name       in varchar2
 ,pi_pretty_print_flag in boolean default true
) return clob is
  l_pretty_print           clob;
  l_clob                   clob;
  l_main_json              json_object_t := json_object_t();
  l_main_array_json        json_array_t := json_array_t();
  l_category_array_json    json_array_t := json_array_t();
  l_category_json          json_object_t := json_object_t();
  l_rules_array_json       json_array_t := json_array_t();
  l_rule_json              json_object_t := json_object_t();
  l_client_name_array_json json_array_t := json_array_t();
  l_client_name_json       json_object_t := json_object_t();
  l_client_names_json      json_object_t := json_object_t();
begin
  -- For all client names if specified
  for r in (select distinct qaru_client_name
            from qa_rules
            where qaru_client_name = nvl(pi_client_name
                                        ,qaru_client_name))
  loop
    -- for each category
    for i in (select distinct qaru_category
              from qa_rules
              where qaru_client_name = nvl(pi_client_name
                                          ,qaru_client_name))
    loop
      -- generate empty json objects to append to the main array later
      l_category_json    := json_object_t();
      l_rules_array_json := json_array_t();
      -- for each rule per client and category
      for s in (select qaru_client_name
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
                      ,qaru_layer
                      ,qaru_rule_number
                from qa_rules
                where qaru_client_name = nvl(pi_client_name
                                            ,qaru_client_name)
                and i.qaru_category = qaru_category)
      loop
        l_rule_json := json_object_t();
        l_rule_json.put('qaru_rule_number'
                       ,s.qaru_rule_number);
        l_rule_json.put('qaru_name'
                       ,s.qaru_name);
        l_rule_json.put('qaru_object_types'
                       ,s.qaru_object_types);
        l_rule_json.put('qaru_error_message'
                       ,s.qaru_error_message);
        l_rule_json.put('qaru_comment'
                       ,s.qaru_comment);
        l_rule_json.put('qaru_exclude_objects'
                       ,s.qaru_exclude_objects);
        l_rule_json.put('qaru_error_level'
                       ,s.qaru_error_level);
        l_rule_json.put('qaru_is_active'
                       , --sys.diutil.int_to_bool(s.qaru_rule_number));
                        s.qaru_is_active);
        -- currently there is a problem formatting the sql
        /*l_rule_json.put('qaru_sql'
        ,s.qaru_sql);*/
        l_rule_json.put('qaru_sql'
                       ,'');
        l_rule_json.put('qaru_predecessor_ids'
                       ,nvl(s.qaru_predecessor_ids
                           ,''));
        l_rule_json.put('qaru_layer'
                       ,s.qaru_layer);
        l_rules_array_json.append(l_rule_json);
      end loop;
      l_category_json.put('qaru_category'
                         ,i.qaru_category);
      l_category_json.put('rules'
                         ,l_rules_array_json);
      l_category_array_json.append(l_category_json);
    end loop;
    l_client_name_json.put('qaru_client_name'
                          ,r.qaru_client_name);
    l_client_name_json.put('qaru_categories'
                          ,l_category_array_json);
  end loop;
  l_client_name_array_json.append(l_client_name_json);
  l_client_names_json.put('qaru_client_names'
                         ,l_client_name_array_json);
  l_main_array_json.append(l_client_names_json);
  --dbms_output.put_line(l_main_json.to_string());
  l_main_json.put('qa_rules'
                 ,l_main_array_json);
  if pi_pretty_print_flag
  then
    l_clob := l_main_json.to_clob;
    select json_serialize(l_clob returning clob pretty)
    into l_pretty_print
    from dual;
    return l_pretty_print;
  else
    return l_main_json.to_clob();
  end if;
end;
/