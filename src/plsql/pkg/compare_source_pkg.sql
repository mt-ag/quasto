create or replace package compare_source_pkg 
as
procedure compare_all;

procedure compare_package_src;

procedure compare_package_body_src;

procedure compare_view_src;

procedure compare_type_src;

procedure compare_table_columns;

end compare_source_pkg;
/

create or replace package body compare_source_pkg
as

procedure compare_package_src
is
  l_count number := 0;
  
  l_test_pkg varchar2(100) := 'QA_UT_MT_AG%';

  cursor cur_package_src_dev is
    select line, text, name
      from (select line, text, name
              from user_source
             where type = 'PACKAGE'
               and name not like l_test_pkg
               and name not in ('COMPARE_SCHEME_OBJ_PKG', 'COMPARE_SOURCE_PKG')
             minus
            select line, text, name
              from user_source@QUASTO_TEST
             where type = 'PACKAGE'
               and name not like l_test_pkg
           )
     where name in (select object_name from user_objects where object_type = 'PACKAGE')
       and name in (select object_name from user_objects@QUASTO_TEST where object_type = 'PACKAGE')
     order by name, line;

  cursor cur_package_src_test is
    select line, text, name
      from (select line, text, name
              from user_source@QUASTO_TEST
             where type = 'PACKAGE'
               and name not like l_test_pkg
             minus
            select line, text, name
              from user_source
             where type = 'PACKAGE'
               and name not like l_test_pkg
               and name not in ('COMPARE_SCHEME_OBJ_PKG', 'COMPARE_SOURCE_PKG')
           )
     where name in (select object_name from user_objects where object_type = 'PACKAGE')
       and name in (select object_name from user_objects@QUASTO_TEST where object_type = 'PACKAGE')
     order by name, line;
begin

  for dev in cur_package_src_dev loop
    if l_count = 0 then
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These code lines in Package Specification differ between DEV and TEST: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Package Specification '||dev.name||' line '||dev.line);
  end loop;

  l_count := 0;

  for tst in cur_package_src_test loop
    if l_count = 0 then
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These code lines in Package Specification differ between TEST and DEV: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Package Specification '||tst.name||' line '||tst.line);
  end loop;

  l_count := 0;

exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_package_src;

procedure compare_package_body_src
is
  l_count number := 0;
  
  l_test_pkg varchar2(200) := 'QA_UT_MT_AG%';

  cursor cur_package_bdy_src_dev is
    select name, line, text
      from (select name, line, text 
              from user_source
             where type = 'PACKAGE BODY'
               and name not like l_test_pkg
               and name not in ('COMPARE_SCHEME_OBJ_PKG', 'COMPARE_SOURCE_PKG')
             minus
            select name, line, text
              from user_source@QUASTO_TEST
             where type = 'PACKAGE BODY'
               and name not like l_test_pkg
           )
     where name in (select object_name from user_objects where object_type = 'PACKAGE BODY')
       and name in (SELECT object_name from user_objects@QUASTO_TEST where object_type in 'PACKAGE BODY')
     order by name, line;

  cursor cur_package_bdy_src_test is
    select name, line, text
      from (select name, line, text
              from user_source@QUASTO_TEST
             where type = 'PACKAGE BODY'
               and name not like l_test_pkg
             minus 
            select name, line, text
              from user_source
             where type = 'PACKAGE BODY'
               and name not like l_test_pkg
               and name not in ('COMPARE_SCHEME_OBJ_PKG', 'COMPARE_SOURCE_PKG')
           )
     where name in (select object_name from user_objects where object_type = 'PACKAGE BODY')
       and name in (select object_name from user_objects@QUASTO_TEST where object_type = 'PACKAGE BODY')
     order by name, line;
begin

  for dev in cur_package_bdy_src_dev loop
    if l_count = 0 then 
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These code lines in Package Body differ between DEV and TEST: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Package Body '||dev.name||' line '||dev.line);
  end loop;
  l_count := 0;

  for tst in cur_package_bdy_src_test loop
    if l_count = 0 then
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These code lines in Package Body differ between TEST and DEV: ###');
    end if;
    dbms_output.put_line('Package Body '||tst.name||' line '||tst.line);
  end loop;
  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_package_body_src;

procedure compare_view_src
is
  l_count     number := 0;
  l_test_view clob;
  l_dev_view  clob;
  
  cursor c_views is
    select view_name 
      from user_views 
      join user_views@QUASTO_TEST using(view_name);
begin
  
  for tab in c_views loop
    select dbms_metadata.get_ddl('VIEW', tab.view_name, 'QUASTO')
      into l_dev_view
      from dual;
    
    select dbms_metadata.get_ddl('VIEW', tab.view_name, 'QUASTO')
      into l_test_view
      from qa_rules@QUASTO_TEST
     where rownum = 1;
    
    --if dbms_lob.compare(l_dev_view, l_test_view) <> 0 then
      if l_count = 0 then
        dbms_output.put_line('###################################################');
        dbms_output.put_line('### The code lines in the View differ between DEV and TEST: ###');
        l_count := 1;
     -- end if;
      dbms_output.put_line(tab.view_name);
      dbms_output.put_line(dbms_lob.compare(l_dev_view, l_test_view));
    end if;
  end loop;
    
  l_count := 0;

exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_view_src;

procedure compare_type_src
is
  l_count number := 0;

  cursor cur_type_src_dev is
    select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
      from (select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
              from user_type_attrs
             minus
            select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
              from user_type_attrs@QUASTO_TEST
           )
     where type_name in (select type_name from user_type_attrs)
       and type_name in (select type_name from user_type_attrs@QUASTO_TEST);

  cursor cur_type_src_test is
    select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
      from (select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
              from user_type_attrs@QUASTO_TEST
             minus
            select type_name, attr_name, attr_type_name, length, precision, scale, character_set_name
              from user_type_attrs
           )
     where type_name in (select type_name from user_type_attrs)
       and type_name in (select type_name from user_type_attrs@QUASTO_TEST);

begin

  for dev in cur_type_src_dev loop
    if l_count = 0 then 
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These Attributes in Type Definition differ between DEV and TEST: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Type '||dev.type_name||' Attribute '||dev.attr_name);
  end loop;

  l_count := 0;

  for tst in cur_type_src_test loop
    if l_count = 0 then 
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These Attributes in Type Definition differ between TEST and DEV: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Type '||tst.type_name||' Attribute '||tst.attr_name);
  end loop;

  l_count := 0;

exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_type_src;

procedure compare_table_columns
is
  l_count number := 0;

  cursor cur_tab_columns_dev is
    select table_name,
           column_name, 
           data_type,
           data_length,
           data_precision,
           data_scale,
           nullable,
           column_id,
           character_set_name,
           default_on_null
      from (select table_name, 
                   column_name, 
                   data_type, 
                   data_length, 
                   data_precision, 
                   data_scale, 
                   nullable, 
                   column_id, 
                   character_set_name,
                   default_on_null
              from user_tab_columns
             minus
            select table_name,
                   column_name,
                   data_type,
                   data_length,
                   data_precision,
                   data_scale,
                   nullable,
                   column_id,
                   character_set_name,
                   default_on_null
              from user_tab_columns@QUASTO_TEST
           )
     where (table_name, column_name) in (select table_name, column_name from user_tab_columns)
       and (table_name, column_name) in (select table_name, column_name from user_tab_columns@QUASTO_TEST)
     order by table_name, column_id;

  cursor cur_tab_columns_test is
    select table_name,
           column_name,
           data_type,
           data_length,
           data_precision,
           data_scale,
           nullable,
           column_id,
           character_set_name,
           default_on_null
      from (select table_name,
                   column_name,
                   data_type,
                   data_length,
                   data_precision,
                   data_scale,
                   nullable,
                   column_id,
                   character_set_name,
                   default_on_null
              from user_tab_columns@QUASTO_TEST
             minus
            select table_name,
                   column_name,
                   data_type,
                   data_length,
                   data_precision,
                   data_Scale,
                   nullable,
                   column_id,
                   character_set_name,
                   default_on_null
              from user_tab_columns
           )
     where (table_name, column_name) in (select table_name, column_name from user_tab_columns)
       and (table_name, column_name) in (select table_name, column_name from user_tab_columns@QUASTO_TEST)
     order by table_name, column_name;

begin
  for dev in cur_tab_columns_dev loop
    if l_count = 0 then 
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These Column Attributes in the Table differ between DEV and TEST: ###');
      l_count := 1;
    end if;
    dbms_output.put_line(' Table '||dev.table_name||' Column '||dev.column_name);
  end loop;

  l_count := 0;

  for tst in cur_tab_columns_test loop
    if l_count = 0 then
      dbms_output.put_line('###################################################');
      dbms_output.put_line('### These Column Attributes in the Table differ between TEST and DEV: ###');
      l_count := 1;
    end if;
    dbms_output.put_line('Table '||tst.table_name||' Column '||tst.column_name);
  end loop;

  l_count := 0;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_table_columns;

procedure compare_all
is
begin
  compare_package_src;
  compare_package_body_src;
  compare_view_src;
  compare_table_columns;
exception
  when others then
    raise_application_error(-20001, sqlerrm);
end compare_all;

end compare_source_pkg;
/