prompt --application/shared_components/logic/application_processes/getrulejsonattachment
begin
--   Manifest
--     APPLICATION PROCESS: getRuleJSONAttachment
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.4'
,p_default_workspace_id=>33657925800256602
,p_default_application_id=>141
,p_default_id_offset=>33662320935301187
,p_default_owner=>'QUASTO'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(21846427572731140)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'getRuleJSONAttachment'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  QA_APEX_APP_PKG.p_download_rules_json(:AI_CLIENT_NAME);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>1909756093
);
wwv_flow_imp.component_end;
end;
/
