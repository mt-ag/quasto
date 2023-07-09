prompt --application/shared_components/user_interface/lovs/category_lov
begin
--   Manifest
--     CATEGORY_LOV
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
 p_id=>wwv_flow_imp.id(21829999255912843)
,p_lov_name=>'CATEGORY_LOV'
,p_lov_query=>'.'||wwv_flow_imp.id(21829999255912843)||'.'
,p_location=>'STATIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(21830270823912856)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'APEX'
,p_lov_return_value=>'APEX'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(21830644153912856)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'DDL'
,p_lov_return_value=>'DDL'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(21831046704912856)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'DATA'
,p_lov_return_value=>'DATA'
);
wwv_flow_imp.component_end;
end;
/
