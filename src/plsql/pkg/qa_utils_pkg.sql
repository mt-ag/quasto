create or replace package qa_utils_pkg is 

  /******************************************************************************
     NAME:       qa_utils_pkg
     PURPOSE:    Methods for helpers and general functionalities
  
     REVISIONS:
     Release    Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     24.1       22.03.2024  mwilhelm         Package has been added to QUASTO
  ******************************************************************************/

  /**
   * function to convert a table of varchar2 to a string
   * @param  pi_table defines the table of varchar2 object
   * @param  pi_separator defines the separator for splitting the string
   * @return varchar2 returns the string
  */
  function f_get_table_as_string(
    pi_table      in varchar2_tab_t
   ,pi_separator  in varchar2 default ':'
  ) return varchar2 deterministic;

  /**
   * function to convert a string to a table of varchar2
   * @param  pi_string defines the string
   * @param  pi_separator defines the separator used within the string
   * @return varchar2_tab_t returns the table of varchar2 object
  */
  function f_get_string_as_table(
    pi_string     in varchar2
   ,pi_separator  in varchar2 default ':'
  ) return varchar2_tab_t deterministic;

  /**
   * function to convert and unify a given string
   * @param  pi_string defines the string to be converted
   * @param  pi_regexp defines the regular expression to be fulfilled
   * @param  pi_replace_blank_space defines whether to replace blank spaces or not
   * @param  pi_replacement_char defines the replacement char for characters which do not fulfill the regexp
   * @param  pi_transform_case defines the transformation as l - lowercase - or u - uppercase
   * @return varchar2 returns the unified string
  */
  function f_get_unified_string
  (
    pi_string               in varchar2
   ,pi_regexp               in varchar2 default '[^a-zA-Z0-9_]'
   ,pi_replace_blank_space  in varchar2 default 'Y'
   ,pi_replacement_char     in varchar2 default '_'
   ,pi_transform_case       in varchar2 default null
  ) return varchar2 deterministic;

  /**
   * function to replace characters in a given string
   * @param  pi_source_string defines the source string
   * @param  pi_search_string defines the characters to be searched for
   * @param  pi_replace_string defines the string for replacement
   * @throws NO_DATA_FOUND if no data found in given string
   * @return clob returns the string
  */
  function f_replace_string
  (
    pi_source_string  in clob
   ,pi_search_string  in varchar2
   ,pi_replace_string in clob
  ) return clob deterministic;

  /**
   * procedure to print a given varchar2 string to dbms_output
   * @param  pi_text defines the string
   * @throws NO_DATA_FOUND if no data found in given string
  */
  procedure p_print_to_dbms_output
  (
    pi_string  in varchar2
  ) deterministic;

  /**
   * procedure to print a given clob to dbms_output
   * @param  pi_text specifies the string
   * @throws NO_DATA_FOUND if no data found in given string
  */
  procedure p_print_to_dbms_output
  (
    pi_string  in clob
  ) deterministic;

  /**
   * function to return the value of a given constant of type varchar2
   * @param  pi_constant_name specifies the constant
   * @throws e_constant_not_found if constant does not exist
   * @return varchar2 returns the constant value
  */
  function f_get_constant_string_value (
    pi_constant_name in varchar2
  ) return varchar2;

  /**
   * function to return the value of a given constant of type number
   * @param  pi_constant_name specifies the constant
   * @throws e_constant_not_found if constant does not exist
   * @return number returns the constant value
  */
  function f_get_constant_number_value (
    pi_constant_name in varchar2
  ) return number;

end qa_utils_pkg;
/
create or replace package body qa_utils_pkg is

  function f_get_table_as_string(
    pi_table      in varchar2_tab_t
   ,pi_separator  in varchar2 default ':'
  ) return varchar2 deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_table_as_string';
    l_param_list qa_logger_pkg.tab_param;

    l_string varchar2(4000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_separator'
                              ,p_val_01  => pi_separator);
                              
    if pi_table is null or pi_separator is null
    then
      raise_application_error(-20001, 'Missing input parameter value for pi_table or pi_separator: ' || pi_separator);
    end if;
    
    for i in pi_table.first .. pi_table.last
    loop
      if l_string is null
      then
        l_string := pi_table(i);
      else
        l_string := l_string || pi_separator || pi_table(i);
      end if;
    end loop;
    
    return l_string;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get a PL/SQL table as string!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_table_as_string;

  function f_get_string_as_table(
    pi_string     in varchar2
   ,pi_separator  in varchar2 default ':'
  ) return varchar2_tab_t deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_string_as_table';
    l_param_list qa_logger_pkg.tab_param;

    l_table varchar2_tab_t := new varchar2_tab_t();
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_string'
                              ,p_val_01  => pi_string
                              ,p_name_02 => 'pi_separator'
                              ,p_val_02  => pi_separator);
                              
    if pi_string is null or pi_separator is null
    then
      raise_application_error(-20001, 'Missing input parameter value for pi_string: ' || pi_string || ' or pi_separator: ' || pi_separator);
    end if;
    
    for i in (select regexp_substr(pi_string, '[^' || pi_separator || ']+', 1, level) as column_value
                from dual 
          connect by regexp_substr(pi_string, '[^' || pi_separator || ']+', 1, level) is not null
             )
    loop
       l_table.extend;
       l_table(l_table.last) := i.column_value;
    end loop;
    
    return l_table;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get a string as a PL/SQL table!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_string_as_table;

  function f_get_unified_string(
    pi_string               in varchar2
   ,pi_regexp               in varchar2 default '[^a-zA-Z0-9_]'
   ,pi_replace_blank_space  in varchar2 default 'Y'
   ,pi_replacement_char     in varchar2 default '_'
   ,pi_transform_case       in varchar2 default null
  ) return varchar2 deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_unified_string';
    l_param_list qa_logger_pkg.tab_param;

    l_string varchar2(4000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_string'
                              ,p_val_01  => pi_string
                              ,p_name_02 => 'pi_regexp'
                              ,p_val_02  => pi_regexp
                              ,p_name_03 => 'pi_transform_blank_space'
                              ,p_val_03  => pi_replace_blank_space
                              ,p_name_04 => 'pi_replace_blank_space'
                              ,p_val_04  => pi_replacement_char
                              ,p_name_05 => 'pi_transform_case'
                              ,p_val_05  => pi_transform_case);
                              
    if pi_string is null or pi_regexp is null or pi_replace_blank_space is null or pi_replace_blank_space not in ('Y','N') or pi_replacement_char is null
    or (pi_transform_case is not null and lower(pi_transform_case) not in ('l','u'))
    then
      raise_application_error(-20001, 'Missing or invalid input parameter value for pi_string: ' || pi_string || ' or pi_regexp: ' || pi_regexp || ' or pi_replace_blank_space: ' || pi_replace_blank_space || ' or pi_replacement_char: ' || pi_replacement_char || ' or pi_transform_case: ' || pi_transform_case);
    end if;
    
    l_string := regexp_replace(case
                                 when pi_replace_blank_space = 'Y' then replace(pi_string, ' ', pi_replacement_char) else pi_string
                               end
                              ,pi_regexp
                              ,pi_replacement_char);

    if lower(pi_transform_case) = 'l'
    then
      l_string := lower(l_string);
    elsif lower(pi_transform_case) = 'u'
    then
      l_string := upper(l_string);
    end if;
    
    return l_string;
  exception
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to generate an unified string!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_unified_string;

  function f_replace_string
  (
    pi_source_string  in clob
   ,pi_search_string  in varchar2
   ,pi_replace_string in clob
  ) return clob deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_replace_string';
    l_param_list qa_logger_pkg.tab_param;

    l_pos pls_integer;
    l_source_string varchar(32767); 
    l_replace_string varchar(32767);
  begin
    l_source_string := dbms_lob.substr(pi_source_string,4000,1);
    l_replace_string := dbms_lob.substr(pi_replace_string,4000,1);

    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_source_string'
                              ,p_val_01  => l_source_string
                              ,p_name_02 => 'pi_search_string'
                              ,p_val_02  => pi_search_string
                              ,p_name_03 => 'pi_replace_string'
                              ,p_val_03  => l_replace_string);


    l_pos := instr(pi_source_string
                  ,pi_search_string);
    if l_pos > 0
    then
      return substr(pi_source_string
                   ,1
                   ,l_pos - 1) || pi_replace_string || substr(pi_source_string
                                                      ,l_pos + length(pi_search_string));
    end if;

    return pi_source_string;
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No data given for replacement!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while replacing characters in a clob!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
     raise;
  end f_replace_string;

  procedure p_print_to_dbms_output
  (
    pi_string  in varchar2
  ) deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_print_to_dbms_output';
    l_param_list qa_logger_pkg.tab_param;
  begin
    qa_logger_pkg.append_param(p_params => l_param_list
                              ,p_name_01 => 'pi_string'
                              ,p_val_01 => pi_string);

    dbms_output.put_line(pi_string);
  exception 
    when no_data_found then 
      qa_logger_pkg.p_qa_log(p_text   => 'No data given for printing!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then 
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to print the string!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_print_to_dbms_output;

  procedure p_print_to_dbms_output
  (
    pi_string  in clob
  ) deterministic
  is
    c_unit constant varchar2(32767) := $$plsql_unit || '.p_print_to_dbms_output';
    l_param_list qa_logger_pkg.tab_param;

    l_offset int := 1;
    l_step   number := 32767;
    l_clob_string varchar(32767); 
  begin

    l_clob_string := dbms_lob.substr(pi_string,4000,1);
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_string'
                              ,p_val_01  => l_clob_string);

    dbms_output.enable(buffer_size => 10000000);
    loop
      exit when l_offset > dbms_lob.getlength(pi_string);
      dbms_output.put_line(dbms_lob.substr(pi_string
                                          ,l_step
                                          ,l_offset));
      l_offset := l_offset + l_step;
    end loop;
  exception
    when no_data_found then
      qa_logger_pkg.p_qa_log(p_text   => 'No data given for printing!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to print the string!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end p_print_to_dbms_output;

  function f_get_constant_string_value (
    pi_constant_name in varchar2
  ) return varchar2
  as
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_constant_string_value';
    l_param_list qa_logger_pkg.tab_param;
    e_constant_not_found exception;
    pragma exception_init(e_constant_not_found, -20001);

    l_constant_value varchar2(4000);
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_constant_name'
                              ,p_val_01  => pi_constant_name);

    case upper(pi_constant_name)
      -- core constants
      when upper('gc_quasto_name')                       then l_constant_value := qa_constant_pkg.gc_quasto_name;
      when upper('gc_quasto_version')                    then l_constant_value := qa_constant_pkg.gc_quasto_version;
      when upper('gc_black_list_exception_text')         then l_constant_value := qa_constant_pkg.gc_black_list_exception_text;
      
      -- utPLSQL Unit test constants
      when upper('gc_utplsql_ut_test_packages_prefix')   then l_constant_value := qa_constant_pkg.gc_utplsql_ut_test_packages_prefix;
      when upper('gc_utplsql_scheduler_cronjob_name')    then l_constant_value := qa_constant_pkg.gc_utplsql_scheduler_cronjob_name;
      when upper('gc_utplsql_custom_scheduler_job_name') then l_constant_value := qa_constant_pkg.gc_utplsql_custom_scheduler_job_name;

      else raise e_constant_not_found;
    end case;
     
    return l_constant_value;
  exception
    when e_constant_not_found then
      qa_logger_pkg.p_qa_log(p_text   => 'The given constant name does not exist!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise_application_error(-20001, qa_constant_pkg.gc_invalid_constant_exception_text || ': ' || pi_constant_name);
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the constant value!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_constant_string_value;

  function f_get_constant_number_value (
    pi_constant_name in varchar2
  ) return number
  as
    c_unit constant varchar2(32767) := $$plsql_unit || '.f_get_constant_number_value';
    l_param_list qa_logger_pkg.tab_param;
    e_constant_not_found exception;
    pragma exception_init(e_constant_not_found, -20001);

    l_constant_value number;
  begin
    qa_logger_pkg.append_param(p_params  => l_param_list
                              ,p_name_01 => 'pi_constant_name'
                              ,p_val_01  => pi_constant_name);

    case upper(pi_constant_name)
      -- core constants
      when upper('gc_utplsql_flag')                      then l_constant_value := qa_constant_pkg.gc_utplsql_flag;
      when upper('gc_apex_flag')                         then l_constant_value := qa_constant_pkg.gc_apex_flag;
      when upper('gc_logger_flag')                       then l_constant_value := qa_constant_pkg.gc_logger_flag;

      -- utPLSQL Unit test constants
      when upper('gc_utplsql_single_package')            then l_constant_value := qa_constant_pkg.gc_utplsql_single_package;
      when upper('gc_utplsql_single_package_per_rule')   then l_constant_value := qa_constant_pkg.gc_utplsql_single_package_per_rule;
      when upper('gc_utplsql_scheme_result_failure')     then l_constant_value := qa_constant_pkg.gc_utplsql_scheme_result_failure;
      when upper('gc_utplsql_scheme_result_success')     then l_constant_value := qa_constant_pkg.gc_utplsql_scheme_result_success;
      when upper('gc_utplsql_scheme_result_error')       then l_constant_value := qa_constant_pkg.gc_utplsql_scheme_result_error;

      else raise e_constant_not_found;
    end case;
     
    return l_constant_value;
  exception
    when e_constant_not_found then
      qa_logger_pkg.p_qa_log(p_text   => 'The given constant name does not exist!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise_application_error(-20001, qa_constant_pkg.gc_invalid_constant_exception_text || ': ' || pi_constant_name);
    when others then
      qa_logger_pkg.p_qa_log(p_text   => 'There has been an error while trying to get the constant value!'
                            ,p_scope  => c_unit
                            ,p_extra  => sqlerrm
                            ,p_params => l_param_list);
      raise;
  end f_get_constant_number_value;

end qa_utils_pkg;
/
