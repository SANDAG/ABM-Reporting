@echo off


set db_server=${database_server}
set db_name=${database_name}
rem db_path and log_path values must be enclosed in double quotes
set db_path=
set log_path=

rem assumes running from project directory
cd sql/db

echo Creating %db_name% on %db_server% at %db_path%
echo Log file at %log_path%
sqlcmd -E -C -b -S %db_server% -i create_db.sql -v db_path=%db_path% log_path=%log_path%

echo Adding metadata schema
sqlcmd -E -C -b -S %db_server% -d %db_name% -i db_meta.sql

echo Adding ABM database synonyms
sqlcmd -E -C -b -S %db_server% -d %db_name% -i synonyms.sql

rem move back to project directory
cd ..
cd ..

echo Finished creating %db_name% on %db_server%
