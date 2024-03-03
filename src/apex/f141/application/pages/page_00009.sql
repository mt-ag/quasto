prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_name=>'Config Scheduler Job'
,p_alias=>'CONFIG-SCHEDULER-JOB'
,p_page_mode=>'MODAL'
,p_step_title=>'Config Scheduler Job'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1500px'
,p_protection_level=>'C'
,p_page_component_map=>'18'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20240301143508'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51469936526214117)
,p_plug_name=>'Job History'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50747098537675120)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51468691337214104)
,p_plug_name=>'History Report'
,p_parent_plug_id=>wwv_flow_imp.id(51469936526214117)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50728801114675111)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'TABLE'
,p_query_table=>'JOBRUNDETAILS_V'
,p_query_where=>'JOB_NAME = :P9_CRONJOB_NAME'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P9_CRONJOB_NAME'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'History Report'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(19586845924742419)
,p_max_row_count=>'1000000'
,p_no_data_found_message=>'The Cronjob has not run recently.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'MWILHELM'
,p_internal_uid=>19586845924742419
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19586970316742420)
,p_db_column_name=>'JOB_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Job Name'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19587089238742421)
,p_db_column_name=>'LOG_DATE'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Log Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19587180500742422)
,p_db_column_name=>'STATUS'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19587231936742423)
,p_db_column_name=>'ERROR#'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Error Code'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19587320516742424)
,p_db_column_name=>'ERRORS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Errors'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(19587434041742425)
,p_db_column_name=>'RUN_DURATION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Run Duration'
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'OTHER'
,p_heading_alignment=>'LEFT'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(19638505959896345)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'196386'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'JOB_NAME:LOG_DATE:STATUS:ERROR#:ERRORS:RUN_DURATION'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(63080644826391011)
,p_plug_name=>'Buttons Container'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50733389987675114)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(101066088915146542)
,p_plug_name=>'Settings'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(59676815528121592)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(63080644826391011)
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
 p_id=>wwv_flow_imp.id(59677201614121593)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(63080644826391011)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8770002090376824)
,p_name=>'P9_CRONJOB_NAME'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_source=>'qa_unit_tests_pkg.f_get_job_name(pi_is_cronjob => ''Y'')'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470033103214118)
,p_name=>'P9_START_DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'First Start'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470112998214119)
,p_name=>'P9_LAST_START_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Last Start'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470239452214120)
,p_name=>'P9_NEXT_RUN_DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Next Run'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470389829214121)
,p_name=>'P9_REPEAT_INTERVAL'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Repeat Interval'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470447925214122)
,p_name=>'P9_JOB_STATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Job State'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51470763742214125)
,p_name=>'P9_LAST_RUN_DURATION'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Last Duration'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59677850853121599)
,p_name=>'P9_ENABLE_SCHEDULER_JOB'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(101066088915146542)
,p_prompt=>'Enable'
,p_source=>'qa_unit_tests_pkg.f_is_scheduler_cronjob_enabled'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_attribute_03=>'Enable'
,p_attribute_04=>'N'
,p_attribute_05=>'Disable'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(59678612308121615)
,p_name=>'Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(59676815528121592)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(59679021191121617)
,p_event_id=>wwv_flow_imp.id(59678612308121615)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Close Dialog'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(59678317328121614)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Scheduler Job Status'
,p_process_sql_clob=>'qa_unit_tests_pkg.p_enable_scheduler_job(pi_status => :P9_ENABLE_SCHEDULER_JOB);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(59677201614121593)
,p_process_success_message=>'Saved.'
,p_internal_uid=>59678317328121614
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(42250288169031712)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>42250288169031712
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(51470870455214126)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load information'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'select',
'  to_char(START_DATE, ''DD-MON-YYYY HH24:MI'')',
', to_char(LAST_START_DATE, ''DD-MON-YYYY HH24:MI'')',
', LAST_RUN_DURATION',
', to_char(NEXT_RUN_DATE, ''DD-MON-YYYY HH24:MI'')',
', REPEAT_INTERVAL',
', STATE',
'into ',
'  :P9_START_DATE',
', :P9_LAST_START_DATE',
', :P9_LAST_RUN_DURATION',
', :P9_NEXT_RUN_DATE',
', :P9_REPEAT_INTERVAL',
', :P9_JOB_STATE',
'from JOBDETAILS_P0009_V;',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>51470870455214126
);
wwv_flow_imp.component_end;
end;
/
