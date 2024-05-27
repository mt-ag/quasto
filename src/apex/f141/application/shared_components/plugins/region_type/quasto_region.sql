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
,p_css_file_urls=>'#PLUGIN_FILES#css/main#MIN#.css'
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
'  l_qa_rules_t           qa_rules_t := new qa_rules_t();',
'  l_qa_rules_temp_t      qa_rules_t := new qa_rules_t();',
'  l_region_render_result apex_plugin.t_region_render_result;',
'',
'  -- variables',
'  l_client_name apex_application_page_regions.attribute_04%type := p_region.attribute_01;',
'  l_rule_number apex_application_page_regions.attribute_03%type := p_region.attribute_02;',
'  l_app_id      apex_application_page_regions.attribute_01%type := p_region.attribute_03;',
'  l_app_page_id apex_application_page_regions.attribute_02%type := p_region.attribute_04;',
'',
'',
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
'    l_header := ''<table class="table-std">'' || --',
'                ''<thead><tr><th class="table-header"> # </th>'' || --',
'                ''<th class="table-header">Error Level</th>'' || --',
'                ''<th class="table-header">Rule Number</th>'' || --',
'                ''<th class="table-header">Rule Name</th>'' || --',
'                ''<th class="table-header">Object Type</th>'' || --',
'                ''<th class="table-header">Object Name</th>'' || --',
'                ''<th class="table-header">Details</th>'' || --',
'                ''</tr></thead>'';',
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
'    l_line := ''<tr><td class="table-row">'' || p_nr || ''</td>'' || --',
'              ''<td class="table-row">'' || p_qa_rule_t.qaru_error_level || ''</td>'' || --',
'              ''<td  class="table-row">'' || p_qa_rule_t.qaru_error_level || ''</td>'' || --',
'              ''<td  class="table-row">'' || p_qa_rule_t.qaru_error_level || ''</td>'' || --',
'              ''<td  class="table-row">'' || p_qa_rule_t.object_type || ''</td>'' || --',
'              ''<td  class="table-row">'' || p_qa_rule_t.object_name || ''</td>'' || --',
'              ''<td class="table-row">'' || p_qa_rule_t.object_details || ''</td>'' || --',
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
'  for i in (select qaru_rule_number as l_number',
'                  ,qaru_name',
'                  ,qaru_client_name',
'            from qa_rules',
'            where (qaru_client_name = l_client_name or l_client_name is null)',
'            and (qaru_rule_number = l_rule_number or l_rule_number is null)',
'            and qaru_category = ''APEX'')',
'  loop',
'    l_qa_rules_temp_t := qa_apex_api_pkg.tf_run_rule(pi_app_id           => l_app_id',
'                                                    ,pi_page_id          => l_app_page_id',
'                                                    ,pi_qaru_rule_number => i.l_number',
'                                                    ,pi_qaru_client_name => i.qaru_client_name',
'                                                    ,pi_target_scheme    => null);',
'    l_qa_rules_t      := l_qa_rules_t multiset union l_qa_rules_temp_t;',
'  end loop;',
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
'end render_qa_region;'))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'render_qa_region'
,p_standard_attributes=>'FETCHED_ROWS:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/quasto'
,p_files_version=>79
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(53127735633623197)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Client Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(53128661321619608)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Rule Number'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(53129280288618370)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Applicaiton ID'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'&APP_ID.'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(53129833224617442)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Page ID'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'&APP_PAGE_ID.'
,p_is_translatable=>false
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '0D0A0D0A2E7461626C652D737464207B0D0A20202020626F726465722D7374796C653A20736F6C69643B0D0A20202020626F726465722D636F6C6C617073653A20636F6C6C617073653B0D0A20202020626F726465722D77696474683A203170783B0D0A';
wwv_flow_imp.g_varchar2_table(2) := '20202020626F726465722D636F6C6F723A20236536653665363B0D0A20202020626F726465722D73706163696E673A20303B0D0A7D0D0A2E7461626C652D686561646572207B0D0A20202020636F6C6F723A20233333376163303B0D0A20202020616C69';
wwv_flow_imp.g_varchar2_table(3) := '676E2D636F6E74656E743A20696E697469616C3B0D0A202020206261636B67726F756E642D636F6C6F723A20236636663666363B0D0A20202020626F726465722D636F6C6F723A20236536653665363B0D0A20202020626F726465722D7374796C653A20';
wwv_flow_imp.g_varchar2_table(4) := '736F6C69643B0D0A20202020626F726465722D77696474683A203170783B0D0A20202020626F726465722D636F6C6C617073653A20636F6C6C617073653B0D0A20202020626F726465722D73706163696E673A20303B0D0A20202020666F6E742D73697A';
wwv_flow_imp.g_varchar2_table(5) := '653A202E373572656D3B0D0A20202020666F6E742D7765696768743A203730303B0D0A202020206C696E652D6865696768743A203172656D3B0D0A2020202070616464696E672D626C6F636B2D656E643A202E373572656D3B0D0A202020207061646469';
wwv_flow_imp.g_varchar2_table(6) := '6E672D626C6F636B2D73746172743A202E373572656D3B0D0A2020202070616464696E672D696E6C696E652D656E643A202E373572656D3B0D0A2020202070616464696E672D696E6C696E652D73746172743A202E373572656D3B0D0A20202020747261';
wwv_flow_imp.g_varchar2_table(7) := '6E736974696F6E3A206261636B67726F756E642D636F6C6F72202E31733B0D0A20202020766572746963616C2D616C69676E3A20626F74746F6D3B0D0A7D0D0A2E7461626C652D726F77207B0D0A20202020626F726465722D636F6C6F723A2023653665';
wwv_flow_imp.g_varchar2_table(8) := '3665363B0D0A20202020626F726465722D7374796C653A20736F6C69643B0D0A20202020626F726465722D77696474683A203170783B0D0A20202020626F726465722D636F6C6C617073653A20636F6C6C617073653B0D0A20202020626F726465722D73';
wwv_flow_imp.g_varchar2_table(9) := '706163696E673A20303B0D0A20202020666F6E742D73697A653A202E373572656D3B0D0A202020206C696E652D6865696768743A203172656D3B0D0A2020202070616464696E672D626C6F636B2D656E643A202E373572656D3B0D0A2020202070616464';
wwv_flow_imp.g_varchar2_table(10) := '696E672D626C6F636B2D73746172743A202E373572656D3B0D0A2020202070616464696E672D696E6C696E652D656E643A202E373572656D3B0D0A2020202070616464696E672D696E6C696E652D73746172743A202E373572656D3B0D0A202020207665';
wwv_flow_imp.g_varchar2_table(11) := '72746963616C2D616C69676E3A20626F74746F6D3B0D0A7D';
null;
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(53734981416808917)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_file_name=>'css/main.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E7461626C652D7374647B626F726465722D7374796C653A736F6C69643B626F726465722D636F6C6C617073653A636F6C6C617073653B626F726465722D77696474683A3170783B626F726465722D636F6C6F723A236536653665363B626F726465722D';
wwv_flow_imp.g_varchar2_table(2) := '73706163696E673A307D2E7461626C652D6865616465727B636F6C6F723A233333376163303B616C69676E2D636F6E74656E743A696E697469616C3B6261636B67726F756E642D636F6C6F723A236636663666363B666F6E742D7765696768743A373030';
wwv_flow_imp.g_varchar2_table(3) := '3B7472616E736974696F6E3A6261636B67726F756E642D636F6C6F72202E31737D2E7461626C652D6865616465722C2E7461626C652D726F777B626F726465722D636F6C6F723A236536653665363B626F726465722D7374796C653A736F6C69643B626F';
wwv_flow_imp.g_varchar2_table(4) := '726465722D77696474683A3170783B626F726465722D636F6C6C617073653A636F6C6C617073653B626F726465722D73706163696E673A303B666F6E742D73697A653A2E373572656D3B6C696E652D6865696768743A3172656D3B70616464696E672D62';
wwv_flow_imp.g_varchar2_table(5) := '6C6F636B2D656E643A2E373572656D3B70616464696E672D626C6F636B2D73746172743A2E373572656D3B70616464696E672D696E6C696E652D656E643A2E373572656D3B70616464696E672D696E6C696E652D73746172743A2E373572656D3B766572';
wwv_flow_imp.g_varchar2_table(6) := '746963616C2D616C69676E3A626F74746F6D7D';
null;
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(53803459698286507)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_file_name=>'css/main.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
