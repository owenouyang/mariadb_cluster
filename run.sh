docker-compose up -d master1 
docker-compose up -d slave1
docker-compose up -d slave2

docker cp master/run.sh master1:/run.sh
docker cp slave/run.sh slave1:/run.sh
docker cp slave/run.sh slave2:/run.sh

docker exec master1 /run.sh
docker exec slave1 /run.sh
docker exec slave2 /run.sh


docker exec master1 mysql -uroot -pmy-secret-pw -e "create table contacts ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));" wordpress
docker exec slave1 mysql -uroot -pmy-secret-pw wordpress -e "show tables \G"
docker exec slave2 mysql -uroot -pmy-secret-pw wordpress -e "show tables \G;"
docker exec slave1 mysql -uroot -pmy-secret-pw wordpress -e "show slave status \G;"
docker exec slave2 mysql -uroot -pmy-secret-pw wordpress -e "show slave status \G;"

