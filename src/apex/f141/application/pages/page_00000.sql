prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
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
 p_id=>0
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
,p_last_updated_by=>'PHILIPP.DAHLEM@HYAND.COM'
,p_last_upd_yyyymmddhh24miss=>'20240424175623'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(37433164330732402)
,p_plug_name=>'Provider Slogan'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(50790142840675136)
,p_plug_display_sequence=>30
,p_plug_display_point=>'REGION_POSITION_05'
,p_plug_source=>'<span style="font-size: var(--ut-footer-apex-font-size, .75rem);">&PROVIDER_SLOGAN.</span>'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp.component_end;
end;
/
