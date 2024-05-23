-- --------------------------------------------------------------------------------
-- 
-- Oracle APEX source export file
-- 
-- The contents of this file are intended for review and analysis purposes only.
-- Developers must use the Application Builder to make modifications to an
-- application. Changes to this file will not be reflected in the application.
-- 
-- --------------------------------------------------------------------------------

-- ----------------------------------------
-- Page: 7 - Add/Edit Rule > Validation: Validate if Rule already exists > Validation > PL/SQL Function Body

declare
  l_count number;
begin
  select count(1)
  into l_count
  from qa_rules
  where qaru_rule_number = :P7_QARU_RULE_NUMBER
  and qaru_client_name = :P7_QARU_CLIENT_NAME;

  if l_count > 0
    then
      return false;
  else
      return true;
  end if;
  exception
    when no_data_found
      then
        return true;
end;

-- ----------------------------------------
-- Page: 7 - Add/Edit Rule > Validation: Validate if Name already exists > Validation > PL/SQL Function Body

declare
  l_count number;
begin
  select count(1)
  into l_count
  from qa_rules
  where qaru_name = :P7_QARU_NAME
  and qaru_client_name = :P7_QARU_CLIENT_NAME;

  if l_count > 0
    then
      return false;
  else
      return true;
  end if;
  exception
    when no_data_found
      then
        return true;
end;

