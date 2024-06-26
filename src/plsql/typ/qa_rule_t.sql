create or replace type qa_rule_t force as 

/******************************************************************************
   NAME:       qa_rule_t
   PURPOSE:    Attributes and constructors for initializing objects of type qa_rule_t

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   0.91       29.08.2022  olemm            Type has been added to QUASTO
   23.2       05.11.2023  mwilhelm         Attributes object_name and object_details have been added
******************************************************************************/

  object
  (
-- Information based on the rule
    qaru_id number                     -- id of the rule

-- optional attributes
   ,qaru_category      varchar2(10)    -- category of this rule row, based on the query
   ,qaru_error_level   number          -- overwrite the error level based on the content of the object
   ,qaru_error_message varchar2(4000)  -- overwrite the standard error_message for this rule
   ,qaru_object_types  varchar2(4000)  -- object types which
   ,qaru_sql           clob            -- sql query for this rule

-- Information based on the query, related to the object which is checked
   ,scheme_name         varchar2(100)  -- owner of the object
   ,object_id           number         -- object id if possible
   ,object_name         varchar2(1000) -- name of the object
   ,object_details      varchar2(2000) -- details about the object and where to find it
   ,object_type         varchar2(100)  -- objecttype
   ,object_value        varchar2(4000) -- value of the object itself
   ,object_updated_user varchar2(50)   -- last update user on object
   ,object_updated_date date           -- last update date on object

-- APEX specific parameters for buildung edit links
   ,apex_app_id  number                -- application where component is placed
   ,apex_page_id number,               -- page where component is placed

-- create object with minimal attributes to query
  constructor function qa_rule_t
  (
    pi_qaru_id            in number
   ,pi_qaru_category      in varchar2
   ,pi_qaru_error_level   in number
   ,pi_qaru_error_message in varchar2
   ,pi_qaru_object_types  in varchar2
   ,pi_qaru_sql           in clob
  ) return self as result,

-- Database objects
  constructor function qa_rule_t
  (
    pi_qaru_id             in number
   ,pi_qaru_category       in varchar2
   ,pi_qaru_error_level    in number
   ,pi_qaru_error_message  in varchar2
   ,pi_qaru_object_types   in varchar2
   ,pi_qaru_sql            in clob
   ,pi_scheme_name         in varchar2
   ,pi_object_id           in number
   ,pi_object_name         in varchar2
   ,pi_object_details      in varchar2
   ,pi_object_type         in varchar2
   ,pi_object_value        in varchar2
   ,pi_object_updated_user in varchar2
   ,pi_object_updated_date in date
  ) return self as result,

-- Unit tests
  constructor function qa_rule_t
  (
    pi_scheme_name    in varchar2
   ,pi_object_name    in varchar2
   ,pi_object_details in varchar2
   ,pi_error_message  in varchar2
  ) return self as result,

-- APEX rules
  constructor function qa_rule_t
  (
    pi_qaru_id             in number
   ,pi_qaru_category       in varchar2
   ,pi_qaru_error_level    in number
   ,pi_qaru_error_message  in varchar2
   ,pi_qaru_object_types   in varchar2
   ,pi_qaru_sql            in clob
   ,pi_scheme_name         in varchar2
   ,pi_object_id           in number
   ,pi_object_name         in varchar2
   ,pi_object_details      in varchar2
   ,pi_object_type         in varchar2
   ,pi_object_value        in varchar2
   ,pi_object_updated_user in varchar2
   ,pi_object_updated_date in date
   ,pi_apex_app_id         in number
   ,pi_apex_page_id        in number
    
  ) return self as result,

  member function to_string return varchar2
  )
;
/
create or replace type body qa_rule_t is

  constructor function qa_rule_t
  (
    pi_qaru_id            in number
   ,pi_qaru_category      in varchar2
   ,pi_qaru_error_level   in number
   ,pi_qaru_error_message in varchar2
   ,pi_qaru_object_types  in varchar2
   ,pi_qaru_sql           in clob
  ) return self as result is
  begin
    self.qaru_id            := pi_qaru_id;
    self.qaru_category      := pi_qaru_category;
    self.qaru_error_level   := pi_qaru_error_level;
    self.qaru_error_message := pi_qaru_error_message;
    self.qaru_object_types  := pi_qaru_object_types;
    self.qaru_sql           := pi_qaru_sql;
  
    return;
  end qa_rule_t;

  constructor function qa_rule_t
  (
    pi_qaru_id             in number
   ,pi_qaru_category       in varchar2
   ,pi_qaru_error_level    in number
   ,pi_qaru_error_message  in varchar2
   ,pi_qaru_object_types   in varchar2
   ,pi_qaru_sql            in clob
   ,pi_scheme_name         in varchar2
   ,pi_object_id           in number
   ,pi_object_name         in varchar2
   ,pi_object_details      in varchar2
   ,pi_object_type         in varchar2
   ,pi_object_value        in varchar2
   ,pi_object_updated_user in varchar2
   ,pi_object_updated_date in date
  ) return self as result is
  begin
    self.qaru_id             := pi_qaru_id;
    self.qaru_category       := pi_qaru_category;
    self.qaru_error_level    := pi_qaru_error_level;
    self.qaru_error_message  := pi_qaru_error_message;
    self.qaru_object_types   := pi_qaru_object_types;
    self.qaru_sql            := pi_qaru_sql;
    self.scheme_name         := pi_scheme_name;
    self.object_id           := pi_object_id;
    self.object_name         := pi_object_name;
    self.object_details      := pi_object_details;
    self.object_type         := pi_object_type;
    self.object_value        := pi_object_value;
    self.object_updated_user := pi_object_updated_user;
    self.object_updated_date := pi_object_updated_date;
  
    return;
  end qa_rule_t;

  constructor function qa_rule_t
  (
    pi_scheme_name    in varchar2
   ,pi_object_name    in varchar2
   ,pi_object_details in varchar2
   ,pi_error_message  in varchar2
  ) return self as result is
  begin
    self.scheme_name        := pi_scheme_name;
    self.object_name        := pi_object_name;
    self.object_details     := pi_object_details;
    self.qaru_error_message := pi_error_message;
  
    return;
  end qa_rule_t;

  constructor function qa_rule_t
  (
    pi_qaru_id             in number
   ,pi_qaru_category       in varchar2
   ,pi_qaru_error_level    in number
   ,pi_qaru_error_message  in varchar2
   ,pi_qaru_object_types   in varchar2
   ,pi_qaru_sql            in clob
   ,pi_scheme_name         in varchar2
   ,pi_object_id           in number
   ,pi_object_name         in varchar2
   ,pi_object_details      in varchar2
   ,pi_object_type         in varchar2
   ,pi_object_value        in varchar2
   ,pi_object_updated_user in varchar2
   ,pi_object_updated_date in date
   ,pi_apex_app_id         in number
   ,pi_apex_page_id        in number
    
  ) return self as result is
  begin
    self.qaru_id             := pi_qaru_id;
    self.qaru_category       := pi_qaru_category;
    self.qaru_error_level    := pi_qaru_error_level;
    self.qaru_error_message  := pi_qaru_error_message;
    self.qaru_object_types   := pi_qaru_object_types;
    self.qaru_sql            := pi_qaru_sql;
    self.scheme_name         := pi_scheme_name;
    self.object_id           := pi_object_id;
    self.object_name         := pi_object_name;
    self.object_details      := pi_object_details;
    self.object_type         := pi_object_type;
    self.object_value        := pi_object_value;
    self.object_updated_user := pi_object_updated_user;
    self.object_updated_date := pi_object_updated_date;
    self.apex_app_id         := pi_apex_app_id;
    self.apex_page_id        := pi_apex_page_id;
  
    return;
  end qa_rule_t;

  member function to_string return varchar2 is
  begin
    return '';
  end to_string;

end;
/
