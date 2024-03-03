prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'Runtime Error'
,p_alias=>'RUNTIME-ERROR'
,p_page_mode=>'MODAL'
,p_step_title=>'Runtime Error'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
,p_last_updated_by=>'MWILHELM'
,p_last_upd_yyyymmddhh24miss=>'20240303150103'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(72887392674052001)
,p_plug_name=>'Runtime Error'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
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
,p_name=>'P3_RUNTIME_ERROR'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(72887392674052001)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Error Backtrace'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select qatr_runtime_error',
'from TESTRUNTIMEERROR_P0003_V',
'where qatr_id = :P3_QATR_ID'))
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
