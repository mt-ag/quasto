prompt --application/shared_components/plugins/region_type/qa_region_plugin
begin
--   Manifest
--     PLUGIN: QA_REGION_PLUGIN
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
 p_id=>wwv_flow_imp.id(37287349313647022)
,p_plugin_type=>'REGION TYPE'
,p_name=>'QA_REGION_PLUGIN'
,p_display_name=>'qa_region_plugin'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('REGION TYPE','QA_REGION_PLUGIN'),'')
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'return ''Test'';',
'end;',
''))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_standard_attributes=>'AJAX_ITEMS_TO_SUBMIT:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp.component_end;
end;
/
