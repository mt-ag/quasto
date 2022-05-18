PROMPT create or replace package QA_PKG
create or replace package qa_pkg as

  c_qa_collection_name constant varchar2(30) := 'QA_COLLECTION';

  -- function for returning the collection name
  function get_collection_name return varchar2;

  -- render function which is called in the apex region plugin
  -- %param p_region properties and information of region in which the plugin is used
  -- %param p_plugin properties of the plugin itself
  -- %param p_is_printer_friendly displaying the plugin printer friendly mode or not
  function render_qa_region
  (
    p_region              in apex_plugin.t_region
   ,p_plugin              in apex_plugin.t_plugin
   ,p_is_printer_friendly in boolean
  ) return apex_plugin.t_region_render_result;

  -- function is used in the apex process plugin
  -- %param p_process 
  -- %param p_plugin properties of the plugin itself
  function execute_process
  (
    p_process in apex_plugin.t_process
   ,p_plugin  in apex_plugin.t_plugin
  ) return apex_plugin.t_process_exec_result;

  -- procedure for testing purposes
  function test
  (
    p_app_id      in number
   ,p_app_page_id in number
   ,p_debug       in varchar2 default 'N'
  ) return qa_rules_t;

  -- function for inserting a new rule
  -- the function determines the next id and encapsulates the insert operation for new rules
  function insert_rule
  (
    p_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,p_qaru_client_name     in qa_rules.qaru_client_name%type
   ,p_qaru_name            in qa_rules.qaru_name%type
   ,p_qaru_category        in qa_rules.qaru_category%type
   ,p_qaru_object_types    in qa_rules.qaru_object_types%type
   ,p_qaru_error_message   in qa_rules.qaru_error_message%type
   ,p_qaru_comment         in qa_rules.qaru_comment%type default null
   ,p_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,p_qaru_error_level     in qa_rules.qaru_error_level%type
   ,p_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,p_qaru_sql             in qa_rules.qaru_sql%type
   ,p_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,p_qaru_layer           in qa_rules.qaru_layer%type
  ) return qa_rules.qaru_id%type;

end qa_pkg;
/
create or replace package body qa_pkg as

  c_debugging constant boolean := false;

  -- same as qa_rule_t.qaru_object_type
  subtype t_object_type is varchar2(30);

  -- @see table comment qa_rules.qaru_object_type
  -- Values which are allowed for object_type
  c_qaru_object_type_app         constant t_object_type := 'APPLICATION';
  c_qaru_object_type_page        constant t_object_type := 'PAGE';
  c_qaru_object_type_region      constant t_object_type := 'REGION';
  c_qaru_object_type_item        constant t_object_type := 'ITEM';
  c_qaru_object_type_rpt_col     constant t_object_type := 'RPT_COL';
  c_qaru_object_type_button      constant t_object_type := 'BUTTON';
  c_qaru_object_type_computation constant t_object_type := 'COMPUTATION';
  c_qaru_object_type_validation  constant t_object_type := 'VALIDATION';
  c_qaru_object_type_process     constant t_object_type := 'PROCESS';
  c_qaru_object_type_branch      constant t_object_type := 'BRANCH';
  c_qaru_object_type_da          constant t_object_type := 'DA';
  c_qaru_object_type_da_action   constant t_object_type := 'DA_ACTION';

  -- @see table comment qa_rules.qaru_layer
  c_qaru_layer_page        constant qa_rules.qaru_layer%type := 'PAGE';
  c_qaru_layer_application constant qa_rules.qaru_layer%type := 'APPLICATION';

  -- @see table comment qa_rules.qaru_category
  c_qaru_category_apex constant qa_rules.qaru_category%type := 'APEX';

  -- @see spec
  function get_collection_name return varchar2 is
  begin
    return c_qa_collection_name;
  end get_collection_name;

  -- Edit Link to jump directly into the Application Builder
  -- Links based on the View wwv_flow_dictionary_views in column link_url
  function get_edit_link(p_qa_rule in qa_rule_t) return varchar2 is
    l_url varchar2(1000 char);
  begin
    -- Application
    if p_qa_rule.qaru_object_type = c_qaru_object_type_app
    then
      l_url := 'f?p=4000:4001:%session%::::F4000_P1_FLOW,FB_FLOW_ID:%pk_value%,%pk_value%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.apex_app_id);

      -- Page
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_page
    then
      l_url := 'f?p=4000:4301:%session%::NO::F4000_P4301_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.apex_page_id);

      -- Page Regions
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_region
    then
      l_url := 'f?p=4000:4651:%session%:::4651,960,420:F4000_P4651_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.apex_region_id);

      -- Item
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_item
    then
      l_url := 'f?p=4000:4311:%session%::::F4000_P4311_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Report Column
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_rpt_col
    then
      l_url := 'f?p=4000:422:%session%:::4651,960,420,422:P422_COLUMN_ID,P420_REGION_ID,F4000_P4651_ID,P960_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%parent_pk_value%,%parent_pk_value%,%parent_pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      l_url := replace(l_url
                      ,'%parent_pk_value%'
                      ,p_qa_rule.apex_region_id);

      -- Button
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_button
    then
      l_url := 'f?p=4000:4314:%session%:::4314:F4000_P4314_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Computation
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_computation
    then
      l_url := 'f?p=4000:4315:%session%::::F4000_P4315_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Validation
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_validation
    then
      l_url := 'f?p=4000:4316:%session%::::F4000_P4316_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Process
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_process
    then
      l_url := 'f?p=4000:4312:%session%::NO:4312:F4000_P4312_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Branch
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_branch
    then
      l_url := 'f?p=4000:4313:%session%::::F4000_P4313_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Dynamic Action
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_da
    then
      l_url := 'f?p=4000:793:%session%::::F4000_P793_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);

      -- Dynamic Action - Action
    elsif p_qa_rule.qaru_object_type = c_qaru_object_type_da_action
    then
      l_url := 'f?p=4000:591:%session%::::F4000_P591_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';

      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule.object_id);


    end if;

    l_url := replace(l_url
                    ,'%application_id%'
                    ,p_qa_rule.apex_app_id);
    l_url := replace(l_url
                    ,'%page_id%'
                    ,p_qa_rule.apex_page_id);
    l_url := replace(l_url
                    ,'%session%'
                    ,apex_application.g_edit_cookie_session_id);

    return l_url;
  end get_edit_link;


  -- if function returns true the a message for the predecessor is added
  -- the rule should be excluded in output
  procedure remove_message_if_predecessor
  (
    p_qa_rules     in qa_rules_t
   ,p_qa_rules_new in out qa_rules_t
  ) is
  begin
    for n in 1 .. p_qa_rules_new.count
    loop
      for i in (select 1
                from table(p_qa_rules) rules
                    ,qa_rules qaru
                where p_qa_rules_new(n).qaru_id = qaru.qaru_id
                 and qaru.qaru_predecessor_ids is not null
                 and p_qa_rules_new(n).object_id = rules.object_id
                 and p_qa_rules_new(n).qaru_object_type = rules.qaru_object_type
                 and instr(':' || qaru.qaru_predecessor_ids || ':'
                          ,':' || rules.qaru_id || ':') > 0)
      loop
        p_qa_rules_new.delete(n);
        exit;
      end loop;
    end loop;
  end remove_message_if_predecessor;

  -- run a single rule
  -- %param p_qaru_id the rule
  -- %param p_app_id application which will be tested
  -- %param p_app_page_id page which is selected
  -- %param p_qa_rules all found rules and the new result
  procedure run_rule
  (
    p_qaru_id         in qa_rules.qaru_id%type
   ,p_app_id          in apex_applications.application_id%type
   ,p_app_page_id     in apex_application_pages.page_id%type
   ,p_debug           in varchar2
   ,p_qa_rules        in out qa_rules_t
  ) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.run_rule';

    l_qaru_sql        varchar2(32767);
    l_qaru_layer      qa_rules.qaru_layer%type;
    l_qa_rules_new    qa_rules_t;
  begin
    select qaru.qaru_sql
          ,qaru.qaru_layer
    into l_qaru_sql
        ,l_qaru_layer
    from qa_rules qaru
    where qaru.qaru_id = p_qaru_id;

    if p_debug = 'Y'
    then
      dbms_output.put_line(length(l_qaru_sql));
      dbms_output.put_line(l_qaru_sql);
    end if;

    if l_qaru_layer = c_qaru_layer_page
    then
      execute immediate l_qaru_sql bulk collect
        into l_qa_rules_new
        using p_qaru_id, p_app_id, p_app_page_id;

      if p_qa_rules is not null
      then
        p_qa_rules := p_qa_rules multiset union l_qa_rules_new;
      else
        p_qa_rules := l_qa_rules_new;
      end if;
    end if;

  exception
    when others then
      dbms_output.put_line(l_qaru_sql);
      raise;
  end run_rule;


  -- run all rules which are active
  procedure run_rules
  (
    p_app_id          in apex_applications.application_id%type
   ,p_app_page_id     in apex_application_pages.page_id%type
   ,p_debug           in varchar2
   ,p_qa_rules        in out qa_rules_t
  ) is
  begin
    for r in (select qaru.qaru_id
              from qa_rules qaru
              where qaru.qaru_is_active = 1
              order by qaru.qaru_predecessor_ids nulls first)
    loop
      run_rule(p_qaru_id         => r.qaru_id
              ,p_app_id          => p_app_id
              ,p_app_page_id     => p_app_page_id
              ,p_debug           => p_debug
              ,p_qa_rules        => p_qa_rules);
    end loop;
  end run_rules;


  procedure rules_2_collection(p_qa_rules in qa_rules_t) is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => c_qa_collection_name);

    -- only process when rules are returning errors
    if p_qa_rules is not null and
       p_qa_rules.count > 0
    then

      -- go through all messages
      for i in 1 .. p_qa_rules.count
      loop

        apex_collection.add_member(p_collection_name => c_qa_collection_name
                                   -- rule specific informations
                                  ,p_c001 => p_qa_rules(i).qaru_id
                                  ,p_c002 => p_qa_rules(i).qaru_category
                                  ,p_c003 => p_qa_rules(i).qaru_error_level
                                  ,p_c004 => p_qa_rules(i).qaru_object_type
                                  ,p_c005 => p_qa_rules(i).qaru_error_message
                                   -- object specific informations
                                  ,p_c020 => p_qa_rules(i).object_id
                                  ,p_c021 => p_qa_rules(i).object_name
                                  ,p_c022 => p_qa_rules(i).object_value
                                  ,p_c023 => p_qa_rules(i).object_updated_user
                                  ,p_d001 => p_qa_rules(i).object_updated_date
                                   -- apex specific parameters
                                  ,p_c040 => p_qa_rules(i).apex_app_id
                                  ,p_c041 => p_qa_rules(i).apex_page_id
                                  ,p_c042 => p_qa_rules(i).apex_region_id);
      end loop;
    end if;

  end rules_2_collection;


  -- HTML formated header for the region plugin
  function get_html_region_header return varchar2 is
    l_header varchar2(32767);
  begin
    l_header := '<table class="apexir_WORKSHEET_DATA">' || --
                '<tr><th> # </th>' || --
                '<th>Objecttype</th>' || --
                '<th>Objectname</th>' || --
                '<th>Message</th>' || --
                '<th>Link</th>' || --
                '</tr>';

    return l_header;
  end get_html_region_header;

  -- Footer for Region Plugin
  function get_html_region_footer return varchar2 is
    l_footer varchar2(32767);
  begin
    l_footer := '</table>';

    return l_footer;
  end get_html_region_footer;

  -- Every single line will be formated like this
  function get_html_rule_line
  (
    p_nr             in pls_integer
   ,p_qa_rule        in qa_rule_t
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td>' || p_nr || '</td>' || --
              '<td>' || p_qa_rule.qaru_object_type || '</td>' || --
              '<td>' || p_qa_rule.object_name || '</td>' || --
              '<td>' || p_qa_rule.qaru_error_message || '</td>' || --
              '<td>' || case p_qa_rule.qaru_category
                when c_qaru_category_apex then
                 '<a href="' || get_edit_link(p_qa_rule => p_qa_rule) || '">edit</a>'
                else
                 ' '
              end || '</td>' || --
              '</tr>';
    return l_line;
  end get_html_rule_line;

  -- print the rules to the region
  procedure print_result(p_qa_rules in qa_rules_t) is
  begin
    if p_qa_rules is not null and
       p_qa_rules.count > 0
    then
      -- print header for plugin region
      htp.p(get_html_region_header);

      -- go through all messages
      for i in 1 .. p_qa_rules.count
      loop
        htp.p(get_html_rule_line(p_nr       => i
                                ,p_qa_rule  => p_qa_rules(i)));
      end loop;

      -- print footer
      htp.p(get_html_region_footer);
    end if;

  end print_result;

  -- @see spec
  function render_qa_region
  (
    p_region              in apex_plugin.t_region
   ,p_plugin              in apex_plugin.t_plugin
   ,p_is_printer_friendly in boolean
  ) return apex_plugin.t_region_render_result is

    l_qa_rules             qa_rules_t;
    l_region_render_result apex_plugin.t_region_render_result;

    -- variables
    l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_01;
    l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_02;
    -- Yes => Y / No => N
    l_debug       varchar2(1)                                     := p_region.attribute_03;
  begin  
    run_rules(p_app_id          => l_app_id
             ,p_app_page_id     => l_app_page_id
             ,p_debug           => l_debug
             ,p_qa_rules        => l_qa_rules);

    print_result(p_qa_rules => l_qa_rules);

    return l_region_render_result;
  end render_qa_region;


  -- @see spec
  function execute_process
  (
    p_process in apex_plugin.t_process
   ,p_plugin  in apex_plugin.t_plugin
  ) return apex_plugin.t_process_exec_result is

    l_qa_rules            qa_rules_t;
    l_process_exec_result apex_plugin.t_process_exec_result;

    -- variables
    l_app_id      apex_application_page_regions.attribute_01%type := p_process.attribute_01;
    l_app_page_id apex_application_page_regions.attribute_02%type := p_process.attribute_02;
    l_debug       apex_application_page_regions.attribute_02%type := p_process.attribute_03;    
  begin  
    run_rules(p_app_id          => l_app_id
             ,p_app_page_id     => l_app_page_id
             ,p_debug           => l_debug
             ,p_qa_rules        => l_qa_rules);

    rules_2_collection(p_qa_rules => l_qa_rules);

    return l_process_exec_result;
  end execute_process;


  function test
  (
    p_app_id      in number
   ,p_app_page_id in number
   ,p_debug       in varchar2 default 'N'
  ) return qa_rules_t is

    l_qa_rules qa_rules_t;
  begin
    if p_app_page_id is not null
    then
      run_rules(p_app_id          => p_app_id
               ,p_app_page_id     => p_app_page_id
               ,p_debug           => p_debug
               ,p_qa_rules        => l_qa_rules);
    else
      for p in (select ap.page_id
                from apex_application_pages ap
                where ap.application_id = p_app_id)
      loop
        run_rules(p_app_id          => p_app_id
                 ,p_app_page_id     => p.page_id
                 ,p_debug           => p_debug
                 ,p_qa_rules        => l_qa_rules);
      end loop;
    end if;

    return l_qa_rules;
  end test;


  -- @see spec
  function insert_rule
  (
    p_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,p_qaru_client_name     in qa_rules.qaru_client_name%type
   ,p_qaru_name            in qa_rules.qaru_name%type
   ,p_qaru_category        in qa_rules.qaru_category%type
   ,p_qaru_object_types    in qa_rules.qaru_object_types%type
   ,p_qaru_error_message   in qa_rules.qaru_error_message%type
   ,p_qaru_comment         in qa_rules.qaru_comment%type default null
   ,p_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,p_qaru_error_level     in qa_rules.qaru_error_level%type
   ,p_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,p_qaru_sql             in qa_rules.qaru_sql%type
   ,p_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,p_qaru_layer           in qa_rules.qaru_layer%type
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
      (p_qaru_rule_number
      ,p_qaru_client_name
      ,p_qaru_name
      ,p_qaru_category
      ,p_qaru_object_types
      ,p_qaru_error_message
      ,p_qaru_comment
      ,p_qaru_exclude_objects
      ,p_qaru_error_level
      ,p_qaru_is_active
      ,p_qaru_sql
      ,p_qaru_predecessor_ids
      ,p_qaru_layer)
    returning qaru_id into l_qaru_id;  

    return l_qaru_id;
  end insert_rule;

end qa_pkg;
/
