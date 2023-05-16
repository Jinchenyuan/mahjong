mysql -uroot -p123456 -h127.0.0.1 -e "DROP DATABASE IF EXISTS logind;"
mysql -uroot -p123456 -h127.0.0.1 -e "CREATE DATABASE logind DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -uroot -p123456 -h127.0.0.1 -D logind < ./create_db.sql

pause