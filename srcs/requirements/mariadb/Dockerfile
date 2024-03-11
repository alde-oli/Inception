FROM debian:buster

RUN apt update -y && apt upgrade -y && \
	apt-get install -y mariadb-server procps

RUN mkdir -p /run/mysqld /var/lib/mysql
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init-db.sh /usr/local/init-db.sh
RUN chmod +x /usr/local/init-db.sh

ENTRYPOINT [ "sh", "/usr/local/init-db.sh" ]