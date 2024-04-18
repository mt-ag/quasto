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
  
end qa_apex_plugin_pkg;
/
create or replace package body qa_apex_plugin_pkg as
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
    p_nr        in pls_integer
   ,p_qa_rule_t in qa_rule_t
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td>' || p_nr || '</td>' || --
              '<td>' || p_qa_rule_t.object_details || '</td>' || --
              '<td>' || p_qa_rule_t.object_name || '</td>' || --
              '<td>' || p_qa_rule_t.qaru_error_message || '</td>' || --
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
    l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_03;
    l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_04;
  begin
  
    if l_rule_number is not null
    then
      l_qa_rules_t := qa_apex_api_pkg.tf_run_rule(pi_app_id           => l_app_id
                                 ,pi_page_id          => l_app_page_id
                                 ,pi_qaru_rule_number => l_rule_number
                                 ,pi_qaru_client_name => l_client_name
                                 ,pi_target_scheme    => null);
    else
      l_qa_rules_t := qa_apex_api_pkg.tf_run_rules(pi_app_id           => l_app_id
                                  ,pi_page_id          => l_app_page_id
                                  ,pi_qaru_client_name => l_client_name);
    end if;
    dbms_output.put_line('Reached print Result');
    if l_qa_rules_t.count > 0 and
       l_qa_rules_t is not null
    then
      print_result(p_qa_rules_t => l_qa_rules_t);
    end if;
  
    return l_region_render_result;
  end render_qa_region;

end qa_apex_plugin_pkg;
/