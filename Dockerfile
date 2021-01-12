
# base image
FROM debian

# user info
LABEL maintainer="yonishi@student.42tokyo.jp"

############################################################
# for docker build
#RUN add-apt-repository ppa:nijel/phpmyadmin && \
RUN echo "########## General: Starting installation... ##########"
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes
RUN \
	apt-get update && apt-get upgrade -y && apt-get install -y \
	man \
	vim \
	wget \
	&& apt-get clean

# nginx
RUN echo "########## nginx: Starting installation... ##########"
RUN apt-get install -y nginx php-fpm && apt-get clean
RUN cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
COPY srcs/nginx.conf /etc/nginx/
COPY srcs/nginx.default /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default \
	&& ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
RUN mkdir /etc/nginx/cert
COPY srcs/cert/* /etc/nginx/cert/
COPY srcs/index2.html /var/www/html
RUN mkdir /var/www/html/noindexdir && echo a > /var/www/html/noindexdir/a.txt
#EXPOSE 80

# MySQL
RUN echo "########## MySQL: Starting installation... ##########"
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	lsb-release \
	gnupg \
	&& apt-get clean
ADD https://repo.mysql.com/mysql-apt-config_0.8.16-1_all.deb /
#RUN export DEBIAN_FRONTEND=noninteractive; dpkg -i /mysql-apt-config_0.8.16-1_all.deb
RUN dpkg -i /mysql-apt-config_0.8.16-1_all.deb \
	&& rm mysql-apt-config_0.8.16-1_all.deb
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	libaio1 \
	mysql-server \
	&& apt-get clean

# phpMyAdmin
RUN echo "########## phpMyAdmin: Starting installation... ##########"
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	php-mbstring \
	php-zip \
	php-gd \
	php-mysql \
	&& apt-get clean
ADD https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz /
RUN tar zxf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages/ /usr/share/phpmyadmin \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz
RUN mkdir -p /var/lib/phpmyadmin/tmp
RUN chown -R www-data:www-data /var/lib/phpmyadmin
#RUN sed -e "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = 'mamgpuemrimodiemwialgnmfanguieng';/" \
#	/usr/share/phpmyadmin/config.sample.inc.php > /usr/share/phpmyadmin/config.inc.php 
COPY srcs/phpmyadmin.config.inc.php /usr/share/phpmyadmin/config.inc.php
COPY srcs/phpmyadmin.create_users.sql /usr/share/phpmyadmin/sql/create_users.sql
RUN chmod -R 744 /usr/share/phpmyadmin/*.php

# WordPress
RUN echo "########## WordPress: Starting installation... ##########"
COPY srcs/wordpress-5.6-ja.tar.gz /
RUN tar zxf wordpress-5.6-ja.tar.gz \
	&& mv wordpress/ /var/www/html/wp \
	&& rm wordpress-5.6-ja.tar.gz
RUN chmod -R 777 /var/www/html/wp

# startup script
RUN echo "########## startup script: Starting installation... ##########"
COPY srcs/startup.sh /startup.sh
RUN chmod 744 /startup.sh
RUN echo "########## All build process has Done! ##########"

############################################################
# for docker run
CMD /startup.sh; /bin/bash
