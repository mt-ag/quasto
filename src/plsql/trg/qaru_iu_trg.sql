PROMPT create or replace trigger QARU_IU_TRG
CREATE OR REPLACE TRIGGER QARU_IU_TRG
  BEFORE INSERT OR UPDATE ON QA_RULES
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
DECLARE
  l_user VARCHAR2(255);
BEGIN
    SELECT nvl(v('APP_USER'), user)
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