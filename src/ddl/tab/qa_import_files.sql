PROMPT create table QA_IMPORT_FILES
declare
  l_sql varchar2(32767) := 
'create table QA_IMPORT_FILES
(
  qaif_id         NUMBER not null,
  qaif_filename   VARCHAR2(200 CHAR) not null,
  qaif_mimetype   VARCHAR2(200 CHAR) not null,
  qaif_clob_data  CLOB not null,
  qaif_status     VARCHAR2(50 CHAR),
  qaif_error_log  VARCHAR2(4000 CHAR),
  qaif_created_on DATE not null,
  qaif_created_by VARCHAR2(255 CHAR) not null,
  qaif_updated_on DATE not null,
  qaif_updated_by VARcHAR2(255) not null
)';

  l_count number;
begin

  select count(1)
    into l_count
  from user_tables
   where table_name = 'QA_IMPORT_FILES';

  if l_count = 0 then
    execute immediate l_sql;
  
  execute immediate q'#comment on table QA_IMPORT_FILES is 'Import table for the JSON-files'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_id is 'pk column'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_filename is 'filename of the Improted Data'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_mimetype is 'mimetype of the File'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_clob_data is 'The Clob-File'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_status is 'the upload-status of the Clob-File'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_error_log is 'if the qaif_status is ERROR the cause of the error is placed here'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_created_on is 'when is the file uploaded'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_created_by is 'who uploaded the file'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_updated_on is 'when is the entry updated last'#';
  execute immediate q'#comment on column QA_IMPORT_FILES.qaif_updated_by is 'who updated the entry last'#';

    select count(1) 
      into l_count
    from user_tables 
     where table_name = 'QA_IMPORT_FILES';
  
    if l_count = 0 then
      dbms_output.put_line('ERROR: Creation of table QA_IMPORT_FILES failed.');
    else
      dbms_output.put_line('INFO: Table QA_IMPORT_FILES has been created');
    end if;
  else
    dbms_output.put_line('WARNING: Table QA_IMPORT_FILES was already created');
  end if;
exception
  when others then
    dbms_output.put_line('ERROR: Table QA_IMPORT_FILES could not been created. '|| sqlerrm);
end;
/





