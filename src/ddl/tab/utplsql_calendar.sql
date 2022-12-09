PROMPT create table UTPLSQL_CALENDAR
declare
  l_sql varchar2(32767) := 
'create table UTPLSQL_CALENDAR
(
  cldr_id              NUMBER not null,
  cldr_title           VARCHAR2(200 CHAR) not null,
  cldr_descr           VARCHAR2(500 CHAR),
  cldr_start_date      DATE,
  cldr_end_date        DATE,
  cldr_event_type      VARCHAR2(50 CHAR),
  cldr_create_date     DATE not null,
  cldr_create_user     VARCHAR2(255 CHAR) not null,
  cldr_change_date     DATE not null,
  cldr_change_user     VARCHAR2(255 CHAR) not null
)';
  l_count number;
begin

  select count(1)
    into l_count
    from user_tables
   where table_name = 'UTPLSQL_CALENDAR';
  
  if l_count = 0
  then
    execute immediate l_sql;

	execute immediate q'#comment on table UTPLSQL_CALENDAR is 'table for calendar entries'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_id is 'primary key'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_title is 'title of calendar entry'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_descr is 'description of calendar entry'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_start_date is 'start Date of calendar entry'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_end_date is 'end Date of calendar entry'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_event_type is 'type of event (Schema name)'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_create_user is 'when is the calendar entry created'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_create_date is 'who has the calendar entry created'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_change_user is 'when is the calendar entry updated'#';
	execute immediate q'#comment on column UTPLSQL_CALENDAR.cldr_change_date is 'who has the calendar entry updated'#';
	
    select count(1)
      into l_count
      from user_tables
     where table_name = 'UTPLSQL_CALENDAR';
    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of table UTPLSQL_CALENDAR failed.');
    else
      dbms_output.put_line('INFO: Table UTPLSQL_CALENDAR has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Table UTPLSQL_CALENDAR was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Table UTPLSQL_CALENDAR could not been created.' || SQLERRM);
end;
/
