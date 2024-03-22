create or replace package qa_apex_pkg is

/******************************************************************************
   NAME:       qa_apex_pkg
   PURPOSE:    Methods for executing functions used on APEX pages

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       22.03.2024  mwilhelm         Package has been added to QUASTO
******************************************************************************/

  /**
   * procedure to upload a json rule file
   * @param pi_file_name defines the file name
  */
  procedure p_upload_rules_json(pi_file_name in varchar2);

  /**
   * procedure to download a json rule file
   * @param pi_client_name defines the client name for which rules should be exported
  */
  procedure p_download_rules_json(pi_client_name in varchar2);

  /**
   * procedure to upload a xml result file
   * @param pi_file_name defines the file name
  */
  procedure p_upload_unit_test_xml(pi_file_name in varchar2);

  /**
   * procedure to download a xml result as file
   * @param pi_qatr_id defines the xml test result id
  */
  procedure p_download_unit_test_xml(pi_qatr_id in number);

end qa_apex_pkg;
/
create or replace package body qa_apex_pkg as

  procedure p_upload_rules_json(
    pi_file_name in varchar2
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_upload_rules_json';
    l_param_list qa_logger_pkg.tab_param;

    l_clob_content clob;
    l_mime_type varchar2(100);
    l_file_name varchar2(100);
    l_mime_type_json varchar2(50) := 'application/json';
    l_qaif_id number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_file_name'
                              ,p_val_01  => pi_file_name);

    select to_clob(blob_content)
          ,mime_type
          ,filename
	into l_clob_content
        ,l_mime_type
        ,l_file_name
	from APEX_APPLICATION_TEMP_FILES
    where name = pi_file_name;
    
    if l_mime_type != l_mime_type_json
    then
      raise_application_error(-20001, 'Invalid MIME type of json file: ' || pi_file_name || ' - MIME type: ' || l_mime_type);
    end if;
   
    l_qaif_id := qa_export_import_rules_pkg.f_import_clob_to_qa_import_files(pi_clob     => l_clob_content
                                                                            ,pi_filename => l_file_name
                                                                            ,pi_mimetype => l_mime_type);
   
    qa_export_import_rules_pkg.p_import_clob_to_rules_table(pi_qaif_id => l_qaif_id);

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to import the json file!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_upload_rules_json;

  procedure p_download_rules_json(
   pi_client_name in varchar2
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_download_rules_json';
    l_param_list qa_logger_pkg.tab_param;

    l_offset number := 1;
    l_chunk number := 3000;
    l_clob_json clob;
    l_client_name_unified varchar2(500);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_client_name'
                              ,p_val_01  => pi_client_name);

    l_clob_json := qa_export_import_rules_pkg.f_export_rules_table_to_clob(pi_client_name => pi_client_name);
    
    l_client_name_unified := qa_utils_pkg.f_get_unified_string(pi_string => pi_client_name, pi_transform_case => 'l');
    
    HTP.init;
    OWA_UTIL.mime_header('application/json', false, 'UTF-8');
    HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_clob_json));
    HTP.p('Content-Type: application/octet-stream');
    HTP.p('Cache-Control: no-cache');
    HTP.p('Content-Disposition: attachment; filename="export_rules_' || l_client_name_unified || '_' || to_char(systimestamp, 'YYYYMMDDHH24MI') || '.json"');
    OWA_UTIL.http_header_close;

    loop
      exit when l_offset > length(l_clob_json);
      HTP.prn(substr(l_clob_json, l_offset, l_chunk));
      l_offset := l_offset + l_chunk;
     end loop;

    apex_application.stop_apex_engine;
  exception
    when apex_application.e_stop_apex_engine then
      null;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to export the json file!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_download_rules_json;

  procedure p_upload_unit_test_xml(
    pi_file_name in varchar2
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_upload_unit_test_xml';
    l_param_list qa_logger_pkg.tab_param;

    l_clob_content clob;
    l_mime_type varchar2(100);
    l_mime_type_xml varchar2(50) := 'application/xml';
    l_qatr_id number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_file_name'
                              ,p_val_01  => pi_file_name);

    select to_clob(blob_content)
          ,mime_type
	into l_clob_content
        ,l_mime_type
	from APEX_APPLICATION_TEMP_FILES
    where name = pi_file_name;
    
    if l_mime_type != l_mime_type_xml
    then
      raise_application_error(-20001, 'Invalid MIME type of xml file: ' || pi_file_name || ' - MIME type: ' || l_mime_type);
    end if;
   
    l_qatr_id := qa_unit_tests_pkg.f_import_test_result(pi_xml_clob => l_clob_content);

  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to upload the xml file!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_upload_unit_test_xml;

  procedure p_download_unit_test_xml(
    pi_qatr_id   in number
  )
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_download_unit_test_xml';
    l_param_list qa_logger_pkg.tab_param;

    l_offset number := 1;
    l_chunk number := 3000;
    l_clob_xml clob;
    l_added_on date;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_qatr_id'
                              ,p_val_01  => pi_qatr_id);

    l_clob_xml := qa_unit_tests_pkg.f_export_test_result(pi_qatr_id => pi_qatr_id);
    
    select qatr_added_on
    into l_added_on
    from qa_test_results
    where qatr_id = pi_qatr_id;
    
    HTP.init;
    OWA_UTIL.mime_header('application/xml', false, 'UTF-8');
    HTP.p('Content-Length: ' || DBMS_LOB.getlength(l_clob_xml));
    HTP.p('Content-Type: application/octet-stream');
    HTP.p('Cache-Control: no-cache');
    HTP.p('Content-Disposition: attachment; filename="export_unit_test_results_' || to_char(l_added_on, 'YYYYMMDDHH24MI') || '.xml"');
    OWA_UTIL.http_header_close;

    loop
      exit when l_offset > length(l_clob_xml);
      HTP.prn(substr(l_clob_xml, l_offset, l_chunk));
      l_offset := l_offset + l_chunk;
     end loop;

    apex_application.stop_apex_engine;
  exception
    when apex_application.e_stop_apex_engine then
      null;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the xml file of an unit test execution!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_download_unit_test_xml;

end qa_apex_pkg;
/