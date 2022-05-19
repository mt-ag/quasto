PROMPT create or replace trigger CASE_IU_TRG
CREATE OR REPLACE TRIGGER CASE_IU_TRG
  BEFORE INSERT OR UPDATE ON utplsql_test_case
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
DECLARE
  l_user VARCHAR2(255);
BEGIN
  SELECT coalesce(sys_context('apex$session','app_user') 
        ,sys_context('userenv','os_user')
	,sys_context('userenv','session_user'))
    INTO l_user
    FROM dual;
  IF inserting AND :new.case_id IS NULL THEN
    :new.case_id := case_seq.nextval;
  END IF;
  IF inserting THEN
    :new.case_create_date := SYSDATE;
    :new.case_create_user := l_user;
  END IF;
  IF updating OR inserting THEN
    :new.case_change_date := SYSDATE;
    :new.case_change_user := l_user;
  END IF;
END case_ui_trg;
/

ALTER TRIGGER CASE_IU_TRG ENABLE;