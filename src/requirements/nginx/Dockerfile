FROM debian:buster

RUN apt-get update -y  && apt upgrade -y && \
	apt-get install -y nginx

RUN mkdir -p /etc/nginx/ssl
RUN apt install -y openssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=SW/ST=VS/L=Lausane/O=42/OU=42/CN=alde-oli.42.fr/emailAddress=alde-oli@student.42.fr"

RUN mkdir -p /var/run/nginx /var/www/wordpress && \
	chmod -R 755 /var/www/wordpress && \
	chown -R www-data:www-data /var/www/wordpress

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/init-nginx.sh /usr/local/init-nginx.sh
RUN chmod +x /usr/local/init-nginx.sh

ENTRYPOINT ["sh", "/usr/local/init-nginx.sh"]