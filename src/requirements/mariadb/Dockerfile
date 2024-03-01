FROM debian:buster

# Mise à jour des paquets et installation de MariaDB
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install mariadb-server -y

# Copie du fichier de configuration MariaDB personnalisé
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copie du script d'initialisation
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

CMD ["init-db.sh"]
