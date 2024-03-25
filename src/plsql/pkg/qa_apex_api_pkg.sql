create or replace package qa_apex_api_pkg authid definer as

  /******************************************************************************
     NAME:       qa_apex_api_pkg
     PURPOSE:    Methods for executing QUASTO rules for APEX
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     0.91       29.08.2022  pdahlem          Package has been added to QUASTO
  ******************************************************************************/

  /**
  * procedure for deleting entries in given ruleset for which exists an entry in qa_apex_blacklisted_apps_v
  * @param pi_qa_rules_t specifies the rule entity
  */
  procedure p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t in out qa_rules_t);

end qa_apex_api_pkg;
/
create or replace package body qa_apex_api_pkg as

  procedure p_exclude_not_whitelisted_apex_entries(pi_qa_rules_t in out qa_rules_t) is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_exclude_not_whitelisted_apex_entries';
  
    l_param_list qa_logger_pkg.tab_param;
    l_count      number;
    l_app_ids    varchar2(4000 char);
    l_page_ids   varchar2(4000 char);
  begin
    if pi_qa_rules_t.count > 0
    then
      select q.qaru_app_id
            ,q.qaru_page_id
      into l_app_ids
          ,l_page_ids
      from qa_rules q
      where q.qaru_id = pi_qa_rules_t(1).qaru_id;
    
      for i in pi_qa_rules_t.first .. pi_qa_rules_t.last
      loop
        select count(1)
        into l_count
        from qa_apex_blacklisted_apps_v v
        where v.application_id = nvl(pi_qa_rules_t(i).apex_app_id
                                    ,-99999);
      
        if (l_app_ids is not null and instr(',' || l_app_ids || ','
                                           ,',' || pi_qa_rules_t(i).apex_app_id || ',') = 0) or
          -- Apex Application welche geblacklisted wurden in der View qa_apex_blacklisted_apps_v rausfiltern
           l_count > 0
        then
          pi_qa_rules_t.delete(i);
        elsif l_page_ids is not null
        then
          for s in (select *
                    from apex_string.split(pi_qa_rules_t(i).apex_page_id
                                          ,','))
          loop
            if (instr(',' || l_page_ids || ','
                     ,',' || s.column_value || ',') > 0)
            then
              exit;
            else
              pi_qa_rules_t.delete(i);
            end if;
          end loop;
        end if;
      end loop;
    end if;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'Cant remove Apex App or Pages from qa_rules Table Record that dont belong to the current owner!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_exclude_not_whitelisted_apex_entries;

end qa_apex_api_pkg;
/