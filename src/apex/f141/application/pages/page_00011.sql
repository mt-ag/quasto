prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.11'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page(
 p_id=>11
,p_name=>'Restart Unit Test'
,p_alias=>'RESTART-UNIT-TEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Restart Unit Test'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20231208165825'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(104945985645082588)
,p_plug_name=>'Restart Unit Test'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51471888707214136)
,p_plug_name=>'Info'
,p_parent_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading js-removeLandmark'
,p_plug_template=>wwv_flow_imp.id(50721469375675106)
,p_plug_display_sequence=>10
,p_plug_source=>'Click on the following Button to let the database scheduler rerun the Unit Test of the given rule and scheme.'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(51471535036214133)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_button_name=>'RESTART_UNIT_TEST'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Restart Unit Test'
,p_icon_css_classes=>'fa-play-circle'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51471466801214132)
,p_name=>'P11_RULE_NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_prompt=>'Rule Number'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51702506479765705)
,p_name=>'P11_CLIENT_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_prompt=>'Client Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51702996026765706)
,p_name=>'P11_SCHEME_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_prompt=>'Scheme Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(51471617693214134)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Job'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'qa_unit_tests_pkg.p_create_unit_test_job(',
'    pi_client_name => :P11_CLIENT_NAME',
'  , pi_scheme_name => :P11_SCHEME_NAME',
'  , pi_qaru_rule_number => :P11_RULE_NUMBER',
');',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(51471535036214133)
,p_process_success_message=>'Job created.'
);
wwv_flow_imp.component_end;
end;
/
