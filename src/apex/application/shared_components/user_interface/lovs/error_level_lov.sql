prompt --application/shared_components/user_interface/lovs/error_level_lov
begin
--   Manifest
--     ERROR_LEVEL_LOV
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.0'
,p_default_workspace_id=>17000820229357378
,p_default_application_id=>108
,p_default_id_offset=>0
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(20578016434799570)
,p_lov_name=>'ERROR_LEVEL_LOV'
,p_lov_query=>'.'||wwv_flow_imp.id(20578016434799570)||'.'
,p_location=>'STATIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(20578349245799571)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Error'
,p_lov_return_value=>'1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(20578756527799571)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Warning'
,p_lov_return_value=>'2'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(20579106499799571)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Info'
,p_lov_return_value=>'4'
);
wwv_flow_imp.component_end;
end;
/
