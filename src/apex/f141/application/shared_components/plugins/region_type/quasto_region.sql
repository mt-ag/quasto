prompt --application/shared_components/plugins/region_type/quasto_region
begin
--   Manifest
--     PLUGIN: QUASTO_REGION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(42944716633863174)
,p_plugin_type=>'REGION TYPE'
,p_name=>'QUASTO_REGION'
,p_display_name=>'Quasto - Region'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('REGION TYPE','QUASTO_REGION'),'')
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render_qa_region',
'(',
'  p_region              in apex_plugin.t_region',
' ,p_plugin              in apex_plugin.t_plugin',
' ,p_is_printer_friendly in boolean',
') return apex_plugin.t_region_render_result is',
'',
'  c_plugin_qa_collection_name constant varchar2(30) := ''PLUGIN_QA_COLLECTION'';',
'',
'',
'  l_qa_rules_t           qa_rules_t;',
'  l_region_render_result apex_plugin.t_region_render_result;',
'',
'  -- variables',
'  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_01;',
'  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_02;',
'  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_03;',
'  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_04;',
'',
'  function get_collection_name return varchar2 is',
'  begin',
'    return c_plugin_qa_collection_name;',
'  end get_collection_name;',
'',
'',
'  -- HTML formated header for the region plugin',
'  function get_html_region_header return varchar2 is',
'    l_header varchar2(32767);',
'  begin',
'    l_header := ''<table class="apexir_WORKSHEET_DATA">'' || --',
'                ''<tr><th> # </th>'' || --',
'                ''<th>Objecttype</th>'' || --',
'                ''<th>Objectname</th>'' || --',
'                ''<th>Message</th>'' || --',
'                ''</tr>'';',
'  ',
'    return l_header;',
'  end get_html_region_header;',
'',
'  -- Footer for Region Plugin',
'  function get_html_region_footer return varchar2 is',
'    l_footer varchar2(32767);',
'  begin',
'    l_footer := ''</table>'';',
'  ',
'    return l_footer;',
'  end get_html_region_footer;',
'',
'  -- Every single line will be formated like this',
'  function get_html_rule_line',
'  (',
'    p_nr        in pls_integer',
'   ,p_qa_rule_t in qa_rule_t',
'  ) return varchar2 is',
'    l_line varchar2(32767);',
'  begin',
'    l_line := ''<tr><td>'' || p_nr || ''</td>'' || --',
'              ''<td>'' || p_qa_rule_t.object_details || ''</td>'' || --',
'              ''<td>'' || p_qa_rule_t.object_name || ''</td>'' || --',
'              ''<td>'' || p_qa_rule_t.qaru_error_message || ''</td>'' || --',
'              ''</tr>'';',
'    return l_line;',
'  end get_html_rule_line;',
'',
'  -- print the rules to the region',
'  procedure print_result(p_qa_rules_t in qa_rules_t) is',
'  begin',
'    if p_qa_rules_t is not null and',
'       p_qa_rules_t.count > 0',
'    then',
'      -- print header for plugin region',
'      htp.p(get_html_region_header);',
'      -- go through all messages',
'      for i in 1 .. p_qa_rules_t.count',
'      loop',
'        htp.p(get_html_rule_line(p_nr        => i',
'                                ,p_qa_rule_t => p_qa_rules_t(i)));',
'      end loop;',
'    ',
'      -- print footer',
'      htp.p(get_html_region_footer);',
'    end if;',
'  ',
'  end print_result;',
'',
'begin',
'',
'  if l_rule_number is not null',
'  then',
'    l_qa_rules_t := qa_apex_api_pkg.tf_run_rule(pi_app_id           => l_app_id',
'                                               ,pi_page_id          => l_app_page_id',
'                                               ,pi_qaru_rule_number => l_rule_number',
'                                               ,pi_qaru_client_name => l_client_name',
'                                               ,pi_target_scheme    => null);',
'  else',
'    l_qa_rules_t := qa_apex_api_pkg.tf_run_rules(pi_app_id           => l_app_id',
'                                                ,pi_page_id          => l_app_page_id',
'                                                ,pi_qaru_client_name => l_client_name);',
'  end if;',
'  dbms_output.put_line(''Reached print Result'');',
'  if l_qa_rules_t.count > 0 and',
'     l_qa_rules_t is not null',
'  then',
'    print_result(p_qa_rules_t => l_qa_rules_t);',
'  end if;',
'',
'  return l_region_render_result;',
'',
'',
'end render_qa_region;',
''))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'render_qa_region'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/quasto'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(44403350636896285)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Application ID'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'&APP_ID.'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(44405807515893587)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Page ID'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'&PAGE_ID.'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42945845694856499)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Rule Number'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42946171306855018)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Client Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'MT AG'
,p_is_translatable=>false
);
wwv_flow_imp.component_end;
end;
/
