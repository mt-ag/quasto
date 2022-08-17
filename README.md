# QUASTO Quality Assurance Tool
A project for checking guidelines and code quality for oracle databases.

Project uses the MIT License.

### Installing utPLSQL and QUASTO objects

To install the QUASTO Quality Assurance Tool on your oracle database from scratch, run the install.sql file in the root directory of the repository.

This file will install all necessary objects for utPLSQL tests and QUASTO.

## Installing Guidelines for the QUASTO Quality Assurance Tool 
It is possible to run QUASTO standalone without a valid apex and ut-plsql Installation.
In order to install the toll the user needs to move into the root directory of the downloaded folder. 
You can either clone the repository on git itself or download a zip.file of the Project.

To start the Installation process you need to movee into the root directory of the downloaded folder.
In the next step the user connects to the database via sqlplus or sql cl.
To ensure all tables and packages are installed into the correct schema make sure to check the current user and switch schema if required.

#### Running the Install Script:
```
@install [1/0] [1/0] [1/0]
```

To ensure a clean installation it is important to decide what you want to install.
It is not mandatory to install apex or ut_plsql. To avoid invalid objects tohugh it is recommend to skip the installation of ut_plsql or apex dependet objects.

Arguments that are required to be passed to the script:
1. Is ut_plsql already installed? If not use 0 else 1.
2. Is apex already installed? If not use 0 else 1.
3. Do you want to install objects support more jenkins features? if not use 0 else 1.

It is possible to install the ut_plsql and apex dependet objects at a later point in time.
To do this the user needs to move from the root Directory of the project into the /src directory.
There are the two installer scripts:
1. install_utplsql_objects.sql
2. install_apex_objects.sql
Both of these scripts can be run wtihout arguments and should be executed in the same shema as the original schema of Quasto.

Example:
```
@nstall_utplsql_objects.sql
```


### Uninstalling utPLSQL and QUASTO objects

To uninstall the utPLSQL test and QUASTO objects, run the script uninstall.sql in the root directory of the repository.


## Installing Guidelines and Specifications for the utPLSQL framework

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
