prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.6'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Unit Test Generation'
,p_alias=>'UNIT-TEST-GENERATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Unit Test Generation'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1500px'
,p_protection_level=>'C'
,p_page_component_map=>'03'
,p_last_updated_by=>'MAURICE.WILHELM@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240419105318'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(21698602325160714)
,p_plug_name=>'Generation'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(21698836460160716)
,p_plug_name=>'Info'
,p_parent_plug_id=>wwv_flow_imp.id(21698602325160714)
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading js-removeLandmark'
,p_plug_template=>wwv_flow_imp.id(50721469375675106)
,p_plug_display_sequence=>10
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select the scheme names for which you want to generate or delete the Unit Tests for. If you don''t select any schemes, all schemes listed below will be affected.</p>',
'<p>In case of generation, a Unit Test procedure will be created for each QUASTO rule. If Unit Test procedures already existed for an affected scheme, they will be removed before they get recreated.</p>'))
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35261442189757201)
,p_plug_name=>'Generated Unit Test Packages'
,p_parent_plug_id=>wwv_flow_imp.id(21698602325160714)
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50747098537675120)
,p_plug_display_sequence=>40
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(35261805006757205)
,p_name=>'Package Report'
,p_parent_plug_id=>wwv_flow_imp.id(35261442189757201)
,p_template=>wwv_flow_imp.id(50790142840675136)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'QA_UNIT_TEST_PACKAGES_P0002_V'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(50807155826675144)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Unit Test packages found.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(35262163789757208)
,p_query_column_id=>1
,p_column_alias=>'PACKAGE_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Package Name'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(35262412258757211)
,p_query_column_id=>2
,p_column_alias=>'PACKAGE_STATUS'
,p_column_display_sequence=>20
,p_column_heading=>'Package Status'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(35262281910757209)
,p_query_column_id=>3
,p_column_alias=>'LAST_COMPILATION'
,p_column_display_sequence=>30
,p_column_heading=>'Last Compilation'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(84857843388194264)
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
 p_id=>wwv_flow_imp.id(21778190027803239)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(84857843388194264)
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
 p_id=>wwv_flow_imp.id(21814024111131501)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(84857843388194264)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete Unit Tests'
,p_button_position=>'DELETE'
,p_icon_css_classes=>'fa-trash'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21777713683803239)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(84857843388194264)
,p_button_name=>'GENERATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Generate'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21698960154160717)
,p_name=>'P2_OPTION'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(21698602325160714)
,p_item_default=>'1'
,p_prompt=>'Option'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Single Package per Scheme;1,Single Package per Scheme and Rule;2'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'2'
,p_attribute_02=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21699080815160718)
,p_name=>'P2_SCHEME_NAMES'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(21698602325160714)
,p_prompt=>'Scheme Names'
,p_display_as=>'NATIVE_SHUTTLE'
,p_named_lov=>'TEST_SCHEME_NAMES_LOV'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'MOVE'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(21814342500131504)
,p_validation_name=>'Validate Option selected for Generate'
,p_validation_sequence=>10
,p_validation=>':P2_OPTION is not null'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Please select the Option.'
,p_when_button_pressed=>wwv_flow_imp.id(21777713683803239)
,p_associated_item=>wwv_flow_imp.id(21698960154160717)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(21787538393803219)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(21778190027803239)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21788024310803219)
,p_event_id=>wwv_flow_imp.id(21787538393803219)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Close Dialog'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(21699169661160719)
,p_name=>'Deactivate Scheme Name selection'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_ALL_SCHEME_NAMES'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'select'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21699271586160720)
,p_event_id=>wwv_flow_imp.id(21699169661160719)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_SCHEME_NAME'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(21814161153131502)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Unit Tests'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'QA_UNIT_TESTS_PKG.p_create_unit_tests_for_schemes(pi_option => :P2_OPTION',
'                                                , pi_scheme_names => :P2_SCHEME_NAMES);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(21777713683803239)
,p_process_success_message=>'Unit Tests created.'
,p_internal_uid=>21814161153131502
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(21814256186131503)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Unit Tests'
,p_process_sql_clob=>'QA_UNIT_TESTS_PKG.p_delete_unit_tests_for_schemes(pi_scheme_names => :P2_SCHEME_NAMES);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(21814024111131501)
,p_process_success_message=>'Unit Tests deleted.'
,p_internal_uid=>21814256186131503
);
wwv_flow_imp.component_end;
end;
/
