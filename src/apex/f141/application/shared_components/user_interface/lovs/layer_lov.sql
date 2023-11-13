prompt --application/shared_components/user_interface/lovs/layer_lov
begin
--   Manifest
--     LAYER_LOV
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.11'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(42333993626488557)
,p_lov_name=>'LAYER_LOV'
,p_lov_query=>'.'||wwv_flow_imp.id(42333993626488557)||'.'
,p_location=>'STATIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(42334237852488558)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'PAGE'
,p_lov_return_value=>'PAGE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(42334686648488559)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'APPLICATION'
,p_lov_return_value=>'APPLICATION'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(42335078144488559)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'DATABASE'
,p_lov_return_value=>'DATABASE'
);
wwv_flow_imp.component_end;
end;
/
