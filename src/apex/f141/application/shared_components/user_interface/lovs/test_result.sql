prompt --application/shared_components/user_interface/lovs/test_result
begin
--   Manifest
--     TEST_RESULT
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(19480956620142580)
,p_lov_name=>'TEST_RESULT'
,p_lov_query=>'.'||wwv_flow_imp.id(19480956620142580)||'.'
,p_location=>'STATIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(19481230607142584)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Failure'
,p_lov_return_value=>'0'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(19481638715142584)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Success'
,p_lov_return_value=>'1'
);
wwv_flow_imp.component_end;
end;
/
