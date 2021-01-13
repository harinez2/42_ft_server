#!/bin/bash

#nginx autoindex
echo "Specified AUTOINDEX value: $AUTOINDEX"
if [ ! "$AUTOINDEX" = "on" ] && [ ! "$AUTOINDEX" = "off" ]; then AUTOINDEX=on; fi
echo "AUTOINDEX value works as: $AUTOINDEX"
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default2
sed -e "s/__AUTOINDEX__/$AUTOINDEX/" /etc/nginx/sites-available/default2 > /etc/nginx/sites-available/default
rm /etc/nginx/sites-available/default2

#mysql
mysqld_safe --user=mysql &

#phpmyadmin, wordpress
for i in `seq 1 10`
do
  RET=`mysqladmin ping -s`
  if [ "$RET" = "mysqld is alive" ]; then
    mysql < /usr/share/phpmyadmin/sql/create_tables.sql
    mysql < /usr/share/phpmyadmin/sql/create_users.sql
    mysql -e "CREATE DATABASE wordpress;"
    mysql -e "CREATE USER 'wp'@'localhost' IDENTIFIED BY 'wppass';"
    mysql -e "ALTER USER 'wp'@'localhost' IDENTIFIED WITH mysql_native_password by 'wppass';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'wp'@'localhost';"
    break;
  elif [ $i = 10 ]; then
    echo "Error: It takes some time to start mysql service. Confirm the service status and run phpMyAdmin's initial sqls."
    break;
  fi
  echo "$i : waiting for starting mysql service..."
  sleep 2;
done

#nginx
service php7.3-fpm start
service nginx start
