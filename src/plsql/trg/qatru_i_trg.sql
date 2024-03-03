create or replace TRIGGER "QATRU_I_TRG" 
  BEFORE INSERT ON QA_TEST_RUNS
  REFERENCING NEW AS NEW
  FOR EACH ROW

/******************************************************************************
   NAME:       qatru_i_trg
   PURPOSE:    Trigger for insert operations on table qa_test_runs

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   24.1       01.03.2024  mwilhelm         Trigger has been added to QUASTO
******************************************************************************/

DECLARE
  l_user VARCHAR2(255);
BEGIN
  SELECT coalesce(sys_context('apex$session','app_user') 
        ,sys_context('userenv','os_user')
	    ,sys_context('userenv','session_user'))
    INTO l_user
    FROM dual;
  IF inserting AND :new.qatr_id IS NULL THEN
    :new.qatr_id := qatru_seq.nextval;
  END IF;
  IF inserting THEN
    :new.qatr_date := SYSDATE;
    :new.qatr_added_by := l_user;
  END IF;
END QATRU_I_TRG;
/

ALTER TRIGGER QATRU_I_TRG ENABLE;