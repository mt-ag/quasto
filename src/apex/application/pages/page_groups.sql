prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 141
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.5'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(50873306834675208)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
