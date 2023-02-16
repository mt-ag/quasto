PROMPT create sequence QAIF_SEQ for table qa_import_files
declare 
  l_count number;
begin

  select count(1)
    into l_count
    from user_sequences
   where sequence_name = 'QAIF_SEQ';

  if l_count = 0
  then
    execute immediate 'create sequence QAIF_SEQ start with 1 increment by 1 minvalue 1 maxvalue 9999999999999999999999999999 nocycle noorder nocache';

    select count(1)
      into l_count
      from user_objects
     where object_name = 'QAIF_SEQ';

    if l_count = 0
    then
      dbms_output.put_line('ERROR: Creation of sequence QAIF_SEQ failed.');
    else
      dbms_output.put_line('INFO: Sequence QAIF_SEQ has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Sequence QAIF_SEQ was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: Sequence QAIF_SEQ could not been created.' || SQLERRM);
end;
/
