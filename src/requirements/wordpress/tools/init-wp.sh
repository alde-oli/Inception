#!/bin/bash

# Vérification et création du répertoire WordPress si nécessaire
if [ ! -d "/home/alde-oli/data/wordpress" ]; then
    echo "Création du répertoire /home/alde-oli/data/wordpress"
    mkdir -p /home/alde-oli/data/wordpress
fi

sleep 30

echo "Vérification de la disponibilité de MariaDB..."
while ! mysqladmin ping -h"${DB_HOST}" --silent; do
    echo "En attente de MariaDB..."
    sleep 5
done

echo "MariaDB est disponible. Poursuite du script..."

# Création du fichier de configuration wp-config.php
echo "Création du fichier wp-config.php avec les configurations nécessaires"
cat <<EOF > /var/www/wordpress/wp-config.php
<?php
define( 'DB_NAME', '${SQL_DATABASE}' );
define( 'DB_USER', '${SQL_USER}' );
define( 'DB_PASSWORD', '${SQL_PASSWORD}' );
define( 'DB_HOST', '${DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
// Clés uniques d'authentification et salage
$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
\$table_prefix  = 'wp_';
define( 'WP_DEBUG', false );
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
EOF

echo "Contenu de wp-config.php après configuration :"
cat /var/www/wordpress/wp-config.php

# Vérification de l'installation de WordPress
if ! wp core is-installed --path="/var/www/wordpress" --allow-root; then
    echo "Installation de WordPress"
    wp core install --allow-root \
        --url="${WP_URL}" \
        --title="Inception c'est trop cool" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="/var/www/wordpress"
else
    echo "WordPress est déjà installé."
fi

# Vérification et ajout de l'utilisateur WordPress si nécessaire
if ! wp user get "${WP_USER}" --field=login --path="/var/www/wordpress" --allow-root > /dev/null 2>&1; then
    echo "Ajout de l'utilisateur WordPress"
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role="author" --user_pass="${WP_USER_PASSWORD}" --path="/var/www/wordpress" --allow-root
else
    echo "L'utilisateur '${WP_USER}' existe déjà."
fi

# Démarrage de PHP-FPM
exec php-fpm7.3 -F
