PROMPT create table QA_RULES
declare
  l_sql varchar2(32767) := 
'create table QA_RULES
(
  qaru_id              NUMBER not null,
  qaru_rule_number     NVARCHAR2(20) not null,
  qaru_client_name     VARCHAR2(100) not null,
  qaru_name            VARCHAR2(100) not null,
  qaru_category        VARCHAR2(10) not null,
  qaru_object_types    VARCHAR2(4000) not null,
  qaru_error_message   VARCHAR2(4000) not null,
  qaru_comment         VARCHAR2(4000),
  qaru_exclude_objects VARCHAR2(4000),
  qaru_error_level     NUMBER not null,
  qaru_is_active       NUMBER default 1 not null,
  qaru_sql             CLOB not null,
  qaru_predecessor_ids VARCHAR2(4000),
  qaru_layer           VARCHAR2(100),
  qaru_created_on      DATE default sysdate not null,
  qaru_created_by      VARCHAR2(50) default user not null,
  qaru_updated_on      DATE default sysdate not null,
  qaru_updated_by      VARCHAR2(50) default user not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_objects u
   where u.object_name = 'QA_RULES';
  
  if l_count = 0
  then
    execute immediate l_sql;
	execute immediate 'create unique index QARU_PK_I on QA_RULES (QARU_ID)';
	execute immediate 'create unique index QARU_RULE_NUMBER_UK_I on QA_RULES (QARU_RULE_NUMBER)';
	execute immediate 'create unique index QARU_NAME_UK_I on QA_RULES (QARU_NAME)';
	execute immediate 'alter table QA_RULES add constraint QARU_PK primary key (QARU_ID)';
	execute immediate 'alter table QA_RULES add constraint QARU_RULE_NUMBER_UK unique (QARU_RULE_NUMBER)';
	execute immediate 'alter table QA_RULES add constraint QARU_NAME_UK unique (QARU_NAME)';
	execute immediate q'#alter table QA_RULES add constraint QARU_CHK_CATEGORY check (QARU_CATEGORY in ('APEX','DDL','DATA'))#';
	execute immediate 'alter table QA_RULES add constraint QARU_CHK_ERROR_LEVEL check (QARU_ERROR_LEVEL in (1,2,4))';
	execute immediate 'alter table QA_RULES add constraint QARU_CHK_IS_ACTIVE check (QARU_IS_ACTIVE in (0,1))';
	execute immediate 'alter table QA_RULES add constraint QARU_CHK_SQL check (length(QARU_SQL) <= 32767)';
	execute immediate q'#alter table QA_RULES add constraint QARU_CHK_LAYER check (QARU_LAYER in ('PAGE','APPLICATION','DATABASE'))#';
	
	dbms_output.put_line('Table QA_RULES has been created.');
  else
    dbms_output.put_line('Table QA_RULES was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('Table QA_RULES could not been created.' || SQLERRM);
end;
/

comment on table QA_RULES
  is 'Table for the rules defined for the QA Tool';
comment on column QA_RULES.qaru_id
  is 'pk column';
comment on column QA_RULES.qaru_rule_number
  is 'rule number';
comment on column QA_RULES.qaru_client_name
  is 'client project name';
comment on column QA_RULES.qaru_name
  is 'name of the rule. is shown when activating rules or as a headline in the output region of the plugin';
comment on column QA_RULES.qaru_category
  is 'the category can be APEX, DDL or DATA and defines for the rules are used';
comment on column QA_RULES.qaru_object_types
  is 'for every category there are different objecttypes. insert a colon delimited list.';
comment on column QA_RULES.qaru_error_message
  is 'this message is given when the rule mismatches';
comment on column QA_RULES.qaru_comment
  is 'further information for this rule';
comment on column QA_RULES.qaru_exclude_objects
  is 'objects which should be excluded when using this rule. a colon delimted list of names';
comment on column QA_RULES.qaru_error_level
  is 'different levels can be filtered out when runing the rules (1=Error, 2=Warning, 4=Info)';
comment on column QA_RULES.qaru_is_active
  is 'is rule active=1 or inactive=0';
comment on column QA_RULES.qaru_sql
  is 'sql query based on the supported type t_plugin_rule the query returns an amount of lines which is not fitting the rule. the length can be at maximum 32767 char';
comment on column QA_RULES.qaru_predecessor_ids
  is 'colon delimted list of predecessors (PIQA_ID). the rule will only be executed if there are no errors found for the predecessor';
comment on column QA_RULES.qaru_layer
  is 'is this rule related to objects on a single apex page (PAGE), to the apex application (APPLICATION) or to the database (DATABASE)';
comment on column QA_RULES.qaru_created_on
  is 'when is the rule created';
comment on column QA_RULES.qaru_created_by
  is 'who has the rule created';
comment on column QA_RULES.qaru_updated_on
  is 'when is the rule updated';
comment on column QA_RULES.qaru_updated_by
  is 'who has the rule updated';
