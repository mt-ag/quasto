set serveroutput on size 1000000;
set linesize 5000;
set pagesize 50000;
set long 50000;
declare
  
begin
  compare_schema_obj_pkg.compare_objects;
  compare_source_pkg.compare_all;
end;
/