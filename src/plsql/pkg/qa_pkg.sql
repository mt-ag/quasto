create or replace package qa_pkg as

  c_qa_collection_name constant varchar2(30) := 'QA_COLLECTION';

  -- Global Variables
  g_edit_cookie_session_id number;

  -- function for returning the collection name
  function get_collection_name return varchar2;

  -- procedure for testing a qa rule
  procedure test_rule
  (
    pi_qaru_id       in number
   ,pi_app_id        in number
   ,pi_app_page_id   in number
   ,po_result        out number
   ,po_object_names  out clob
   ,po_error_message out varchar2
  );

  -- function for inserting a new rule
  -- the function determines the next id and encapsulates the insert operation for new rules
  function insert_rule
  (
    pi_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name     in qa_rules.qaru_client_name%type
   ,pi_qaru_name            in qa_rules.qaru_name%type
   ,pi_qaru_category        in qa_rules.qaru_category%type
   ,pi_qaru_object_types    in qa_rules.qaru_object_types%type
   ,pi_qaru_error_message   in qa_rules.qaru_error_message%type
   ,pi_qaru_comment         in qa_rules.qaru_comment%type default null
   ,pi_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,pi_qaru_error_level     in qa_rules.qaru_error_level%type
   ,pi_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,pi_qaru_sql             in qa_rules.qaru_sql%type
   ,pi_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,pi_qaru_layer           in qa_rules.qaru_layer%type
  ) return qa_rules.qaru_id%type;

end qa_pkg;
/
create or replace package body qa_pkg as

  -- same as qa_rule_t.qaru_object_type
  subtype t_object_type is varchar2(30);

  -- @see table comment qa_rules.qaru_object_type
  -- Values which are allowed for object_type
  c_qaru_object_type_app         constant t_object_type := 'APPLICATION';
  c_qaru_object_type_page        constant t_object_type := 'PAGE';
  c_qaru_object_type_region      constant t_object_type := 'REGION';
  c_qaru_object_type_item        constant t_object_type := 'ITEM';
  c_qaru_object_type_rpt_col     constant t_object_type := 'RPT_COL';
  c_qaru_object_type_button      constant t_object_type := 'BUTTON';
  c_qaru_object_type_computation constant t_object_type := 'COMPUTATION';
  c_qaru_object_type_validation  constant t_object_type := 'VALIDATION';
  c_qaru_object_type_process     constant t_object_type := 'PROCESS';
  c_qaru_object_type_branch      constant t_object_type := 'BRANCH';
  c_qaru_object_type_da          constant t_object_type := 'DA';
  c_qaru_object_type_da_action   constant t_object_type := 'DA_ACTION';

  -- @see table comment qa_rules.qaru_category
  c_qaru_category_apex constant qa_rules.qaru_category%type := 'APEX';

  -- @see table comment qa_rules.qaru_error_level
  c_qaru_error_level_error   constant qa_rules.qaru_error_level%type := 1;
  c_qaru_error_level_warning constant qa_rules.qaru_error_level%type := 2;
  c_qaru_error_level_info    constant qa_rules.qaru_error_level%type := 4;

  -- @see spec
  function get_collection_name return varchar2 is
  begin
    return c_qa_collection_name;
  end get_collection_name;

  -- Edit Link to jump directly into the Application Builder
  -- Links based on the View wwv_flow_dictionary_views in column link_url
  function get_edit_link(pi_qa_rule in qa_rule_t) return varchar2 is
    l_url varchar2(1000 char);
  begin
    -- Application
    if pi_qa_rule.qaru_object_type = c_qaru_object_type_app
    then
      l_url := 'f?p=4000:4001:%session%::::F4000_P1_FLOW,FB_FLOW_ID:%pk_value%,%pk_value%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.apex_app_id);
    
      -- Page
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_page
    then
      l_url := 'f?p=4000:4301:%session%::NO::F4000_P4301_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.apex_page_id);
    
      -- Page Regions
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_region
    then
      l_url := 'f?p=4000:4651:%session%:::4651,960,420:F4000_P4651_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.apex_region_id);
    
      -- Item
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_item
    then
      l_url := 'f?p=4000:4311:%session%::::F4000_P4311_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Report Column
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_rpt_col
    then
      l_url := 'f?p=4000:422:%session%:::4651,960,420,422:P422_COLUMN_ID,P420_REGION_ID,F4000_P4651_ID,P960_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%parent_pk_value%,%parent_pk_value%,%parent_pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      l_url := replace(l_url
                      ,'%parent_pk_value%'
                      ,pi_qa_rule.apex_region_id);
    
      -- Button
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_button
    then
      l_url := 'f?p=4000:4314:%session%:::4314:F4000_P4314_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Computation
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_computation
    then
      l_url := 'f?p=4000:4315:%session%::::F4000_P4315_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Validation
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_validation
    then
      l_url := 'f?p=4000:4316:%session%::::F4000_P4316_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Process
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_process
    then
      l_url := 'f?p=4000:4312:%session%::NO:4312:F4000_P4312_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Branch
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_branch
    then
      l_url := 'f?p=4000:4313:%session%::::F4000_P4313_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Dynamic Action
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_da
    then
      l_url := 'f?p=4000:793:%session%::::F4000_P793_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
      -- Dynamic Action - Action
    elsif pi_qa_rule.qaru_object_type = c_qaru_object_type_da_action
    then
      l_url := 'f?p=4000:591:%session%::::F4000_P591_ID,FB_FLOW_ID,FB_FLOW_PAGE_ID:%pk_value%,%application_id%,%page_id%';
    
      l_url := replace(l_url
                      ,'%pk_value%'
                      ,pi_qa_rule.object_id);
    
    
    end if;
  
    l_url := replace(l_url
                    ,'%application_id%'
                    ,pi_qa_rule.apex_app_id);
    l_url := replace(l_url
                    ,'%page_id%'
                    ,pi_qa_rule.apex_page_id);
    l_url := replace(l_url
                    ,'%session%'
                    ,g_edit_cookie_session_id);
  
    return l_url;
  
  exception
    when others then
      raise;
  end get_edit_link;


  -- if function returns true the a message for the predecessor is added
  -- the rule should be excluded in output
  procedure remove_message_if_predecessor
  (
    pi_qa_rules      in qa_rules_t
   ,pio_qa_rules_new in out qa_rules_t
  ) is
  begin
    for n in 1 .. pio_qa_rules_new.count
    loop
      for i in (select 1
                from table(pi_qa_rules) rules
                    ,qa_rules qaru
                where pio_qa_rules_new(n).qaru_id = qaru.qaru_id
                 and qaru.qaru_predecessor_ids is not null
                 and pio_qa_rules_new(n).object_id = rules.object_id
                 and pio_qa_rules_new(n).qaru_object_type = rules.qaru_object_type
                 and instr(':' || qaru.qaru_predecessor_ids || ':'
                         ,':' || rules.qaru_id || ':') > 0)
      loop
        pio_qa_rules_new.delete(n);
        exit;
      end loop;
    end loop;
  
  exception
    when others then
      raise;
  end remove_message_if_predecessor;

  -- run a single rule
  -- %param pi_qaru_id the rule
  -- %param pi_app_id application which will be tested
  -- %param pi_app_page_id page which is selected
  -- %param pio_qa_rules all found rules and the new result
  procedure run_rule
  (
    pi_qaru_id     in qa_rules.qaru_id%type
   ,pi_app_id      in number
   ,pi_app_page_id in number
   ,pi_debug       in varchar2
   ,pio_qa_rules   in out qa_rules_t
  ) is
    c_unit       constant varchar2(32767) := $$plsql_unit || '.run_rule';
    c_param_list constant varchar2(32767) := 'pi_qaru_id=' || pi_qaru_id || chr(10);
  
    l_qaru_sql     varchar2(32767);
    l_qaru_layer   qa_rules.qaru_layer%type;
    l_qa_rules_new qa_rules_t;
  begin
    select qaru.qaru_sql
          ,qaru.qaru_layer
    into l_qaru_sql
        ,l_qaru_layer
    from qa_rules qaru
    where qaru.qaru_id = pi_qaru_id;
  
    if pi_debug = 'Y'
    then
      dbms_output.put_line(length(l_qaru_sql));
      dbms_output.put_line(l_qaru_sql);
    end if;
  
    execute immediate l_qaru_sql bulk collect
      into l_qa_rules_new
      using pi_qaru_id, pi_app_id, pi_app_page_id;
  
    if pio_qa_rules is not null
    then
      pio_qa_rules := pio_qa_rules multiset union l_qa_rules_new;
    else
      pio_qa_rules := l_qa_rules_new;
    end if;
  
  exception
    when others then
      dbms_output.put_line(l_qaru_sql);
      raise;
  end run_rule;

  -- run all rules which are active
  procedure run_rules
  (
    pi_app_id          in number
   ,pi_app_page_id     in number
   ,pi_debug           in varchar2
   ,pi_max_error_level in integer
   ,pio_qa_rules       in out qa_rules_t
  ) is
  begin
    for r in (select qaru.qaru_id
              from qa_rules qaru
              where qaru.qaru_is_active = 1
              and qaru.qaru_error_level <= nvl(pi_max_error_level
                                             ,4)
              order by qaru.qaru_error_level
                      ,qaru.qaru_predecessor_ids nulls first)
    loop
      run_rule(pi_qaru_id     => r.qaru_id
              ,pi_app_id      => pi_app_id
              ,pi_app_page_id => pi_app_page_id
              ,pi_debug       => pi_debug
              ,pio_qa_rules   => pio_qa_rules);
    end loop;
  
  exception
    when others then
      raise;
  end run_rules;

  -- HTML formated header for the region plugin
  function get_html_region_header return varchar2 is
    l_header varchar2(32767);
  begin
    l_header := '<table class="t-Report-report">' || --
                '<tr><th class="t-Report-colHead"> # </th>' || --
                '<th class="t-Report-colHead">Error Level</th>' || --
                '<th class="t-Report-colHead">Objecttype</th>' || --
                '<th class="t-Report-colHead">Objectname</th>' || --
                '<th class="t-Report-colHead">Message</th>' || --
                '<th class="t-Report-colHead">Objectvalue</th>' || --
                '<th class="t-Report-colHead">Link</th>' || --
                '</tr>';
  
    return l_header;
  
  exception
    when others then
      raise;
  end get_html_region_header;

  -- Footer for Region Plugin
  function get_html_region_footer return varchar2 is
    l_footer varchar2(32767);
  begin
    l_footer := '</table>';
  
    return l_footer;
  end get_html_region_footer;

  -- Converts the number into a readable text
  function error_level_2_text(pi_error_level in integer) return varchar2 deterministic is
  begin
    if pi_error_level = c_qaru_error_level_error
    then
      return 'Error';
    elsif pi_error_level = c_qaru_error_level_warning
    then
      return 'Warning';
    elsif pi_error_level = c_qaru_error_level_info
    then
      return 'Info';
    end if;
  
  exception
    when others then
      raise;
  end error_level_2_text;

  -- Every single line will be formated like this
  function get_html_rule_line
  (
    pi_nr      in pls_integer
   ,pi_qa_rule in qa_rule_t
  ) return varchar2 is
    l_line varchar2(32767);
  begin
    l_line := '<tr><td class="t-Report-cell">' || pi_nr || '</td>' || --
              '<td class="t-Report-cell">' || error_level_2_text(pi_error_level => pi_qa_rule.qaru_error_level) || '</td>' || --
              '<td class="t-Report-cell">' || pi_qa_rule.qaru_object_type || '</td>' || --
              '<td class="t-Report-cell">' || pi_qa_rule.object_name || '</td>' || --
              '<td class="t-Report-cell">' || pi_qa_rule.qaru_error_message || '</td>' || --
              '<td class="t-Report-cell">' || pi_qa_rule.object_value || '</td>' || --
              '<td class="t-Report-cell">' || case pi_qa_rule.qaru_category
                when c_qaru_category_apex then
                 '<a href="' || get_edit_link(pi_qa_rule => pi_qa_rule) || '">edit</a>'
                else
                 ' '
              end || '</td>' || --
              '</tr>';
    return l_line;
  end get_html_rule_line;

  -- get excluded objects for a rule
  function fc_get_excluded_objects(pi_qaru_id in qa_rules.qaru_id%type) return qa_rules.qaru_exclude_objects%type result_cache is
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
  begin
    select p.qaru_exclude_objects
    into l_qaru_exclude_objects
    from qa_rules p
    where p.qaru_id = pi_qaru_id;
  
    return l_qaru_exclude_objects;
  
  exception
    when others then
      raise;
  end fc_get_excluded_objects;

  -- @see spec
  procedure test_rule
  (
    pi_qaru_id       in number
   ,pi_app_id        in number
   ,pi_app_page_id   in number
   ,po_result        out number
   ,po_object_names  out clob
   ,po_error_message out varchar2
  ) is
    l_qa_rules             qa_rules_t;
    l_qaru_exclude_objects qa_rules.qaru_exclude_objects%type;
    l_count_objects        number;
    l_object_names         clob;
    l_qaru_error_message   qa_rules.qaru_error_message%type;
  begin
  
    run_rule(pi_qaru_id     => pi_qaru_id
            ,pi_app_id      => pi_app_id
            ,pi_app_page_id => pi_app_page_id
            ,pi_debug       => 'N'
            ,pio_qa_rules   => l_qa_rules);
  
    l_qaru_exclude_objects := fc_get_excluded_objects(pi_qaru_id => pi_qaru_id);
  
    select count(1)
    into l_count_objects
    from table(l_qa_rules) rule
    join qa_rules qaru on qaru.qaru_id = rule.qaru_id
    where qaru.qaru_exclude_objects is null
    or not (rule.object_name in (select regexp_substr(l_qaru_exclude_objects
                                                    ,'[^,]+'
                                                    ,1
                                                    ,level) as data
                                from dual
                                connect by regexp_substr(l_qaru_exclude_objects
                                                        ,'[^,]+'
                                                        ,1
                                                        ,level) is not null));
  
    if l_qa_rules is not null and
       l_qa_rules.count > 0 and
       l_count_objects > 0
    then
      select rtrim(xmlagg(xmlelement(e, rule.object_name, '; ').extract('//text()') order by rule.object_name).getclobval()
                  ,'; ') as object_names
            ,qaru.qaru_error_message
      into l_object_names
          ,l_qaru_error_message
      from table(l_qa_rules) rule
      join qa_rules qaru on qaru.qaru_id = rule.qaru_id
      where qaru.qaru_exclude_objects is null
      or not (rule.object_name in (select regexp_substr(l_qaru_exclude_objects
                                                      ,'[^,]+'
                                                      ,1
                                                      ,level) as data
                                  from dual
                                  connect by regexp_substr(l_qaru_exclude_objects
                                                          ,'[^,]+'
                                                          ,1
                                                          ,level) is not null))
      group by rule.qaru_id
              ,qaru.qaru_error_message;
    
      po_result        := 0;
      po_object_names  := l_object_names;
      po_error_message := l_qaru_error_message;
    else
      po_result        := 1;
      po_object_names  := 'None.';
      po_error_message := 'No Errors.';
    end if;
  
  exception
    when others then
      raise;
  end test_rule;

  -- @see spec
  function insert_rule
  (
    pi_qaru_rule_number     in qa_rules.qaru_rule_number%type
   ,pi_qaru_client_name     in qa_rules.qaru_client_name%type
   ,pi_qaru_name            in qa_rules.qaru_name%type
   ,pi_qaru_category        in qa_rules.qaru_category%type
   ,pi_qaru_object_types    in qa_rules.qaru_object_types%type
   ,pi_qaru_error_message   in qa_rules.qaru_error_message%type
   ,pi_qaru_comment         in qa_rules.qaru_comment%type default null
   ,pi_qaru_exclude_objects in qa_rules.qaru_exclude_objects%type default null
   ,pi_qaru_error_level     in qa_rules.qaru_error_level%type
   ,pi_qaru_is_active       in qa_rules.qaru_is_active%type default 1
   ,pi_qaru_sql             in qa_rules.qaru_sql%type
   ,pi_qaru_predecessor_ids in qa_rules.qaru_predecessor_ids%type default null
   ,pi_qaru_layer           in qa_rules.qaru_layer%type
  ) return qa_rules.qaru_id%type is
    l_qaru_id qa_rules.qaru_id%type;
  begin
  
    insert into qa_rules
      (qaru_rule_number
      ,qaru_client_name
      ,qaru_name
      ,qaru_category
      ,qaru_object_types
      ,qaru_error_message
      ,qaru_comment
      ,qaru_exclude_objects
      ,qaru_error_level
      ,qaru_is_active
      ,qaru_sql
      ,qaru_predecessor_ids
      ,qaru_layer)
    values
      (pi_qaru_rule_number
      ,pi_qaru_client_name
      ,pi_qaru_name
      ,pi_qaru_category
      ,pi_qaru_object_types
      ,pi_qaru_error_message
      ,pi_qaru_comment
      ,pi_qaru_exclude_objects
      ,pi_qaru_error_level
      ,pi_qaru_is_active
      ,pi_qaru_sql
      ,pi_qaru_predecessor_ids
      ,pi_qaru_layer)
    returning qaru_id into l_qaru_id;
  
    return l_qaru_id;
  exception
    when others then
      raise;
  end insert_rule;

end qa_pkg;
/