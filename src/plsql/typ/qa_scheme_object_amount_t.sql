create or replace type qa_scheme_object_amount_t force as

/******************************************************************************
   NAME:       qa_scheme_object_amount_t
   PURPOSE:    Attributes and constructors for initializing objects of type qa_scheme_object_amount_t

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   23.2       05.11.2023  mwilhelm         Type has been added to QUASTO
******************************************************************************/

  object
  (
    scheme_name   varchar2(100) -- owner of the object
   ,object_amount number,       -- number of invalid objects

-- create object with attributes
  constructor function qa_scheme_object_amount_t
  (
    pi_scheme_name         in varchar2
   ,pi_object_amount       in number
  ) return self as result
  )
;
/
create or replace type body qa_scheme_object_amount_t is

  constructor function qa_scheme_object_amount_t
  (
    pi_scheme_name         in varchar2
   ,pi_object_amount       in number
  ) return self as result is
  begin
    self.scheme_name         := pi_scheme_name;
    self.object_amount       := pi_object_amount;

    return;
  end qa_scheme_object_amount_t;

end;
/
