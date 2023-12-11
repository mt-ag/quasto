create or replace package qa_helper_pkg 
as

function p0001_get_faceted_search_data ( p_page_id          in number,
                                         p_region_static_id in varchar2
                                       )
return test_results_table_t pipelined;

end qa_helper_pkg;
/


create or replace package body qa_helper_pkg 
as


function p0001_get_faceted_search_data ( p_page_id          in number,
                                         p_region_static_id in varchar2
                                       )
return test_results_table_t pipelined
is
  l_region_id number;
  l_context   apex_exec.t_context;

  type t_col_index is table of pls_integer index by varchar2(255);
  l_col_index t_col_index;

  ------------
  procedure get_column_indexes (p_columns wwv_flow_t_varchar2) 
  is 
  begin
    for i in 1..p_columns.count loop
      l_col_index (p_columns(i)) := apex_exec.get_column_position(p_context     => l_context,
                                                                  p_column_name => p_columns(i));
    end loop;
  end get_column_indexes;
begin
  --1. get the region ID of the Faceted Search region
  select region_id
    into l_region_id
    from apex_application_page_regions
   where application_id = V('APP_ID')
     and page_id = p_page_id
     and static_id = p_region_static_id;

  --2. Get a cursor (apex_exec.t_content) for the current region data
  l_context := apex_region.open_query_context(p_page_id   => p_page_id,
                                              p_region_id => l_region_id);

  get_column_indexes(wwv_flow_t_varchar2('QATR_ID','EXECUTION_DATE', 'SCHEME', 'CATEGORY', 'DETAILS', 'STATUS', 'NAME', 'LAYER', 'ERRORLEVEL', 'ACTIVE', 'UTPLSQL_INFO', 'TEST_NAME', 'PROJECT'));

  while apex_exec.next_row(p_context => l_context) loop
    pipe row(test_results_row_t(
                    apex_exec.get_number  (p_context => l_context, p_column_idx => l_col_index('QATR_ID')),
                    apex_exec.get_date    (p_context => l_context, p_column_idx => l_col_index('EXECUTION_DATE')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('SCHEME')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('CATEGORY')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('DETAILS')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('STATUS')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('NAME')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('LAYER')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('ERRORLEVEL')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('ACTIVE')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('UTPLSQL_INFO')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('TEST_NAME')),
                    apex_exec.get_varchar2(p_context => l_context, p_column_idx => l_col_index('PROJECT'))));
  end loop;

  apex_exec.close(l_context);
  return;
exception
  when no_data_needed then
    apex_exec.close(l_context);
  when others then
    apex_exec.close(l_context);
    raise;
end p0001_get_faceted_search_data;


end qa_helper_pkg;
/