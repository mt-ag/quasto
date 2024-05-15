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
-- Page: 9 - Config Scheduler Job > Process: Trigger Scheduler Cronjob > Source > PL/SQL Code

qa_unit_tests_pkg.p_trigger_scheduler_cronjob;

-- ----------------------------------------
-- Page: 9 - Config Scheduler Job > Process: Save Scheduler Job Status > Source > PL/SQL Code

qa_unit_tests_pkg.p_enable_scheduler_cronjob(pi_status => :P9_ENABLE_SCHEDULER_JOB);

-- ----------------------------------------
-- Page: 9 - Config Scheduler Job > Process: Load information > Source > PL/SQL Code

begin
select
  to_char(START_DATE, 'DD-MON-YYYY HH24:MI')
, to_char(LAST_START_DATE, 'DD-MON-YYYY HH24:MI')
, LAST_RUN_DURATION
, to_char(NEXT_RUN_DATE, 'DD-MON-YYYY HH24:MI')
, REPEAT_INTERVAL
, STATE
into 
  :P9_START_DATE
, :P9_LAST_START_DATE
, :P9_LAST_RUN_DURATION
, :P9_NEXT_RUN_DATE
, :P9_REPEAT_INTERVAL
, :P9_JOB_STATE
from QA_JOB_DETAILS_P0009_V;

exception
  when no_data_found
    then
      :P9_START_DATE        := null;
      :P9_LAST_START_DATE   := null;
      :P9_LAST_RUN_DURATION := null;
      :P9_NEXT_RUN_DATE     := null;
      :P9_REPEAT_INTERVAL   := null;
      :P9_JOB_STATE         := null;
end;

