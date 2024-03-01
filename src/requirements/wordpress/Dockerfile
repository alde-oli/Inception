FROM debian:buster

# Mise à jour et installation des dépendances nécessaires
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget curl php7.3 php7.3-fpm php7.3-mysql mariadb-client && \
    wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
    cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress && \
    chmod -R 755 /var/www/wordpress

# Configuration de PHP-FPM pour écouter sur le port 9000
RUN echo "clear_env = no" >> /etc/php/7.3/fpm/pool.d/www.conf && \
    echo "listen = 9000" >> /etc/php/7.3/fpm/pool.d/www.conf && \
    mkdir -p /run/php

# Installation de WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copie du script d'initialisation
COPY tools/init-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["/usr/local/bin/init-wp.sh"]
