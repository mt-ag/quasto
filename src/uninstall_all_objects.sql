set serveroutput on;

prompt uninstall all objects
declare
  type t_vc2_array is table of varchar2(1000) index by varchar2(100);
  
  l_object_name t_vc2_array;
  l_object_type t_vc2_array;
  l_action      varchar2(32767);
  l_count       number;
begin
  -- buffer size extend
  dbms_output.enable(buffer_size => 10000000);

  -- objects:
  -- tables
  l_object_name('UTPLSQL_CALENDER') := 'UTPLSQL_CALENDER';
  l_object_type('UTPLSQL_CALENDER') := 'TABLE';
  l_object_name('UTPLSQL_TEST_CASE') := 'UTPLSQL_TEST_CASE';
  l_object_type('UTPLSQL_TEST_CASE') := 'TABLE';
  l_object_name('UTPLSQL_TEST_SUITE') := 'UTPLSQL_TEST_SUITE';
  l_object_type('UTPLSQL_TEST_SUITE') := 'TABLE';
  l_object_name('UTPLSQL_TEST_RUN') := 'UTPLSQL_TEST_RUN';
  l_object_type('UTPLSQL_TEST_RUN') := 'TABLE';
  l_object_name('QA_RULES_DROP') := 'QA_RULES_DROP';
  l_object_type('QA_RULES_DROP') := 'TABLE';

  -- packages
  l_object_name('PREPARE_TEST_RESULTS_PKG') := 'PREPARE_TEST_RESULTS_PKG';
  l_object_type('PREPARE_TEST_RESULTS_PKG') := 'PACKAGE';
  l_object_name('CREATE_UT_TEST_PACKAGES_PKG') := 'CREATE_UT_TEST_PACKAGES_PKG';
  l_object_type('CREATE_UT_TEST_PACKAGES_PKG') := 'PACKAGE';
  l_object_name('QA_PKG') := 'QA_PKG';
  l_object_type('QA_PKG') := 'PACKAGE';
  
  -- functions
  l_object_name('FC_EXPORT_QA_RULES') := 'FC_EXPORT_QA_RULES';
  l_object_type('FC_EXPORT_QA_RULES') := 'FUNCTION';
  
  -- types
  l_object_name('VARCHAR2_TAB_T') := 'VARCHAR2_TAB_T';
  l_object_type('VARCHAR2_TAB_T') := 'TYPE';
  l_object_name('QA_RULE_T_DROP') := 'QA_RULE_T_DROP';
  l_object_type('QA_RULE_T_DROP') := 'TYPE';
  
  l_object := l_object_name.first;
  while l_item is not null
  loop
    l_action := 'drop ' || l_object_type(l_object) || ' ' || l_object;
    select count(1) into l_count from user_objects s  where object_name = l_object and object_type = l_object_type(l_object);
    if l_count <> 0
    then  
      execute immediate(l_action);
      dbms_output.put_line ('INFO: ' || l_object_type(l_object) || ' ' || l_object || ' entfernt.');  
    end if;
    select count(1) into l_count from user_objects s  where object_name = l_object and object_type = l_object_type(l_object);
    if l_count <> 0
      dbms_output.put_line ('WARNING: ' || l_object_type(l_object) || ' ' || l_object || ' konnte nicht entfernt werden.');  
    end if;
	  l_key := l_objects.next(l_key);  
  end loop;
  
exception
  when others then
	  dbms_output.put_line ('ERROR: ' || l_action || ' konnte NICHT ausgefuehrt werden!' || substr(SQLERRM,0,200));
end;
/  
