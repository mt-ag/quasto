prompt --application/shared_components/logic/application_items/ai_client_name
begin
--   Manifest
--     APPLICATION ITEM: AI_CLIENT_NAME
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.6'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(21846057534736099)
,p_name=>'AI_CLIENT_NAME'
,p_protection_level=>'P'
,p_version_scn=>1901984054
);
wwv_flow_imp.component_end;
end;
/
