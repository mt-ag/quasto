
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_JOB_RUN_DETAILS_P0011_V"
  AS 
select job_name, log_date, status, error#, errors, lpad(extract(hour from run_duration),2,'0') || ':' || lpad(extract(minute from run_duration),2,'0') || ':' || lpad(extract(second from run_duration),2,'0') as run_duration
from USER_SCHEDULER_JOB_RUN_DETAILS
where job_name != qa_constant_pkg.get_constant_value('gc_utplsql_scheduler_cronjob_name')
order by log_date desc
;
/
