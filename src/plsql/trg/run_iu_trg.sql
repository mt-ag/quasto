CREATE OR REPLACE TRIGGER RUN_IU_TRG
  BEFORE INSERT OR UPDATE ON utplsql_test_run
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
  IF inserting AND :new.run_id IS NULL THEN
    :new.run_id := run_seq.nextval;
  END IF;
  IF inserting THEN
    :new.run_create_date := SYSDATE;
    :new.run_create_user := l_user;
  END IF;
  IF updating OR inserting THEN
    :new.run_change_date := SYSDATE;
    :new.run_change_user := l_user;
  END IF;
END run_ui_trg;
/

ALTER TRIGGER RUN_IU_TRG ENABLE;