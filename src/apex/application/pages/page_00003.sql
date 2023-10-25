prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'System Error'
,p_alias=>'SYSTEM-ERROR'
,p_page_mode=>'MODAL'
,p_step_title=>'System Error'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20230312132117'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72887392674052001)
,p_plug_name=>'System Error'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53306249749036324)
,p_name=>'P3_QUASTO_TESTCASE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(72887392674052001)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53306656824036326)
,p_name=>'P3_QATR_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(72887392674052001)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53307056095036326)
,p_name=>'P3_SYSTEM_ERROR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(72887392674052001)
,p_prompt=>'System Error Backtrace'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'with xml_result as',
'(select qatr_id,',
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
'where qatr_id = :P3_QATR_ID)',
'select system_error from ',
'(',
'    select testcases.system_error',
'    from xml_result t',
'         join XMLTABLE(''/testsuites/testsuite/testsuite/testcase''',
'         PASSING XMLTYPE( t.xml_raw )',
'         COLUMNS',
'           testcase_name VARCHAR2(4000) PATH ''@name'',',
'           system_error VARCHAR2(4000) PATH ''error/text()''',
'         ) testcases on 1=1',
'         where testcases.testcase_name = :P3_QUASTO_TESTCASE_NAME',
')'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_imp.id(50842276801675164)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp.component_end;
end;
/
