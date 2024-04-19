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
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'qa_apex_plugin_pkg.render_qa_region'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/mt-ag/quasto'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42945167529859485)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Application ID'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'&APP_ID.'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42945556833857316)
,p_plugin_id=>wwv_flow_imp.id(42944716633863174)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Page ID'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'&APP_PAGE_ID.'
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
