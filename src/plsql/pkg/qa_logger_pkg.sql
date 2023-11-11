create or replace package qa_logger_pkg authid definer is

/******************************************************************************
   NAME:       qa_logger_pkg
   PURPOSE:    Methods for creating and printing logs to the console output

   REVISIONS:
   Release    Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.1        21.04.2023  pdahlem          Package has been added to QUASTO
******************************************************************************/

/**
* type for the logger parameters
* @param name specifies the name of the parameter
* @param val specifies the value of the parameter
*/
  type rec_param is record(
     name varchar2(255)
    ,val  varchar2(4000));

/**
* type of table for the logger parameters
*/
  type tab_param is table of rec_param index by binary_integer;

  gc_empty_tab_param tab_param;
  gc_date_format         constant varchar2(255) := 'DD-MON-YYYY HH24:MI:SS';
  gc_timestamp_format    constant varchar2(255) := gc_date_format || ':FF';
  gc_timestamp_tz_format constant varchar2(255) := gc_timestamp_format || ' TZR';

/**
* procedure to log entries
* @param p_text specifies the message text
* @param p_scope specifies the unit where the log was made
* @param p_extra specifies additional information
* @param p_params specifies the parameter list
*/
  procedure p_qa_log
  (
    p_text   in varchar2
   ,p_scope  in varchar2 default null
   ,p_extra  in clob default null
   ,p_params in tab_param default gc_empty_tab_param
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as varchar2 of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in varchar2
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name_01 specifies the name of the parameter 1
* @param p_val_01 specifies the value as varchar2 of the parameter 1
* @param p_name_02 specifies the name of the parameter 2
* @param p_val_02 specifies the value as varchar2 of the parameter 2
* @param p_name_03 specifies the name of the parameter 3
* @param p_val_03 specifies the value as varchar2 of the parameter 3
* @param p_name_04 specifies the name of the parameter 4
* @param p_val_04 specifies the value as varchar2 of the parameter 4
* @param p_name_05 specifies the name of the parameter 5
* @param p_val_05 specifies the value as varchar2 of the parameter 5
* @param p_name_06 specifies the name of the parameter 6
* @param p_val_06 specifies the value as varchar2 of the parameter 6
* @param p_name_07 specifies the name of the parameter 7
* @param p_val_07 specifies the value as varchar2 of the parameter 7
* @param p_name_08 specifies the name of the parameter 8
* @param p_val_08 specifies the value as varchar2 of the parameter 8
* @param p_name_09 specifies the name of the parameter 9
* @param p_val_09 specifies the value as varchar2 of the parameter 9
* @param p_name_10 specifies the name of the parameter 10
* @param p_val_10 specifies the value as varchar2 of the parameter 10
* @param p_name_11 specifies the name of the parameter 11
* @param p_val_11 specifies the value as varchar2 of the parameter 11
* @param p_name_12 specifies the name of the parameter 12
* @param p_val_12 specifies the value as varchar2 of the parameter 12
* @param p_name_13 specifies the name of the parameter 13
* @param p_val_13 specifies the value as varchar2 of the parameter 13
* @param p_name_14 specifies the name of the parameter 14
* @param p_val_14 specifies the value as varchar2 of the parameter 14
*/
  procedure append_param
  (
    p_params  in out nocopy tab_param
   ,p_name_01 in varchar2
   ,p_val_01  in varchar2
   ,p_name_02 in varchar2 default null
   ,p_val_02  in varchar2 default null
   ,p_name_03 in varchar2 default null
   ,p_val_03  in varchar2 default null
   ,p_name_04 in varchar2 default null
   ,p_val_04  in varchar2 default null
   ,p_name_05 in varchar2 default null
   ,p_val_05  in varchar2 default null
   ,p_name_06 in varchar2 default null
   ,p_val_06  in varchar2 default null
   ,p_name_07 in varchar2 default null
   ,p_val_07  in varchar2 default null
   ,p_name_08 in varchar2 default null
   ,p_val_08  in varchar2 default null
   ,p_name_09 in varchar2 default null
   ,p_val_09  in varchar2 default null
   ,p_name_10 in varchar2 default null
   ,p_val_10  in varchar2 default null
   ,p_name_11 in varchar2 default null
   ,p_val_11  in varchar2 default null
   ,p_name_12 in varchar2 default null
   ,p_val_12  in varchar2 default null
   ,p_name_13 in varchar2 default null
   ,p_val_13  in varchar2 default null
   ,p_name_14 in varchar2 default null
   ,p_val_14  in varchar2 default null
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as number of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in number
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as date of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in date
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as timestamp of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as timestamp with time zone of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with time zone
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as timestamp with local time zone of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with local time zone
  );

/**
* procedure to append parameters
* @param p_params specifies the param entity
* @param p_name specifies the name of the parameter
* @param p_val specifies the value as boolean of the parameter
*/
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in boolean
  );

/**
* function to convert a number to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in number
  ) return varchar2;
  
/**
* function to convert a date to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in date
  ) return varchar2;

/**
* function to convert a timestamp to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in timestamp
  ) return varchar2;

/**
* function to convert a timestamp with time zone to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in timestamp with time zone
  ) return varchar2;

/**
* function to convert a timestamp with local time zone to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in timestamp with local time zone
  ) return varchar2;

/**
* function to convert a boolean to varchar2
* @param  p_val specifies the param value
* @return varchar2 returns the converted value
*/
  function tochar(
    p_val in boolean
  ) return varchar2;

end;
/
create or replace package body qa_logger_pkg as

  procedure p_qa_log
  (
    p_text   in varchar2
   ,p_scope  in varchar2 default null
   ,p_extra  in clob default null
   ,p_params in tab_param default gc_empty_tab_param
  ) is
    $IF qa_constant_pkg.gc_logger_flag = 1
                      $THEN
    l_params logger.tab_param default logger.gc_empty_tab_param;
    $END


  begin
    $IF qa_constant_pkg.gc_logger_flag = 1
                        $THEN
    if p_params.count <> null
    then
      for i in p_params.first .. p_params.last
      loop
        dbms_output.put_line('p_name:  ' || p_params(i).name || ' P_val:  ' || p_params(i).val);
        logger.append_param(p_params => l_params
                           ,p_name   => (p_params(i).name)
                           ,p_val    => nvl(p_params(i).val
                                           ,''));

      end loop;
    end if;
    logger.log(p_text   => p_text
              ,p_scope  => p_scope
              ,p_extra  => p_extra
              ,p_params => l_params);
    $ELSE
    null;
    $END
  end p_qa_log;

  -- to_char helper functions:
  function tochar(p_val in number) return varchar2 as
  begin
    return to_char(p_val);
  end tochar;

  function tochar(p_val in date) return varchar2 as
  begin
    return to_char(p_val
                  ,gc_date_format);
  end tochar;

  function tochar(p_val in timestamp) return varchar2 as
  begin
    return to_char(p_val
                  ,gc_timestamp_format);
  end tochar;

  function tochar(p_val in timestamp with time zone) return varchar2 as
  begin
    return to_char(p_val
                  ,gc_timestamp_tz_format);
  end tochar;

  function tochar(p_val in timestamp with local time zone) return varchar2 as
  begin
    return to_char(p_val
                  ,gc_timestamp_tz_format);
  end tochar;

  -- #119: Return null for null booleans
  function tochar(p_val in boolean) return varchar2 as
  begin
    return case p_val when true then 'TRUE' when false then 'FALSE' else null end;
  end tochar;


  -- Handle Parameters
  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in varchar2
  ) as
    l_param rec_param;
  begin
    l_param.name := p_name;
    l_param.val := p_val;
    p_params(p_params.count + 1) := l_param;
  end append_param;

  -- Procedure to append all Parameters in one go
  procedure append_param
  (
    p_params  in out nocopy tab_param
   ,p_name_01 in varchar2
   ,p_val_01  in varchar2
   ,p_name_02 in varchar2 default null
   ,p_val_02  in varchar2 default null
   ,p_name_03 in varchar2 default null
   ,p_val_03  in varchar2 default null
   ,p_name_04 in varchar2 default null
   ,p_val_04  in varchar2 default null
   ,p_name_05 in varchar2 default null
   ,p_val_05  in varchar2 default null
   ,p_name_06 in varchar2 default null
   ,p_val_06  in varchar2 default null
   ,p_name_07 in varchar2 default null
   ,p_val_07  in varchar2 default null
   ,p_name_08 in varchar2 default null
   ,p_val_08  in varchar2 default null
   ,p_name_09 in varchar2 default null
   ,p_val_09  in varchar2 default null
   ,p_name_10 in varchar2 default null
   ,p_val_10  in varchar2 default null
   ,p_name_11 in varchar2 default null
   ,p_val_11  in varchar2 default null
   ,p_name_12 in varchar2 default null
   ,p_val_12  in varchar2 default null
   ,p_name_13 in varchar2 default null
   ,p_val_13  in varchar2 default null
   ,p_name_14 in varchar2 default null
   ,p_val_14  in varchar2 default null
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name_01
                ,p_val    => p_val_01);
    append_param(p_params => p_params
                ,p_name   => p_name_02
                ,p_val    => p_val_02);
    append_param(p_params => p_params
                ,p_name   => p_name_03
                ,p_val    => p_val_03);
    append_param(p_params => p_params
                ,p_name   => p_name_04
                ,p_val    => p_val_04);
    append_param(p_params => p_params
                ,p_name   => p_name_05
                ,p_val    => p_val_05);
    append_param(p_params => p_params
                ,p_name   => p_name_06
                ,p_val    => p_val_06);
    append_param(p_params => p_params
                ,p_name   => p_name_07
                ,p_val    => p_val_07);
    append_param(p_params => p_params
                ,p_name   => p_name_08
                ,p_val    => p_val_08);
    append_param(p_params => p_params
                ,p_name   => p_name_09
                ,p_val    => p_val_09);
    append_param(p_params => p_params
                ,p_name   => p_name_10
                ,p_val    => p_val_10);
    append_param(p_params => p_params
                ,p_name   => p_name_11
                ,p_val    => p_val_11);
    append_param(p_params => p_params
                ,p_name   => p_name_12
                ,p_val    => p_val_12);
    append_param(p_params => p_params
                ,p_name   => p_name_13
                ,p_val    => p_val_13);
    append_param(p_params => p_params
                ,p_name   => p_name_14
                ,p_val    => p_val_14);
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in number
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in date
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with time zone
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with local time zone
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in boolean
  ) as
    l_param rec_param;
  begin
    append_param(p_params => p_params
                ,p_name   => p_name
                ,p_val    => tochar(p_val => p_val));
  end append_param;

end qa_logger_pkg;
/
