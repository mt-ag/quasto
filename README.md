# QUASTO Quality Assurance Tool
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

grant create session to quasto;
```

#### Running the Install Script:
```
@install [1/0] [1/0] [1/0]
```

To ensure a clean installation it is important to decide what you want to install.
It is not mandatory to install APEX or utPLSQL. But if you have one or both of these, you get more features for your quality approach.

Arguments that are required to be passed to the script:
1. Do you want to install supporting objects for utPLSQL usage? 1=yes / 0=no (you need to install utPLSQL seperatly)
2. Do you want to install supporting objects for APEX usage? 1=yes / 0=no (you need to install APEX seperatly)
3. Do you want to install supporting objects for Jenkins usage? 1=yes / 0=no (you need to run Jenkins seperatly)

It is possible to install utPLSQL, APEX or Jenkins objects later
To do this the user needs to move from the root Directory of the project into the /src directory.
There are the two installer scripts:
1. install_utplsql_objects.sql
2. install_apex_objects.sql
3. install_jenkins_objects.sql
All of these scripts can be run without arguments and should be executed in the same schema as the original schema of Quasto.

Example:
```
@install_utplsql_objects.sql
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
sqlplus admin/admins_password@database @install.sql ut3
```

#### Installing utPLSQL DDL Trigger

To minimize startup time of the utPLSQL framework it is recommended to install DDL trigger for utPLSQL to enable utPLSQL annotation to be updated at compile-time. To install the DDL trigger the script install_ddl_trigger.sql in the source directory must be run providing the schema name for utPLSQL:

Example invocation:
```
sqlplus admin/admins_password@database @install_ddl_trigger.sql ut3
```

### Allowing other users to access the utPLSQL framework

There are two ways to grant access rights to the utPLSQL framework to other users. It is possible to grant access to all users or only to a certain selection of users.

To grant access to all users, the script create_synonyms_and_grants_for_public.sql in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation:
```
sqlplus admin/admins_password@database @create_synonyms_and_grants_for_public.sql ut3  
```

To grant access only to specific users, the create_user_grants.sql and create_user_synonyms.sql scripts in the source directory must be run to create grants and synonyms for the utPLSQL schema.

Example invocation for granting and creating synonyms for user hr:
```
sqlplus ut3_user/ut3_password@database @create_user_grants.sql ut3 hr
sqlplus user/user_password@database @create_user_synonyms.sql ut3 hr
```

### Checking environment and utPLSQL version

To check the framework version the following query must be executed:

```
select substr(ut.version(),1,60) as ut_version from dual;
```

### Uninstalling utPLSQL

To uninstall the utPLSQL framework, run the script uninstall.sql in the source directory by giving the schema name utPLSQL is installed in.

```
sqlplus admin/admins_password@database @uninstall.sql ut3
```

