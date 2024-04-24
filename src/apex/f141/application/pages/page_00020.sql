prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page(
 p_id=>20
,p_name=>'Region Plugin'
,p_alias=>'REGION-PLUGIN'
,p_step_title=>'Region Plugin'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
,p_last_updated_by=>'PHILIPP.DAHLEM@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240424175545'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18126053872567136)
,p_plug_name=>'QUASTO Region Plugin'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50728801114675111)
,p_plug_display_sequence=>20
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h1>Sample Page to demonstrate the functionality of the QUASTO Region Plugin</h1>',
'',
'<h2>Usage:</h2>',
'<ol>',
'    <li>Select an Application or all</li>',
'    <li>Select a page to test or all</li>',
'    <li>Select a rule or none to test all</li>',
'</ol>',
'',
'<p><strong>Note:</strong> You don''t have to select a specific App/Page or Rule. The Plugin will simply run for all available Combinations all Rules based on the Selection you make.</p>',
'',
'<h2>How to install the Plugin:</h2>',
'<p>Import the region plugin over the Appbuilder. The installation file is located under <code>quasto/src/plugin/region_type_plugin_quasto_region.sql</code> in our GitHub Repository: <a href="https://github.com/mt-ag/quasto">https://github.com/mt-ag/q'
||'uasto</a></p>',
'',
'<h2>How to Implement the Plugin into your Application:</h2>',
'<!-- Add implementation steps here -->',
'',
'<h2>How to use the region Plugin:</h2>',
'<p>One Possible Use Case would be to create a new Region on your Global Page. The Region will be Shown by Default and you can customize when the Region shall be displayed e.g. only in the Development Application.</p>',
'',
'<p>Once you created the Region you can set the Default Parameters:</p>',
'<ul>',
'    <li>Application ID => pass a custom ID or default APP ID of your application (e.g. "&amp;APP_ID.") or leave empty to run rules for all Applications</li>',
'    <li>Page ID => pass a custom ID or default PAGE ID of your current Page (e.g. "&amp;PAGE_ID.") or leave empty to run rules for all Pages</li>',
'    <li>Rule Number => pass the Rule number or leave empty to test all Rules. Right now it is necessary that the user creates their own select list. An example is P20_RULE_SELECTION of this page</li>',
'</ul>'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(62488812881968151)
,p_plug_name=>'QUASTO Region Plugin Demo'
,p_parent_plug_id=>wwv_flow_imp.id(18126053872567136)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'PLUGIN_QUASTO_REGION'
,p_attribute_01=>'&P20_APP_ID.'
,p_attribute_02=>'&P20_APP_PAGE_ID.'
,p_attribute_03=>'&P20_RULE_SELECTION.'
,p_attribute_04=>'MT AG'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37288452984645603)
,p_name=>'P20_APP_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(62488812881968151)
,p_prompt=>'Applicaiton'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'APPLICATION_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_number(application_id) as r,  application_id || '' - '' || application_name as d',
'from apex_applications',
'where workspace != ''INTERNAL''',
'order by application_name desc'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(37288665264645605)
,p_name=>'P20_APP_PAGE_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(62488812881968151)
,p_prompt=>'Page'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'APP_PAGE_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select page_id as r, page_id || '' - '' || page_name as d',
'from apex_application_pages',
'where workspace != ''INTERNAL'' and (:P20_APP_ID = application_id or :P20_APP_ID is null)'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All'
,p_lov_cascade_parent_items=>'P20_APP_ID'
,p_ajax_items_to_submit=>'P20_APP_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(62489177196968150)
,p_name=>'P20_RULE_SELECTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(62488812881968151)
,p_prompt=>'Rule Selection'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'APEX_RULES_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select qaru_rule_number || '' - '' || qaru_name as d,qaru_rule_number as r from qa_rules',
'where qaru_is_active = 1',
'and qaru_category = ''APEX'''))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'SUBMIT'
,p_attribute_03=>'N'
);
wwv_flow_imp.component_end;
end;
/
