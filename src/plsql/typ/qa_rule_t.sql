create or replace type qa_rule_t force as object
(
-- Information based on the rule
  qaru_id             number, -- id of the rule
-- optional attributes
  qaru_category       varchar2(10), -- category of this rule row, based on the query
  qaru_error_level    number, -- overwrite the error level based on the content of the object
  qaru_object_type    varchar2(30), -- objecttype, based on query
  qaru_error_message  varchar2(4000), -- overwrite the standard error_message for this rule
-- Information based on the query, related to the object which is checked
  object_id           number, -- object id if possible
  object_name         varchar2(100), -- name of the object
  object_value        varchar2(4000), -- value of the object itself
  object_updated_user varchar2(50), -- last update user on object
  object_updated_date date, -- last update date on object
-- apex specific parameters for buildung edit links
  apex_app_id         number, -- application where component is placed
  apex_page_id        number, -- page where component is placed
  apex_region_id      number  -- region where component is placed
);
/
