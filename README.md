# MariaDB cluster

[blog](https://owenouyang.github.io/blog/2020/11/03/mysql-%E4%B8%BB%E5%BE%9E%E4%BC%BA%E6%9C%8D%E5%99%A8/)
## master/slave

```bash
$ sh -x run.sh
+ docker-compose up -d master1
Creating master1 ... done
+ docker-compose up -d slave1
Creating slave1 ... done
+ docker-compose up -d slave2
Creating slave2 ... done
+ docker cp master/run.sh master1:/run.sh
+ docker cp slave/run.sh slave1:/run.sh
+ docker cp slave/run.sh slave2:/run.sh
+ docker exec master1 /run.sh
+ docker exec slave1 /run.sh
+ docker exec slave2 /run.sh
+ docker exec master1 mysql -uroot -pmy-secret-pw -e 'create table contacts ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));' wordpress
+ docker exec slave1 mysql -uroot -pmy-secret-pw wordpress -e 'show tables \G'
*************************** 1. row ***************************
Tables_in_wordpress: contacts
+ docker exec slave2 mysql -uroot -pmy-secret-pw wordpress -e 'show tables \G;'
*************************** 1. row ***************************
Tables_in_wordpress: contacts
+ docker exec slave1 mysql -uroot -pmy-secret-pw wordpress -e 'show slave status \G;'
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: master1
                   Master_User: slave
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: mysql-bin.000003
           Read_Master_Log_Pos: 975
                Relay_Log_File: slave1-relay-bin.000004
                 Relay_Log_Pos: 1274
         Relay_Master_Log_File: mysql-bin.000003
              Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
               Replicate_Do_DB: 
           Replicate_Ignore_DB: 
            Replicate_Do_Table: 
        Replicate_Ignore_Table: 
       Replicate_Wild_Do_Table: 
   Replicate_Wild_Ignore_Table: 
                    Last_Errno: 0
                    Last_Error: 
                  Skip_Counter: 0
           Exec_Master_Log_Pos: 975
               Relay_Log_Space: 2154
               Until_Condition: None
                Until_Log_File: 
                 Until_Log_Pos: 0
            Master_SSL_Allowed: No
            Master_SSL_CA_File: 
            Master_SSL_CA_Path: 
               Master_SSL_Cert: 
             Master_SSL_Cipher: 
                Master_SSL_Key: 
         Seconds_Behind_Master: 0
 Master_SSL_Verify_Server_Cert: No
                 Last_IO_Errno: 0
                 Last_IO_Error: 
                Last_SQL_Errno: 0
                Last_SQL_Error: 
   Replicate_Ignore_Server_Ids: 
              Master_Server_Id: 1
                Master_SSL_Crl: 
            Master_SSL_Crlpath: 
                    Using_Gtid: No
                   Gtid_IO_Pos: 
       Replicate_Do_Domain_Ids: 
   Replicate_Ignore_Domain_Ids: 
                 Parallel_Mode: conservative
                     SQL_Delay: 0
           SQL_Remaining_Delay: NULL
       Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
              Slave_DDL_Groups: 4
Slave_Non_Transactional_Groups: 0
    Slave_Transactional_Groups: 0
+ docker exec slave2 mysql -uroot -pmy-secret-pw wordpress -e 'show slave status \G;'
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: master1
                   Master_User: slave
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: mysql-bin.000003
           Read_Master_Log_Pos: 975
                Relay_Log_File: slave2-relay-bin.000004
                 Relay_Log_Pos: 1274
         Relay_Master_Log_File: mysql-bin.000003
              Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
               Replicate_Do_DB: 
           Replicate_Ignore_DB: 
            Replicate_Do_Table: 
        Replicate_Ignore_Table: 
       Replicate_Wild_Do_Table: 
   Replicate_Wild_Ignore_Table: 
                    Last_Errno: 0
                    Last_Error: 
                  Skip_Counter: 0
           Exec_Master_Log_Pos: 975
               Relay_Log_Space: 2154
               Until_Condition: None
                Until_Log_File: 
                 Until_Log_Pos: 0
            Master_SSL_Allowed: No
            Master_SSL_CA_File: 
            Master_SSL_CA_Path: 
               Master_SSL_Cert: 
             Master_SSL_Cipher: 
                Master_SSL_Key: 
         Seconds_Behind_Master: 0
 Master_SSL_Verify_Server_Cert: No
                 Last_IO_Errno: 0
                 Last_IO_Error: 
                Last_SQL_Errno: 0
                Last_SQL_Error: 
   Replicate_Ignore_Server_Ids: 
              Master_Server_Id: 1
                Master_SSL_Crl: 
            Master_SSL_Crlpath: 
                    Using_Gtid: No
                   Gtid_IO_Pos: 
       Replicate_Do_Domain_Ids: 
   Replicate_Ignore_Domain_Ids: 
                 Parallel_Mode: conservative
                     SQL_Delay: 0
           SQL_Remaining_Delay: NULL
       Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
              Slave_DDL_Groups: 4
Slave_Non_Transactional_Groups: 0
    Slave_Transactional_Groups: 0
/db # cat run.sh 
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
```

## master/master

```bash
 $ sh -x run2m.sh 
+ echo start containers
start containers
+ docker-compose up -d masterm1
Creating masterm1 ... done
+ docker-compose up -d masterm2
Creating masterm2 ... done
+ echo grant privileges
grant privileges
+ sleep 8
+ sql='grant replication slave on *.* to '"'"'slave'"'"'@'"'"'%'"'"' identified by'"'"'my-secret-pw'"'"'; flush privileges;'
+ docker exec masterm1 mysql -uroot -pmy-secret-pw -e 'grant replication slave on *.* to '"'"'slave'"'"'@'"'"'%'"'"' identified by'"'"'my-secret-pw'"'"'; flush privileges;' wordpress
+ docker exec masterm2 mysql -uroot -pmy-secret-pw -e 'grant replication slave on *.* to '"'"'slave'"'"'@'"'"'%'"'"' identified by'"'"'my-secret-pw'"'"'; flush privileges;' wordpress
+ echo connect master1 from and to master2
connect master1 from and to master2
+ sql='CHANGE MASTER TO MASTER_HOST = '"'"'masterm2'"'"', MASTER_USER = '"'"'slave'"'"', MASTER_PASSWORD = '"'"'my-secret-pw'"'"';start slave;'
+ docker exec masterm1 mysql -uroot -pmy-secret-pw -e 'CHANGE MASTER TO MASTER_HOST = '"'"'masterm2'"'"', MASTER_USER = '"'"'slave'"'"', MASTER_PASSWORD = '"'"'my-secret-pw'"'"';start slave;' wordpress
+ sql='CHANGE MASTER TO MASTER_HOST = '"'"'masterm1'"'"', MASTER_USER = '"'"'slave'"'"', MASTER_PASSWORD = '"'"'my-secret-pw'"'"';start slave;'
+ docker exec masterm2 mysql -uroot -pmy-secret-pw -e 'CHANGE MASTER TO MASTER_HOST = '"'"'masterm1'"'"', MASTER_USER = '"'"'slave'"'"', MASTER_PASSWORD = '"'"'my-secret-pw'"'"';start slave;' wordpress
+ echo view slave status
view slave status
+ docker exec masterm1 mysql -uroot -pmy-secret-pw wordpress -e 'show slave status \G;'
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: masterm2
                   Master_User: slave
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: mysql-bin.000003
           Read_Master_Log_Pos: 675
                Relay_Log_File: masterm1-relay-bin.000004
                 Relay_Log_Pos: 974
         Relay_Master_Log_File: mysql-bin.000003
              Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
               Replicate_Do_DB: 
           Replicate_Ignore_DB: 
            Replicate_Do_Table: 
        Replicate_Ignore_Table: 
       Replicate_Wild_Do_Table: 
   Replicate_Wild_Ignore_Table: 
                    Last_Errno: 0
                    Last_Error: 
                  Skip_Counter: 0
           Exec_Master_Log_Pos: 675
               Relay_Log_Space: 2009
               Until_Condition: None
                Until_Log_File: 
                 Until_Log_Pos: 0
            Master_SSL_Allowed: No
            Master_SSL_CA_File: 
            Master_SSL_CA_Path: 
               Master_SSL_Cert: 
             Master_SSL_Cipher: 
                Master_SSL_Key: 
         Seconds_Behind_Master: 0
 Master_SSL_Verify_Server_Cert: No
                 Last_IO_Errno: 0
                 Last_IO_Error: 
                Last_SQL_Errno: 0
                Last_SQL_Error: 
   Replicate_Ignore_Server_Ids: 
              Master_Server_Id: 3332
                Master_SSL_Crl: 
            Master_SSL_Crlpath: 
                    Using_Gtid: No
                   Gtid_IO_Pos: 
       Replicate_Do_Domain_Ids: 
   Replicate_Ignore_Domain_Ids: 
                 Parallel_Mode: conservative
                     SQL_Delay: 0
           SQL_Remaining_Delay: NULL
       Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
              Slave_DDL_Groups: 6
Slave_Non_Transactional_Groups: 0
    Slave_Transactional_Groups: 0
+ docker exec masterm2 mysql -uroot -pmy-secret-pw wordpress -e 'show slave status \G;'
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: masterm1
                   Master_User: slave
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: mysql-bin.000003
           Read_Master_Log_Pos: 675
                Relay_Log_File: masterm2-relay-bin.000004
                 Relay_Log_Pos: 974
         Relay_Master_Log_File: mysql-bin.000003
              Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
               Replicate_Do_DB: 
           Replicate_Ignore_DB: 
            Replicate_Do_Table: 
        Replicate_Ignore_Table: 
       Replicate_Wild_Do_Table: 
   Replicate_Wild_Ignore_Table: 
                    Last_Errno: 0
                    Last_Error: 
                  Skip_Counter: 0
           Exec_Master_Log_Pos: 675
               Relay_Log_Space: 2009
               Until_Condition: None
                Until_Log_File: 
                 Until_Log_Pos: 0
            Master_SSL_Allowed: No
            Master_SSL_CA_File: 
            Master_SSL_CA_Path: 
               Master_SSL_Cert: 
             Master_SSL_Cipher: 
                Master_SSL_Key: 
         Seconds_Behind_Master: 0
 Master_SSL_Verify_Server_Cert: No
                 Last_IO_Errno: 0
                 Last_IO_Error: 
                Last_SQL_Errno: 0
                Last_SQL_Error: 
   Replicate_Ignore_Server_Ids: 
              Master_Server_Id: 3331
                Master_SSL_Crl: 
            Master_SSL_Crlpath: 
                    Using_Gtid: No
                   Gtid_IO_Pos: 
       Replicate_Do_Domain_Ids: 
   Replicate_Ignore_Domain_Ids: 
                 Parallel_Mode: conservative
                     SQL_Delay: 0
           SQL_Remaining_Delay: NULL
       Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
              Slave_DDL_Groups: 6
Slave_Non_Transactional_Groups: 0
    Slave_Transactional_Groups: 0
+ echo verify
verify
+ sql='create table contacts1 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));'
+ docker exec masterm1 mysql -uroot -pmy-secret-pw -e 'create table contacts1 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));' wordpress
+ sql='create table contacts2 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));'
+ docker exec masterm2 mysql -uroot -pmy-secret-pw -e 'create table contacts2 ( contact_id INT(11) not null auto_increment,last_name varchar(30) not null, first_name varchar(25), birthday date, constraint contacts_pk primary key (contact_id));' wordpress
+ sleep 8
+ docker exec masterm1 mysql -uroot -pmy-secret-pw wordpress -e 'show tables \G'
*************************** 1. row ***************************
Tables_in_wordpress: contacts1
*************************** 2. row ***************************
Tables_in_wordpress: contacts2
+ docker exec masterm2 mysql -uroot -pmy-secret-pw wordpress -e 'show tables \G;'
*************************** 1. row ***************************
Tables_in_wordpress: contacts1
*************************** 2. row ***************************
Tables_in_wordpress: contacts2
```
