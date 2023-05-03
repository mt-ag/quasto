PROMPT Create Schedule Plan RUN_UNIT_TESTS_DAILY_0100

BEGIN 
dbms_scheduler.disable1_calendar_check();
dbms_scheduler.create_schedule('"RUN_UNIT_TESTS_DAILY_0100"',TO_TIMESTAMP_TZ('01-MAR-2023 01.00.00,000000000 AM EUROPE/BERLIN','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
'FREQ=DAILY; BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN; BYHOUR=1;',
NULL,
'Runtime: Run at 1am every day'
);
COMMIT; 
END;
/
