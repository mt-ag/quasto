prompt --application/shared_components/user_interface/lovs/test_execution_dates_lov
begin
--   Manifest
--     TEST_EXECUTION_DATES_LOV
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
 p_id=>wwv_flow_imp.id(28136793030913312)
,p_lov_name=>'TEST_EXECUTION_DATES_LOV'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_table=>'QA_TEST_EXECUTION_DATES_LOV'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'DESC'
);
wwv_flow_imp.component_end;
end;
/
