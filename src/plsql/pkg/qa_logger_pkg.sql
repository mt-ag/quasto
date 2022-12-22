create or replace package qa_logger_pkg authid definer is
  -- TYPES
  type qa_rec_param is record(
     name varchar2(255)
    ,val  varchar2(4000));
  type tab_param is table of qa_rec_param index by binary_integer;

  gc_empty_tab_param tab_param;

  procedure p_qa_log
  (
    p_text   in varchar2
   ,p_scope  in varchar2 default null
   ,p_extra  in clob default null
   ,p_params in tab_param default qa_logger_pkg.gc_empty_tab_param
  );
end;
/
create or replace package body qa_logger_pkg as
  procedure p_qa_log
  (
    p_text   in varchar2
   ,p_scope  in varchar2 default null
   ,p_extra  in clob default null
   ,p_params in tab_param default qa_logger_pkg.gc_empty_tab_param
  ) is
  begin
  
    $IF qa_constant_pkg.gc_logger_flag = 1
    $THEN
    logger.log(p_text   => p_text
              ,p_scope  => p_scope
              ,p_extra  => p_extra
              ,p_params => p_params);
    $ELSE
      null;
    $END
  end p_qa_log;
end qa_logger_pkg;
/