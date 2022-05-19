PROMPT create or replace trigger SUITE_IU_TRG
CREATE OR REPLACE TRIGGER SUITE_IU_TRG
  BEFORE INSERT OR UPDATE ON utplsql_test_suite
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
  IF inserting AND :new.suite_id IS NULL THEN
    :new.suite_id := suite_seq.nextval;
  END IF; 
  IF inserting THEN
    :new.suite_create_date := SYSDATE;
    :new.suite_create_user := l_user;
  END IF;
  IF updating OR inserting THEN
    :new.suite_change_date := SYSDATE;
    :new.suite_change_user := l_user;
  END IF;
END suite_ui_trg;
/

ALTER TRIGGER SUITE_IU_TRG ENABLE;
