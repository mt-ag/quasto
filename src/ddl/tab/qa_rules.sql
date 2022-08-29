PROMPT create table QA_RULES
declare
  l_sql varchar2(32767) := 
'create table QA_RULES
(
  qaru_id              NUMBER not null,
  qaru_rule_number     VARCHAR2(20 CHAR) not null,
  qaru_client_name     VARCHAR2(100 CHAR) not null,
  qaru_name	       	   VARCHAR2(100 CHAR) not null,
  qaru_category	       VARCHAR2(100 CHAR) not null,
  qaru_object_types    VARCHAR2(4000 CHAR) not null,
  qaru_error_message   VARCHAR2(4000 CHAR) not null,
  qaru_comment	       VARCHAR2(4000 CHAR),
  qaru_exclude_objects VARCHAR2(4000 CHAR),
  qaru_error_level     NUMBER not null,
  qaru_is_active       NUMBER default 1 not null,
  qaru_sql             CLOB not null,
  qaru_predecessor_ids VARCHAR2(4000 CHAR),
  qaru_layer           VARCHAR2(100 CHAR) not null,
  qaru_created_on      DATE not null,
  qaru_created_by      VARCHAR2(255 CHAR) not null,
  qaru_updated_on      DATE not null,
  qaru_updated_by      VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'QA_RULES';
  
  if l_count = 0
  then
    execute immediate l_sql;

	execute immediate q'#comment on table QA_RULES is 'table for the rules defined for the QA Tool'#';
	execute immediate q'#comment on column QA_RULES.qaru_id is 'pk column'#';
	execute immediate q'#comment on column QA_RULES.qaru_rule_number is 'rule number'#';
	execute immediate q'#comment on column QA_RULES.qaru_client_name is 'client project name'#';
	execute immediate q'#comment on column QA_RULES.qaru_name is 'name of the rule. is shown when activating rules or as a headline in the output region of the plugin'#';
	execute immediate q'#comment on column QA_RULES.qaru_category is 'the category can be APEX, DDL or DATA and defines for the rules are used'#';
	execute immediate q'#comment on column QA_RULES.qaru_object_types is 'for every category there are different objecttypes. insert a colon delimited list.'#';
	execute immediate q'#comment on column QA_RULES.qaru_error_message is 'this message is given when the rule mismatches'#';
	execute immediate q'#comment on column QA_RULES.qaru_comment is 'further information for this rule'#';
	execute immediate q'#comment on column QA_RULES.qaru_exclude_objects is 'objects which should be excluded when using this rule. a colon delimted list of names'#';
	execute immediate q'#comment on column QA_RULES.qaru_error_level is 'different levels can be filtered out when runing the rules (1=Error, 2=Warning, 4=Info)'#';
	execute immediate q'#comment on column QA_RULES.qaru_is_active is 'is rule active=1 or inactive=0'#';
	execute immediate q'#comment on column QA_RULES.qaru_sql is 'sql query based on the supported type t_plugin_rule the query returns an amount of lines which is not fitting the rule. the length can be at maximum 32767 char'#';
	execute immediate q'#comment on column QA_RULES.qaru_predecessor_ids is 'colon delimted list of predecessors (PIQA_ID). the rule will only be executed if there are no errors found for the predecessor'#';
	execute immediate q'#comment on column QA_RULES.qaru_layer is 'is this rule related to objects on a single apex page (PAGE), to the apex application (APPLICATION) or to the database (DATABASE)'#';
	execute immediate q'#comment on column QA_RULES.qaru_created_on is 'when is the rule created'#';
	execute immediate q'#comment on column QA_RULES.qaru_created_by is 'who has the rule created'#';
	execute immediate q'#comment on column QA_RULES.qaru_updated_on is 'when is the rule updated'#';
	execute immediate q'#comment on column QA_RULES.qaru_updated_by is 'who has the rule updated'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'QA_RULES';
    if l_count = 0 THEN 
      dbms_output.put_line('Creation of table QA_RULES failed.');
    else
      dbms_output.put_line('Table QA_RULES has been created.');
    end if;
  else
    dbms_output.put_line('Table QA_RULES was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('Table QA_RULES could not been created.' || SQLERRM);
end;
/
