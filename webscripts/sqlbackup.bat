@echo off
echo Running dump...
E:\wamp\bin\mysql\mysql5.6.12\bin\mysqldump -u root -pzaq123ZAQ!@# appmanage --result-file="e:\sqlbackup\backup.%DATE:~0,3%.sql" 
echo Done!