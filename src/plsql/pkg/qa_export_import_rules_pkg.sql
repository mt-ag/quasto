create or replace package qa_export_import_rules_pkg is

  gc_scope constant varchar2(100) := $$plsql_unit || '.';
  g_version_number number := 1.1;

  -- if spool set to active, all outputs are deactivated
  -- otherwise you would get extra lines in your JSON
  g_spool_active boolean := false;

  function f_export_rules_table_to_clob
  (
    pi_client_name in qa_rules.qaru_client_name%type
   ,pi_category    in qa_rules.qaru_category%type default null
  ) return clob;

  -- Wrapper Function to create an executable .sql Script to import Rules
  function f_export_rules_to_script_clob(pi_clob in clob) return clob;

  procedure p_clob_to_output(pi_clob in clob);

  procedure p_import_clob_to_rules_table(pi_clob in clob);

  /* will be removed in future */
  function fc_export_qa_rules(pi_client_name in varchar2 default null) return clob;

end qa_export_import_rules_pkg;
/
create or replace package body qa_export_import_rules_pkg is

  procedure p_print(pi_text in varchar2) is
  begin
    if not g_spool_active
    then
      dbms_output.put_line(pi_text);
    end if;
  end p_print;

  function f_export_rules_table_to_clob
  (
    pi_client_name in qa_rules.qaru_client_name%type
   ,pi_category    in qa_rules.qaru_category%type default null
  ) return clob is
    c_scope constant varchar2(100) := gc_scope || 'f_export_rules_table_to_clob';
  
    l_count_rules            number;
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
    select count(1)
    into l_count_rules
    from qa_rules r
    where (pi_client_name is null or pi_client_name = r.qaru_client_name)
    and (pi_category is null or pi_category = r.qaru_category);
  
    if l_count_rules = 0
    then
      p_print('No rules found.');
      return null;
    else
      p_print('Exporting ' || l_count_rules || ' rules with CLIENT_NAME=' || pi_client_name || ' and CATEGORY=' || pi_category);
    
      -- for each client_name
      for client in (select qaru_client_name
                     from qa_rules
                     where pi_client_name is null
                     or qaru_client_name = pi_client_name
                     group by qaru_client_name
                     order by qaru_client_name)
      
      loop
        -- for each category
        for category in (select qaru_category
                         from qa_rules
                         where qaru_client_name = client.qaru_client_name
                         and (pi_category is null or pi_category = qaru_category)
                         group by qaru_category
                         order by qaru_category)
        loop
          -- generate empty json objects to append to the main array later
          l_category_json    := json_object_t();
          l_rules_array_json := json_array_t();
          -- for each rule per client and category
          for rules in (select qaru_client_name
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
                        where qaru_client_name = client.qaru_client_name
                        and qaru_category = category.qaru_category)
          loop
            l_rule_json := json_object_t();
            l_rule_json.put('rule_number'
                           ,rules.qaru_rule_number);
            l_rule_json.put('name'
                           ,rules.qaru_name);
            l_rule_json.put('object_types'
                           ,rules.qaru_object_types);
            l_rule_json.put('error_message'
                           ,rules.qaru_error_message);
            l_rule_json.put('comment'
                           ,rules.qaru_comment);
            l_rule_json.put('exclude_objects'
                           ,rules.qaru_exclude_objects);
            l_rule_json.put('error_level'
                           ,rules.qaru_error_level);
            l_rule_json.put('is_active'
                           ,rules.qaru_is_active);
            -- currently there is a problem formatting the sql
            l_rule_json.put('sql'
                           ,rules.qaru_sql);
            l_rule_json.put('predecessor_ids'
                           ,nvl(rules.qaru_predecessor_ids
                               ,''));
            l_rule_json.put('layer'
                           ,rules.qaru_layer);
            l_rules_array_json.append(l_rule_json);
          end loop;
        
          l_category_json.put('category'
                             ,category.qaru_category);
          l_category_json.put('rules'
                             ,l_rules_array_json);
          l_category_array_json.append(l_category_json);
        end loop;
      
        l_client_name_json.put('client_name'
                              ,client.qaru_client_name);
        l_client_name_json.put('categories'
                              ,l_category_array_json);
      end loop;
    
      l_client_name_array_json.append(l_client_name_json);
      l_client_names_json.put('client_names'
                             ,l_client_name_array_json);
      l_main_array_json.append(l_client_names_json);
      l_main_json.put('version'
                     ,g_version_number);
      l_main_json.put('qa_rules'
                     ,l_main_array_json);
    
      l_clob := l_main_json.to_clob;
      select json_serialize(l_clob returning clob pretty)
      into l_pretty_print
      from dual;
      return l_pretty_print;
    end if;
  end f_export_rules_table_to_clob;

  -- Experimental Function to Export A Json as an executable script
  function f_export_rules_to_script_clob(pi_clob in clob) return clob is
    l_clob clob;
    l_sql  clob;
  begin
    l_clob := 'set serveroutput on;' || chr(10);
    dbms_lob.append(l_clob
                   ,'declare' || chr(10));
    dbms_lob.append(l_clob
                   ,'  l_clob clob;' || chr(10));
    dbms_lob.append(l_clob
                   ,'begin' || chr(10));
    for f in (select line
              from dual
                  ,lateral (select regexp_substr(pi_clob
                                               ,'.+'
                                               ,1
                                               ,level
                                               ,'m') line
                           from dual
                           connect by level <= regexp_count(pi_clob
                                                           ,'.+'
                                                           ,1
                                                           ,'m')))
    loop
      if dbms_lob.instr(f.line
                       ,'"sql" : "') > 0 --and 1=0
      then
        null;
        l_sql := replace_with_clob(i_source  => f.line,
                          i_search  => '\n',
                          i_replace => 'chr(10)');
        /*select qaru_sql
        into l_sql
        from json_table(f.line
                       ,'$.qa_rules[*]' columns(nested path '$.client_names[*]' columns(nested path '$.categories[*]' columns(nested path '$.rules[*]' columns(qaru_sql varchar2(400 char) path '$.sql')))));
      */
        dbms_lob.append(l_clob
                       ,'dbms_lob.append(l_clob,' || 'q' || '''' || '[' || l_sql || ']' || ''');' || chr(10));
      else
        dbms_lob.append(l_clob
                       ,'dbms_lob.append(l_clob,' || 'q' || '''' || '[' || f.line || ']' || ''');' || chr(10));
      end if;
    end loop;
    dbms_lob.append(l_clob
                   ,chr(10) || 'quasto.qa_export_import_rules_pkg.p_import_clob_to_rules_table(pi_clob => l_clob);' || chr(10));
    dbms_lob.append(l_clob
                   ,'end;' || chr(10) || '/');
  
    return l_clob;
  end f_export_rules_to_script_clob;


  procedure p_clob_to_output(pi_clob in clob) is
    l_offset int := 1;
    l_step   number := 32767;
  begin
    dbms_output.enable(buffer_size => 10000000);
    loop
      exit when l_offset > dbms_lob.getlength(pi_clob);
      dbms_output.put_line(dbms_lob.substr(pi_clob
                                          ,l_step
                                          ,l_offset));
      l_offset := l_offset + l_step;
    end loop;
  end p_clob_to_output;


  procedure p_import_clob_to_rules_table(pi_clob in clob) is
  begin
    if pi_clob is not null
    then
/*      insert into qa_import_files
        (qaif_id
        ,qaif_clob_data
        ,qaif_import_date)
      values
        (null
        ,pi_clob
        ,trunc(sysdate));*/
      for i in (select *
                from json_table(pi_clob
                               ,'$.qa_rules[*]' columns(nested path '$.client_names[*]' columns(qaru_client_name varchar2(400 char) path '$.client_name'
                                               ,nested path '$.categories[*]' columns(qaru_category varchar2(400 char) path '$.category'
                                                       ,nested path '$.rules[*]' columns(qaru_rule_number varchar2(400 char) path '$.rule_number'
                                                               ,qaru_name varchar2(400 char) path '$.name'
                                                               ,qaru_object_types varchar2(400 char) path '$.object_types'
                                                               ,qaru_error_message varchar2(400 char) path '$.error_message'
                                                               ,qaru_comment varchar2(400 char) path '$.comment'
                                                               ,qaru_exclude_objects varchar2(400 char) path '$.exclude_objects'
                                                               ,qaru_error_level number path '$.error_level'
                                                               ,qaru_is_active number path '$.is_active'
                                                               ,qaru_sql varchar2(400 char) path '$.sql'
                                                               ,qaru_predecessor_ids varchar2(400 char) path '$.predecessor_ids'
                                                               ,qaru_layer varchar2(400 char) path '$.layer'))))))
      loop
        dbms_output.put_line('MERGE CLIENT_NAME=' || i.qaru_client_name || ' RULE_NUMBER=' || i.qaru_rule_number);
      
        merge into qa_rules r
        using dual
        on (r.qaru_client_name = i.qaru_client_name and r.qaru_rule_number = i.qaru_rule_number)
        when matched then
          update
          set r.qaru_category        = i.qaru_category
             ,r.qaru_comment         = i.qaru_comment
             ,r.qaru_error_level     = i.qaru_error_level
             ,r.qaru_error_message   = i.qaru_error_message
             ,r.qaru_exclude_objects = i.qaru_exclude_objects
             ,r.qaru_is_active       = i.qaru_is_active
             ,r.qaru_layer           = i.qaru_layer
             ,r.qaru_name            = i.qaru_name
             ,r.qaru_object_types    = i.qaru_object_types
             ,r.qaru_predecessor_ids = i.qaru_predecessor_ids
             ,r.qaru_sql             = i.qaru_sql
        when not matched then
          insert
            (r.qaru_client_name
            ,r.qaru_rule_number
            ,r.qaru_category
            ,r.qaru_comment
            ,r.qaru_error_level
            ,r.qaru_error_message
            ,r.qaru_exclude_objects
            ,r.qaru_is_active
            ,r.qaru_layer
            ,r.qaru_name
            ,r.qaru_object_types
            ,r.qaru_predecessor_ids
            ,r.qaru_sql)
          values
            (i.qaru_client_name
            ,i.qaru_rule_number
            ,i.qaru_category
            ,i.qaru_comment
            ,i.qaru_error_level
            ,i.qaru_error_message
            ,i.qaru_exclude_objects
            ,i.qaru_is_active
            ,i.qaru_layer
            ,i.qaru_name
            ,i.qaru_object_types
            ,i.qaru_predecessor_ids
            ,i.qaru_sql);
      end loop;
    end if;
  end p_import_clob_to_rules_table;

  function fc_export_qa_rules(pi_client_name in varchar2 default null) return clob is
    type tab_t is table of qa_rules%rowtype;
  
    l_table_name varchar2(50) := 'QA_RULES';
  
    l_tab    tab_t;
    l_return clob;
  begin
  
    if pi_client_name is not null
    then
      select *
      bulk collect
      into l_tab
      from qa_rules qaru
      where qaru.qaru_client_name = pi_client_name
      order by qaru.qaru_id;
    else
      select *
      bulk collect
      into l_tab
      from qa_rules qaru
      order by qaru.qaru_id;
    end if;
  
    l_return := 'SET SERVEROUTPUT ON' || chr(10);
    dbms_lob.append(l_return
                   ,'declare' || chr(10));
    dbms_lob.append(l_return
                   ,'  l_sql clob;' || chr(10));
    dbms_lob.append(l_return
                   ,'begin' || chr(10) || chr(10));
  
    dbms_lob.append(l_return
                   ,'  dbms_output.put_line(''Merging data into table ' || l_table_name || ' started.'');' || chr(10) || chr(10));
  
    for i in 1 .. l_tab.count
    loop
      dbms_lob.append(l_return
                     ,'  l_sql := ''' || replace(l_tab(i).qaru_sql
                                                ,''''
                                                ,'''''') || ''';' || chr(10) || chr(10));
      dbms_lob.append(l_return
                     ,'  merge into ' || l_table_name || ' a' || chr(10));
      dbms_lob.append(l_return
                     ,'    using (select ''' || replace(l_tab(i).qaru_client_name
                                                       ,''''
                                                       ,'''''') || ''' as qaru_client_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_rule_number
                                                       ,''''
                                                       ,'''''') || ''' as qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_name
                                                       ,''''
                                                       ,'''''') || ''' as qaru_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_category
                                                       ,''''
                                                       ,'''''') || ''' as qaru_category,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_object_types
                                                       ,''''
                                                       ,'''''') || ''' as qaru_object_types,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_error_message
                                                       ,''''
                                                       ,'''''') || ''' as qaru_error_message,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_comment
                                                       ,''''
                                                       ,'''''') || ''' as qaru_comment,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_exclude_objects
                                                       ,''''
                                                       ,'''''') || ''' as qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_error_level
                                                       ,''''
                                                       ,'''''') || ''' as qaru_error_level,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_is_active
                                                       ,''''
                                                       ,'''''') || ''' as qaru_is_active,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  l_sql as qaru_sql,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_predecessor_ids
                                                       ,''''
                                                       ,'''''') || ''' as qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return
                     ,'                  ''' || replace(l_tab(i).qaru_layer
                                                       ,''''
                                                       ,'''''') || ''' as qaru_layer' || chr(10));
      dbms_lob.append(l_return
                     ,'             from dual) b' || chr(10));
      dbms_lob.append(l_return
                     ,'    on ( a.qaru_client_name = b.qaru_client_name' || chr(10));
      dbms_lob.append(l_return
                     ,'     and a.qaru_rule_number = b.qaru_rule_number )' || chr(10));
      dbms_lob.append(l_return
                     ,'    when MATCHED then' || chr(10));
      dbms_lob.append(l_return
                     ,'      update' || chr(10));
      dbms_lob.append(l_return
                     ,'         set qaru_name            = b.qaru_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_category        = b.qaru_category,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_object_types    = b.qaru_object_types,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_error_message   = b.qaru_error_message,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_comment         = b.qaru_comment,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_exclude_objects = b.qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_error_level     = b.qaru_error_level,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_is_active       = b.qaru_is_active,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_sql             = b.qaru_sql,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_predecessor_ids = b.qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return
                     ,'             qaru_layer           = b.qaru_layer' || chr(10));
      dbms_lob.append(l_return
                     ,'    when NOT MATCHED then' || chr(10));
      dbms_lob.append(l_return
                     ,'      insert ( qaru_client_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_category,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_object_types,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_error_message,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_comment,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_error_level,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_is_active,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_sql,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return
                     ,'               qaru_layer )' || chr(10));
      dbms_lob.append(l_return
                     ,'      values ( b.qaru_client_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_name,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_category,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_object_types,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_error_message,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_comment,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_error_level,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_is_active,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_sql,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return
                     ,'               b.qaru_layer );' || chr(10) || chr(10));
    end loop;
  
    dbms_lob.append(l_return
                   ,'  commit;' || chr(10));
    dbms_lob.append(l_return
                   ,'  dbms_output.put_line(''Merging data into table ' || l_table_name || ' completed.'');' || chr(10) || chr(10));
    dbms_lob.append(l_return
                   ,'  exception' || chr(10));
    dbms_lob.append(l_return
                   ,'    when others then' || chr(10));
    dbms_lob.append(l_return
                   ,'      dbms_output.put_line(''Merging data into table ' || l_table_name || ' raised exception.'');' || chr(10));
    dbms_lob.append(l_return
                   ,'      rollback;' || chr(10));
    dbms_lob.append(l_return
                   ,'      raise;' || chr(10));
    dbms_lob.append(l_return
                   ,'end;' || chr(10) || '/' || chr(10));
  
    return l_return;
  
  exception
    when others then
      raise;
  end fc_export_qa_rules;

end qa_export_import_rules_pkg;
/
