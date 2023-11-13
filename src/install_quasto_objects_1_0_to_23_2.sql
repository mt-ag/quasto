PROMPT Running SQL file for installing the QUASTO objects on the database. Called from install_objects_1_0_to_23_2.sql 

set define '~'
set concat on
set concat .
set verify off


PROMPT UGPRADE TO 1.1
@src/install_quasto_objects_1_0_to_1_1.sql
PROMPT UGPRADE TO 23_2
@src/install_quasto_objects_1_1_to_23_2.sql


