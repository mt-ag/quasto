-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Plugin: Quasto - Region > Source > PL/SQL Code

function render_qa_region
(
  p_region              in apex_plugin.t_region
 ,p_plugin              in apex_plugin.t_plugin
 ,p_is_printer_friendly in boolean
) return apex_plugin.t_region_render_result is

  c_plugin_qa_collection_name constant varchar2(30) := 'PLUGIN_QA_COLLECTION';


  l_qa_rules_t           qa_rules_t;
  l_region_render_result apex_plugin.t_region_render_result;

  -- variables
  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_01;
  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_02;
  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_03;
  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_04;

  function get_collection_name return varchar2 is
  begin
    return c_plugin_qa_collection_name;
  end get_collection_name;


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


-- ----------------------------------------
-- Plugin: Quasto - Region > Source > PL/SQL Code

function render_qa_region
(
  p_region              in apex_plugin.t_region
 ,p_plugin              in apex_plugin.t_plugin
 ,p_is_printer_friendly in boolean
) return apex_plugin.t_region_render_result is

  c_plugin_qa_collection_name constant varchar2(30) := 'PLUGIN_QA_COLLECTION';


  l_qa_rules_t           qa_rules_t;
  l_region_render_result apex_plugin.t_region_render_result;

  -- variables
  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_01;
  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_02;
  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_03;
  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_04;

  function get_collection_name return varchar2 is
  begin
    return c_plugin_qa_collection_name;
  end get_collection_name;


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


