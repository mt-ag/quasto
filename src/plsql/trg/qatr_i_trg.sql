create or replace TRIGGER "QATR_I_TRG" 
  BEFORE INSERT ON QA_TEST_RESULTS
  REFERENCING NEW AS NEW
  FOR EACH ROW

/******************************************************************************
   NAME:       qatr_i_trg
   PURPOSE:    Trigger for insert operations on table qa_test_results

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   23.2       05.11.2023  mwilhelm         Trigger has been added to QUASTO
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
    :new.qatr_id := qatr_seq.nextval;
  END IF;
  IF inserting THEN
    :new.qatr_added_on := SYSDATE;
    :new.qatr_added_by := l_user;
  END IF;
END QATR_I_TRG;
/

ALTER TRIGGER QATR_I_TRG ENABLE;