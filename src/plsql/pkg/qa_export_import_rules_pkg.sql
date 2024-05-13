create or replace package qa_export_import_rules_pkg is

/******************************************************************************
   NAME:       qa_export_import_rules_pkg
   PURPOSE:    Methods for exporting and importing QUASTO rules

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.1        21.04.2023  pdahlem          Package has been added to QUASTO
******************************************************************************/

  gc_scope constant varchar2(100) := $$plsql_unit || '.';
  g_version_number number := 1.1;

  -- if spool set to active, all outputs are deactivated
  -- otherwise you would get extra lines in your JSON
  g_spool_active boolean := false;

/**
 * function for converting rules table to clob
 * @param  pi_client_name specifies the client name
 * @param  pi_category specifies the rule category
 * @throws NO_DATA_FOUND if rule does not exist
 * @return clob returns the data
*/
  function f_export_rules_table_to_clob
  (
    pi_client_name in qa_rules.qaru_client_name%type
   ,pi_category    in qa_rules.qaru_category%type default null
  ) return clob;

/**
 * Wrapper function to create an executable .sql Script to import Rules
 * @param  pi_clob specifies the clob
 * @throws NO_DATA_FOUND if rule does not exist
 * @return clob returns the data
*/
  function f_export_rules_to_script_clob(
    pi_clob in clob
  ) return clob;

/**
 * function to import a given blob file into qa_import_files table and return id
 * @param  pi_clob specifies the clob
 * @param  pi_filename specifies file name
 * @param  pi_mimetype specifies the MIME type
 * @throws NO_DATA_FOUND if no data found in given clob
 * @return number returns the id
*/
  function f_import_clob_to_qa_import_files
  (
    pi_clob     in clob
   ,pi_filename in qa_import_files.qaif_filename%type
   ,pi_mimetype in qa_import_files.qaif_mimetype%type
  ) return number;

/**
 * procedure to import a given clob into qa_rules table
 * @param  pi_qaif_id specifies the primary key
 * @throws NO_DATA_FOUND if no data found for given qaif_id
*/
  procedure p_import_clob_to_rules_table(
   pi_qaif_id in qa_import_files.qaif_id%type
  );

/* will be removed in future */
/**
 * function to export a rule by a given client name
 * @param  pi_client_name specifies the client name
 * @throws NO_DATA_FOUND if rule does not exist
 * @return clob returns the data
*/
  function fc_export_qa_rules(
   pi_client_name in varchar2 default null
  ) return clob;

end qa_export_import_rules_pkg;
/
create or replace package body qa_export_import_rules_pkg is

  function f_export_rules_table_to_clob
  (
    pi_client_name in qa_rules.qaru_client_name%type
   ,pi_category    in qa_rules.qaru_category%type default null
  ) return clob is
    c_scope constant varchar2(100) := gc_scope || 'f_export_rules_table_to_clob';
    l_param_list qa_logger_pkg.tab_param;

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


    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name
                              ,p_name_02 => 'pi_category'
                              ,p_val_02  =>pi_category);

    select count(1)
    into l_count_rules
    from qa_rules r
    where (pi_client_name is null or pi_client_name = r.qaru_client_name)
    and (pi_category is null or pi_category = r.qaru_category);

    if l_count_rules = 0
    then
      if not g_spool_active
      then
        qa_utils_pkg.p_print_to_dbms_output('No rules found.');
      end if;
      return null;
    else
      if not g_spool_active
      then
        qa_utils_pkg.p_print_to_dbms_output('Exporting ' || l_count_rules || ' rules with CLIENT_NAME=' || pi_client_name || ' and CATEGORY=' || pi_category);
      end if;

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
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while exporting Rules from Table'
                            ,p_scope  => c_scope
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
     when others then
       qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to Export Rules from Table'
                             ,p_scope  => c_scope
                             ,p_extra  => sqlerrm
                             ,p_params => l_param_list);
      raise;
  end f_export_rules_table_to_clob;

  -- Experimental Function to Export A Json as an executable script
  function f_export_rules_to_script_clob(pi_clob in clob) return clob is

    c_unit constant varchar2(32767) := $$plsql_unit || '.f_export_rules_to_script_clob';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
    l_sql  clob;
    l_clob_varchar varchar(32767); 

  begin
    l_clob_varchar := dbms_lob.substr(pi_clob,4000,1);
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_clob'
                              ,p_val_01  => l_clob_varchar);

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
        l_sql := qa_utils_pkg.f_replace_string(pi_source_string  => f.line
                                              ,pi_search_string  => '\n'
                                              ,pi_replace_string => 'chr(10)');
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

  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found at exporting Rules to Scripts'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while exporting Rules to Scripts'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_export_rules_to_script_clob;

  function f_import_clob_to_qa_import_files
  (
    pi_clob     in clob
   ,pi_filename in qa_import_files.qaif_filename%type
   ,pi_mimetype in qa_import_files.qaif_mimetype%type
  ) return number
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_Import_clob_to_qa_import_files';
    l_param_list qa_logger_pkg.tab_param;

    l_ret number;
    l_clob_varchar varchar(32767);
  begin
    l_clob_varchar := dbms_lob.substr(pi_clob,4000,1);
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_clob'
                              ,p_val_01  => l_clob_varchar
                              ,p_name_02 => 'pi_file_name'
                              ,p_val_02  => pi_filename
                              ,p_name_03 => 'pi_mimetype'
                              ,p_val_03  => pi_mimetype);

    insert into qa_import_files
      (qaif_filename
      ,qaif_mimetype
      ,qaif_clob_data)
    values
      (pi_filename
      ,pi_mimetype
      ,to_clob(pi_clob))
    returning qaif_id into l_ret;
    
    return l_ret;
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while Importing clob to qa_import_files'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while Importing clob to qa_import_files'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_import_clob_to_qa_import_files;


  procedure p_import_clob_to_rules_table(pi_qaif_id in qa_import_files.qaif_id%type) is

    c_unit constant varchar2(32767) := $$plsql_unit || '.f_Import_clob_to_rules_table';
    l_param_list qa_logger_pkg.tab_param;

    l_clob clob;
  begin
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name_01 => 'pi_qaif_id'
                              ,p_val_01  =>  pi_qaif_id);

    select q.qaif_clob_data
    into l_clob
    from qa_import_files q
    where q.qaif_id = pi_qaif_id;

    if l_clob is not null
    then
      for i in (select *
                from json_table(l_clob
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
                                                               ,qaru_sql clob path '$.sql'
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
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while Importing Clob to QA_RULES Table'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while Importing clob to QA_RULES Table'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_import_clob_to_rules_table;

  function fc_export_qa_rules(pi_client_name in varchar2 default null) return clob is
    c_unit constant varchar2(32767) := $$plsql_unit || '.fc_export_qa_rules';
    l_param_list qa_logger_pkg.tab_param;

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
    when no_data_found then

      qa_logger_pkg.p_qa_log(p_text   => 'No Data found while Exporting Rules from QA_RULES Table'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while Exporting from QA_RULES Table'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end fc_export_qa_rules;

end qa_export_import_rules_pkg;
/
