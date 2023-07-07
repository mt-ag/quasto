PROMPT Create Schedule Plan RUN_UNIT_TESTS_DAILY_0100

declare
  l_sql varchar2(32767) := 
'dbms_scheduler.disable1_calendar_check();
dbms_scheduler.create_schedule('"RUN_UNIT_TESTS_DAILY_0100"',TO_TIMESTAMP_TZ(''01-MAR-2023 01.00.00,000000000 AM EUROPE/BERLIN'',''DD-MON-RRRR HH.MI.SSXFF AM TZR'',''NLS_DATE_LANGUAGE=english''),
''FREQ=DAILY; BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN; BYHOUR=1;'',
NULL,
''Runtime: Run at 1am every day''
);';
  l_count number;
begin

  select count(1)
    into l_count
    from user_scheduler_schedules
   where schedule_name = 'RUN_UNIT_TESTS_DAILY_0100';
  
  if l_count = 0
  then
    execute immediate l_sql;
	
    select count(1)
      into l_count
      from user_scheduler_schedules
     where schedule_name = 'RUN_UNIT_TESTS_DAILY_0100';

    if l_count = 0 THEN 
      dbms_output.put_line('ERROR: Creation of schedule plan RUN_UNIT_TESTS_DAILY_0100 failed.');
    else
      dbms_output.put_line('INFO: Schedule plan RUN_UNIT_TESTS_DAILY_0100 has been created.');
    end if;
  else
    dbms_output.put_line('WARNING: Schedule plan RUN_UNIT_TESTS_DAILY_0100 was already created.');
  end if;
  
exception
  when others then
    dbms_output.put_line('ERROR: Schedule plan RUN_UNIT_TESTS_DAILY_0100 could not been created.' || SQLERRM);
end;
/
