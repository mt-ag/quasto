
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QA_JOB_DETAILS_P0009_V"
  AS 
select START_DATE, LAST_START_DATE, LAST_RUN_DURATION, NEXT_RUN_DATE, REPEAT_INTERVAL, STATE
from USER_SCHEDULER_JOBS
where job_name = qa_constant_pkg.get_constant_value('gc_utplsql_scheduler_cronjob_name')
;
/
