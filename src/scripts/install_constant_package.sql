PROMPT SQL file for installing the constant package
set define '~'
set concat on
set concat .
set verify off

declare
  l_count        number;
  l_action       varchar2(32767);
  l_utplsql_flag number := '~1';
  l_apex_flag    number := '~2';
  l_jenkins_flag number := '~3';
  l_logger_flag  number := '~4';
  l_apex_version varchar2(50) := '~5';
begin
  l_action := 'create or replace package quasto_constant_pkg
    authid definer
  as
    
    gc_quasto_version constant varchar(50 char) := ' || '''' || l_apex_version || '''' || ';
    gc_utplsql_flag   constant number           := ' || l_utplsql_flag || ';
    gc_apex_flag      constant number           := ' || l_apex_flag || ';
    gc_logger_flag    constant number           := ' || l_logger_flag || ';

end quasto_constant_pkg;
';

    dbms_output.put_line(l_action);
    execute immediate l_action;

    select count(1)
    into l_count
    from user_objects
    where object_name = upper('quasto_constant_pkg');

    if l_count = 0
      then
        dbms_output.put_line('ERROR: Cosntants_Package could not be created');
    else
        dbms_output.put_line('IFNO: Cosntants_Package was succesfully created');
    end if;
end;
/