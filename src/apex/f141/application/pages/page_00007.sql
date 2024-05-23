prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_name=>'Add/Edit Rule'
,p_alias=>'ADD-EDIT-RULE'
,p_page_mode=>'MODAL'
,p_step_title=>'Add/Edit Rule'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_protection_level=>'C'
,p_page_component_map=>'02'
,p_last_updated_by=>'PHILIPP.DAHLEM@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240523101305'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54280765006258501)
,p_plug_name=>'Add/Edit Rule'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54073518069447836)
,p_plug_name=>'Add/Edit Rule Form'
,p_parent_plug_id=>wwv_flow_imp.id(54280765006258501)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>20
,p_query_type=>'TABLE'
,p_query_table=>'QA_RULES_P0007_V'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51468339666214101)
,p_plug_name=>'Left Content'
,p_parent_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51468477464214102)
,p_plug_name=>'Right Content'
,p_parent_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>60
,p_plug_new_grid_row=>false
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54281128117258505)
,p_plug_name=>'Buttons Container'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50733389987675114)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54281519913258508)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(54281128117258505)
,p_button_name=>'CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(50844813129675167)
,p_button_image_alt=>'Close'
,p_button_position=>'CLOSE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54468111224367589)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(54281128117258505)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>wwv_flow_imp.id(50844813129675167)
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_confirm_message=>'Do you really want to delete this rule?'
,p_confirm_style=>'warning'
,p_button_condition=>'P7_QARU_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54281277862258506)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(54281128117258505)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P7_QARU_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(37067720447570637)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(54281128117258505)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_condition=>'P7_QARU_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-save'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54279587759258489)
,p_name=>'P7_QARU_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_source=>'QARU_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54279634041258490)
,p_name=>'P7_QARU_RULE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Rule Number'
,p_source=>'QARU_RULE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_read_only_when=>'P7_QARU_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54279727859258491)
,p_name=>'P7_QARU_CLIENT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Client Name'
,p_source=>'QARU_CLIENT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_read_only_when=>'P7_QARU_ID'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54279823323258492)
,p_name=>'P7_QARU_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Name'
,p_source=>'QARU_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>400
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54279933995258493)
,p_name=>'P7_QARU_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Category'
,p_source=>'QARU_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'RULE_CATEGORIES_LOV'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54280091789258494)
,p_name=>'P7_QARU_ERROR_MESSAGE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Error Message'
,p_source=>'QARU_ERROR_MESSAGE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54280126112258495)
,p_name=>'P7_QARU_COMMENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Comment'
,p_source=>'QARU_COMMENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54280283710258496)
,p_name=>'P7_QARU_ERROR_LEVEL'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Error Level'
,p_source=>'QARU_ERROR_LEVEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'RULE_ERROR_LEVELS_LOV'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54280399454258497)
,p_name=>'P7_QARU_IS_ACTIVE'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_item_default=>'1'
,p_prompt=>'Active'
,p_source=>'QARU_IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'1'
,p_attribute_03=>'Yes'
,p_attribute_04=>'0'
,p_attribute_05=>'No'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54280469688258498)
,p_name=>'P7_QARU_LAYER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Layer'
,p_source=>'QARU_LAYER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'RULE_LAYERS_LOV'
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'5'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54281035237258504)
,p_name=>'P7_QARU_SQL'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(51468477464214102)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'SQL Statement'
,p_source=>'QARU_SQL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cHeight=>45
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54281888812258512)
,p_name=>'P7_QARU_EXCLUDE_OBJECTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Exclude Objects'
,p_source=>'QARU_EXCLUDE_OBJECTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_inline_help_text=>'Use a colon (:) to separate each object.'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(54281986130258513)
,p_name=>'P7_QARU_OBJECT_TYPES'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(51468339666214101)
,p_item_source_plug_id=>wwv_flow_imp.id(54073518069447836)
,p_prompt=>'Object Types'
,p_source=>'QARU_OBJECT_TYPES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>20
,p_field_template=>wwv_flow_imp.id(50843572694675165)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_inline_help_text=>'Use a colon (:) to separate each object type.'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'PROCESS'
,p_quick_pick_value_01=>'PROCESS'
,p_quick_pick_label_02=>'TABLE'
,p_quick_pick_value_02=>'TABLE'
,p_quick_pick_label_03=>'VIEW'
,p_quick_pick_value_03=>'VIEW'
,p_quick_pick_label_04=>'PACKAGE'
,p_quick_pick_value_04=>'PACKAGE'
,p_quick_pick_label_05=>'PACKAGE BODY'
,p_quick_pick_value_05=>'PACKAGE BODY'
,p_quick_pick_label_06=>'ITEM'
,p_quick_pick_value_06=>'ITEM'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(43123261717871103)
,p_validation_name=>'Validate if rule can be deleted'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'NOT qa_unit_tests_pkg.f_has_rule_test_results(pi_qaru_rule_number => :P7_QARU_RULE_NUMBER',
'                                            , pi_qaru_client_name => :P7_QARU_CLIENT_NAME)'))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'The Rule has saved test results and therefore cannot be deleted. Please set it to "Inactive" instead.'
,p_when_button_pressed=>wwv_flow_imp.id(54468111224367589)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37289631365645615)
,p_validation_name=>'Validate if Rule already exists'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_count number;',
'begin',
'  select count(1)',
'  into l_count',
'  from qa_rules',
'  where qaru_rule_number = :P7_QARU_RULE_NUMBER',
'  and qaru_client_name = :P7_QARU_CLIENT_NAME;',
'',
'  if l_count > 0',
'    then',
'      return false;',
'  else',
'      return true;',
'  end if;',
'  exception',
'    when no_data_found',
'      then',
'        return true;',
'end;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Rulenumber already exists for this client.'
,p_when_button_pressed=>wwv_flow_imp.id(37067720447570637)
,p_associated_item=>wwv_flow_imp.id(54279634041258490)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(37289712992645616)
,p_validation_name=>'Validate if Name already exists'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'  l_count number;',
'begin',
'  select count(1)',
'  into l_count',
'  from qa_rules',
'  where qaru_name = :P7_QARU_NAME',
'  and qaru_client_name = :P7_QARU_CLIENT_NAME;',
'',
'  if l_count > 0',
'    then',
'      return false;',
'  else',
'      return true;',
'  end if;',
'  exception',
'    when no_data_found',
'      then',
'        return true;',
'end;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Rulename already exists for this client.'
,p_when_button_pressed=>wwv_flow_imp.id(37067720447570637)
,p_associated_item=>wwv_flow_imp.id(54279823323258492)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(54281541618258509)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(54281519913258508)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(54281688797258510)
,p_event_id=>wwv_flow_imp.id(54281541618258509)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Close Dialog'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(54281819645258511)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(54073518069447836)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Save Form Process'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Changes saved.'
,p_internal_uid=>54281819645258511
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(42249416368031704)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>42249416368031704
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(54073597837447837)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(54073518069447836)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Edit Rule'
,p_internal_uid=>54073597837447837
);
wwv_flow_imp.component_end;
end;
/
