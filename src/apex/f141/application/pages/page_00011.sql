prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_name=>'Restart Unit Test'
,p_alias=>'RESTART-UNIT-TEST'
,p_page_mode=>'MODAL'
,p_step_title=>'Restart Unit Test'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1000px'
,p_protection_level=>'C'
,p_page_component_map=>'03'
,p_last_updated_by=>'MAURICE.WILHELM@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240404134243'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(104945985645082588)
,p_plug_name=>'Restart Unit Test'
,p_region_name=>'job_overview'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8769661398376820)
,p_plug_name=>'Job History'
,p_parent_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody:margin-top-md'
,p_plug_template=>wwv_flow_imp.id(50747098537675120)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(8767788728376801)
,p_name=>'History Report'
,p_region_name=>'history_report'
,p_parent_plug_id=>wwv_flow_imp.id(8769661398376820)
,p_template=>wwv_flow_imp.id(50728801114675111)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'QA_JOB_RUN_DETAILS_P0011_V'
,p_query_where=>'JOB_NAME like :P11_CUSTOM_JOB_NAME || ''%'''
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P11_CUSTOM_JOB_NAME'
,p_lazy_loading=>true
,p_query_row_template=>wwv_flow_imp.id(50807155826675144)
,p_query_num_rows=>5
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'No Jobs have run recently for this rule, client and scheme.'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8768928718376813)
,p_query_column_id=>1
,p_column_alias=>'JOB_NAME'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8769048853376814)
,p_query_column_id=>2
,p_column_alias=>'LOG_DATE'
,p_column_display_sequence=>20
,p_column_heading=>'Log Date'
,p_use_as_row_header=>'N'
,p_column_format=>'MM/DD/YYYY HH24:MI'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8769191068376815)
,p_query_column_id=>3
,p_column_alias=>'STATUS'
,p_column_display_sequence=>30
,p_column_heading=>'Job Execution Status'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8769531577376819)
,p_query_column_id=>4
,p_column_alias=>'ERROR#'
,p_column_display_sequence=>40
,p_column_heading=>'Error Code'
,p_use_as_row_header=>'N'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8769482526376818)
,p_query_column_id=>5
,p_column_alias=>'ERRORS'
,p_column_display_sequence=>50
,p_column_heading=>'Errors'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(8769208522376816)
,p_query_column_id=>6
,p_column_alias=>'RUN_DURATION'
,p_column_display_sequence=>70
,p_column_heading=>'Run Duration'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(28126610889016713)
,p_plug_name=>'Info'
,p_parent_plug_id=>wwv_flow_imp.id(8769661398376820)
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--info:t-Alert--removeHeading js-removeLandmark'
,p_plug_template=>wwv_flow_imp.id(50721469375675106)
,p_plug_display_sequence=>10
,p_plug_source=>'The following report shows the execution status of recent runs of scheduler jobs that have been executed for this rule and schema. Please note that the output only shows process states as well as errors if the execution of the Unit test logics failed'
||'. It does not indicate whether invalid objects that do not comply with the QUASTO rule were found or not.'
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
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(51471535036214133)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_button_name=>'RESTART_UNIT_TEST'
,p_button_static_id=>'button'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Restart Unit Test'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'QA_UNIT_TESTS_PKG.f_exists_custom_job(pi_qaru_rule_number => :P11_RULE_NUMBER',
'                                     ,pi_qaru_client_name => :P11_CLIENT_NAME',
'                                     ,pi_scheme_name => :P11_SCHEME_NAME) = ''N'''))
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-play-circle'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21671676825944301)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_button_name=>'UNIT_TEST_IN_PROGRESS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconLeft:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Unit Test in progress...'
,p_button_execute_validations=>'N'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'QA_UNIT_TESTS_PKG.f_exists_custom_job(pi_qaru_rule_number => :P11_RULE_NUMBER',
'                                     ,pi_qaru_client_name => :P11_CLIENT_NAME',
'                                     ,pi_scheme_name => :P11_SCHEME_NAME) = ''Y'''))
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-refresh fa-anim-spin'
,p_button_cattributes=>'disabled="disabled"'
,p_grid_new_row=>'Y'
,p_grid_column_span=>10
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(21671976762944304)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_button_name=>'REFRESH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--simple:t-Button--stretch'
,p_button_template_id=>wwv_flow_imp.id(50844813129675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'QA_UNIT_TESTS_PKG.f_exists_custom_job(pi_qaru_rule_number => :P11_RULE_NUMBER',
'                                     ,pi_qaru_client_name => :P11_CLIENT_NAME',
'                                     ,pi_scheme_name => :P11_SCHEME_NAME) = ''Y'''))
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8768814433376812)
,p_name=>'P11_CUSTOM_JOB_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(104945985645082588)
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'qa_unit_tests_pkg.f_get_job_name(pi_qaru_rule_number => :P11_RULE_NUMBER',
'                                ,pi_qaru_client_name => :P11_CLIENT_NAME',
'                                ,pi_scheme_name => :P11_SCHEME_NAME',
'                                ,pi_is_cronjob => ''N'')'))
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(21672053447944305)
,p_name=>'Refresh Page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(21671976762944304)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(21672195827944306)
,p_event_id=>wwv_flow_imp.id(21672053447944305)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'location.reload();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(51471617693214134)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create Job'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'qa_unit_tests_pkg.p_create_custom_unit_test_job(pi_qaru_rule_number => :P11_RULE_NUMBER',
'                                               ,pi_qaru_client_name => :P11_CLIENT_NAME',
'                                               ,pi_scheme_name => :P11_SCHEME_NAME);'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(51471535036214133)
,p_process_success_message=>'Job started.'
,p_internal_uid=>51471617693214134
);
wwv_flow_imp.component_end;
end;
/
