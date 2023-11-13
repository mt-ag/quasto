PROMPT create table QA_TEST_RESULTS
declare
  l_sql varchar2(32767) := 
'create table QA_TEST_RESULTS
(
  qatr_id              NUMBER not null,
  qatr_xml_result      CLOB not null,
  qatr_added_on        DATE not null,
  qatr_added_by	       VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'QA_TEST_RESULTS';
  
  if l_count = 0
  then
    execute immediate l_sql;

	  execute immediate q'#comment on table QA_TEST_RESULTS is 'table for the xml test results'#';
	  execute immediate q'#comment on column QA_TEST_RESULTS.qatr_id is 'pk column'#';
	  execute immediate q'#comment on column QA_TEST_RESULTS.qatr_xml_result is 'xml result of utplsql tests execution as clob'#';
	  execute immediate q'#comment on column QA_TEST_RESULTS.qatr_added_on is 'when is the test result added'#';
	  execute immediate q'#comment on column QA_TEST_RESULTS.qatr_added_by is 'who has the test result added'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'QA_TEST_RESULTS';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table QA_TEST_RESULTS failed.');
    else
      dbms_output.put_line('INFO: Table QA_TEST_RESULTS has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table QA_TEST_RESULTS was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table QA_TEST_RESULTS could not been created.' || SQLERRM);
end;
/
