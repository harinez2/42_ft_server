if [ ! -v AUTOINDEX ]; then AUTOINDEX=on; fi
echo "AUTOINDEX setting: $AUTOINDEX"
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default2
sed -e "s/__AUTOINDEX__/$AUTOINDEX/" /etc/nginx/sites-available/default2 > /etc/nginx/sites-available/default
rm /etc/nginx/sites-available/default2

service php7.3-fpm start
service nginx start
mysqld_safe --user=mysql &
