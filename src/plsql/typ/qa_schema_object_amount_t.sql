create or replace type qa_schema_object_amount_t force as object
(
  schema_name   varchar2(100), -- owner of the object
  object_amount number, -- number of invalid objects

-- create object with attributes
  constructor function qa_schema_object_amount_t
  (
    pi_schema_name         in varchar2
   ,pi_object_amount       in number
  ) return self as result
)
;
/
create or replace type body qa_schema_object_amount_t is

  constructor function qa_schema_object_amount_t
  (
    pi_schema_name         in varchar2
   ,pi_object_amount       in number
  ) return self as result is
  begin
    self.schema_name         := pi_schema_name;
    self.object_amount       := pi_object_amount;

    return;
  end qa_schema_object_amount_t;

end;
/
