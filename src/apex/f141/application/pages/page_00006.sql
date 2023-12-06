prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Rules'
,p_alias=>'RULES'
,p_step_title=>'Rules'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
,p_last_updated_by=>'SBOZOK'
,p_last_upd_yyyymmddhh24miss=>'20231128100610'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54073327692447835)
,p_plug_name=>'Rules'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54071262705447814)
,p_plug_name=>'Rules Report'
,p_parent_plug_id=>wwv_flow_imp.id(54073327692447835)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50728801114675111)
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select QARU_ID,',
'QARU_RULE_NUMBER,',
'QARU_CLIENT_NAME,',
'QARU_NAME,',
'QARU_CATEGORY,',
'QARU_ERROR_MESSAGE,',
'QARU_COMMENT,',
'QARU_ERROR_LEVEL,',
'QARU_IS_ACTIVE,',
'QARU_LAYER,',
'QARU_CREATED_ON,',
'QARU_CREATED_BY,',
'QARU_UPDATED_ON,',
'QARU_UPDATED_BY',
'from QA_RULES'))
,p_plug_source_type=>'NATIVE_IR'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Rules Report'
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
 p_id=>wwv_flow_imp.id(42907229798653329)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_QARU_ID:#QARU_ID#'
,p_detail_link_text=>'<img src="#APEX_FILES#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_owner=>'SBOZOK'
,p_internal_uid=>42907229798653329
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907305389653330)
,p_db_column_name=>'QARU_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Qaru Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907482835653331)
,p_db_column_name=>'QARU_RULE_NUMBER'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Qaru Rule Number'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907589746653332)
,p_db_column_name=>'QARU_CLIENT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Qaru Client Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907646606653333)
,p_db_column_name=>'QARU_NAME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Qaru Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907717940653334)
,p_db_column_name=>'QARU_CATEGORY'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Qaru Category'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907867360653335)
,p_db_column_name=>'QARU_ERROR_MESSAGE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Qaru Error Message'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42907956662653336)
,p_db_column_name=>'QARU_COMMENT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Qaru Comment'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908070995653337)
,p_db_column_name=>'QARU_ERROR_LEVEL'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Qaru Error Level'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908115635653338)
,p_db_column_name=>'QARU_IS_ACTIVE'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Qaru Is Active'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908299771653339)
,p_db_column_name=>'QARU_LAYER'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Qaru Layer'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908374280653340)
,p_db_column_name=>'QARU_CREATED_ON'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Qaru Created On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908433613653341)
,p_db_column_name=>'QARU_CREATED_BY'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Qaru Created By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908582870653342)
,p_db_column_name=>'QARU_UPDATED_ON'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Qaru Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(42908668899653343)
,p_db_column_name=>'QARU_UPDATED_BY'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Qaru Updated By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(48686523933119244)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'486866'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'QARU_ID:QARU_RULE_NUMBER:QARU_CLIENT_NAME:QARU_NAME:QARU_CATEGORY:QARU_ERROR_MESSAGE:QARU_COMMENT:QARU_ERROR_LEVEL:QARU_IS_ACTIVE:QARU_LAYER:QARU_CREATED_ON:QARU_CREATED_BY:QARU_UPDATED_ON:QARU_UPDATED_BY'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54282053948258514)
,p_plug_name=>'Breadcrumb Bar'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54468222926367591)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(54282053948258514)
,p_button_name=>'UPLOAD_RULE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Upload Rule'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54073316110447834)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(54282053948258514)
,p_button_name=>'CREATE_RULE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Rule'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_icon_css_classes=>'fa-plus-square'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(42249550385031705)
,p_name=>'Refresh Report after Dialog closed (Report)'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(54071262705447814)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(42249650107031706)
,p_event_id=>wwv_flow_imp.id(42249550385031705)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(54071262705447814)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(42249918798031709)
,p_name=>'Refresh Report after Dialog closed (Breadcrumb)'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(54282053948258514)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(42250031301031710)
,p_event_id=>wwv_flow_imp.id(42249918798031709)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(54071262705447814)
);
wwv_flow_imp.component_end;
end;
/
