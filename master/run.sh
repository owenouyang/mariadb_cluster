#!/bin/sh
sleep 10
#echo "grant replication slave on *.* to 'slave'@'%' identified by'my-secret-pw'; flush privileges;" > /tmp/test.sql
mysql -uroot -pmy-secret-pw wordpress -e "grant replication slave on *.* to 'slave'@'%' identified by'my-secret-pw'; flush privileges;" 
echo done > /done.log
