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
-- Page: 9999 - Login Page > Process: Get Username Cookie > Source > PL/SQL Code

:P9999_USERNAME := apex_authentication.get_login_username_cookie;
:P9999_REMEMBER := case when :P9999_USERNAME is not null then 'Y' end;

