prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
end;
/
 
prompt APPLICATION 141 - QUASTO
--
-- Application Export:
--   Application:     141
--   Name:            QUASTO
--   Date and Time:   11:18 Thursday April 18, 2024
--   Exported By:     PHILIPP.DAHLEM@HYAND.COM
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 2515948831078540410
--   Manifest End
--   Version:         23.2.4
--   Instance ID:     248258786232538
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/com_mtag_olemm_qa_region
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(2515948831078540410)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.MTAG.OLEMM.QA.REGION'
,p_display_name=>'Quasto - Region'
,p_default_escape_mode=>'HTML'
,p_api_version=>1
,p_render_function=>'qa_apex_plugin_pkg.render_qa_region'
,p_standard_attributes=>'AJAX_ITEMS_TO_SUBMIT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.1'
,p_about_url=>'http://oliverlemm.blogspot.de/'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1278445103286538184)
,p_plugin_id=>wwv_flow_imp.id(2515948831078540410)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Application ID'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'&APP_ID.'
,p_display_length=>20
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1278453516099541896)
,p_plugin_id=>wwv_flow_imp.id(2515948831078540410)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Page ID'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_default_value=>'&APP_PAGE_ID.'
,p_display_length=>20
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42509471391281805)
,p_plugin_id=>wwv_flow_imp.id(2515948831078540410)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Rule Number'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(42928268040208441)
,p_plugin_id=>wwv_flow_imp.id(2515948831078540410)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Client Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'MT AG'
,p_is_translatable=>false
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
