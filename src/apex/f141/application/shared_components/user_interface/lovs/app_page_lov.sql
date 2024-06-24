prompt --application/shared_components/user_interface/lovs/app_page_lov
begin
--   Manifest
--     APP_PAGE_LOV
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.6'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(44383986428080598)
,p_lov_name=>'APP_PAGE_LOV'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select page_id as r, page_id || '' - '' || page_name as d',
'from apex_application_pages',
'where workspace != ''INTERNAL'' and (:P20_APP_ID = application_id or :P20_APP_ID is null)'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'D'
,p_default_sort_direction=>'ASC'
);
wwv_flow_imp.component_end;
end;
/
