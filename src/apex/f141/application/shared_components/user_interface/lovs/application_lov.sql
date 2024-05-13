prompt --application/shared_components/user_interface/lovs/application_lov
begin
--   Manifest
--     APPLICATION_LOV
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
 p_id=>wwv_flow_imp.id(44381359686205992)
,p_lov_name=>'APPLICATION_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select to_number(application_id) as r,  application_id || '' - '' || application_name as d',
'from apex_applications',
'where workspace != ''INTERNAL''',
'order by application_name desc'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp.component_end;
end;
/
