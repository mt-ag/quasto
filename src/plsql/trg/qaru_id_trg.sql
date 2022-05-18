PROMPT create trigger QARU_ID_TRG
declare 
  l_count number;
begin

  select count(1)
    into l_count
    from user_objects u
   where u.object_name = 'QARU_ID_TRG';

  if l_count = 0
  then
    execute immediate q'#create or replace editionable trigger QARU_ID_TRG
    before insert
    on QA_RULES
    for each row
begin
    :new.qaru_id := qaru_id_seq.nextval;
end;#';
    execute immediate 'alter trigger QARU_ID_TRG enable';

    select count(1)
      into l_count
      from user_objects u
     where u.object_name = 'QARU_ID_TRG';

    if l_count = 0
    then
      dbms_output.put_line('Creation of trigger QARU_ID_TRG failed.');
    else
      dbms_output.put_line('Trigger QARU_ID_TRG has been created.');
    end if;
  else
    dbms_output.put_line('Trigger QARU_ID_TRG was already created.');
  end if;

exception
  when others then
    dbms_output.put_line('Trigger QARU_ID_TRG could not been created.' || SQLERRM);
end;
/
