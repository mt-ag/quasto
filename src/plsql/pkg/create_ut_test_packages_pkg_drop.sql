PROMPT drop PACKAGE CREATE_UT_TEST_PACKAGES_PKG...

declare
  l_count  number;
  l_action varchar2(32767);
begin
  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'CREATE_UT_TEST_PACKAGES_PKG';
  if l_count > 0
  then
    l_action := 'drop package CREATE_UT_TEST_PACKAGES_PKG';
    execute immediate l_action;
    dbms_output.put_line('INFO: drop package CREATE_UT_TEST_PACKAGES_PKG sucessfully.');
  else
    dbms_output.put_line('WARNING: drop package CREATE_UT_TEST_PACKAGES_PKG already done.');
  end if;

  select count(1)
  into l_count
  from user_objects
  where object_type = 'PACKAGE'
  and object_name = 'CREATE_UT_TEST_PACKAGES_PKG';
  if l_count > 0
  then
    dbms_output.put_line('ERROR: drop package CREATE_UT_TEST_PACKAGES_PKG failed.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: drop package CREATE_UT_TEST_PACKAGES_PKG failed.' || substr(sqlerrm
                                                                                            ,1
                                                                                            ,400));
end;
/
