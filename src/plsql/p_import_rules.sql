create or replace procedure p_import_rules(pi_data in clob) is
  l_action varchar2(5000 char);
begin
  if pi_data is not null
  then
    for i in (select *
              from json_table(pi_data
                             ,'$.qa_rules[*]' columns(nested path '$.qaru_client_names[*]' columns(qaru_client_name varchar2(400 char) path '$.qaru_client_name'
                                             ,nested path '$.qaru_categories[*]' columns(qaru_category varchar2(400 char) path '$.qaru_category'
                                                     ,nested path '$.rules[*]' columns(qaru_rule_number varchar2(400 char) path '$.qaru_rule_number'
                                                             ,qaru_name varchar2(400 char) path '$.qaru_name'
                                                             ,qaru_object_types varchar2(400 char) path '$.qaru_object_types'
                                                             ,qaru_error_message varchar2(400 char) path '$.qaru_error_message'
                                                             ,qaru_comment varchar2(400 char) path '$.qaru_comment'
                                                             ,qaru_exclude_objects varchar2(400 char) path '$.qaru_exclude_objects'
                                                             ,qaru_error_level varchar2(400 char) path '$.qaru_error_level'
                                                             ,qaru_is_active varchar2(400 char) path '$.qaru_is_active'
                                                             ,qaru_sql varchar2(400 char) path '$.qaru_sql'
                                                             ,qaru_predecessor_ids varchar2(400 char) path '$.qaru_predecessor_ids'
                                                             ,qaru_layer varchar2(400 char) path '$.qaru_layer'))))))
    loop
      l_action := 'insert into qa_rules ( qaru_client_name
                                         ,qaru_name
                                         ,qaru_category
                                         ,qaru_object_types
                                         ,qaru_error_message
                                         ,qaru_error_message
                                         ,qaru_comment
                                         ,qaru_error_level
                                         ,qaru_is_active
                                         ,qaru_sql
                                         ,qaru_predecessor_ids
                                         ,qaru_layer
                                         ,qaru_rule_number) values ( '|| i.qaru_client_name || '
                                                                    ,'|| i.qaru_name || '
                                                                    ,'|| i.qaru_category || '
                                                                    ,'|| i.qaru_object_types || '
                                                                    ,'|| i.qaru_error_message || '
                                                                    ,'|| i.qaru_comment || '
                                                                    ,'|| i.qaru_exclude_objects || '
                                                                    ,'|| i.qaru_error_level || '
                                                                    ,'|| i.qaru_is_active || '
                                                                    ,'|| i.qaru_sql || '
                                                                    ,'|| i.qaru_predecessor_ids || '
                                                                    ,'|| i.qaru_layer || '
                                                                    ,'|| i.qaru_rule_number || ')';
      dbms_output.put_line(l_action);
    end loop;
  end if;
end p_import_rules;
/