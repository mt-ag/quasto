prompt --application/shared_components/logic/application_processes/getutxmlattachment
begin
--   Manifest
--     APPLICATION PROCESS: getUTXMLAttachment
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
 p_id=>wwv_flow_imp.id(21646742059529764)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'getUTXMLAttachment'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  QA_UNIT_TESTS_PKG.p_download_unit_test_xml(:AI_XML_TEST_RESULT_ID);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>1901323520
);
wwv_flow_imp.component_end;
end;
/
