PROMPT create constraints QAIF_PK on qa_import_files
declare
  l_count  number;
  l_action varchar2(4000 char) := 'alter table qa_import_files add constraint QAIF_PK primary key (QAIF_ID)';
begin
  select count(1)
  into l_count
  from user_constraints
  where constraint_name = 'QAIF_PK';

  if l_count = 0
  then
    execute immediate l_action;
    dbms_output.put_line('INFO: ' || l_action || ' has been executed.');
  else
    dbms_output.put_line('WARNING: ' || l_action || ' was already executed.');
  end if;

  select count(1)
  into l_count
  from user_constraints
  where constraint_name = 'QAIF_PK';

  if l_count = 0
  then
    dbms_output.put_line('ERROR: ' || l_action || ' failed.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: ' || l_action || ' could not been executed. ' || sqlerrm);
end;
/
