create or replace package compare_scheme_obj_pkg 
as

procedure compare_tables;

procedure compare_views;

procedure compare_triggers;

procedure compare_sequences;

procedure compare_indexes;

procedure compare_objects;

procedure compare_constraints;

procedure compare_packages;

procedure compare_package_bodies;

procedure compare_types;

procedure compare_functions;

procedure compare_procedures;

procedure compare_materialized_views;

procedure compare_synonyms;

end compare_scheme_obj_pkg;
/
create or replace package body compare_scheme_obj_pkg 
as

procedure compare_tables
is
  l_count number := 0;

  cursor cur_tables_dev is
    select object_name
      from user_objects
     where object_type = 'TABLE'
    minus
     select object_name
       from user_objects@QUASTO_TEST
      where object_type = 'TABLE';
  
  cursor cur_tables_test is
    select object_name 
      from user_objects@QUASTO_TEST
     where object_type = 'TABLE'
   minus
    select object_name
      from user_objects
     where object_type = 'TABLE';
begin
  
  for dev in cur_tables_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Tables exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_tables_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Tables exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
    l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_tables;

procedure compare_views
is
  l_count number := 0;

  cursor cur_views_dev is
    select object_name
      from user_objects
     where object_type = 'VIEW'
   minus
    select object_name 
      from user_objects@QUASTO_TEST
     where object_type = 'VIEW';

  cursor cur_views_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'VIEW'
   minus
    select object_name
      from user_objects
     where object_type = 'VIEW';
begin
  for dev in cur_views_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Views exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_views_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Views exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_views;

procedure compare_triggers
is
  l_count number := 0;

  cursor cur_trigger_dev is
    select object_name
      from user_objects
     where object_type = 'TRIGGER'
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'TRIGGER';

  cursor cur_trigger_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'TRIGGER'
   minus
    select object_name
      from user_objects
     where object_type = 'TRIGGER';
begin
  for dev in cur_trigger_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Trigger exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_trigger_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Trigger exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_triggers;

procedure compare_sequences
is
  l_count number := 0;

  cursor cur_sequence_dev is
    select object_name 
      from user_objects
     where object_type = 'SEQUENCE'
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'SEQUENCE';

  cursor cur_sequence_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'SEQUENCE'
   minus
    select object_name
      from user_objects
     where object_type = 'SEQUENCE';
begin
  for dev in cur_sequence_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Sequences exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_sequence_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Sequences exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_sequences;


procedure compare_indexes
is
  l_count number := 0;

  cursor cur_index_dev is
    select index_name 
      from user_indexes
     where index_type <> 'LOB'
   minus
    select index_name
      from user_indexes@QUASTO_TEST
     where index_type <> 'LOB';

  cursor cur_index_test is
    select index_name
      from user_indexes@QUASTO_TEST
     where index_type <> 'LOB'
   minus 
    select index_name
      from user_indexes
     where index_type <> 'LOB';
begin
  for dev in cur_index_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Indexes exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.index_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_index_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Indexes exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.index_name);
  end loop;
  
  l_count := 0;
exception 
  when others then 
    raise_application_error(-20001, sqlerrm);
end compare_indexes;

procedure compare_constraints
is
  l_count number := 0;

  cursor cur_constraint_dev is
    select constraint_name 
      from user_constraints
   minus
    select constraint_name
      from user_constraints@QUASTO_TEST;

  cursor cur_constraint_test is
    select constraint_name
      from user_constraints@QUASTO_TEST
   minus
    select constraint_name
      from user_constraints;
begin
  for dev in cur_constraint_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Constraints exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.constraint_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_constraint_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Constraints exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.constraint_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_constraints;

procedure compare_packages
is
  l_count number := 0;
  
  l_test_pkg varchar2(100) := 'QA_UT_MT_AG_%'; --diese Packages werden automatisch generiert und sollten nicht mit verglichen werden

  cursor cur_package_dev is
    select object_name 
      from user_objects
     where object_type = 'PACKAGE'
       and object_name not like l_test_pkg
       and object_name not in ('COMPARE_scheme_OBJ_PKG', 'COMPARE_SOURCE_PKG') --compare-packages -> nur auf DEV
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'PACKAGE'
       and object_name not like l_test_pkg;

  cursor cur_package_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'PACKAGE'
       and object_name not like l_test_pkg
   minus
    select object_name
      from user_objects
     where object_type = 'PACKAGE'
       and object_name not like l_test_pkg
       and object_name not in ('COMPARE_scheme_OBJ_PKG', 'COMPARE_SOURCE_PKG'); --compare-packages -> nur auf DEV
begin
  for dev in cur_Package_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Package Specifications exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_package_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Package Specifications exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception 
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_packages;

procedure compare_package_bodies
is
  l_count number := 0;
  
  l_test_pkg varchar2(100) := 'QA_UT_MT_AG_%';--wird automatisch generiert

  cursor cur_package_body_dev is
    select object_name
      from user_objects
     where object_type = 'PACKAGE BODY'
       and object_name not like l_test_pkg
       and object_name not in ('COMPARE_scheme_OBJ_PKG', 'COMPARE_SOURCE_PKG') --nur auf DEV -> Zum Vergleichen der Objekte
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'PACKAGE BODY'
       and object_name not like l_test_pkg;

  cursor cur_package_body_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'PACKAGE BODY'
       and object_name not like l_test_pkg
   minus
    select object_name
      from user_objects
     where object_type = 'PACKAGE BODY'
       and object_name not like l_test_pkg
       and object_name not in ('COMPARE_scheme_OBJ_PKG', 'COMPARE_SOURCE_PKG'); --nur auf DEV -> Zum Vergleichen der Objekte
begin
  for dev in cur_package_body_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Package Bodies exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_package_body_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Package Bodies exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_package_bodies;

procedure compare_types
is
  l_count number;

  cursor cur_type_dev is
    select object_name 
      from user_objects
     where object_type = 'TYPE'
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'TYPE';
     
  cursor cur_type_test is
    select object_name 
      from user_objects@QUASTO_TEST
     where object_type = 'TYPE'
   minus 
    select object_name
      from user_objects
     where object_type = 'TYPE';
begin
  for dev in cur_type_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Types exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_type_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Types exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_types;

procedure compare_functions
is
  l_count number := 0;

  cursor cur_function_dev is
    select object_name
      from user_objects
     where object_type = 'FUNCTION'
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'FUNCTION';
     
  cursor cur_function_test is
    select object_name 
      from user_objects@QUASTO_TEST
     where object_type = 'FUNCTION'
   minus
    select object_name
      from user_objects
     where object_type = 'FUNCTION ';
begin
  for dev in cur_function_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Functions exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_function_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Functions exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception 
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_functions;

procedure compare_procedures
is
  l_count number := 0;

  cursor cur_procedure_dev is
    select object_name 
      from user_procedures
     where object_type = 'PROCEDURE'
   minus
    select object_name
      from user_procedures@QUASTO_TEST
     where object_type = 'PROCEDURE';
     
   cursor cur_procedure_test is
     select object_name 
       from user_procedures@QUASTO_TEST
     where object_type = 'PROCEDURE'
   minus 
    select object_name 
      from user_procedures
     where object_type = 'PROCEDURE';
begin
  for dev in cur_procedure_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Procedures exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_procedure_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Procedures exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception 
  when others then 
    raise_application_error(-20001, sqlerrm);
end compare_procedures;

procedure compare_materialized_views
is
  l_count number;

  cursor cur_materialized_view_dev is
    select object_name 
      from user_objects
     where object_type = 'MATERIALIZED VIEW'
   minus
    select object_name 
      from user_objects@QUASTO_TEST
     where object_type = 'MATERIALITZED VIEW';
     
  cursor cur_materialized_view_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'MATERIALIZED VIEW'
   minus
    select object_name
      from user_objects
     where object_type = 'MATERIALIZED VIEW';
begin
  for dev in cur_materialized_view_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Materialized Views exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_materialized_view_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Materialized Views exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_materialized_views;

procedure compare_synonyms
is
  l_count number := 0;

  cursor cur_synonym_dev is
    select object_name
      from user_objects
     where object_type = 'SYNONYM'
   minus
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'SYNONYM';
     
  cursor cur_synonym_test is
    select object_name
      from user_objects@QUASTO_TEST
     where object_type = 'SYNONYM'
   minus
    select object_name 
      from user_objects
     where object_type = 'SYNONYM';
begin
  for dev in cur_synonym_dev loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Synonyms exists in DEV but not in TEST:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||dev.object_name);
  end loop;
  
  l_count := 0;
  
  for tst in cur_synonym_test loop
    if l_count = 0 then
      dbms_output.put_line('######################################');
      dbms_output.put_line('###These Synonyms exists in TEST but not in DEV:###');
      l_count := 1;
    end if;
    
    dbms_output.put_line('--->  '||tst.object_name);
  end loop;
  
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_synonyms;

procedure compare_objects
is
begin
  compare_constraints;
  compare_functions;
  compare_indexes;
  compare_materialized_views;
  compare_packages;
  compare_package_bodies;
  compare_procedures;
  compare_sequences;
  compare_synonyms;
  compare_tables;
  compare_triggers;
  compare_types;
  compare_views;
  
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_objects;

end compare_scheme_obj_pkg;
/