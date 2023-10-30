create or replace force view qaru_apex_blacklisted_apps_v as
select a.application_id
      ,a.application_name
      ,a.workspace_display_name
from apex_applications a
where workspace_display_name not in ('INTERNAL');