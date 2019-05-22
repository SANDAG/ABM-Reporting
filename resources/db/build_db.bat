@echo off


set db_server=${database_server}
set db_name=${database_name}
rem db_path and log_path values must be enclosed in double quotes
set db_path=
set log_path=


cd ../sql/db


echo Creating %db_name% on %db_server% at %db_path%
echo Log file at %log_path%
sqlcmd -E -C -b -S %db_server% -i create_db.sql -v db_path=%db_path% log_path=%log_path%
