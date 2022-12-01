PROMPT create or replace trigger QAIF_IU_TRG
create or replace trigger qaif_iu_trg
  before insert or update on qa_import_files
  referencing new as new old as old
  for each row
declare
  l_user varchar2(255);
begin
  select coalesce(sys_context('apex$session'
                             ,'app_user')
                 ,sys_context('userenv'
                             ,'os_user')
                 ,sys_context('userenv'
                             ,'session_user'))
  into l_user
  from dual;
  if inserting and
     :new.qaif_id is null
  then
    :new.qaif_id := qaif_seq.nextval;
  end if;
  if inserting
  then
    :new.qaif_created_on := sysdate;
    :new.qaif_created_by := l_user;
  end if;
  if updating or
     inserting
  then
    :new.qaif_updated_on := sysdate;
    :new.qaif_updated_by := l_user;
  end if;
end qaif_iu_trg;
/

alter trigger qaif_iu_trg enable;
