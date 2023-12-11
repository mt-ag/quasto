prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_name=>'test page 1'
,p_alias=>'TEST-PAGE-1'
,p_step_title=>'test page 1'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>wwv_flow_imp.id(50682476030675090)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'22'
,p_last_updated_by=>'SPRANG'
,p_last_upd_yyyymmddhh24miss=>'20231208143154'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(101526312272608861)
,p_plug_name=>'Search Region'
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50747098537675120)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_02'
,p_plug_source_type=>'NATIVE_FACETED_SEARCH'
,p_filtered_region_id=>wwv_flow_imp.id(102563248301776917)
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_06=>'N'
,p_attribute_09=>'N'
,p_attribute_12=>'10000'
,p_attribute_13=>'Y'
,p_attribute_15=>'10'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(105168962989205433)
,p_plug_name=>'Dashboard'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(50780356327675132)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(102563248301776917)
,p_name=>'Test Executions Report'
,p_region_name=>'TEST_REPORT'
,p_parent_plug_id=>wwv_flow_imp.id(105168962989205433)
,p_template=>wwv_flow_imp.id(50728801114675111)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'OVERVIEWTESTS_P0001_V'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
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
 p_id=>wwv_flow_imp.id(50907859298097639)
,p_query_column_id=>1
,p_column_alias=>'QATR_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50907958160097640)
,p_query_column_id=>2
,p_column_alias=>'DETAILS'
,p_column_display_sequence=>20
,p_column_heading=>'Details'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908076807097641)
,p_query_column_id=>3
,p_column_alias=>'STATUS'
,p_column_display_sequence=>30
,p_column_heading=>'Status'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908129454097642)
,p_query_column_id=>4
,p_column_alias=>'UTPLSQL_INFO'
,p_column_display_sequence=>40
,p_column_heading=>'Utplsql Info'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908240088097643)
,p_query_column_id=>5
,p_column_alias=>'TEST_NAME'
,p_column_display_sequence=>50
,p_column_heading=>'Test Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908396757097644)
,p_query_column_id=>6
,p_column_alias=>'SCHEME'
,p_column_display_sequence=>60
,p_column_heading=>'Scheme'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908489614097645)
,p_query_column_id=>7
,p_column_alias=>'PROJECT'
,p_column_display_sequence=>70
,p_column_heading=>'Project'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908595522097646)
,p_query_column_id=>8
,p_column_alias=>'CATEGORY'
,p_column_display_sequence=>80
,p_column_heading=>'Category'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908688903097647)
,p_query_column_id=>9
,p_column_alias=>'NAME'
,p_column_display_sequence=>90
,p_column_heading=>'Name'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908746972097648)
,p_query_column_id=>10
,p_column_alias=>'LAYER'
,p_column_display_sequence=>100
,p_column_heading=>'Layer'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908885792097649)
,p_query_column_id=>11
,p_column_alias=>'ERRORLEVEL'
,p_column_display_sequence=>110
,p_column_heading=>'Errorlevel'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(50908985319097650)
,p_query_column_id=>12
,p_column_alias=>'ACTIVE'
,p_column_display_sequence=>120
,p_column_heading=>'Active'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(51633229391081201)
,p_query_column_id=>13
,p_column_alias=>'EXECUTION_DATE'
,p_column_display_sequence=>130
,p_column_heading=>'Execution Date'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(51633312005081202)
,p_query_column_id=>14
,p_column_alias=>'EXECUTION_DATE_CHAR'
,p_column_display_sequence=>140
,p_column_heading=>'Execution Date Char'
,p_use_as_row_header=>'N'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(105167752067205421)
,p_plug_name=>'Charts'
,p_region_name=>'QUOTA_CHART'
,p_parent_plug_id=>wwv_flow_imp.id(105168962989205433)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(105167811809205422)
,p_plug_name=>'Quota Chart'
,p_parent_plug_id=>wwv_flow_imp.id(105167752067205421)
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
 p_id=>wwv_flow_imp.id(51508957693250341)
,p_region_id=>wwv_flow_imp.id(105167811809205422)
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
,p_fill_multi_series_gaps=>false
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>false
,p_show_value=>true
,p_show_label=>false
,p_show_row=>false
,p_show_start=>false
,p_show_end=>false
,p_show_progress=>false
,p_show_baseline=>false
,p_legend_rendered=>'off'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
,p_show_gauge_value=>false
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(51509440294250342)
,p_chart_id=>wwv_flow_imp.id(51508957693250341)
,p_seq=>10
,p_name=>'Quota'
,p_data_source_type=>'SQL'
,p_data_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    select status testcase_status',
'         , count(*) over (partition by status) as status_amount',
'         , case status',
'            when ''Failure'' then',
'               ''#c42222''',
'            when ''Error'' then',
'                ''#7a1616''',
'            else',
'                ''#1c6d11''',
'          end as color_hex',
'    from table(get_faceted_search_data(:APP_PAGE_ID, ''TEST_REPORT''))',
'     '))
,p_ajax_items_to_submit=>'P10_CATEGORIES,P10_PROJECT,P10_SCHEME,P10_STATUS,P10_ERRORLEVEL,P10_EXECUTION_DATE_CHAR'
,p_items_value_column_name=>'STATUS_AMOUNT'
,p_items_label_column_name=>'TESTCASE_STATUS'
,p_items_short_desc_column_name=>'TESTCASE_STATUS'
,p_color=>'&COLOR_HEX.'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
,p_items_label_display_as=>'LBL_PCT'
,p_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_REPORT_STATUS_FILTER:&TESTCASE_STATUS.'
,p_link_target_type=>'REDIRECT_PAGE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(105168392068205427)
,p_plug_name=>'Timeline Chart'
,p_parent_plug_id=>wwv_flow_imp.id(105167752067205421)
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
 p_id=>wwv_flow_imp.id(51510325558250343)
,p_region_id=>wwv_flow_imp.id(105168392068205427)
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
,p_show_label=>false
,p_show_row=>false
,p_show_start=>false
,p_show_end=>false
,p_show_progress=>false
,p_show_baseline=>false
,p_legend_rendered=>'off'
,p_show_gauge_value=>false
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(51512020601250343)
,p_chart_id=>wwv_flow_imp.id(51510325558250343)
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
'         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)',
'         and (:P10_SCHEME = schemes.schemename',
'             or :P10_SCHEME is null)',
'     ) where testcase_status = ''Success''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P10_DATE,P10_SCHEMEX'
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
 p_id=>wwv_flow_imp.id(51512633352250344)
,p_chart_id=>wwv_flow_imp.id(51510325558250343)
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
'         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)',
'         and (:P10_SCHEME = schemes.schemename',
'             or :P10_SCHEME is null)',
'     ) where testcase_status = ''Failure''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P10_DATE,P10_SCHEMEX'
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
 p_id=>wwv_flow_imp.id(51513216642250344)
,p_chart_id=>wwv_flow_imp.id(51510325558250343)
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
'         where (to_date(t.qatr_added_on) = :P10_DATE or :P10_DATE is null)',
'         and (:P10_SCHEME = schemes.schemename',
'             or :P10_SCHEME is null)',
'     ) where testcase_status = ''Error''',
'     group by testcase_status, execution_date',
'     order by execution_date desc',
'     fetch first 10 rows only',
')'))
,p_ajax_items_to_submit=>'P10_DATE,P10_SCHEMEX'
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
 p_id=>wwv_flow_imp.id(51510814471250343)
,p_chart_id=>wwv_flow_imp.id(51510325558250343)
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
 p_id=>wwv_flow_imp.id(51511406035250343)
,p_chart_id=>wwv_flow_imp.id(51510325558250343)
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
 p_id=>wwv_flow_imp.id(105782518759508845)
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
 p_id=>wwv_flow_imp.id(51500817399250332)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(105168962989205433)
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
 p_id=>wwv_flow_imp.id(51514146113250345)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(105782518759508845)
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
 p_id=>wwv_flow_imp.id(51514533314250345)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(105782518759508845)
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
 p_id=>wwv_flow_imp.id(51501276445250335)
,p_name=>'P10_DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(105168962989205433)
,p_prompt=>'Date'
,p_format_mask=>'&DATE_FORMAT.'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_char(qatr_added_on, ''DD-MON-YYYY'')||'' - ''||row_number() over(partition by to_char(qatr_added_on, ''DD.MM.YYYY'') order by qatr_added_on)  as d',
'      ,qatr_added_on as r',
'from qa_test_results',
'order by qatr_added_on desc'))
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
 p_id=>wwv_flow_imp.id(51501622872250335)
,p_name=>'P10_SCHEMEX'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(105168962989205433)
,p_prompt=>'Schemex'
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
 p_id=>wwv_flow_imp.id(51502095185250335)
,p_name=>'P10_REPORT_STATUS_FILTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(105168962989205433)
,p_prompt=>'Report Status Filter'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51515225303250345)
,p_name=>'P10_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Search'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_SEARCH'
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'ROW'
,p_attribute_02=>'FACET'
,p_fc_show_chart=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51515672989250345)
,p_name=>'P10_CATEGORIES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Categories'
,p_source=>'CATEGORY'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51516090560250345)
,p_name=>'P10_PROJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Project'
,p_source=>'PROJECT'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51516476017250346)
,p_name=>'P10_SCHEME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Scheme'
,p_source=>'SCHEME'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT USERNAME as d, USERNAME AS R FROM QARU_SCHEME_NAMES_FOR_TESTING_V',
''))
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51516885564250346)
,p_name=>'P10_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Status'
,p_source=>'STATUS'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51517299092250346)
,p_name=>'P10_ERRORLEVEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Errorlevel'
,p_source=>'ERRORLEVEL'
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51517606831250346)
,p_name=>'P10_EXECUTION_DATE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(101526312272608861)
,p_prompt=>'Execution Date'
,p_source=>'EXECUTION_DATE_CHAR'
,p_source_type=>'FACET_COLUMN'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select execution_date_char  d, execution_date_char r ',
'from OVERVIEWTESTS_P0001_V ',
'order by execution_date desc',
''))
,p_item_template_options=>'#DEFAULT#'
,p_fc_show_label=>true
,p_fc_collapsible=>true
,p_fc_initial_collapsed=>false
,p_fc_compute_counts=>false
,p_fc_show_more_count=>7
,p_fc_filter_values=>false
,p_fc_show_selected_first=>false
,p_fc_actions_filter=>true
,p_fc_toggleable=>false
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
,p_multi_value_trim_space=>false
,p_fc_filter_combination=>'OR'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(51520744911250350)
,p_name=>'Refresh Regions'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(51500817399250332)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51521216584250350)
,p_event_id=>wwv_flow_imp.id(51520744911250350)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(105167811809205422)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51521702065250350)
,p_event_id=>wwv_flow_imp.id(51520744911250350)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Timeline'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(105168392068205427)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51522255581250350)
,p_event_id=>wwv_flow_imp.id(51520744911250350)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102563248301776917)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(51518945647250349)
,p_name=>'Refresh Reports after Dialog closed (Breadcrumb)'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(105782518759508845)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51519474477250349)
,p_event_id=>wwv_flow_imp.id(51518945647250349)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota Chart'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(105167811809205422)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51519951703250349)
,p_event_id=>wwv_flow_imp.id(51518945647250349)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Timeline Chart'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(105168392068205427)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51520499024250349)
,p_event_id=>wwv_flow_imp.id(51518945647250349)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Execution Report'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102563248301776917)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(51522609137250351)
,p_name=>'Repot neuanordnen'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(105167811809205422)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_display_when_type=>'NEVER'
,p_required_patch=>wwv_flow_imp.id(50668567409675065)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51523161369250351)
,p_event_id=>wwv_flow_imp.id(51522609137250351)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_REPORT_STATUS_FILTER'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.11'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51523674730250351)
,p_event_id=>wwv_flow_imp.id(51522609137250351)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(102563248301776917)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(51518003891250348)
,p_name=>'Filter Regions'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(101526312272608861)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'facetschange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(51518567575250349)
,p_event_id=>wwv_flow_imp.id(51518003891250348)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Refresh Quota Chart'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(105167811809205422)
);
wwv_flow_imp.component_end;
end;
/
