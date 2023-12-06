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
,p_name=>'test new Page design'
,p_alias=>'TEST-NEW-PAGE-DESIGN'
,p_step_title=>'test new Page design'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_imp.id(50682476030675090)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'22'
,p_last_updated_by=>'SPRANG'
,p_last_upd_yyyymmddhh24miss=>'20231206113519'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(48696031437184346)
,p_plug_name=>'New'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(99862895938231347)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_06=>'N'
,p_attribute_09=>'N'
,p_attribute_12=>'10000'
,p_attribute_13=>'Y'
,p_attribute_15=>'10'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(102467399703659851)
,p_plug_name=>'Charts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(102467459445659852)
,p_plug_name=>'Quota Chart'
,p_parent_plug_id=>wwv_flow_imp.id(102467399703659851)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>4
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(48807738347704773)
,p_region_id=>wwv_flow_imp.id(102467459445659852)
,p_chart_type=>'donut'
,p_title=>'Quota'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(48808273751704775)
,p_chart_id=>wwv_flow_imp.id(48807738347704773)
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
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemes xmltype path ''system-out/Results/Scheme''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Scheme''',
'         PASSING testcases.schemes',
'         COLUMNS',
'           schemename VARCHAR2(50) PATH ''@name''',
'         ) schemes on 1=1',
'         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)',
'         and (:P11_SCHEME = schemes.schemename',
'             or :P11_SCHEME is null)',
'     )',
') order by status_amount desc'))
,p_ajax_items_to_submit=>'P11_DATE,P11_SCHEME'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'TESTCASE_STATUS'
,p_items_short_desc_column_name=>'TESTCASE_STATUS'
,p_color=>'&COLOR_HEX.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_PCT'
,p_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:RR,1:IR[TEST_REPORT]EQ_TESTCASE_STATUS,P11_DATE,P11_SCHEME:&TESTCASE_STATUS.,&P11_DATE.,&P11_SCHEME.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(102468039704659857)
,p_plug_name=>'Timeline Chart'
,p_parent_plug_id=>wwv_flow_imp.id(102467399703659851)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source_type=>'NATIVE_JET_CHART'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(48809186179704776)
,p_region_id=>wwv_flow_imp.id(102468039704659857)
,p_chart_type=>'lineWithArea'
,p_title=>'Timeline (max. 10 executions)'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(48810834537704777)
,p_chart_id=>wwv_flow_imp.id(48809186179704776)
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
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemes xmltype path ''system-out/Results/Scheme''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Scheme''',
'         PASSING testcases.schemes',
'         COLUMNS',
'           schemename VARCHAR2(50) PATH ''@name''',
'         ) schemes on 1=1',
'         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)',
'         and (:P11_SCHEME = schemes.schemename',
'             or :P11_SCHEME is null)',
'     ) where testcase_status = ''Success''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P11_DATE,P11_SCHEME'
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
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(48811435255704777)
,p_chart_id=>wwv_flow_imp.id(48809186179704776)
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
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemes xmltype path ''system-out/Results/Scheme''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Scheme''',
'         PASSING testcases.schemes',
'         COLUMNS',
'           schemename VARCHAR2(50) PATH ''@name''',
'         ) schemes on 1=1',
'         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)',
'         and (:P11_SCHEME = schemes.schemename',
'             or :P11_SCHEME is null)',
'     ) where testcase_status = ''Failure''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P11_DATE,P11_SCHEME'
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
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(48812046486704777)
,p_chart_id=>wwv_flow_imp.id(48809186179704776)
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
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_status VARCHAR2(4000) PATH ''@status'',',
'           schemes xmltype path ''system-out/Results/Scheme''',
'         ) testcases on 1=1',
'         left join XMLTABLE(''/Scheme''',
'         PASSING testcases.schemes',
'         COLUMNS',
'           schemename VARCHAR2(50) PATH ''@name''',
'         ) schemes on 1=1',
'         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)',
'         and (:P11_SCHEME = schemes.schemename',
'             or :P11_SCHEME is null)',
'     ) where testcase_status = ''Error''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P11_DATE,P11_SCHEME'
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
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(48810294356704776)
,p_chart_id=>wwv_flow_imp.id(48809186179704776)
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
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(48809684412704776)
,p_chart_id=>wwv_flow_imp.id(48809186179704776)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(102468610625659863)
,p_plug_name=>'Dashboard'
,p_parent_plug_id=>wwv_flow_imp.id(102467399703659851)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(99862895938231347)
,p_name=>'Test Executions Report'
,p_region_name=>'TEST_REPORT'
,p_parent_plug_id=>wwv_flow_imp.id(102468610625659863)
,p_template=>wwv_flow_imp.id(50728801114675111)
,p_display_sequence=>60
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'         ,case',
'		    when testcases.testcase_status = ''Failure'' then ',
'			  ''<a href="'' || APEX_PAGE.GET_URL (p_page   => 4,          ',
'											    p_items  => ''P4_QATR_ID,P4_TESTCASE_NAME,P4_DATE,P4_SCHEME'',',
'											    p_values =>  t.qatr_id ||'',''|| testcases.quasto_test_name || '','' || :P11_DATE || '','' || :P11_SCHEME) || ',
'			  ''">'' || ',
'				  ''<i class="fa fa-search"></i>'' ||',
'			  ''</a>''',
'           end as testcase_scheme_invalid_objects',
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
'         ,qaru.qaru_category',
'         , testresult.quasto_rulenumber',
'         , qaru.qaru_comment',
'         , t.qatr_added_on',
'    from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testsuite/testsuite''',
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
'           schemes xmltype path ''Scheme''',
'         ) testresult on 1=1',
'         left join XMLTABLE(''/Scheme''',
'         PASSING testresult.schemes',
'         COLUMNS',
'           schemename VARCHAR2(50) PATH ''@name'',',
'           schemeresult VARCHAR2(10) PATH ''@result''',
'         ) schemes on 1=1',
'         left join QA_RULES qaru',
'         on qaru.qaru_rule_number = testresult.quasto_rulenumber',
'         where (to_date(t.qatr_added_on) = :P11_DATE or :P11_DATE is null)',
'         and (schemes.schemename = :P11_SCHEME or :P11_SCHEME is null)',
'         order by t.qatr_added_on desc, testresult.quasto_rulenumber',
')'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P11_DATE,P11_SCHEME'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(50807155826675144)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953064421534328)
,p_query_column_id=>1
,p_column_alias=>'QATR_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Qatr Id'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953123897534329)
,p_query_column_id=>2
,p_column_alias=>'TESTCASE_SCHEME_INVALID_OBJECTS'
,p_column_display_sequence=>20
,p_column_heading=>'Testcase Scheme Invalid Objects'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953211024534330)
,p_query_column_id=>3
,p_column_alias=>'QUASTO_TEST_SUITE'
,p_column_display_sequence=>30
,p_column_heading=>'Quasto Test Suite'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953357298534331)
,p_query_column_id=>4
,p_column_alias=>'QUASTO_TEST_NAME'
,p_column_display_sequence=>40
,p_column_heading=>'Quasto Test Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953422683534332)
,p_query_column_id=>5
,p_column_alias=>'TESTCASE_STATUS'
,p_column_display_sequence=>50
,p_column_heading=>'Testcase Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953539910534333)
,p_query_column_id=>6
,p_column_alias=>'TESTCASE_SYSTEM_ERROR_INFO'
,p_column_display_sequence=>60
,p_column_heading=>'Testcase System Error Info'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953695756534334)
,p_query_column_id=>7
,p_column_alias=>'UTPLSQL_INFO'
,p_column_display_sequence=>70
,p_column_heading=>'Utplsql Info'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953755976534335)
,p_query_column_id=>8
,p_column_alias=>'QUASTO_LAYER'
,p_column_display_sequence=>80
,p_column_heading=>'Quasto Layer'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953829679534336)
,p_query_column_id=>9
,p_column_alias=>'QARU_CATEGORY'
,p_column_display_sequence=>90
,p_column_heading=>'Qaru Category'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48953963713534337)
,p_query_column_id=>10
,p_column_alias=>'QUASTO_RULENUMBER'
,p_column_display_sequence=>100
,p_column_heading=>'Quasto Rulenumber'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48954087421534338)
,p_query_column_id=>11
,p_column_alias=>'QARU_COMMENT'
,p_column_display_sequence=>110
,p_column_heading=>'Qaru Comment'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(48954100436534339)
,p_query_column_id=>12
,p_column_alias=>'QATR_ADDED_ON'
,p_column_display_sequence=>120
,p_column_heading=>'Qatr Added On'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(103082166395963275)
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
 p_id=>wwv_flow_imp.id(48800939108704760)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(102468610625659863)
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
 p_id=>wwv_flow_imp.id(48812918308704778)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(103082166395963275)
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
 p_id=>wwv_flow_imp.id(48813345218704778)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(103082166395963275)
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
 p_id=>wwv_flow_imp.id(48696190419184347)
,p_name=>'P11_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(48696031437184346)
,p_prompt=>'Search'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'ROW'
,p_attribute_02=>'FACET'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(48801338208704761)
,p_name=>'P11_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(102468610625659863)
,p_prompt=>'Date'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(qatr_added_on, ''DD-MON-YYYY HH24:MI'') as d',
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
 p_id=>wwv_flow_imp.id(48801768096704761)
,p_name=>'P11_SCHEME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(102468610625659863)
,p_prompt=>'Scheme'
,p_format_mask=>'RR-MON-DD'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select username as d',
'      ,username as r',
'from QARU_SCHEME_NAMES_FOR_TESTING_V',
'order by username asc'))
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(48951645370534314)
,p_name=>'CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(48696031437184346)
,p_prompt=>'Category'
,p_source=>'QARU_CATEGORY'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>false
,p_fc_compute_counts=>true
,p_fc_show_counts=>true
,p_fc_zero_count_entries=>'H'
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_sort_by_top_counts=>true
,p_fc_show_selected_first=>false
,p_fc_show_chart=>true
,p_fc_initial_chart=>false
,p_fc_actions_filter=>true
,p_fc_toggleable=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(48815687926704780)
,p_name=>'Refresh Regions'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(48800939108704760)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48816128929704780)
,p_event_id=>wwv_flow_imp.id(48815687926704780)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102467459445659852)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48816688415704781)
,p_event_id=>wwv_flow_imp.id(48815687926704780)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Timeline'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102468039704659857)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48817120757704781)
,p_event_id=>wwv_flow_imp.id(48815687926704780)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(99862895938231347)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(48813767376704779)
,p_name=>'Refresh Reports after Dialog closed (Breadcrumb)'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(103082166395963275)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48814236307704780)
,p_event_id=>wwv_flow_imp.id(48813767376704779)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota Chart'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102467459445659852)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48814758405704780)
,p_event_id=>wwv_flow_imp.id(48813767376704779)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Timeline Chart'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102468039704659857)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(48815241586704780)
,p_event_id=>wwv_flow_imp.id(48813767376704779)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Execution Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(99862895938231347)
);
wwv_flow_imp.component_end;
end;
/
