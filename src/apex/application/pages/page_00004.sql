prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Invalid Objects'
,p_alias=>'INVALID-OBJECTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Invalid Objects'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1250'
,p_protection_level=>'C'
,p_page_component_map=>'21'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20230627001113'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(20406404292146602)
,p_plug_name=>'Invalid Objects Report'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(17066480179373924)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with xml_result as',
'(select qatr_id,',
'        qatr_added_on,',
'        replace(',
'                 replace(',
'                          replace(',
'                                   QATR_XML_RESULT,',
'                                   ''<![CDATA[''',
'                                 ),',
'                                 '']]>''',
'                         ),',
'                         ''&quot;'',',
'                         ''''''''',
'                ) as xml_raw',
'from QA_TEST_RESULTS',
'where qatr_id = :P4_QATR_ID)',
'select * from ',
'(',
'    select t.qatr_id',
'         , schemas.schemaname',
'         , objects.objectname',
'         , objects.objectpath',
'         , objects.objectdetails',
'         , objects.error_message',
'    from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           quasto_test_name VARCHAR2(50) PATH ''@name'',',
'           schemas xmltype path ''system-out/Results/Schema''',
'         ) testcase on 1=1',
'         join XMLTABLE(''/Schema''',
'         PASSING testcase.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name'',',
'           objects xmltype path ''Object''',
'         ) schemas on 1=1',
'         join XMLTABLE(''/Object''',
'         PASSING schemas.objects',
'         COLUMNS',
'           objectname VARCHAR2(50) PATH ''@name'',',
'           objectpath VARCHAR2(100) PATH ''@path'',',
'           objectdetails VARCHAR2(500) PATH ''@details'',',
'           error_message VARCHAR2(500) PATH ''text()''',
'         ) objects on 1=1',
'         where (to_date(t.qatr_added_on) = :P4_DATE or :P4_DATE is null)',
'         and (:P4_SCHEMA = schemas.schemaname or :P4_SCHEMA is null)',
'         and testcase.quasto_test_name = :P4_TESTCASE_NAME',
'         order by t.qatr_added_on desc',
')'))
,p_plug_source_type=>'NATIVE_IG'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Invalid Objects Report'
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408330040146621)
,p_name=>'QATR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QATR_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408401202146622)
,p_name=>'OBJECTNAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OBJECTNAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408563845146623)
,p_name=>'OBJECTPATH'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OBJECTPATH'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Path'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408627543146624)
,p_name=>'OBJECTDETAILS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OBJECTDETAILS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Details'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>500
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408706617146625)
,p_name=>'ERROR_MESSAGE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ERROR_MESSAGE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Error Message'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>500
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(20408838160146626)
,p_name=>'SCHEMANAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCHEMANAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Schema'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(20408231418146620)
,p_internal_uid=>20408231418146620
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(20488922817543767)
,p_interactive_grid_id=>wwv_flow_imp.id(20408231418146620)
,p_static_id=>'204890'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(20489137936543768)
,p_report_id=>wwv_flow_imp.id(20488922817543767)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20489675000543769)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(20408330040146621)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20490552503543772)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(20408401202146622)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20491448988543775)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(20408563845146623)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>250
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20492387715543778)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(20408627543146624)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20493214831543781)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(20408706617146625)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(20517688808716250)
,p_view_id=>wwv_flow_imp.id(20489137936543768)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(20408838160146626)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20407131879146609)
,p_name=>'P4_DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(20406404292146602)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20407277924146610)
,p_name=>'P4_SCHEMA'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(20406404292146602)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20407436143146612)
,p_name=>'P4_QATR_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(20406404292146602)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(20407538394146613)
,p_name=>'P4_TESTCASE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(20406404292146602)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp.component_end;
end;
/
