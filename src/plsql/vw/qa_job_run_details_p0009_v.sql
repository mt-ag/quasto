
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_JOB_RUN_DETAILS_P0009_V"
  AS 
  select job_name, log_date, status, error#, errors, lpad(to_char(extract(hour from run_duration)),2,'0') || ':' || lpad(to_char(extract(minute from run_duration)),2,'0') || ':' || lpad(to_char(extract(second from run_duration)),2,'0') as run_duration
from USER_SCHEDULER_JOB_RUN_DETAILS
where job_name = qa_utils_pkg.f_get_constant_string_value('gc_utplsql_scheduler_cronjob_name')
order by log_date desc
;
/
