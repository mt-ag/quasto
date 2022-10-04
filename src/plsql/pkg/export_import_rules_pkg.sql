PROMPT create or replace package EXPORT_IMPORT_RULES_PKG
create or replace package export_import_rules_pkg is

  function fc_export_qa_rules(
	pi_client_name in varchar2 default null
  ) return clob;

end export_import_rules_pkg;
/
create or replace package body export_import_rules_pkg is

  function fc_export_qa_rules(
	pi_client_name in varchar2 default null
  ) return clob
  is
    type tab_t is table of qa_rules%rowtype;

    l_table_name varchar2(50) := 'QA_RULES';

    l_tab    tab_t;
    l_return clob;
  begin

   if pi_client_name is not null
   then
      select *
        bulk collect into l_tab
        from qa_rules qaru
       where qaru.qaru_client_name = pi_client_name
    order by qaru.qaru_id
    ;
   else
       select *
         bulk collect into l_tab
         from qa_rules qaru
     order by qaru.qaru_id
	;
   end if;

   l_return := 'SET SERVEROUTPUT ON' || chr(10);
   dbms_lob.append(l_return, 'declare' || chr(10));
   dbms_lob.append(l_return, '  l_sql clob;' || chr(10));
   dbms_lob.append(l_return, 'begin' || chr(10) || chr(10));
 
   dbms_lob.append(l_return, '  dbms_output.put_line(''Merging data into table ' || l_table_name || ' started.'');' || chr(10) || chr(10));

   for i in 1 .. l_tab.count
   loop
      dbms_lob.append(l_return, '  l_sql := ''' || replace(l_tab(i).qaru_sql, '''', '''''') || ''';' || chr(10) || chr(10));
      dbms_lob.append(l_return, '  merge into ' || l_table_name || ' a' || chr(10));
      dbms_lob.append(l_return, '    using (select ''' || replace(l_tab(i).qaru_client_name, '''', '''''')     || ''' as qaru_client_name,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_rule_number, '''', '''''')     || ''' as qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_name, '''', '''''')            || ''' as qaru_name,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_category, '''', '''''')        || ''' as qaru_category,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_object_types, '''', '''''')    || ''' as qaru_object_types,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_error_message, '''', '''''')   || ''' as qaru_error_message,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_comment, '''', '''''')         || ''' as qaru_comment,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_exclude_objects, '''', '''''') || ''' as qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_error_level, '''', '''''')     || ''' as qaru_error_level,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_is_active, '''', '''''')       || ''' as qaru_is_active,' || chr(10));
      dbms_lob.append(l_return, '                  l_sql as qaru_sql,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_predecessor_ids, '''', '''''') || ''' as qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return, '                  ''' || replace(l_tab(i).qaru_layer, '''', '''''')           || ''' as qaru_layer' || chr(10));
      dbms_lob.append(l_return, '             from dual) b' || chr(10));
      dbms_lob.append(l_return, '    on ( a.qaru_client_name = b.qaru_client_name' || chr(10));
      dbms_lob.append(l_return, '     and a.qaru_rule_number = b.qaru_rule_number )' || chr(10));
      dbms_lob.append(l_return, '    when MATCHED then' || chr(10));
      dbms_lob.append(l_return, '      update' || chr(10));
      dbms_lob.append(l_return, '         set qaru_name            = b.qaru_name,' || chr(10));
      dbms_lob.append(l_return, '             qaru_category        = b.qaru_category,' || chr(10));
      dbms_lob.append(l_return, '             qaru_object_types    = b.qaru_object_types,' || chr(10));
      dbms_lob.append(l_return, '             qaru_error_message   = b.qaru_error_message,' || chr(10));
      dbms_lob.append(l_return, '             qaru_comment         = b.qaru_comment,' || chr(10));
      dbms_lob.append(l_return, '             qaru_exclude_objects = b.qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return, '             qaru_error_level     = b.qaru_error_level,' || chr(10));
      dbms_lob.append(l_return, '             qaru_is_active       = b.qaru_is_active,' || chr(10));
      dbms_lob.append(l_return, '             qaru_sql             = b.qaru_sql,' || chr(10));
      dbms_lob.append(l_return, '             qaru_predecessor_ids = b.qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return, '             qaru_layer           = b.qaru_layer' || chr(10));
      dbms_lob.append(l_return, '    when NOT MATCHED then' || chr(10));
      dbms_lob.append(l_return, '      insert ( qaru_client_name,' || chr(10));
      dbms_lob.append(l_return, '               qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return, '               qaru_name,' || chr(10));
      dbms_lob.append(l_return, '               qaru_category,' || chr(10));
      dbms_lob.append(l_return, '               qaru_object_types,' || chr(10));
      dbms_lob.append(l_return, '               qaru_error_message,' || chr(10));
      dbms_lob.append(l_return, '               qaru_comment,' || chr(10));
      dbms_lob.append(l_return, '               qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return, '               qaru_error_level,' || chr(10));
      dbms_lob.append(l_return, '               qaru_is_active,' || chr(10));
      dbms_lob.append(l_return, '               qaru_sql,' || chr(10));
      dbms_lob.append(l_return, '               qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return, '               qaru_layer )' || chr(10));
      dbms_lob.append(l_return, '      values ( b.qaru_client_name,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_rule_number,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_name,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_category,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_object_types,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_error_message,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_comment,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_exclude_objects,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_error_level,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_is_active,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_sql,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_predecessor_ids,' || chr(10));
      dbms_lob.append(l_return, '               b.qaru_layer );' || chr(10) || chr(10));
   end loop;

   dbms_lob.append(l_return, '  commit;' || chr(10));
   dbms_lob.append(l_return, '  dbms_output.put_line(''Merging data into table ' || l_table_name || ' completed.'');' || chr(10) || chr(10));
   dbms_lob.append(l_return, '  exception' || chr(10));
   dbms_lob.append(l_return, '    when others then' || chr(10));
   dbms_lob.append(l_return, '      dbms_output.put_line(''Merging data into table ' || l_table_name || ' raised exception.'');' || chr(10));
   dbms_lob.append(l_return, '      rollback;' || chr(10));
   dbms_lob.append(l_return, '      raise;' || chr(10));
   dbms_lob.append(l_return, 'end;' || chr(10) || '/' || chr(10));

   return l_return;

  exception
    when others then
      raise;
  end fc_export_qa_rules;

end export_import_rules_pkg;
/
