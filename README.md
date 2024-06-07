# QUASTO - Quality Assurance Tool
[1. What is QUASTO?](https://github.com/mt-ag/quasto#1-what-is-quasto)<br>
[2. Installing QUASTO](https://github.com/mt-ag/quasto#2-installing-quasto)<br>
[3. Using QUASTO](https://github.com/mt-ag/quasto#3-using-quasto)<br>
[4. Installing utPLSQL](https://github.com/mt-ag/quasto#4-installing-utplsql)<br>
[5. Upcoming Features](https://github.com/mt-ag/quasto#5-upcoming-features)<br>
[6. Latest Releases](https://github.com/mt-ag/quasto#6-latest-releases)

## 1. What is QUASTO?
A project for checking guidelines and code quality for inside the oracle database.
The current version supports checks for your data model, PL/SQL code and data itself.
It also provides utPLSQL tests to check your rules and an APEX Front-End.
CI/CD support for jenkins/azure devops or gitlab/github are planned for the future.

You need to have installed Oracle 19c or higher to be able to install and use QUASTO.

The project uses the MIT License.

## 2. Installing QUASTO
### Installing Guidelines for QUASTO

To install QUASTO on your oracle database from scratch, run the install.sql file in the root directory of the repository.

This file will install all necessary objects for QUASTO.

It is possible to run QUASTO standalone without a valid APEX or utPLSQL installation.
In order to install the tool the user needs to move into the root directory of the downloaded folder. 
You can either clone the repository on git itself or download the .zip file.

To start the installation, you need to connect to the database scheme in which you want to install QUASTO using SQL*Plus or SQLcl.

In order to use QUASTO in other schemes, a public synonym is required on the type "QA_RULE_T".
The user has to create this outside of the regular QUASTO installation.

<b>Note:</b> To drop a public synonym, the user needs the DROP PUBLIC SYNONYM or DROP ANY SYNONYM privilege.

### Minimal user rights
If you install QUASTO in a blank new scheme, the user needs the following rights:

```sql
grant create procedure, public synonym, sequence, table, trigger, type, view, job to quasto;

grant create session to quasto;
```

### Optional user rights
If you want to run APEX Tests, you should grant the APEX_ADMINISTRATOR_ROLE to QUASTO. Otherwise QUASTO has no rights to see APEX Objects from other schemes:

```sql
grant APEX_ADMINISTRATOR_ROLE to quasto;
```

### Running the Install Script
```
@install.sql [1/0] [1/0] [1/0] [1/0]
```

To ensure a clean installation, it is important to decide what you want to install.
It is not mandatory to install APEX or utPLSQL. However, you get more features for your quality approach.

Arguments that are required to be passed to the script are:
1. Do you want to install supporting objects for utPLSQL? 1=yes / 0=no (you need to install supporting utPLSQL objects separately later, if desired)
2. Do you want to install supporting objects for Oracle APEX? 1=yes / 0=no (you need to install supporting APEX objects separately later, if desired)
3. Do you want to install supporting objects for Jenkins? 1=yes / 0=no (you need to install supporting Jenkins objects separately later, if desired [*])
4. Do you wish to install a logger functionality for debugging? 1=yes / 0=no (if activated, you can debug parameter and variable values [**])

[*] Please not that the third argument about Jenkins does not have any effect yet. Jenkins objects will be added in a future release of QUASTO.

[**] QUASTO is using the open-source logger framework. You can download it on GitHub: https://github.com/OraOpenSource/Logger.

It is possible to install QUASTO, utPLSQL or APEX objects separately.
To do this, the user needs to move from the root directory of the project into the /src/ directory.

Currently, there are three installer scripts:
1. install_quasto_objects.sql
2. install_utplsql_objects.sql
3. install_apex_objects.sql

The first script is necessary for any installation and includes all core objects of QUASTO. The second and third script can be executed optionally. All of these scripts do not need any arguments and should be executed in the same scheme.

Example:
```sql
@install_utplsql_objects.sql
```

### Upgrading from a prior Version to the latest version
In Order to upgrade, the user has to follow the same steps like above.

Just like installing the tool for the first time, we run:
```sql
@install.sql [1/0] [1/0] [1/0] [1/0]
```

The script automatically detects if no version or one of the previous versions (1.0, 1.1) has been installed, and upgrades to the latest release.

An alternative way to install the new release is to fully remove the old version and install the latest one by using the unistall and install scripts.

<b>Note:</b> Please be aware that the uninstall will remove all QUASTO objects including the table QA_RULES and its data. Therefore it is recommended to export or backup all rules and reimport them once the full installation process is finished. More information on how to backup rules, you can find in the section [Export and Import Rules](https://github.com/mt-ag/quasto#export-and-import-rules).


### Uninstalling utPLSQL and QUASTO objects

To uninstall the utPLSQL test and QUASTO objects, run the script uninstall.sql in the root directory of the repository.

## 3. Using QUASTO
### Define a rule
For using QUASTO you have to define rules based on SQL queries which have to be saved inside the QA_RULES table.
The query for every rule should return every object which does not match you quality standards.

The following example shows a query which returns all table names that do not have a primary key defined:

```sql
with param as
 (select :1 scheme
        ,:2 qaru_id
        ,:3 qaru_category
        ,:4 qaru_error_level
        ,:5 qaru_object_types
        ,:6 qaru_error_message
        ,:7 qaru_sql
  from dual)
select qa_rule_t(pi_qaru_id             => p.qaru_id
                ,pi_qaru_category       => p.qaru_category
                ,pi_qaru_error_level    => p.qaru_error_level
                ,pi_qaru_error_message  => p.qaru_error_message
                ,pi_qaru_object_types   => p.qaru_object_types
                ,pi_qaru_sql            => p.qaru_sql
                ,pi_scheme_name         => p.scheme
                ,pi_object_id           => ao.object_id
                ,pi_object_name         => ao.object_name
                ,pi_object_details      => ao.object_name || ' without primary key'
                ,pi_object_type         => 'TABLE'
                ,pi_object_value        => null
                ,pi_object_updated_user => null
                ,pi_object_updated_date => ao.last_ddl_time)
from param p
cross join all_tables at
join all_objects ao on at.table_name = ao.object_name
where (ao.owner = p.scheme or p.scheme is null)
and not exists (select null
       from all_constraints cons
       join all_cons_columns cols on cols.constraint_name = cons.constraint_name
       where cols.table_name = at.table_name
       and cons.constraint_type = 'P'
       and cons.status = 'ENABLED')
```

Example for DML/DATA Rule - Table QA_RULES not empty
``` sql
with param as
 (select :1 scheme
        ,:2 qaru_id
        ,:3 qaru_category
        ,:4 qaru_error_level
        ,:5 qaru_object_types
        ,:6 qaru_error_message
        ,:7 qaru_sql
  from dual)
select qa_rule_t(pi_qaru_id             => p.qaru_id
                ,pi_qaru_category       => p.qaru_category
                ,pi_qaru_error_level    => p.qaru_error_level
                ,pi_qaru_error_message  => p.qaru_error_message
                ,pi_qaru_object_types   => p.qaru_object_types
                ,pi_qaru_sql            => p.qaru_sql
                ,pi_scheme_name         => p.scheme
                ,pi_object_id           => src.object_id
                ,pi_object_name         => src.object_name
                ,pi_object_details      => src.object_name || ' without Data'
                ,pi_object_type         => 'TABLE'
                ,pi_object_value        => src.object_value
                ,pi_object_updated_user => src.updated_user
                ,pi_object_updated_date => src.updated_date)
from param p
cross join (select null as object_id
                  ,'QA_RULES' as object_name
                  ,'TABLE' as object_type
                  ,'0' as object_value
                  ,null as updated_user
                  ,null as updated_date
            from dual
            where not exists (select *
                   from qa_rules)) src
```

Example for APEX Rule - No Never Condition
Here we need two additional Paramters for Apex Page and App ID
``` sql
with param as
 (select :1 scheme
        ,:2 qaru_id
        ,:3 qaru_category
        ,:4 qaru_error_level
        ,:5 qaru_object_types
        ,:6 qaru_error_message
        ,:7 qaru_sql
        ,:8 apex_app_id
        ,:9 apex_page_id
  from dual)
select qa_rule_t(pi_qaru_id             => qaru_id
                ,pi_qaru_category       => qaru_category
                ,pi_qaru_error_level    => qaru_error_level
                ,pi_qaru_error_message  => qaru_error_message
                ,pi_qaru_object_types   => qaru_object_types
                ,pi_qaru_sql            => qaru_sql
                ,pi_scheme_name         => scheme
                ,pi_object_id           => object_id
                ,pi_object_name         => object_name
                ,pi_object_details      => 'The Item ' || object_name || ' on Page ' || c.page_id || ' in ' || application_name || ' has a never condition!'
                ,pi_object_type         => object_type
                ,pi_object_value        => object_value
                ,pi_object_updated_user => object_updated_user
                ,pi_object_updated_date => object_updated_date
                ,pi_apex_app_id         => c.apex_app_id
                ,pi_apex_page_id        => c.apex_page_id)
from param p
cross join (select 'ITEM' object_type
            ,pi.application_id
            ,pi.application_name
            ,pi.page_id
            ,pi.region_id
            ,pi.item_id object_id
            ,pi.item_name object_name
            ,pi.condition_type_code object_value
            ,pi.last_updated_by object_updated_user
            ,pi.last_updated_on object_updated_date
            ,pi.application_id as apex_app_id
            ,pi.page_id as apex_page_id
      from apex_application_page_items pi
      where pi.condition_type_code = 'NEVER'
      union
      select 'REGION' object_type
            ,pr.application_id
            ,pr.application_name
            ,pr.page_id
            ,pr.region_id
            ,pr.region_id object_id
            ,pr.region_name object_name
            ,pr.condition_type_code object_value
            ,pr.last_updated_by object_updated_user
            ,pr.last_updated_on object_updated_date
            ,pr.application_id as apex_app_id
            ,pr.page_id as apex_page_id
      from apex_application_page_regions pr
      where condition_type_code = 'NEVER'
      union
      select 'BUTTON' object_type
            ,pb.application_id
            ,pb.application_name
            ,pb.page_id
            ,pb.region_id
            ,pb.button_id object_id
            ,pb.button_name object_name
            ,pb.condition_type_code object_value
            ,pb.last_updated_by object_updated_user
            ,pb.last_updated_on object_updated_date
            ,pb.application_id as apex_app_id
            ,pb.page_id as apex_page_id
      from apex_application_page_buttons pb
      where pb.condition_type_code = 'NEVER'
      union
      select 'RPT_COL' object_type
            ,prc.application_id
            ,prc.application_name
            ,prc.page_id
            ,prc.region_id
            ,prc.region_report_column_id object_id
            ,prc.column_alias object_name
            ,prc.condition_type_code object_value
            ,prc.last_updated_by object_updated_user
            ,prc.last_updated_on object_updated_date
            ,prc.application_id as apex_app_id
            ,prc.page_id as apex_page_id
      from apex_application_page_rpt_cols prc
      where prc.condition_type_code = 'NEVER'
      union
      select 'COMPUTATION' object_type
            ,pc.application_id
            ,pc.application_name
            ,pc.page_id
            ,null region_id
            ,pc.computation_id object_id
            ,pc.item_name object_name
            ,pc.condition_type_code object_value
            ,pc.last_updated_by object_updated_user
            ,pc.last_updated_on object_updated_date
            ,pc.application_id as apex_app_id
            ,pc.page_id as apex_page_id
      from apex_application_page_comp pc
      where pc.condition_type_code = 'NEVER'
      union
      select 'VALIDATION' object_type
            ,pv.application_id
            ,pv.application_name
            ,pv.page_id
            ,null region_id
            ,pv.validation_id object_id
            ,pv.validation_name object_name
            ,pv.condition_type_code object_value
            ,pv.last_updated_by object_updated_user
            ,pv.last_updated_on object_updated_date
            ,pv.application_id as apex_app_id
            ,pv.page_id as apex_page_id
      from apex_application_page_val pv
      where pv.condition_type_code = 'NEVER'
      union
      select 'PROCESS' object_type
            ,pp.application_id
            ,pp.application_name
            ,pp.page_id
            ,null region_id
            ,pp.process_id object_id
            ,pp.process_name object_name
            ,pp.condition_type_code object_value
            ,pp.last_updated_by object_updated_user
            ,pp.last_updated_on object_updated_date
            ,pp.application_id as apex_app_id
            ,pp.page_id as apex_page_id
      from apex_application_page_proc pp
      where pp.condition_type_code = 'NEVER'
      union
      select 'BRANCH' object_type
            ,pb.application_id
            ,pb.application_name
            ,pb.page_id
            ,null region_id
            ,pb.branch_id object_id
            ,pb.branch_point object_name
            ,pb.condition_type_code object_value
            ,pb.last_updated_by object_updated_user
            ,pb.last_updated_on object_updated_date
            ,pb.application_id as apex_app_id
            ,pb.page_id as apex_page_id
      from apex_application_page_branches pb
      where pb.condition_type_code = 'NEVER'
      union
      select 'DA' object_type
            ,pd.application_id
            ,pd.application_name
            ,pd.page_id
            ,null region_id
            ,pd.dynamic_action_id object_id
            ,pd.dynamic_action_name object_name
            ,pd.condition_type_code object_value
            ,pd.last_updated_by object_updated_user
            ,pd.last_updated_on object_updated_date
            ,pd.application_id as apex_app_id
            ,pd.page_id as apex_page_id
      from apex_application_page_da pd
      where pd.condition_type_code = 'NEVER') c
where (p.apex_app_id = c.apex_app_id or p.apex_app_id is null)
and (p.apex_page_id = c.apex_page_id or p.apex_page_id is null)
```
### Running rules
After you defined one or more rules, you can run these rules. The easiest way is to call them in your SQL tool.
To run rules, you can use the package QA_API_PKG. It allows you to run a single rule, or a complete ruleset for one project only with a single SQL query.
For running one rule you need the rule number, the client name and the scheme in which you want to search for.

```sql
select *
from qa_api_pkg.tf_run_rule(pi_qaru_rule_number => '23.1'
                           ,pi_qaru_client_name => 'MT AG'
                           ,pi_target_scheme    => 'QUASTO')
```

In this example, the rule 23.1 from the client "MT AG" is used inside the scheme QUASTO. If you don't provide a scheme, all schemes are tested, excluding Oracle-preserved ones. The return of the SQL query will list all found objects that do not comply the rule.

If you want to run all rules from one client simply call the following query:

```sql
select *
from qa_api_pkg.tf_run_rules(pi_qaru_client_name => 'MT AG'
                            ,pi_target_scheme    => 'QUASTO')
```

### Exclude objects in rules
Sometimes a rule is valid for all objects except one. For this object it is possible to exclude the run. The table QA_RULES includes a column named QARU_EXCLUDE_OBJECTS in which you can save object names to be excluded.
If you want to enter more than one object, you have to separate them with a colon (':'). Example: OBJECT_ONE:OBJECT_TWO.

When you test a rule, the specified objects will not run for this test and therefore will not give any feedback of the test run. The addition or deletion in the QARU_EXCLUDE_OBJECTS column will have impact in the next run immediatly.


### Defining a test-run-order
With the column QARU_PREDECESSOR_IDS in the table QA_RULES it is possible to give an order to the test run. In this column you can define which rules have to run successful before another rule can start.

Therefore, you have to add the rule names separated with a colon (':'). You can add one or more rules. Example: 12.3:4:1.

Be careful, that there is no recursive connection between the rules. Otherwise an exception is raised and the run is stopped immediatly.
If you have defined predecessors, the rules will be ordered first and will be executed in the predefined order.
If one or more predecessors of one rule failed, the rule will not run. You have to fix the errors first. Even if all predecessors of a rule run successful, this rule will also run.

With this option you have the ability to control, which rule will run under which circumstances. It can also protect you to get a big log of failures. For example, there could be a rule to check if APEX exists.

All rules that belong to an APEX scheme have this rule as predecessor. So if this first rule fails, no other APEX rule will run.

### Export and Import Rules

#### Exporting Rules

In order to export a JSON file of the currently existing rules of the QA_RULES table, change into the folder /src/scripts/ and connect to the database via SQL*Plus or SQLcl executing the following command:

```sh
@export_rules_to_file.sql "[Client Name]" "[Category (optional)]"
```

Here we use two arguments.
1. The name of the client we want to export the rules for. This name needs to be the exact entry of the client name inside the QA_RULES table!
2. The optional name of the category for which rules we want to export.

Note: Leaving the brackets empty is required in case the user wants to export all categories at once.

Example:
```sh
@export_rules_to_file.sql "MT IT-Solutions" ""
```

#### Importing Rules
In order to import rules, SQLcl is required. The user has to either download it and unzip the client or can use any existing installation.
We need to switch into the scripts folder on command line again before connecting to the database. Then we connect via SQLcl and run the import command which is structured as follows:

```sh
script import_file_to_rules.js "[Filename.json]" "[Flag 1/0 - to determine Full Import]"
```
1. First parameter defines the exact Json-Filename that is required
2. Second Paramter defines if the File is only going to be imported into a table qa_import_files or fully migrated into the QA_RULES table

To fully import the Rules choose the Flag 1. Remember that this argument is always required to run the script successfully.
  
Example script call:
```sh
script import_file_to_rules.js "qa_rules_MT_IT_Solutions.json" 1
```

## 4. Installing utPLSQL
### Installing Guidelines and Specifications for the utPLSQL framework

These installation instructions are based on the installation instructions of the software provider: http://utplsql.org/utPLSQL/latest/userguide/install.html.

The following prerequisites and instructions refer to the utPLSQL Framework version 3.1.11. For other versions, the requirements and installation steps may differ.

For the installation of DDL triggers, the user needs to have SYS privileges.

Prerequisites:
- The installation of utPLSQL requires a database version of Oracle 11gR2, 12c, 12c R2, 18c, 19c
- PowerShell 3.0 or above
- .NET 4.0 Framework or above

### Manual Download of utPLSQL

- Windows

The following script must be saved and executed as Power Shell script (.ps1):

```
$archiveName = 'utPLSQL.zip'
$latestRepo = Invoke-WebRequest https://api.github.com/repos/utPLSQL/utPLSQL/releases/latest
$repo = $latestRepo.Content | Convertfrom-Json

$urlList = $repo.assets.browser_download_url

Add-Type -assembly "system.io.compression.filesystem"

foreach ($i in $urlList) {

   $fileName = $i.substring($i.LastIndexOf("/") + 1)

   if ( $fileName.substring($fileName.LastIndexOf(".") + 1) -eq 'zip' ) {
      Invoke-WebRequest $i -OutFile $archiveName
      $fileLocation = Get-ChildItem | where {$_.Name -eq $archiveName}

      if ($fileLocation) {
         [io.compression.zipfile]::ExtractToDirectory($($fileLocation.FullName),$($fileLocation.DirectoryName))   
      }
   }
}
```

- Linux/Unix

```
#!/bin/bash
curl -LOk $(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g') 
unzip -q utPLSQL.zip
```

### Installation of utPLSQL (manual)

There are two ways to install utPLSQL. The headless installation performs all installation steps in one single script. At this point the manual installation is described, because it allows more configuration options during the installation.

#### Creating schema for utPLSQL

It should be considered that the utPLSQL installation is installed separately from the transaction data in a different schema.

For the installation the script create_utplsql_owner.sql in the source directory must be executed with three given parameters:
1. user name owning utPLSQL, e.g. ut3
2. user's password, e.g. ut3
3. tablespace name, e.g. users

Example invocation:
```sh
sqlplus sys/sys_password@database as sysdba @create_utPLSQL_owner.sql ut3 ut3 users
```

##### Necessary Grants for ut3
```sql
CREATE SESSION
CREATE PROCEDURE
CREATE TYPE
CREATE TABLE
CREATE SEQUENCE
CREATE VIEW
CREATE SYNONYM
CREATE PUBLIC SYNONYM
ALTER SESSION
CREATE TRIGGER
CREATE ANY CONTEXT
```


#### Installing utPLSQL

To install the utPLSQL framework the script install.sql in the source directory has to be executed specifying the schema name created previously:

Example invocation:
```sh
sqlplus ut3/ut3@database @install.sql ut3
```

#### Installing utPLSQL DDL Trigger

To minimize startup time of the utPLSQL framework it is recommended to install DDL trigger for utPLSQL to enable utPLSQL annotation to be updated at compile-time. To install the DDL trigger the script install_ddl_trigger.sql in the source directory must be run providing the schema name for utPLSQL:

Example invocation:
```sh
sqlplus ut3/ut3@database @install_ddl_trigger.sql ut3
```

### Allowing other users to access the utPLSQL framework

There are two ways to grant access rights to the utPLSQL framework to other users. It is possible to grant access to all users or only to a certain selection of users.

To grant access to all users, the script create_synonyms_and_grants_for_public.sql in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation:
```sh
sqlplus ut3/ut3@database @create_synonyms_and_grants_for_public.sql ut3  
```

To grant access only to specific users, the create_user_grants.sql and create_user_synonyms.sql scripts in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation for granting and creating synonyms for user hr:
```sh
sqlplus ut3/ut3@database @create_user_grants.sql ut3 hr
sqlplus ut3/ut3@database @create_user_synonyms.sql ut3 hr
```

### Checking environment and utPLSQL version

To check the framework version the following query must be executed:

```sql
select substr(ut.version(),1,60) as ut_version from dual;
```

### Uninstalling utPLSQL

To uninstall the utPLSQL framework, run the script uninstall.sql in the source directory by giving the schema name utPLSQL is installed in.

```sh
sqlplus admin/admins_password@database @uninstall.sql ut3
```

## 5. Upcoming Features

Get ready for an exciting update! We're thrilled to announce that Version 24.1 is on the horizon, bringing a wave of new and anticipated features. Stay tuned as we reveal the incredible enhancements coming your way very soon!

The new features will include a major overhaul of the unit test generation. The APEX app can now be used to export and import the QUASTO rules as well as the test results of the rules in a JUnit compatible XML format. In addition, new unit tests can be generated and deleted via the app UI and every tests can be restarted by the user.

## 6. Latest Releases

### Version 23.2.1
[Release 23.2.1](https://github.com/mt-ag/quasto/releases/tag/v23.2.1)

### Version 1.1
[Release 1.1](https://github.com/mt-ag/quasto/releases/tag/v1.1)

### Version 1.0
[Release 1.0](https://github.com/mt-ag/quasto/releases/tag/v1.0)
