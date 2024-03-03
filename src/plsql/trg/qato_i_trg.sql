create or replace TRIGGER "QATO_I_TRG" 
  BEFORE INSERT ON QA_TEST_RUN_INVALID_OBJECTS
  REFERENCING NEW AS NEW
  FOR EACH ROW

/******************************************************************************
   NAME:       qato_i_trg
   PURPOSE:    Trigger for insert operations on table qa_test_run_invalid_objects

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       01.03.2024  mwilhelm         Trigger has been added to QUASTO
******************************************************************************/

BEGIN
  IF inserting AND :new.qato_id IS NULL THEN
    :new.qato_id := qato_seq.nextval;
  END IF;
END QATO_I_TRG;
/

ALTER TRIGGER QATO_I_TRG ENABLE;