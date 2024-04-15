create or replace package qa_apex_plugin_pkg authid current_user as 

  c_plugin_qa_collection_name constant varchar2(30) := 'PLUGIN_QA_COLLECTION';

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

  --########################################
  --test spec
  function get_html_region_header return varchar2;

  function get_html_rule_line
  (
    p_nr        in pls_integer
   ,p_qa_rule_t in qa_rule_t
  ) return varchar2;

  function tf_run_rule
  (
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t;

end qa_apex_plugin_pkg;
/

create or replace package body qa_apex_plugin_pkg as

  c_debugging constant boolean := false;

  -- same as t_qa_rule_t.qaru_object_types
  subtype t_object_type is varchar2(30);

  -- @see table comment qa_rule_ts.qaru_object_types
  -- Values which are allowed for object_type
  c_qaru_object_types_app         constant t_object_type := 'APPLICATION';
  c_qaru_object_types_page        constant t_object_type := 'PAGE';
  c_qaru_object_types_region      constant t_object_type := 'REGION';
  c_qaru_object_types_item        constant t_object_type := 'ITEM';
  c_qaru_object_types_rpt_col     constant t_object_type := 'RPT_COL';
  c_qaru_object_types_button      constant t_object_type := 'BUTTON';
  c_qaru_object_types_computation constant t_object_type := 'COMPUTATION';
  c_qaru_object_types_validation  constant t_object_type := 'VALIDATION';
  c_qaru_object_types_process     constant t_object_type := 'PROCESS';
  c_qaru_object_types_branch      constant t_object_type := 'BRANCH';
  c_qaru_object_types_da          constant t_object_type := 'DA';
  c_qaru_object_types_da_action   constant t_object_type := 'DA_ACTION';

  -- @see spec
  function get_collection_name return varchar2 is
  begin
    return c_plugin_qa_collection_name;
  end get_collection_name;

  function tf_run_rule
  (
    pi_app_id           in apex_application_items.application_id%type
   ,pi_page_id          in apex_application_pages.page_id%type
   ,pi_qaru_rule_number in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name in qa_rules.qaru_client_name%type
   ,pi_target_scheme    in varchar2 default user
  ) return qa_rules_t is
  
    c_unit constant varchar2(32767) := $$plsql_unit || '.tf_run_rule';
    l_param_list qa_logger_pkg.tab_param;
  
    l_rule_active boolean;
    l_qa_rule     qa_rule_t;
    l_qa_rules    qa_rules_t;
    l_qa_rules_tmp  qa_rules_t;
  
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qaru_rule_number'
                              ,p_val_01  => pi_qaru_rule_number
                              ,p_name_02 => 'pi_qaru_client_name'
                              ,p_val_02  => pi_qaru_client_name
                              ,p_name_03 => 'pi_target_scheme'
                              ,p_val_03  => pi_target_scheme);
  
    if pi_qaru_rule_number is null or
       pi_qaru_client_name is null or
       pi_target_scheme is null
    then
      raise_application_error(-20001
                             ,'Missing input parameter value for pi_qaru_rule_number: ' || pi_qaru_rule_number || ' or pi_qaru_client_name: ' || pi_qaru_client_name || ' or pi_target_scheme: ' || pi_target_scheme);
    end if;
  
    if qa_main_pkg.f_is_owner_black_listed(pi_user_name => pi_target_scheme) = false
    then
    
      l_rule_active := qa_main_pkg.f_is_rule_active(pi_qaru_rule_number => pi_qaru_rule_number
                                                   ,pi_qaru_client_name => pi_qaru_client_name);
      if l_rule_active = false
      then
        raise_application_error(-20001
                               ,'Rule is not set to active for rule number: ' || pi_qaru_rule_number || ' and client name: ' || pi_qaru_client_name);
      end if;
    
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
      -- :8 app_id
      -- :9 page_id
        using pi_target_scheme, l_qa_rule.qaru_id, l_qa_rule.qaru_category, l_qa_rule.qaru_error_level, l_qa_rule.qaru_object_types, l_qa_rule.qaru_error_message, l_qa_rule.qaru_sql, pi_app_id, pi_page_id;
      --Remove entries that dont belong to the current owner
     
      return l_qa_rules;
    else
      return null;
    end if;
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
  end tf_run_rule;

  -- Edit Link to jump directly into the Application Builder
  -- Links based on the View wwv_flow_dictionary_views in column link_url
  function get_edit_link(p_qa_rule_t in qa_rule_t) return varchar2 is
    l_url varchar2(1000 char);
  begin
    -- Application
    if p_qa_rule_t.qaru_object_types = c_qaru_object_types_app
    then
      l_url := 'f?p=4000:4001:%session%::::F4000_P1_FLOW,FB_FLOW_ID:%pk_value%,%pk_value%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.apex_app_id);
    
      -- Page
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_page
    then
      l_url := 'f?p=4000:4301:%session%::NO::F4000_P4301_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.apex_page_id);
    
      -- Page Regions
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_region
    then
      l_url := 'f?p=4000:4651:%session%:::4651,960,420:F4000_P4651_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Item
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_item
    then
      l_url := 'f?p=4000:4311:%session%::::F4000_P4311_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Report Column
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_rpt_col
    then
      l_url := 'f?p=4000:422:%session%:::4651,960,420,422:P422_COLUMN_ID,P420_REGION_ID,F4000_P4651_ID,P960_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%parent_pk_value%,%parent_pk_value%,%parent_pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      l_url := replace(l_url
                      ,'%parent_pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Button
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_button
    then
      l_url := 'f?p=4000:4314:%session%:::4314:F4000_P4314_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Computation
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_computation
    then
      l_url := 'f?p=4000:4315:%session%::::F4000_P4315_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Validation
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_validation
    then
      l_url := 'f?p=4000:4316:%session%::::F4000_P4316_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Process
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_process
    then
      l_url := 'f?p=4000:4312:%session%::NO:4312:F4000_P4312_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Branch
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_branch
    then
      l_url := 'f?p=4000:4313:%session%::::F4000_P4313_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Dynamic Action
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_da
    then
      l_url := 'f?p=4000:793:%session%::::F4000_P793_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
      -- Dynamic Action - Action
    elsif p_qa_rule_t.qaru_object_types = c_qaru_object_types_da_action
    then
      l_url := 'f?p=4000:591:%session%::::F4000_P591_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,p_qa_rule_t.object_id);
    
    
    end if;
  
    l_url := replace(l_url
                    ,'%application_id%'
                    ,p_qa_rule_t.apex_app_id);
    l_url := replace(l_url
                    ,'%page_id%'
                    ,p_qa_rule_t.apex_page_id);
    l_url := replace(l_url
                    ,'%session%'
                    ,apex_application.g_edit_cookie_session_id);
  
    return l_url;
  end get_edit_link;

  procedure rules_2_collection(pi_qa_rules_t in qa_rules_t) is
  begin
    apex_collection.create_or_truncate_collection(p_collection_name => c_plugin_qa_collection_name);
  
    -- only process when rules are returning errors
    if pi_qa_rules_t is not null and
       pi_qa_rules_t.count > 0
    then
    
      -- go through all messages
      for i in 1 .. pi_qa_rules_t.count
      loop
      
        apex_collection.add_member(p_collection_name => c_plugin_qa_collection_name
                                   -- rule specific informations
                                  ,p_c001 => pi_qa_rules_t(i).qaru_id
                                  ,p_c002 => pi_qa_rules_t(i).qaru_category
                                  ,p_c003 => pi_qa_rules_t(i).qaru_error_level
                                  ,p_c004 => pi_qa_rules_t(i).qaru_object_types
                                  ,p_c005 => pi_qa_rules_t(i).qaru_error_message
                                   -- object specific informations
                                  ,p_c020 => pi_qa_rules_t(i).object_id
                                  ,p_c021 => pi_qa_rules_t(i).object_name
                                  ,p_c022 => pi_qa_rules_t(i).object_value
                                  ,p_c023 => pi_qa_rules_t(i).object_updated_user
                                  ,p_d001 => pi_qa_rules_t(i).object_updated_date
                                   -- apex specific parameters
                                  ,p_c040 => pi_qa_rules_t(i).apex_app_id
                                  ,p_c041 => pi_qa_rules_t(i).apex_page_id);
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
                '</tr>' || '<label for="cars">Choose a car:</label>

<select name="cars" id="cars">
  <option value="volvo">Volvo</option>
  <option value="saab">Saab</option>
  <option value="mercedes">Mercedes</option>
  <option value="audi">Audi</option>
</select>';
  
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
    p_nr        in pls_integer
   ,p_qa_rule_t in qa_rule_t
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td>' || p_nr || '</td>' || --
              '<td>' || p_qa_rule_t.object_details || '</td>' || --
              '<td>' || p_qa_rule_t.object_name || '</td>' || --
              '<td>' || p_qa_rule_t.qaru_error_message || '</td>' || --
              '<td>' || '<a href="' || get_edit_link(p_qa_rule_t => p_qa_rule_t) || '">edit</a>' || '</td>' || --
              '</tr>';
    return l_line;
  end get_html_rule_line;

  -- print the rules to the region
  procedure print_result(p_qa_rules_t in qa_rules_t) is
  begin
    if p_qa_rules_t is not null and
       p_qa_rules_t.count > 0
    then
      -- print header for plugin region
      htp.p(get_html_region_header);
      -- go through all messages
      for i in 1 .. p_qa_rules_t.count
      loop
        htp.p(get_html_rule_line(p_nr        => i
                                ,p_qa_rule_t => p_qa_rules_t(i)));
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
  
    l_qa_rules_t           qa_rules_t;
    l_region_render_result apex_plugin.t_region_render_result;
  
    -- variables
    l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_01;
    l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_02;
    -- Yes => Y / No => N
    l_debug varchar2(1) := p_region.attribute_03;
  begin
    l_qa_rules_t := tf_run_rule(pi_app_id           => l_app_id
                               ,pi_page_id          => l_app_page_id
                               ,pi_qaru_rule_number => 1
                               ,pi_qaru_client_name => 'MT AG'
                               ,pi_target_scheme    => 'QUASTO');
    dbms_output.put_line('Reached print Result');
    if l_qa_rules_t.count > 0 and
       l_qa_rules_t is not null
    then
      print_result(p_qa_rules_t => l_qa_rules_t);
    end if;
  
    return l_region_render_result;
  end render_qa_region;

  -- @see spec
  function execute_process
  (
    p_process in apex_plugin.t_process
   ,p_plugin  in apex_plugin.t_plugin
  ) return apex_plugin.t_process_exec_result is
  
    l_qa_rules_t          qa_rules_t;
    l_process_exec_result apex_plugin.t_process_exec_result;
  
    -- variables
    l_app_id      apex_application_page_regions.attribute_01%type := p_process.attribute_01;
    l_app_page_id apex_application_page_regions.attribute_02%type := p_process.attribute_02;
    l_debug       apex_application_page_regions.attribute_02%type := p_process.attribute_03;
  begin
    l_qa_rules_t := tf_run_rule(pi_app_id => l_app_id
                                          ,pi_page_id => l_app_page_id
                                          ,pi_qaru_rule_number => 1
                                          ,pi_qaru_client_name => 'MT AG'
                                          ,pi_target_scheme    => 'QUASTO');
  
    rules_2_collection(pi_qa_rules_t => l_qa_rules_t);
  
    return l_process_exec_result;
  end execute_process;

end qa_apex_plugin_pkg;
/