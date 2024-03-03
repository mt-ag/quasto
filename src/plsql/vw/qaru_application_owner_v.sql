
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "QARU_APPLICATION_OWNER_V"
  AS 
select application_id
        ,application_name
        ,owner
  from apex_applications
  order by owner asc
;
/
