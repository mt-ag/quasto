PROMPT create or replace trigger CLDR_IU_TRG
CREATE OR REPLACE TRIGGER CLDR_IU_TRG
  BEFORE INSERT OR UPDATE ON utplsql_calendar
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
  IF inserting AND :new.cldr_id IS NULL THEN
    :new.cldr_id := cldr_seq.nextval;
  END IF;
  IF inserting THEN
    :new.cldr_create_date := SYSDATE;
    :new.cldr_create_user := l_user;
  END IF;
  IF updating OR inserting THEN
    :new.cldr_change_date := SYSDATE;
    :new.cldr_change_user := l_user;
  END IF;
END cldr_ui_trg;
/

ALTER TRIGGER CLDR_IU_TRG ENABLE;