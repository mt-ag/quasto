prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 108
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.0'
,p_default_workspace_id=>17000820229357378
,p_default_application_id=>108
,p_default_id_offset=>0
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(17210985899374021)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
