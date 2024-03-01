#!/bin/bash

service mysql start

# Configuration initiale de MariaDB
mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Maintient le conteneur en cours d'exécution
tail -f /dev/null
