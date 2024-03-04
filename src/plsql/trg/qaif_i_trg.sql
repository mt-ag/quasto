create or replace trigger qaif_i_trg
  before insert on qa_import_files
  referencing new as new
  for each row

begin
  if inserting and
     :new.qaif_id is null
  then
    :new.qaif_id := qaif_seq.nextval;
  end if;
end qaif_i_trg;
/

alter trigger qato_i_trg
  enable;