create or replace trigger qaif_i_trg
  before insert on qa_import_files
  referencing new as new
  for each row

/******************************************************************************
   NAME:       qaif_i_trg
   PURPOSE:    Trigger for insert operations on table qa_import_files

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       04.03.2024  pdahlem          Trigger has been added to QUASTO
******************************************************************************/

begin
  if inserting and
     :new.qaif_id is null
  then
    :new.qaif_id := qaif_seq.nextval;
  end if;
end qaif_i_trg;
/