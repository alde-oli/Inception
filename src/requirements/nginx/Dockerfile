FROM debian:buster

# Mise à jour des paquets et installation de NGINX, Vim, Curl, et OpenSSL
RUN apt update && apt upgrade -y && \
    apt install nginx vim curl openssl -y && \
    mkdir -p /etc/nginx/ssl /var/www/html /var/run/nginx && \
    chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=alde-oli.42.fr/UID=alde-oli"

# Copie du fichier de configuration NGINX personnalisé
COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]
