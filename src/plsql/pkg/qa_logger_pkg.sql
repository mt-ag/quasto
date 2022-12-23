create or replace package qa_logger_pkg authid definer is
  -- TYPES
  type rec_param is record(
     name varchar2(255)
    ,val  varchar2(4000));
  type tab_param is table of rec_param index by binary_integer;

  gc_empty_tab_param tab_param;
  gc_date_format         constant varchar2(255) := 'DD-MON-YYYY HH24:MI:SS';
  gc_timestamp_format    constant varchar2(255) := gc_date_format || ':FF';
  gc_timestamp_tz_format constant varchar2(255) := gc_timestamp_format || ' TZR';

  procedure p_qa_log
  (
    p_text   in varchar2
   ,p_scope  in varchar2 default null
   ,p_extra  in clob default null
   ,p_params in tab_param default gc_empty_tab_param
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in varchar2
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in number
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in date
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with time zone
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in timestamp with local time zone
  );

  procedure append_param
  (
    p_params in out nocopy tab_param
   ,p_name   in varchar2
   ,p_val    in boolean
  );

  function tochar(p_val in number) return varchar2;

  function tochar(p_val in date) return varchar2;

  function tochar(p_val in timestamp) return varchar2;

  function tochar(p_val in timestamp with time zone) return varchar2;

  function tochar(p_val in timestamp with local time zone) return varchar2;

  function tochar(p_val in boolean) return varchar2;

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
    for i in p_params.first .. p_params.last
    loop
      logger.append_param(p_params => l_params
                         ,p_name   => (p_params(i).name)
                         ,p_val    => (p_params(i).val));
    end loop;
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