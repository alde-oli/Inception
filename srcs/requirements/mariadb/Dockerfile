FROM debian:buster

RUN apt update -y && apt upgrade -y && \
	apt-get install -y mariadb-server procps

RUN mkdir -p /run/mysqld /var/lib/mysql
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/start_mdb.sh /usr/local/start_mdb.sh
RUN chmod +x /usr/local/start_mdb.sh

ENTRYPOINT [ "sh", "/usr/local/start_mdb.sh" ]