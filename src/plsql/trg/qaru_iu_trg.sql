create or replace TRIGGER QARU_IU_TRG
  BEFORE INSERT OR UPDATE ON QA_RULES
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW

/******************************************************************************
   NAME:       qaru_iu_trg
   PURPOSE:    Trigger for insert and update operations on table qa_rules

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   0.91       29.08.2022  olemm            Trigger has been added to QUASTO
******************************************************************************/

DECLARE
  l_user VARCHAR2(255);
BEGIN
  SELECT coalesce(sys_context('apex$session','app_user') 
        ,sys_context('userenv','os_user')
	,sys_context('userenv','session_user'))
    INTO l_user
    FROM dual;
  IF inserting AND :new.qaru_id IS NULL THEN
    :new.qaru_id := qaru_seq.nextval;
  END IF;
  IF inserting THEN
    :new.qaru_created_on := SYSDATE;
    :new.qaru_created_by := l_user;
  END IF;
  IF updating OR inserting THEN
    :new.qaru_updated_on := SYSDATE;
    :new.qaru_updated_by := l_user;
  END IF;
END QARU_IU_TRG;
/

ALTER TRIGGER QARU_IU_TRG ENABLE;