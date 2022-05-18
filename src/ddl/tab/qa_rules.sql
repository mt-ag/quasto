-- Create table
create table QA_RULES
(
  qaru_id              NUMBER not null,
  qaru_name            VARCHAR2(100 CHAR) not null,
  qaru_category        VARCHAR2(10 CHAR) not null,
  qaru_object_types    VARCHAR2(4000 CHAR) not null,
  qaru_error_message   VARCHAR2(4000 CHAR) not null,
  qaru_comment         VARCHAR2(4000 CHAR),
  qaru_exclude_objects VARCHAR2(4000 CHAR),
  qaru_error_level     NUMBER not null,
  qaru_is_active       NUMBER default 1 not null,
  qaru_sql             CLOB not null,
  qaru_predecessor_ids VARCHAR2(4000 CHAR),
  qaru_layer           VARCHAR2(100 CHAR) not null,
  qaru_created_on      DATE default sysdate not null,
  qaru_created_by      VARCHAR2(50 CHAR) default user not null,
  qaru_updated_on      DATE default sysdate not null,
  qaru_updated_by      VARCHAR2(50 CHAR) default user not null
);
-- Add comments to the table 
comment on table QA_RULES
  is 'Table for the rules defined for the QA Tool (v 0.1)';
-- Add comments to the columns 
comment on column QA_RULES.qaru_id
  is 'pk column';
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
  is 'colon delimted list of predecessors (qaru_ID). the rule will only be executed if there are no errors found for the predecessor';
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
-- Create/Recreate indexes 
create unique index qaru_PK_I on QA_RULES (qaru_ID);
create unique index qaru_UK_I on QA_RULES (qaru_NAME);
-- Create/Recreate primary, unique and foreign key constraints 
alter table QA_RULES
  add constraint qaru_PK primary key (qaru_ID);
alter table QA_RULES
  add constraint qaru_UK unique (qaru_NAME);
-- Create/Recreate check constraints 
alter table QA_RULES
  add constraint qaru_CHK_CATEGORY
  check (qaru_CATEGORY in ('APEX','DDL','DATA'));
alter table QA_RULES
  add constraint qaru_CHK_ERROR_LEVEL
  check (qaru_ERROR_LEVEL in (1,2,4));
alter table QA_RULES
  add constraint qaru_CHK_IS_ACTIVE
  check (qaru_IS_ACTIVE in (0,1));
alter table QA_RULES
  add constraint qaru_CHK_SQL
  check (length(qaru_SQL) <= 32767);
