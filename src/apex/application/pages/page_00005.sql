prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.0'
,p_default_workspace_id=>17000820229357378
,p_default_application_id=>108
,p_default_id_offset=>0
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page(
 p_id=>5
,p_name=>'Upload Test Results'
,p_alias=>'UPLOAD-TEST-RESULTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Upload Test Results'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20230328203652'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(3404451521269441)
,p_plug_name=>'Buttons Container'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(17071069052373927)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41389895610024972)
,p_plug_name=>'Upload Test Result'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(17127821905373949)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3404550466269442)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(3404451521269441)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(17182492194373980)
,p_button_image_alt=>'Close'
,p_button_position=>'CLOSE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(3404870964269445)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(3404451521269441)
,p_button_name=>'UPLOAD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(17182523513373980)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Upload'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(3404327072269440)
,p_name=>'P5_XML_FILE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41389895610024972)
,p_prompt=>'XML file'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(17179955866373977)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'APEX_APPLICATION_TEMP_FILES'
,p_attribute_09=>'SESSION'
,p_attribute_10=>'N'
,p_attribute_11=>'.xml'
,p_attribute_12=>'DROPZONE_BLOCK'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(3404693572269443)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(3404550466269442)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(3404714366269444)
,p_event_id=>wwv_flow_imp.id(3404693572269443)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Close Dialog'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(3404958717269446)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Upload file'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    v_clob_content  clob;',
'begin',
'  select to_clob(blob_content)',
'	into v_clob_content',
'	from APEX_APPLICATION_TEMP_FILES',
'   where name = :P5_XML_FILE;',
'   ',
'   insert into qa_test_results (qatr_xml_result)',
'   values (v_clob_content);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(3404870964269445)
,p_process_success_message=>'File uploaded.'
);
wwv_flow_imp.component_end;
end;
/
