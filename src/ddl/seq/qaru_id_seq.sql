PROMPT create sequence QARU_ID_SEQ
declare 
  l_count number;
begin

  select count(1)
    into l_count
    from user_objects u
   where u.object_name = 'QARU_ID_SEQ';

  if l_count = 0
  then
    execute immediate 'create sequence QARU_ID_SEQ start with 1 increment by 1 minvalue 1 maxvalue 9999999999999999999999999999 nocycle noorder nocache';

    select count(1)
      into l_count
      from user_objects u
     where u.object_name = 'QARU_ID_SEQ';

    if l_count = 0
    then
      dbms_output.put_line('Creation of sequence QARU_ID_SEQ failed.');
    else
      dbms_output.put_line('Sequence QARU_ID_SEQ has been created.');
    end if;
  else
    dbms_output.put_line('Sequence QARU_ID_SEQ was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('Sequence QARU_ID_SEQ could not been created.' || SQLERRM);
end;
/
