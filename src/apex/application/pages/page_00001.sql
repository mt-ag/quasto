prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.5'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page(
 p_id=>1
,p_name=>'Dashboard'
,p_alias=>'DASHBOARD'
,p_step_title=>'Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20230914142611'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53668689025955104)
,p_plug_name=>'Dashboard'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(51062974338526588)
,p_plug_name=>'Test Executions Report'
,p_region_name=>'TEST_REPORT'
,p_parent_plug_id=>wwv_flow_imp.id(53668689025955104)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50728801114675111)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
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
'from QA_TEST_RESULTS)',
'select * from ',
'(',
'    select t.qatr_id',
'          , case',
'		    when testcases.testcase_status = ''Failure'' then ',
'			  ''<a href="'' || APEX_PAGE.GET_URL (p_page   => 4,          ',
'											    p_items  => ''P4_QATR_ID,P4_TESTCASE_NAME,P4_DATE,P4_SCHEMA'',',
'											    p_values =>  t.qatr_id ||'',''|| testcases.quasto_test_name || '','' || :P1_DATE || '','' || :P1_SCHEMA) || ',
'			  ''">'' || ',
'				  ''<i class="fa fa-search"></i>'' ||',
'			  ''</a>''',
'           end as testcase_schema_invalid_objects',
'         , testsuite.quasto_test_suite',
'         , testcases.quasto_test_name',
'         , nvl(testcases.testcase_status, ''Success'') as testcase_status',
'         , case',
'		   when testcases.testcase_status = ''Error'' then ',
'			  ''<a href="'' || APEX_PAGE.GET_URL (p_page   => 3,          ',
'											    p_items  => ''P3_QATR_ID,P3_QUASTO_TESTCASE_NAME'',',
'											    p_values =>  t.qatr_id ||'',''|| testcases.quasto_test_name) || ',
'			  ''">'' || ',
'				  ''<i class="fa fa-exclamation-circle"></i>'' ||',
'			  ''</a>''',
'           end as testcase_system_error_info',
'         , case',
'		   when testcases.testcase_status = ''Failure'' then ',
'			  ''<a href="'' || APEX_PAGE.GET_URL (p_page   => 2,          ',
'											    p_items  => ''P2_QATR_ID,P2_QUASTO_TESTCASE_NAME'',',
'											    p_values =>  t.qatr_id ||'',''|| testcases.quasto_test_name) || ',
'			  ''">'' || ',
'				  ''<i class="fa fa-exclamation-circle"></i>'' ||',
'			  ''</a>''',
'           end as utplsql_info',
'         , testresult.quasto_layer',
'         , testresult.quasto_rulenumber',
'         , qaru.qaru_comment',
'         , t.qatr_added_on',
'    from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           quasto_test_suite VARCHAR2(50) PATH ''@name'',',
'           cases xmltype path ''testcase''',
'         ) testsuite on 1=1',
'         join XMLTABLE(''/testcase''',
'         PASSING testsuite.cases',
'         COLUMNS',
'           quasto_test_name VARCHAR2(4000) PATH ''@name'',',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           results xmltype path ''system-out/Results''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Results''',
'         PASSING testcases.results',
'         COLUMNS',
'           quasto_layer VARCHAR2(50) PATH ''@layer'',',
'           quasto_rulenumber VARCHAR2(10) PATH ''@rulenumber'',',
'           schemas xmltype path ''Schema''',
'         ) testresult on 1=1',
'         left join XMLTABLE(''/Schema''',
'         PASSING testresult.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name'',',
'           schemaresult VARCHAR2(10) PATH ''@result''',
'         ) schemas on 1=1',
'         left join QA_RULES qaru',
'         on qaru.qaru_rule_number = testresult.quasto_rulenumber',
'         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)',
'         and (schemas.schemaname = :P1_SCHEMA or :P1_SCHEMA is null)',
'         order by t.qatr_added_on desc, testresult.quasto_rulenumber',
')'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P1_DATE,P1_SCHEMA'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Test Executions Report'
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
 p_id=>wwv_flow_imp.id(52871266136757995)
,p_name=>'QUASTO_LAYER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUASTO_LAYER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Layer'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
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
 p_id=>wwv_flow_imp.id(52871397061757996)
,p_name=>'QUASTO_RULENUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUASTO_RULENUMBER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Rule Number'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attribute_05=>'BOTH'
,p_is_required=>false
,p_max_length=>10
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
 p_id=>wwv_flow_imp.id(53069227836762688)
,p_name=>'QUASTO_TEST_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUASTO_TEST_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Test Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
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
 p_id=>wwv_flow_imp.id(53069561888762691)
,p_name=>'QUASTO_TEST_SUITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUASTO_TEST_SUITE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Client Name'
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
 p_id=>wwv_flow_imp.id(53069637258762692)
,p_name=>'QATR_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QATR_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>10
,p_attribute_01=>'Y'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(53070308601762698)
,p_name=>'QARU_COMMENT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QARU_COMMENT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Rule Comment'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
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
 p_id=>wwv_flow_imp.id(53281891984003789)
,p_name=>'UTPLSQL_INFO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UTPLSQL_INFO'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'utPLSQL Failure'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'CENTER'
,p_link_target=>'&UTPLSQL_INFO.'
,p_link_text=>'&UTPLSQL_INFO.'
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
,p_escape_on_http_output=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(53667185870955089)
,p_name=>'TESTCASE_SYSTEM_ERROR_INFO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TESTCASE_SYSTEM_ERROR_INFO'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'System Error'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
,p_value_alignment=>'CENTER'
,p_link_target=>'&TESTCASE_SYSTEM_ERROR.'
,p_link_text=>'&TESTCASE_SYSTEM_ERROR_INFO.'
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
,p_escape_on_http_output=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(53667413456955091)
,p_name=>'TESTCASE_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TESTCASE_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Result'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>160
,p_value_alignment=>'CENTER'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
,p_is_required=>false
,p_max_length=>4000
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
 p_id=>wwv_flow_imp.id(54068720839447788)
,p_name=>'QATR_ADDED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QATR_ADDED_ON'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Execution Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
,p_value_alignment=>'CENTER'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
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
 p_id=>wwv_flow_imp.id(54069710629447798)
,p_name=>'TESTCASE_SCHEMA_INVALID_OBJECTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TESTCASE_SCHEMA_INVALID_OBJECTS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Invalid Objects'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_link_target=>'&TESTCASE_SCHEMA_INVALID_OBJECTS.'
,p_link_text=>'&TESTCASE_SCHEMA_INVALID_OBJECTS.'
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
,p_escape_on_http_output=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(51063022949526589)
,p_internal_uid=>17400702014225402
,p_is_editable=>false
,p_lazy_loading=>true
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
 p_id=>wwv_flow_imp.id(51068632827532058)
,p_interactive_grid_id=>wwv_flow_imp.id(51063022949526589)
,p_static_id=>'174064'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(51068832439532060)
,p_report_id=>wwv_flow_imp.id(51068632827532058)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52930557799198002)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(52871266136757995)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52931447025198011)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(52871397061757996)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53075308727763732)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(53069227836762688)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>300
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53141320947026958)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(53069561888762691)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>200
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53159945293131068)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(53069637258762692)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53217750693520504)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(53070308601762698)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53287633429013599)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(53281891984003789)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53676154718963085)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(53667185870955089)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53681415002978301)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(53667413456955091)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(54075138191450235)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(54068720839447788)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>150
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(54116572387751774)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(54069710629447798)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>120
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(33662790300301195)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_execution_seq=>5
,p_name=>'Success'
,p_column_id=>wwv_flow_imp.id(53667413456955091)
,p_background_color=>'#1c6d11'
,p_text_color=>'#fff6f6'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(53667413456955091)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Success'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(33663117961301192)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_execution_seq=>15
,p_name=>'Error'
,p_column_id=>wwv_flow_imp.id(53667413456955091)
,p_background_color=>'#7a1616'
,p_text_color=>'#fcf8f8'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(53667413456955091)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Error'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(33663217828301196)
,p_view_id=>wwv_flow_imp.id(51068832439532060)
,p_execution_seq=>10
,p_name=>'Failure'
,p_column_id=>wwv_flow_imp.id(53667413456955091)
,p_background_color=>'#c42222'
,p_text_color=>'#fff6f6'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(53667413456955091)
,p_condition_operator=>'IN'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Failure'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53667478103955092)
,p_plug_name=>'Charts'
,p_parent_plug_id=>wwv_flow_imp.id(53668689025955104)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53667537845955093)
,p_plug_name=>'Quota Chart'
,p_parent_plug_id=>wwv_flow_imp.id(53667478103955092)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(53667689137955094)
,p_region_id=>wwv_flow_imp.id(53667537845955093)
,p_chart_type=>'donut'
,p_title=>'Quota'
,p_height=>'200'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(53667818773955095)
,p_chart_id=>wwv_flow_imp.id(53667689137955094)
,p_seq=>10
,p_name=>'Quota'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'from QA_TEST_RESULTS)',
'select testcase_status, status_amount, color_hex from ',
'(',
'    select testcase_status',
'         , count(*) over (partition by testcase_status) as status_amount',
'         , case testcase_status',
'            when ''Failure'' then',
'               ''#c42222''',
'            when ''Error'' then',
'                ''#7a1616''',
'            else',
'                ''#1c6d11''',
'          end as color_hex',
'    from ',
'     ( select nvl(testcases.testcase_status, ''Success'') as testcase_status',
'     from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemas xmltype path ''system-out/Results/Schema''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Schema''',
'         PASSING testcases.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name''',
'         ) schemas on 1=1',
'         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)',
'         and (:P1_SCHEMA = schemas.schemaname',
'             or :P1_SCHEMA is null)',
'     )',
') order by status_amount desc'))
,p_ajax_items_to_submit=>'P1_DATE,P1_SCHEMA'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'TESTCASE_STATUS'
,p_color=>'&COLOR_HEX.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_PCT'
,p_threshold_display=>'onIndicator'
,p_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:RR,1:IG[TEST_REPORT]EQ_TESTCASE_STATUS,P1_DATE,P1_SCHEMA:&TESTCASE_STATUS.,&P1_DATE.,&P1_SCHEMA.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53668118104955098)
,p_plug_name=>'Timeline Chart'
,p_parent_plug_id=>wwv_flow_imp.id(53667478103955092)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(53668181381955099)
,p_region_id=>wwv_flow_imp.id(53668118104955098)
,p_chart_type=>'lineWithArea'
,p_title=>'Timeline (max. 10 executions)'
,p_height=>'200'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_stack_label=>'off'
,p_connect_nulls=>'Y'
,p_value_position=>'auto'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_show_label=>true
,p_show_row=>true
,p_show_start=>true
,p_show_end=>true
,p_show_progress=>true
,p_show_baseline=>true
,p_legend_rendered=>'off'
,p_legend_position=>'auto'
,p_overview_rendered=>'off'
,p_horizontal_grid=>'auto'
,p_vertical_grid=>'auto'
,p_gauge_orientation=>'circular'
,p_gauge_plot_area=>'on'
,p_show_gauge_value=>true
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(53668311390955100)
,p_chart_id=>wwv_flow_imp.id(53668181381955099)
,p_seq=>10
,p_name=>'Success'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'from QA_TEST_RESULTS)',
'select execution_date, testcase_status, status_amount, color_hex from ',
'(',
'    select testcase_status',
'         , count(1) as status_amount',
'         , ''#1c6d11'' as color_hex',
'         , execution_date',
'    from ',
'     ( select nvl(testcases.testcase_status, ''Success'') as testcase_status',
'            , t.qatr_added_on as execution_date',
'     from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemas xmltype path ''system-out/Results/Schema''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Schema''',
'         PASSING testcases.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name''',
'         ) schemas on 1=1',
'         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)',
'         and (:P1_SCHEMA = schemas.schemaname',
'             or :P1_SCHEMA is null)',
'     ) where testcase_status = ''Success''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P1_DATE,P1_SCHEMA'
,p_series_name_column_name=>'TESTCASE_STATUS'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'EXECUTION_DATE'
,p_color=>'&COLOR_HEX.'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(53669166727955109)
,p_chart_id=>wwv_flow_imp.id(53668181381955099)
,p_seq=>20
,p_name=>'Failure'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'from QA_TEST_RESULTS)',
'select execution_date, testcase_status, status_amount, color_hex from ',
'(',
'    select testcase_status',
'         , count(1) as status_amount',
'         , ''#c42222'' as color_hex',
'         , execution_date',
'    from ',
'     ( select nvl(testcases.testcase_status, ''Success'') as testcase_status',
'            , t.qatr_added_on as execution_date',
'     from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemas xmltype path ''system-out/Results/Schema''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Schema''',
'         PASSING testcases.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name''',
'         ) schemas on 1=1',
'         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)',
'         and (:P1_SCHEMA = schemas.schemaname',
'             or :P1_SCHEMA is null)',
'     ) where testcase_status = ''Failure''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P1_DATE,P1_SCHEMA'
,p_series_name_column_name=>'TESTCASE_STATUS'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'EXECUTION_DATE'
,p_color=>'&COLOR_HEX.'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(53669313706955110)
,p_chart_id=>wwv_flow_imp.id(53668181381955099)
,p_seq=>30
,p_name=>'Error'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'from QA_TEST_RESULTS)',
'select execution_date, testcase_status, status_amount, color_hex from ',
'(',
'    select testcase_status',
'         , count(1) as status_amount',
'         , ''#7a1616'' as color_hex',
'         , execution_date',
'    from ',
'     ( select nvl(testcases.testcase_status, ''Success'') as testcase_status',
'            , t.qatr_added_on as execution_date',
'     from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemas xmltype path ''system-out/Results/Schema''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Schema''',
'         PASSING testcases.schemas',
'         COLUMNS',
'           schemaname VARCHAR2(50) PATH ''@name''',
'         ) schemas on 1=1',
'         where (to_date(t.qatr_added_on) = :P1_DATE or :P1_DATE is null)',
'         and (:P1_SCHEMA = schemas.schemaname',
'             or :P1_SCHEMA is null)',
'     ) where testcase_status = ''Error''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P1_DATE,P1_SCHEMA'
,p_series_name_column_name=>'TESTCASE_STATUS'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'EXECUTION_DATE'
,p_color=>'&COLOR_HEX.'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
,p_items_label_display_as=>'PERCENT'
,p_threshold_display=>'onIndicator'
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.5'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(53668369396955101)
,p_chart_id=>wwv_flow_imp.id(53668181381955099)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_title=>'Execution Dates'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(53668472558955102)
,p_chart_id=>wwv_flow_imp.id(53668181381955099)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Amount'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_zoom_order_seconds=>false
,p_zoom_order_minutes=>false
,p_zoom_order_hours=>false
,p_zoom_order_days=>false
,p_zoom_order_weeks=>false
,p_zoom_order_months=>false
,p_zoom_order_quarters=>false
,p_zoom_order_years=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(54282244796258516)
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
 p_id=>wwv_flow_imp.id(53850038795459591)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(53668689025955104)
,p_button_name=>'FILTER'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--stretch:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Filter'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-filter'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(59669294668084191)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(54282244796258516)
,p_button_name=>'CONFIG_SCHEDULER_JOB'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Config Scheduler Job'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-clock-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(54282394419258517)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(54282244796258516)
,p_button_name=>'UPLOAD_TEST_RESULT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(50844844448675167)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Upload Test Result'
,p_button_position=>'CREATE'
,p_button_redirect_url=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-upload'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53668795793955105)
,p_name=>'P1_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(53668689025955104)
,p_prompt=>'Date'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select qatr_added_on as d',
'      ,qatr_added_on as r',
'from qa_test_results'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All -'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53796728929976192)
,p_name=>'P1_SCHEMA'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(53668689025955104)
,p_prompt=>'Schema'
,p_format_mask=>'RR-MON-DD'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select username as d',
'      ,username as r',
'from QARU_SCHEMA_NAMES_FOR_TESTING_V'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53668874270955106)
,p_name=>'Refresh Regions'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(53850038795459591)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53669102330955108)
,p_event_id=>wwv_flow_imp.id(53668874270955106)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(53667537845955093)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53669374151955111)
,p_event_id=>wwv_flow_imp.id(53668874270955106)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Timeline'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(53668118104955098)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53669003468955107)
,p_event_id=>wwv_flow_imp.id(53668874270955106)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(51062974338526588)
);
wwv_flow_imp.component_end;
end;
/
