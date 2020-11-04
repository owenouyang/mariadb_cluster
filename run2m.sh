
echo start containers
docker-compose up -d masterm1 
docker-compose up -d masterm2

echo grant privileges
sleep 8
sql="grant replication slave on *.* to 'slave'@'%' identified by'my-secret-pw'; flush privileges;"
docker exec masterm1 mysql -uroot -pmy-secret-pw -e "$sql" wordpress
docker exec masterm2 mysql -uroot -pmy-secret-pw -e "$sql" wordpress

echo connect master1 from and to master2
sql="CHANGE MASTER TO MASTER_HOST = 'masterm2', MASTER_USER = 'slave', MASTER_PASSWORD = 'my-secret-pw';start slave;"
docker exec masterm1 mysql -uroot -pmy-secret-pw -e "$sql" wordpress
sql="CHANGE MASTER TO MASTER_HOST = 'masterm1', MASTER_USER = 'slave', MASTER_PASSWORD = 'my-secret-pw';start slave;"
docker exec masterm2 mysql -uroot -pmy-secret-pw -e "$sql" wordpress

echo view slave status
docker exec masterm1 mysql -uroot -pmy-secret-pw wordpress -e "show slave status \G;"
docker exec masterm2 mysql -uroot -pmy-secret-pw wordpress -e "show slave status \G;"

echo verify
sql="create table contacts1 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));"
docker exec masterm1 mysql -uroot -pmy-secret-pw -e "$sql" wordpress
sql="create table contacts2 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));"
docker exec masterm2 mysql -uroot -pmy-secret-pw -e "$sql" wordpress

sleep 8
docker exec masterm1 mysql -uroot -pmy-secret-pw wordpress -e "show tables \G"
docker exec masterm2 mysql -uroot -pmy-secret-pw wordpress -e "show tables \G;"
