# Quasto - Quality Assurance Tool
[1. What is Quasto?](https://github.com/mt-ag/quasto#1-what-is-quasto)<br>
[2. Installing Quasto](https://github.com/mt-ag/quasto#2-installing-quasto)<br>
[3. Using Quasto](https://github.com/mt-ag/quasto#3using-quasto)<br>
[4. Installing utPLSQL](https://github.com/mt-ag/quasto/blob/dev/README.md#4-installing-guidelines-and-specifications-for-the-utplsql-framework)

## 1. What is Quasto?
A project for checking guidelines and code quality for inside the oracle database.
The first version supports checks for your data model, PL/SQL code and data itself.
Coming up releases will integrate utPLSQL and get an APEX Front-End.
CI/CD support for jenkins/azure devops or gitlab/github are planned on the roadmap.

Project uses the MIT License.

## 2. Installing Quasto
### Installing utPLSQL and QUASTO objects

To install the QUASTO Quality Assurance Tool on your oracle database from scratch, run the install.sql file in the root directory of the repository.

This file will install all necessary objects for utPLSQL tests and QUASTO.

## Installing Guidelines for the QUASTO Quality Assurance Tool 
It is possible to run QUASTO standalone without a valid apex or utPLSQL Installation.
In order to install the tool the user needs to move into the root directory of the downloaded folder. 
You can either clone the repository on git itself or download a zip.file.

To start the Installation process you need to move into the root directory of the downloaded folder.
In the next step the user connects to the database via sqlplus or sqlCL.
To ensure all tables and packages are installed into the right schema make sure to check the current user and switch schema if required.

In order to use quasto in other schemas a public synonym is required on the type "qa_rule_t".
The user has to create this outside of the regular Quasto installation.
Note: To drop a public synonym the user needs the drop any synonym grant!

### Minimal user rights
If you install quasto in a blank new scheme the user needs the following rights:
```
grant create procedure to quasto;
grant create public synonym to quasto;
grant create sequence to quasto;
grant create table to quasto;
grant create trigger to quasto;
grant create type to quasto;
grant create view to quasto;
grant create job to quasto;

grant create session to quasto;
```

#### Running the Install Script:
```
@install [1/0] [1/0] [1/0] [1/0]
```

To ensure a clean installation it is important to decide what you want to install.
It is not mandatory to install APEX or utPLSQL. But if you have one or both of these, you get more features for your quality approach.

Arguments that are required to be passed to the script:
1. Do you want to install supporting objects for utPLSQL usage? 1=yes / 0=no (you need to install utPLSQL seperatly)
2. Do you want to install supporting objects for APEX usage? 1=yes / 0=no (you need to install APEX seperatly)
3. Do you want to install supporting objects for Jenkins usage? 1=yes / 0=no (you need to run Jenkins seperatly)
4. Do you have the offical oracle logger framework installed? 1=yes / 0=no (required for conditional compilation of a package)

It is possible to install utPLSQL, APEX or Jenkins objects later
To do this the user needs to move from the root Directory of the project into the /src directory.
There are the three installer scripts:
1. install_utplsql_objects.sql
2. install_apex_objects.sql
3. install_jenkins_objects.sql
All of these scripts can be run without arguments and should be executed in the same schema as the original schema of Quasto.

Example:
```
@install_utplsql_objects.sql 1 1 0 0
```

### Uninstalling utPLSQL and QUASTO objects

To uninstall the utPLSQL test and QUASTO objects, run the script uninstall.sql in the root directory of the repository.

## 3.Using Quasto
### Define a rule
For using quasto you have to define rules based on SQL queries which have to be saved inside the QA_RULES table.
The query for every rule should name every object which does not match you quality standards.
A first example could be, that every table needs to have a primary key.
Here is an example for this rule:
```
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
                ,pi_scheme_name         => p-scheme
                ,pi_object_id           => ao.object_id
                ,pi_object_name         => ao.object_name
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
### Running rules
After you defined one or more rules, you can run these rules. The easiest way is to call them in your SQL tool.
The QA_API_PKG is the Package to run your rules. 
You can run a single rule, or a complete rulesset for one project only with a single SQL query.
For running one rule you need the rule number, the client name and the target schema
```
select *
from qa_api_pkg.tf_run_rule(pi_qaru_rule_number => '23.1'
                           ,pi_qaru_client_name => 'MT AG'
                           ,pi_target_scheme    => 'QUASTO')
```
In this example the rule 23.1 from the client/project MT AG is used inside the schema Quasto. If you don't provide a schema, all Schemas are used which are able to reach. The sql output gives now every object in a row which is not matching your rule.
If you wanna run all rules from one client/project simply call
```
select *
from qa_api_pkg.tf_run_rules(pi_qaru_client_name => 'MT AG'
                            ,pi_target_scheme    => 'QUASTO')
```

### Exclude objects in rules
Sometimes a rule is valid for all objects except one. For this object it is possible to exclude the run. In the Table QA_RULES there exists the column QARU_EXCLUDE_OBJECTS. In this column you can add all objects you want to exclude from this rule.
If you want to enter more than one object, you have to separate them with a ':'. Example: OBJECT_ONE:OBJECT_TO
When you test a rule, the specified Objects will not run for this test and therefore will not give any feedback of the test run. The adding or deleting in the QARU_EXCLUDE_OBJECTS column will have impact in the next run immediatly.


### Defining a test-run-order
With the Column QARU_PREDECESSOR_IDS in the table QA_RULES it is possible to give an order to the test run. In this Column You can define which rules have to run successful before another rule can start.
Therefore You have to add the rule names separated with a ':'. You can add one or more rules. Example: 12.3:4:1
Be careful, that there is no recursive connection between the rules. Otherwise an Exception is raised an the run is stopped immediatly.
If You have defined predecessors, the rules will be ordered first and the will be run in the predefined order.
If one or more predecessors of one rule failed, the rule will not run. You have to fix the errors first. Even if all predecessors of a rule run successfully this rule will also run.

With this option you have the ability to controll, which rule will run under which circumstance. It can also protect you to get a big log of failures. For example There could be a rule to check if apex exists.
All rules that belongs to an apex scheme have this rule as predecessor. So if this first rule fails, no other apex rules will run.

## 4. Installing Guidelines and Specifications for the utPLSQL framework

These installation instructions are based on the installation instructions of the software provider: http://utplsql.org/utPLSQL/latest/userguide/install.html

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
```
sqlplus sys/sys_password@database as sysdba @create_utPLSQL_owner.sql ut3 ut3 users
```

##### Necessary Grants for ut3

- CREATE SESSION
- CREATE PROCEDURE
- CREATE TYPE
- CREATE TABLE
- CREATE SEQUENCE
- CREATE VIEW
- CREATE SYNONYM / PUBLIC SYNONYM
- ALTER SESSION
- CREATE TRIGGER
- CREATE ANY CONTEXT


#### Installing utPLSQL

To install the utPLSQL framework the script install.sql in the source directory has to be executed specifying the schema name created previously:

Example invocation:
```
sqlplus ut3/ut3@database @install.sql ut3
```

#### Installing utPLSQL DDL Trigger

To minimize startup time of the utPLSQL framework it is recommended to install DDL trigger for utPLSQL to enable utPLSQL annotation to be updated at compile-time. To install the DDL trigger the script install_ddl_trigger.sql in the source directory must be run providing the schema name for utPLSQL:

Example invocation:
```
sqlplus ut3/ut3@database @install_ddl_trigger.sql ut3
```

### Allowing other users to access the utPLSQL framework

There are two ways to grant access rights to the utPLSQL framework to other users. It is possible to grant access to all users or only to a certain selection of users.

To grant access to all users, the script create_synonyms_and_grants_for_public.sql in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation:
```
sqlplus ut3/ut3@database @create_synonyms_and_grants_for_public.sql ut3  
```

To grant access only to specific users, the create_user_grants.sql and create_user_synonyms.sql scripts in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation for granting and creating synonyms for user hr:
```
sqlplus ut3/ut3@database @create_user_grants.sql ut3 hr
sqlplus ut3/ut3@database @create_user_synonyms.sql ut3 hr
```

### Checking environment and utPLSQL version

To check the framework version the following query must be executed:

```
select substr(ut.version(),1,60) as ut_version from dual;
```

### Export- and Import-Rules

## Exporting Rules:

In order to export a JSON-File of the currently exisiting rules of the qa_rules table we need to connect to the database via SQL-Plus inside the Installation folder.
For example open up cmd. And change with cd into the folder where your Quasto is located. It is required to be in the oracle-qa-tool\src\scripts Folder.
Afterwards you connect to the DB via SQL-Plus and run the following command:

```
@export_rules_to_file.sql "[Client Name]" "[Category (optional)]"
```
Here we use two paramters.
1. The name of the Client we want to export the rules. This name needs to be the exact entry of the Client Name inside the qa_rules table!
2. The optional name of the Category for which rules we want to export.
Note: Leaving the brackets empty is required in case the user wants to export all categories at once.

Example:
```
@export_rules_to_file.sql "MT IT-Solutions" ""
```

## Importing Rules:
In order to import Rules SQL CL is required. The user has to either download it and unzip the client or can use any existing installation.
We need to switch into the scripts folder in cmd again before connecting to the Database. Then we connect via SQL CL and issue the import command
which is build as follows:


```
script import_file_to_rules.js "[Filename.json]" "[Flag 1/0 - to determine Full Import]"
```
1. First parameter defines the exact Json-Filename that is required
2. Second Paramter defines if the File is only going to be imported into a table qa_import_files or fully migrated into the qa_rules table
   To fully import the Rules choose the Flag 1. Remember that this parameter is always required to run the Script successfully
  
Example Script-Call:
```
script import_file_to_rules.js "qa_rules_MT_IT_Solutions.json" 1
```

### Uninstalling utPLSQL

To uninstall the utPLSQL framework, run the script uninstall.sql in the source directory by giving the schema name utPLSQL is installed in.

```
sqlplus admin/admins_password@database @uninstall.sql ut3
```

### Upcoming Features of our new Version 23.2
1. ## Schema and Object Blacklisting:
   We are implementing a schema and object based blacklisting.

3. ## Exclusion of objects which are not owned by a the testing schema
   To avoid testing objects that are granted access by public synonyms or belong to other schemas, we are introducing a mechanism to exclude such objects from unit testing. This further refines your testing processes.

3. ## New table for Unit Test Results
   In order to store unit test results, we are implementing a table to hold this data to be further analzyed and processed.

5. ## Improved Unit Test Package Generation
   The create_ut_test_packages_pkg will be renamed to QA_UNIT_TESTS_PKG, and it will offer the option to create unit test packages per rule or as a single package containing all active rules. Additionally, we want to enhanced the naming convention, including the schema in the package names for more straightforward multiple schema management.

5. ## new Data type for holding additional information such as invalid schema objects

6. ## Oracle Apex Application
   One major component of the next update will be an apex application to add new rules or configure existing ones and run them.
   We will also introduce the support for apex based rules to check the integrety of apex objects.

8. ## automated daily Unit Testing
   We are planning to implement a new scheduler Job which runs all the activated Rules on a daily basis.

8. ## Installation Process will be adapted to be able to upgrade from any released version to the latest one

9. ## Version Naming has been changed to standard Oracle Format
   The new Format for our upcoming and later releases will be changed to the standard that oracle uses for their relases as well.
   The first part is always the year of release and the second part will be in our case the incremental number of an increnmental release cycle during the year.
   In Our Case we already released a Version this year so we are jumping to the Version #23.2


Beware that these features may be subject to change in the final release.
The final release Notes will be released with the upcoming Version 23.2

### Lates Releases
## Version 1.1
[Release 1.1](https://github.com/mt-ag/quasto/releases/tag/v1.1)

## Version 1.0
[Release 1.0](https://github.com/mt-ag/quasto/releases/tag/v1.0)


