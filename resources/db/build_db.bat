@echo off


set db_server=
set db_name=
set abm_db_name=
rem db_path and log_path values must be enclosed in double quotes
set db_path=
set log_path=

echo Creating %db_name% on %db_server% at %db_path%
echo Log file at %log_path%
sqlcmd -E -C -b -S %db_server% -i create_db.sql -v db_path=%db_path% log_path=%log_path%

echo Adding metadata schema
sqlcmd -E -C -b -S %db_server% -d %db_name% -i db_meta.sql

echo Adding ABM database synonyms
sqlcmd -E -C -b -S %db_server% -d %db_name% -i synonyms.sql -v abm_db_name=%abm_db_name%


echo Finished creating %db_name% on %db_server%
