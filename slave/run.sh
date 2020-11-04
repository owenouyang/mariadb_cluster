#!/bin/sh
#echo "CHANGE MASTER TO MASTER_HOST = 'master1', MASTER_USER = 'slave', MASTER_PASSWORD = 'my-secret-pw';start slave;"  > /tmp/test.sql
mysql -uroot -pmy-secret-pw wordpress -e "CHANGE MASTER TO MASTER_HOST = 'master1', MASTER_USER = 'slave', MASTER_PASSWORD = 'my-secret-pw';start slave;"
echo done > /done.log
