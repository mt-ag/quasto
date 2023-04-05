CREATE OR REPLACE PACKAGE PREPARE_TEST_RESULTS_PKG IS

  TYPE rec_sample_data IS RECORD(
    t_test_suite_name   VARCHAR2(50),
    t_total_fail_pct    NUMBER,
    t_total_success_pct NUMBER,
    t_date              DATE);
  TYPE t_sample_data IS TABLE OF rec_sample_data;


  PROCEDURE utplsql_run(
    pi_pkg_name          IN  VARCHAR2,
    Pi_prc_name          IN  VARCHAR2 DEFAULT NULL,
    po_errror_message    OUT VARCHAR2);

  PROCEDURE utplsql_run_all(
    pi_suite_path     IN  VARCHAR2 DEFAULT NULL,
    pi_owner          IN  VARCHAR2,
    po_errror_message OUT VARCHAR2);

  FUNCTION clob2blob(pi_clob IN CLOB) RETURN BLOB;

  FUNCTION get_test_results_per_day(pi_schema    IN VARCHAR2,
                                    pi_test_name IN VARCHAR2) 
  RETURN t_sample_data PIPELINED;

  PROCEDURE create_calendar_entry(pi_testsuite_id IN NUMBER);

END prepare_test_results_pkg;
/
CREATE OR REPLACE PACKAGE BODY PREPARE_TEST_RESULTS_PKG IS
    
  -- To concatinate the table data
  FUNCTION tab_to_string (pi_varchar2_tab IN varchar2_tab_t,
                          pi_delimiter    IN VARCHAR2 DEFAULT ',')
  RETURN clob 
  IS
    l_string     clob;
  BEGIN
    FOR i IN pi_varchar2_tab.FIRST .. pi_varchar2_tab.LAST
      LOOP
        IF i != pi_varchar2_tab.FIRST THEN
          l_string := l_string || pi_delimiter;
        END IF;
        l_string := l_string || pi_varchar2_tab(i);
      END LOOP;
      RETURN l_string;
    END tab_to_string;

  -- Run utPLSQL Tests with given parameter values
  FUNCTION run_tests(pi_pkg_name  IN VARCHAR2,
                     pi_prc_name  IN VARCHAR2 DEFAULT NULL,
                     pi_suitepath IN VARCHAR2 DEFAULT NULL)
  RETURN CLOB
  AS
    l_test_run_result_xml CLOB;
    l_test_result varchar2_tab_t;
    l_pkg_name       VARCHAR2(32000 char);
  BEGIN
    IF pi_prc_name IS NULL THEN
      IF pi_suitepath IS NOT NULL THEN

        SELECT * 
          BULK COLLECT INTO l_test_result
          FROM TABLE(ut.run(ut_varchar2_list(pi_pkg_name ||':'||pi_suitepath),ut_junit_reporter()));

      ELSE

        l_pkg_name :=REPLACE(pi_pkg_name,':',',');
        SELECT *
          BULK COLLECT INTO l_test_result
          FROM TABLE(ut.run(ut_varchar2_list(l_pkg_name),ut_junit_reporter()));

      END IF;
    ELSE

      l_pkg_name := REPLACE(pi_prc_name,':',',');
      SELECT * 
        BULK COLLECT INTO l_test_result
        FROM TABLE(ut.run(ut_varchar2_list(l_pkg_name),ut_junit_reporter()));

    END IF;
    l_test_run_result_xml := trim(REPLACE(tab_to_string(l_test_result,''),'<?xml version="1.0"?>',''));
    RETURN l_test_run_result_xml;
  END run_tests;

  PROCEDURE insert_test_run(pi_test_output IN  CLOB,
                            po_test_run_id OUT utplsql_test_run.run_id%type)
  AS
  BEGIN
    INSERT
      INTO utplsql_test_run 
         ( run_start_date,
           run_test_result_xml )
    VALUES 
         ( sysdate,
           pi_test_output )
    RETURN run_id
      INTO po_test_run_id;
  END insert_test_run;

  -- derive required values from test run result
  PROCEDURE derive_test_run_details (pi_test_run_id    IN  utplsql_test_run.run_id%type,
                                     po_total_tests    OUT utplsql_test_run.run_total_tests%type,
                                     po_disabled_tests OUT utplsql_test_run.run_disabled_tests%type,
                                     po_errored_tests  OUT utplsql_test_run.run_errored_tests%type,
                                     po_failed_tests   OUT utplsql_test_run.run_failed_tests%type,
                                     po_duration_sec   OUT utplsql_test_run.run_duration_sec%type )
  AS
  BEGIN
    SELECT xt.*
      INTO po_total_tests,
           po_disabled_tests,
           po_errored_tests,
           po_failed_tests,
           po_duration_sec
      FROM utplsql_test_run run,
           XMLTABLE('/testsuites' PASSING xmltype(run.run_test_result_xml)
                                  COLUMNS "total_tests" VARCHAR2(4) PATH '@tests',
                                          "disabled_tests" VARCHAR2(4) PATH '@disabled',
                                          "errored_tests" VARCHAR2(4) PATH '@errors',
                                          "failed_tests" VARCHAR2(4) PATH '@failures',
                                          "duration_sec" VARCHAR2(4) PATH '@time') xt
     WHERE run.run_id =pi_test_run_id ;
  END derive_test_run_details;

  -- update utplsql_test_run table with derived values
  PROCEDURE update_test_run(pi_test_run_id    IN utplsql_test_run.run_id%type,
                            pi_total_tests    IN utplsql_test_run.run_total_tests%type,
                            pi_disabled_tests IN utplsql_test_run.run_disabled_tests%type,
                            pi_errored_tests  IN utplsql_test_run.run_errored_tests%type,
                            pi_failed_tests   IN utplsql_test_run.run_failed_tests%type,
                            pi_duration_sec   IN utplsql_test_run.run_duration_sec%type)
  AS
  BEGIN
    UPDATE utplsql_test_run
       SET run_end_date          = sysdate,
           run_total_tests       = to_number(pi_total_tests),
           run_disabled_tests    = to_number(pi_disabled_tests),
           run_errored_tests     = to_number(pi_errored_tests),
           run_failed_tests      = to_number(pi_failed_tests),
           run_duration_sec      = pi_duration_sec
     WHERE run_id = pi_test_run_id;
  END update_test_run;

  -- create an entry into the calendar for testsuite
  PROCEDURE create_calendar_entry(pi_testsuite_id IN NUMBER)
    IS
      l_count NUMBER;
    BEGIN
      IF pi_testsuite_id IS NOT NULL THEN
        SELECT COUNT(1)
          INTO l_count
          FROM utplsql_calendar c
         WHERE EXISTS ( SELECT NULL 
                          FROM utplsql_test_suite s, 
                               utplsql_test_run r
                         WHERE s.suite_id = pi_testsuite_id
                           AND s.suite_run_id = r.run_id
                           AND s.suite_schema = c.cldr_event_type
                           AND s.suite_testsuite_name = c.cldr_title
                           AND to_date(r.run_start_date, 'DD.MM.YY') = to_date(c.cldr_start_date, 'DD.MM.YY')
                           AND to_date(r.run_end_date, 'DD.MM.YY') = to_date(c.cldr_end_date, 'DD.MM.YY'));

        IF l_count = 0 THEN
          INSERT
            INTO utplsql_calendar
               ( cldr_title,
                 cldr_start_date,
                 cldr_end_date,
                 cldr_event_type )
          SELECT suite_testsuite_name,
                 to_date(run_start_date, 'DD.MM.YY'), 
                 to_date(run_end_date, 'DD.MM.YY'), 
                 suite_schema
            FROM utplsql_test_run r, 
                 utplsql_test_suite s
           WHERE s.suite_run_id = r.run_id
             AND s.suite_id = pi_testsuite_id;
        END IF;
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line('Es konnte kein Kalendereintrag erstellt werden!'||SQLERRM);
    END create_calendar_entry;

  -- insert test_suite and test case details into utplsql_test_suite, utplsql_test_case tables
  PROCEDURE ins_test_suite_and_case(pi_testrun_id IN NUMBER)
  AS
    l_testsuite_id utplsql_test_suite.suite_id%type;
    l_tsu_id       utplsql_test_suite.suite_id%type:=0;
    l_error_message  VARCHAR2(32000 char);
    l_pkg_name       VARCHAR2(32000 char);
    l_count NUMBER;

    CURSOR c_test_suite(pi_test_run_id NUMBER)
     IS
     WITH xml_tab AS (
          SELECT  xmltype(run.run_test_result_xml) AS xml,
                  run_id
            FROM utplsql_test_run run)
          SELECT xt.package_path ,
                 xt.parent ,
                 SUM(xt.total_tests) total_tests ,
                 MIN(xt.testsuite_id) testsuite_id ,
                 SUM(xt.disabled_tests) disabled_tests ,
                 SUM(xt.errored_tests) errored_tests ,
                 SUM(xt.failed_tests) failed_tests ,
                 xt.testsuite_name ,
                 SUM(to_number(xt.duration_sec, '999999.999999')) duration_sec ,
                 xt.system_out ,
                 xt.system_err
            FROM xml_tab,
                 XMLTABLE( ' for $i in $doc//testsuite
                             let $j := $i/..
                             return <res>
                             <suitepath>{data($i/@package)}</suitepath>
                             <parent>{data($j/@package)}</parent>
                             <tests>{data($i/@tests)}</tests>
                             <id>{data($i/@id)}</id>
                             <disabled>{data($i/@disabled)}</disabled>
                             <errors>{data($i/@errors)}</errors>
                             <failures>{data($i/@failures)}</failures>
                             <name>{data($i/@name)}</name>
                             <time>{data($i/@time)}</time>
                             <system-out>{data($i/system-out)}</system-out>
                             <system-err>{data($i/system-err)}</system-err>
                             </res>'
                 passing xml_tab.xml AS "doc"
                 COLUMNS "PACKAGE_PATH"    VARCHAR2(100 char) PATH '//suitepath',
                         parent            VARCHAR2(100 char) PATH '//parent',
                         "TOTAL_TESTS"     VARCHAR2(4 char)   PATH '//tests',
                         "TESTSUITE_ID"    VARCHAR2(255 char) PATH '//id',
                         "DISABLED_TESTS"  VARCHAR2(4 char)   PATH '//disabled',
                         "ERRORED_TESTS"   VARCHAR2(4 char)   PATH '//errors',
                         "FAILED_TESTS"    VARCHAR2(4 char)   PATH '//failures',
                         "TESTSUITE_NAME"  VARCHAR2(255 char) PATH '//name',
                         "DURATION_SEC"    VARCHAR2(255 char) PATH '//time',
                         "SYSTEM_OUT"      VARCHAR2(255 char) PATH 'system-out',
                         "SYSTEM_ERR"      VARCHAR2(255 char) PATH 'system-err' ) xt
           WHERE xml_tab.run_id= pi_test_run_id
           GROUP BY xt.package_path ,
                 xt.parent ,
                 xt.TESTSUITE_NAME ,
                 xt.system_out ,
                 xt.system_err
           ORDER BY testsuite_id;

    CURSOR c_test_case(pi_test_suite_path VARCHAR2,pi_test_run_id NUMBER)
        IS
         SELECT xt.*
           FROM utplsql_test_run run,
                XMLTABLE('/testsuites/testsuite//testcase'
                PASSING xmltype(run.run_test_result_xml)
                COLUMNS "FAILURE_STATEMENT" VARCHAR2(255 char) PATH 'failure',
                        "ERROR_STATEMENT"   VARCHAR2(255 char) PATH 'error',
                        "SYSTEM_OUT"        VARCHAR2(4 char)   PATH 'system-out',
                        "SYSTEM_ERR"        VARCHAR2(255 char) PATH 'system-err',
                        "TESTCASE_PATH"     VARCHAR2(255 char) PATH '@classname',
                        "TESTCASE_NAME"     VARCHAR2(255 char) PATH '@name',
                        "ASSERTIONS"        VARCHAR2(4 char)   PATH '@assertions',
                        "STATUS"            VARCHAR2(20 char)  PATH '@status',
                        "DURATION_SEC"      VARCHAR2(255 char) PATH '@time') xt
          WHERE run.run_id     = pi_test_run_id
            AND xt.TESTCASE_PATH =pi_test_suite_path;
  BEGIN
    FOR tsu_rec IN c_test_suite(pi_testrun_id)
    LOOP
      INSERT
        INTO utplsql_test_suite 
           ( suite_run_id,
             suite_package_path,
             suite_testsuite_name,
             suite_testsuite_id,
             suite_total_tests,
             suite_disabled_tests,
             suite_errored_tests,
             suite_failed_tests,
             suite_duration_sec,
             suite_tsu_id,
             suite_schema )
      VALUES 
           ( pi_testrun_id,
             tsu_rec.package_path,
             tsu_rec.testsuite_name,
             tsu_rec.testsuite_id,
             to_number(tsu_rec.total_tests),
             to_number(tsu_rec.disabled_tests),
             to_number(tsu_rec.errored_tests),
             to_number(tsu_rec.failed_tests),
             tsu_rec.duration_sec,
             l_tsu_id,
             upper(SUBSTR(tsu_rec.testsuite_name, 6, INSTR(tsu_rec.testsuite_name, '_', 9)-6) ))
      RETURN suite_id
        INTO l_testsuite_id;

      create_calendar_entry(pi_testsuite_id => l_testsuite_id);

      l_tsu_id :=l_testsuite_id;
      FOR tc_rec IN c_test_case ( tsu_rec.package_path,pi_testrun_id )
      LOOP
        SELECT COUNT(*)
          INTO l_count
          FROM utplsql_test_case utc,
               utplsql_test_suite uts
         WHERE utc.case_suite_id = uts.suite_id
           AND uts.suite_run_id  = pi_testrun_id
           AND utc.case_testcase_path = tc_rec.testcase_path
           AND utc.case_testcase_name = tc_rec.testcase_name;

        IF l_count = 0 THEN
          INSERT
            INTO utplsql_test_case 
               ( case_suite_id,
                 case_testcase_path,
                 case_testcase_name,
                 case_assertions,
                 case_test_status,
                 case_failure_statement,
                 case_error_statement,
                 case_system_out,
                 case_system_err,
                 case_duration_sec ,
                 case_executed_on,
                 case_schema )
          VALUES 
               ( l_testsuite_id,
                 tc_rec.testcase_path,
                 tc_rec.testcase_name,
                 tc_rec.assertions,
                 coalesce (tc_rec.status, 'Success'),
                 tc_rec.failure_statement,
                 tc_rec.error_statement,
                 tc_rec.system_out,
                 tc_rec.system_err,
                 tc_rec.duration_sec,
                 sysdate,
                 upper(SUBSTR(tc_rec.testcase_path, 6, INSTR(tc_rec.testcase_path, '_', 9)-6) ));
        END IF;
      END LOOP;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      l_error_message := 'Error occured while inserting test result into utplsql_test_suite, utplsql_test_case tables'||' '|| l_pkg_name;
      raise;
  END ins_test_suite_and_case;

  -- Main Test run call for selected Packges or Procedures
  PROCEDURE utplsql_run ( pi_pkg_name       IN  VARCHAR2,
                          Pi_prc_name       IN  VARCHAR2 DEFAULT NULL,
                          po_errror_message OUT VARCHAR2)
  AS
    l_testrun_id utplsql_test_run.run_id%type;
    l_test_run_result_xml CLOB;
    l_total_tests    VARCHAR2(4 char);
    l_disabled_tests VARCHAR2(4 char);
    l_errored_tests  VARCHAR2(4 char);
    l_failed_tests   VARCHAR2(4 char);
    l_duration_sec   VARCHAR2(4 char);
    l_error_message  VARCHAR2(32000 char);
  BEGIN
    l_test_run_result_xml:= run_tests(pi_pkg_name,pi_prc_name,NULL);
    insert_test_run(l_test_run_result_xml,l_testrun_id);
    derive_test_run_details(l_testrun_id,l_total_tests, l_disabled_tests, l_errored_tests, l_failed_tests, l_duration_sec);
    update_test_run(l_testrun_id,l_total_tests, l_disabled_tests, l_errored_tests, l_failed_tests, l_duration_sec);
    ins_test_suite_and_case(l_testrun_id);
  EXCEPTION
    WHEN OTHERS THEN
      po_errror_message := l_error_message;
      RAISE;
  END utplsql_run;

  -- Main Test run call to execute all packages from given user and suitepath
  PROCEDURE utplsql_run_all (pi_suite_path     IN  VARCHAR2 DEFAULT NULL,
                             pi_owner          IN  VARCHAR2,
                             po_errror_message OUT VARCHAR2)
  AS
    l_testrun_id utplsql_test_run.run_id%type;
    l_test_run_result_xml CLOB;
    l_total_tests    VARCHAR2(4 char);
    l_disabled_tests VARCHAR2(4 char);
    l_errored_tests  VARCHAR2(4 char);
    l_failed_tests   VARCHAR2(4 char);
    l_duration_sec   VARCHAR2(4 char);
    l_error_message  VARCHAR2(32000 char);
  BEGIN
    l_test_run_result_xml:= run_tests(pi_owner,NULL,pi_suite_path);
    insert_test_run( l_test_run_result_xml,l_testrun_id);
    derive_test_run_details(l_testrun_id,l_total_tests, l_disabled_tests, l_errored_tests, l_failed_tests, l_duration_sec);
    update_test_run(l_testrun_id,l_total_tests, l_disabled_tests, l_errored_tests, l_failed_tests, l_duration_sec);
    ins_test_suite_and_case(l_testrun_id);
  EXCEPTION
    WHEN OTHERS THEN
      po_errror_message := l_error_message;
      RAISE;
  END utplsql_run_all;

  FUNCTION clob2blob(pi_clob IN CLOB) RETURN BLOB
  IS 
    l_return BLOB;
    l_val1   NUMBER := 1;
    l_val0   NUMBER := 0;
  BEGIN
    dbms_lob.createTemporary(l_return, TRUE);
    dbms_lob.convertToBlob(l_return, pi_clob, length(pi_clob), l_val1, l_val1, l_val0, l_val0, l_val0);
    RETURN l_return;
  END clob2blob;

  FUNCTION get_test_results_per_day(pi_schema    IN VARCHAR2,
                                    pi_test_name IN VARCHAR2) 
  RETURN t_sample_data PIPELINED
  IS
    l_min_date_all DATE;
    l_max_date_all DATE;
    l_diff_dates   NUMBER;

    l_date_anz        NUMBER;

    l_sample_data t_sample_data;
  BEGIN
    -- get max and min date of all tests
    SELECT MAX(to_date(c.case_executed_on, 'DD.MM.YY')),
           MIN(to_date(c.case_executed_on, 'DD.MM.YY'))
      INTO l_max_date_all,
           l_min_date_all
      FROM utplsql_test_case c;

    SELECT l_max_date_all - l_min_date_all 
       INTO l_diff_dates
       FROM dual;

    FOR i IN 0..l_diff_dates 
    LOOP
      SELECT COUNT(1)
        INTO l_date_anz
        FROM utplsql_test_case c
       WHERE to_date(c.case_executed_on, 'DD.MM.YY') = l_min_date_all + i;

      IF l_date_anz >= 1 THEN
        SELECT 'test_'||lower(pi_schema)||pi_test_name AS t_test_suite_name,
               (SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_fail_pct,
               100-(SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_success_pct,
               to_date(c.case_executed_on, 'DD.MM.YY') AS t_date
          BULK COLLECT INTO l_sample_data
          FROM utplsql_test_suite s, utplsql_test_case c
         WHERE instr(s.suite_testsuite_name,pi_test_name) >0
           AND s.suite_schema = coalesce(upper(pi_schema), s.suite_schema)
           AND s.suite_id = c.case_suite_id
           AND to_date (c.case_executed_on, 'DD.MM.YY') = l_min_date_all + i
         GROUP BY to_date(c.case_executed_on, 'DD.MM.YY');

         if sql%rowcount > 0 then
           for k in l_sample_data.first .. l_sample_data.last
           loop
             pipe row(l_sample_data(k));
           end loop;
         end if;

     ELSE
        IF i = 0 THEN
          SELECT 'test_'||lower(pi_schema)||pi_test_name AS t_test_suite_name,
               (SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_fail_pct,
               100-(SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_success_pct,
               l_min_date_all + i AS t_date
          BULK COLLECT INTO l_sample_data
          FROM utplsql_test_suite s, utplsql_test_case c
         WHERE instr(s.suite_testsuite_name,pi_test_name) >0
           AND s.suite_schema = coalesce(upper(pi_schema), s.suite_schema)
           AND s.suite_id = c.case_suite_id;

         if sql%rowcount > 0 then
           for k in l_sample_data.first .. l_sample_data.last
           loop
             pipe row(l_sample_data(k));
           end loop;
         end if;

        ELSE
          FOR j IN 1..l_diff_dates
          LOOP
            SELECT COUNT(1)
              INTO l_date_anz
              FROM utplsql_test_case c
             WHERE to_date(c.case_executed_on, 'DD.MM.YY') = l_min_date_all + i -j;

            IF l_date_anz >= 1 THEN
              SELECT 'test_'||lower(pi_schema)||pi_test_name AS t_test_suite_name,
               (SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_fail_pct,
               100-(SUM(suite_disabled_tests) + SUM(suite_errored_tests) + SUM(suite_failed_tests)) /SUM(suite_total_tests)*100 AS t_total_success_pct,
               l_min_date_all + i  AS t_date
          BULK COLLECT INTO l_sample_data
          FROM utplsql_test_suite s, utplsql_test_case c
         WHERE instr(s.suite_testsuite_name,pi_test_name) >0
           AND s.suite_schema = coalesce(upper(pi_schema), s.suite_schema)
           AND s.suite_id = c.case_suite_id
           AND to_date(c.case_executed_on, 'DD.MM.YY') = l_min_date_all + i -j
         GROUP BY to_date(c.case_executed_on, 'DD.MM.YY');

         if sql%rowcount > 0 then
           for k in l_sample_data.first .. l_sample_data.last
           loop
             pipe row(l_sample_data(k));
           end loop;
         end if;

         EXIT;
         END IF;
          END LOOP;
        END IF;
      END IF;     
    END LOOP;
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(SQLERRM);
  END get_test_results_per_day;
END prepare_test_results_pkg;
/
