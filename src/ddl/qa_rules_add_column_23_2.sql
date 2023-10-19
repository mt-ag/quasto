-- JIRA-Nr.: QUASTO-36
-- Bearbeiter: pdahlem
-- Datum: 18.10.23
-- Patch-Version: 23.2
-- Beschreibung: add column QARU_APP_ID(VARCHAR2 (4000 CHAR)) to QA_RULES
-- Skript-Name: qa_rules_add_column_23_2.sql

PROMPT alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR))

declare
  l_count number;
begin
  select count(1)
  into l_count
  from user_tab_cols
  where table_name = upper('QA_RULES')
  and column_name = upper('QARU_APP_ID');

  if (l_count > 0)
  then
    dbms_output.put_line('WARNING: alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR)) ist schon ausgefuehrt worden.');
  else
    execute immediate 'alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR))';
    execute immediate 'comment on column QA_RULES.QARU_APP_ID is ''Comma Seprated List containing all App_ids that will get tested- If the Value is Null all Applications will get tested''';
    dbms_output.put_line('INFO: alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR)) wurde erfolgreich ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_tab_cols
  where table_name = upper('QA_RULES')
  and column_name = upper('QARU_APP_ID');

  if (l_count = 0)
  then
    dbms_output.put_line('ERROR: alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR)) ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: alter table QA_RULES add (QARU_APP_ID VARCHAR2 (4000 CHAR)) ist fehlgeschlagen.' || substr(sqlerrm
                                                                                                                           ,1
                                                                                                                           ,400));
end;
/

PROMPT alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR))

declare
  l_count number;
begin
  select count(1)
  into l_count
  from user_tab_cols
  where table_name = upper('QA_RULES')
  and column_name = upper('QARU_PAGE_ID');

  if (l_count > 0)
  then
    dbms_output.put_line('WARNING: alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR)) ist schon ausgefuehrt worden.');
  else
    execute immediate 'alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR))';
    execute immediate 'comment on column QA_RULES.QARU_PAGE_ID is ''Comma Seprated List containing all Page_ids that will get tested. If the Value is Null all Pages will get tested''';
    dbms_output.put_line('INFO: alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR)) wurde erfolgreich ausgefuehrt.');
  end if;

  select count(1)
  into l_count
  from user_tab_cols
  where table_name = upper('QA_RULES')
  and column_name = upper('QARU_PAGE_ID');

  if (l_count = 0)
  then
    dbms_output.put_line('ERROR: alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR)) ist fehlgeschlagen.');
  end if;

exception
  when others then
    dbms_output.put_line('ERROR: alter table QA_RULES add (QARU_PAGE_ID VARCHAR2 (4000 CHAR)) ist fehlgeschlagen.' || substr(sqlerrm
                                                                                                                            ,1
                                                                                                                            ,400));
end;
/
