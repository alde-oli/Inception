FROM debian:buster

RUN apt update -y && apt upgrade -y && \
	apt-get install -y wget

RUN apt-get -y install php7.3 php-fpm php-mysql mariadb-client

RUN	mkdir -p /var/www/wordpress /run/php
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY tools/init-wp.sh /usr/local/init-wp.sh
RUN chmod +x /usr/local/init-wp.sh

ENTRYPOINT ["sh", "/usr/local/init-wp.sh"]
