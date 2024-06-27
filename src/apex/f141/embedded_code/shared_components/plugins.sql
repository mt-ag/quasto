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


  l_qa_rules_t           qa_rules_t := new qa_rules_t();
  l_qa_rules_temp_t      qa_rules_t;-- := new qa_rules_t();
  l_region_render_result apex_plugin.t_region_render_result;

  -- variables
  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_01;
  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_02;
  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_03;
  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_04;

  l_display_rule_number varchar2(5000 char);
  l_display_rule_name   qa_rules.qaru_name%type;



  function get_collection_name return varchar2 is
  begin
    return c_plugin_qa_collection_name;
  end get_collection_name;


  -- HTML formated header for the region plugin
  function get_html_region_header return varchar2 is
    l_header varchar2(32767);
  begin
    l_header := '<table class="table-std">' || --
                '<thead><tr><th class="table-header"> # </th>' || --
                '<th class="table-header">Error Level</th>' || --
                '<th class="table-header">Rule Number</th>' || --
                '<th class="table-header">Rule Name</th>' || --
                '<th class="table-header">Object Type</th>' || --
                '<th class="table-header">Object Name</th>' || --
                '<th class="table-header">Details</th>' || --
                '</tr></thead>';
  
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
    p_nr           in pls_integer
   ,p_qa_rule_t    in qa_rule_t
   ,pi_rule_number in varchar2
   ,pi_rule_name   in varchar2
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td class="table-row">' || p_nr || '</td>' || --
              '<td class="table-row">' || p_qa_rule_t.qaru_error_level || '</td>' || --
              '<td  class="table-row">' || pi_rule_number || '</td>' || --
              '<td  class="table-row">' || pi_rule_name || '</td>' || --
              '<td  class="table-row">' || p_qa_rule_t.object_type || '</td>' || --
              '<td  class="table-row">' || p_qa_rule_t.object_name || '</td>' || --
              '<td class="table-row">' || p_qa_rule_t.object_details || '</td>' || --
              '</tr>';
    return l_line;
  end get_html_rule_line;

  -- print the rules to the region
  procedure print_result
  (
    p_qa_rules_t   in qa_rules_t
   ,pi_rule_number in varchar2
   ,pi_rule_name   in varchar2
  ) is
  begin
    if p_qa_rules_t is not null and
       p_qa_rules_t.count > 0
    then
      -- print header for plugin region
      htp.p(get_html_region_header);
      -- go through all messages
      for s in 1 .. p_qa_rules_t.count
      loop
        htp.p(get_html_rule_line(p_nr           => s
                                ,p_qa_rule_t    => p_qa_rules_t(s)
                                ,pi_rule_number => pi_rule_number
                                ,pi_rule_name   => pi_rule_name));
      end loop;
    
      -- print footer
      htp.p(get_html_region_footer);
    end if;
  
  end print_result;

begin
  -- Print Header
  htp.p(get_html_region_header);
    l_qa_rules_t := qa_apex_api_pkg.tf_run_rules(pi_app_id           => l_app_id
                                                ,pi_page_id          => l_app_page_id
                                                ,pi_rule_number      => l_rule_number
                                                ,pi_qaru_client_name => l_client_name
                                                ,pi_target_scheme    => null );
    if l_qa_rules_t is not null and
       l_qa_rules_t.count > 0
    then
      for s in 1 .. l_qa_rules_t.count
      loop
          select qaru_name,qaru_rule_number 
          into l_display_rule_number,l_display_rule_name
          from qa_rules where qaru_id = l_qa_rules_t(s).qaru_id;

          htp.p(get_html_rule_line(p_nr           => s
                                  ,p_qa_rule_t    => l_qa_rules_t(s)
                                  ,pi_rule_number => l_display_rule_number
                                  ,pi_rule_name   => l_display_rule_name));
      end loop;
    end if;
  htp.p(get_html_region_footer);

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


  l_qa_rules_t           qa_rules_t := new qa_rules_t();
  l_qa_rules_temp_t      qa_rules_t;-- := new qa_rules_t();
  l_region_render_result apex_plugin.t_region_render_result;

  -- variables
  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_01;
  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_02;
  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_03;
  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_04;

  l_display_rule_number varchar2(5000 char);
  l_display_rule_name   qa_rules.qaru_name%type;



  function get_collection_name return varchar2 is
  begin
    return c_plugin_qa_collection_name;
  end get_collection_name;


  -- HTML formated header for the region plugin
  function get_html_region_header return varchar2 is
    l_header varchar2(32767);
  begin
    l_header := '<table class="table-std">' || --
                '<thead><tr><th class="table-header"> # </th>' || --
                '<th class="table-header">Error Level</th>' || --
                '<th class="table-header">Rule Number</th>' || --
                '<th class="table-header">Rule Name</th>' || --
                '<th class="table-header">Object Type</th>' || --
                '<th class="table-header">Object Name</th>' || --
                '<th class="table-header">Details</th>' || --
                '</tr></thead>';
  
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
    p_nr           in pls_integer
   ,p_qa_rule_t    in qa_rule_t
   ,pi_rule_number in varchar2
   ,pi_rule_name   in varchar2
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td class="table-row">' || p_nr || '</td>' || --
              '<td class="table-row">' || p_qa_rule_t.qaru_error_level || '</td>' || --
              '<td  class="table-row">' || pi_rule_number || '</td>' || --
              '<td  class="table-row">' || pi_rule_name || '</td>' || --
              '<td  class="table-row">' || p_qa_rule_t.object_type || '</td>' || --
              '<td  class="table-row">' || p_qa_rule_t.object_name || '</td>' || --
              '<td class="table-row">' || p_qa_rule_t.object_details || '</td>' || --
              '</tr>';
    return l_line;
  end get_html_rule_line;

  -- print the rules to the region
  procedure print_result
  (
    p_qa_rules_t   in qa_rules_t
   ,pi_rule_number in varchar2
   ,pi_rule_name   in varchar2
  ) is
  begin
    if p_qa_rules_t is not null and
       p_qa_rules_t.count > 0
    then
      -- print header for plugin region
      htp.p(get_html_region_header);
      -- go through all messages
      for s in 1 .. p_qa_rules_t.count
      loop
        htp.p(get_html_rule_line(p_nr           => s
                                ,p_qa_rule_t    => p_qa_rules_t(s)
                                ,pi_rule_number => pi_rule_number
                                ,pi_rule_name   => pi_rule_name));
      end loop;
    
      -- print footer
      htp.p(get_html_region_footer);
    end if;
  
  end print_result;

begin
  -- Print Header
  htp.p(get_html_region_header);
    l_qa_rules_t := qa_apex_api_pkg.tf_run_rules(pi_app_id           => l_app_id
                                                ,pi_page_id          => l_app_page_id
                                                ,pi_rule_number      => l_rule_number
                                                ,pi_qaru_client_name => l_client_name
                                                ,pi_target_scheme    => null );
    if l_qa_rules_t is not null and
       l_qa_rules_t.count > 0
    then
      for s in 1 .. l_qa_rules_t.count
      loop
          select qaru_name,qaru_rule_number 
          into l_display_rule_number,l_display_rule_name
          from qa_rules where qaru_id = l_qa_rules_t(s).qaru_id;

          htp.p(get_html_rule_line(p_nr           => s
                                  ,p_qa_rule_t    => l_qa_rules_t(s)
                                  ,pi_rule_number => l_display_rule_number
                                  ,pi_rule_name   => l_display_rule_name));
      end loop;
    end if;
  htp.p(get_html_region_footer);

  return l_region_render_result;
end render_qa_region;


