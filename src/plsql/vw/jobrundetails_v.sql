
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "JOBRUNDETAILS_V"
  AS 
select job_name, log_date, status, error#, errors, run_duration
from USER_SCHEDULER_JOB_RUN_DETAILS
order by log_date desc
;
/
