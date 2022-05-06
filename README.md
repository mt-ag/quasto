# oracle-qa-tool
a project for checking guidelines and code quality for oracle databases.

Project uses the MIT License.

## Installing Guidelines and Specifications

These installation instructions are based on the installation instructions of the software provider: http://utplsql.org/utPLSQL/latest/userguide/install.html

Prerequisites:
- The installation of utPLSQL requires a database version of Oracle 11gR2, 12c, 12c R2, 18c, 19c, 20c, 21c or above
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

## Checking environment and utPLSQL version

To check the framework version the following query must be executed:

```
select substr(ut.version(),1,60) as ut_version from dual;
```

## Uninstalling utPLSQL

To uninstall the utPLSQL framework, run the script uninstall.sql in the source directory by giving the schema name utPLSQL is installed in.

```
sqlplus admin/admins_password@database @uninstall.sql ut3
```