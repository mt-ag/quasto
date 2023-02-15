PROMPT create or replace public synonym qa_rule_t for qa_rule_t
declare
  c_syn_name varchar2(100) := 'QA_RULE_T';
  l_count    number;
begin
  select count(1)
  into l_count
  from all_synonyms s
  where s.synonym_name = c_syn_name
  and s.owner = 'PUBLIC';

  if l_count = 0
  then
    execute immediate 'create or replace public synonym qa_rule_t for qa_rule_t';
  
    select count(1)
    into l_count
    from all_synonyms s
    where s.synonym_name = c_syn_name
    and s.owner = 'PUBLIC';
  
    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of public synonym ' || c_syn_name || ' failed.');
    else
      dbms_output.put_line('INFO: public synonym ' || c_syn_name || ' has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: public synonym ' || c_syn_name || ' was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: public synonym ' || c_syn_name || ' could not been created.' || sqlerrm);
end;
/
