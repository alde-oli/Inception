<!-- YoRHa archive -->
```
▸ YoRHa // ARCHIVE — INCEPTION
```

A small WordPress hosting stack in Docker Compose: NGINX (TLS only), PHP-FPM and MariaDB. Each service runs from its own image, built from `debian:buster`.

![Docker Compose](https://img.shields.io/badge/Docker-Compose-4e4b42?style=flat-square) ![TLS](https://img.shields.io/badge/TLS-1.2%20%7C%201.3-dad4bb?style=flat-square)

| UNIT DATA | |
|---|---|
| Type | 42 Lausanne common-core project · solo |
| Stack | Docker · Docker Compose · NGINX · PHP-FPM 7.3 · WordPress (WP-CLI) · MariaDB · Debian Buster |
| Status | ■ COMPLETE |

## ▸ Overview
The goal is to build a small production-like infrastructure without pulling ready-made service images. Each container has a hand-written Dockerfile and an entrypoint script. NGINX is the only public entry point, on port 443. It passes PHP requests over FastCGI to the WordPress container, which talks to MariaDB on a private bridge network. The database and site files are kept in named volumes bind-mounted on the host.

## ▸ Features
- **nginx**: listens on `443` only, allows TLSv1.2/1.3 with a self-signed certificate generated when the image is built, and forwards `*.php` to `wordpress:9000`
- **wordpress**: `php-fpm7.3` pool on port 9000. On first start it waits for MariaDB, then uses WP-CLI to download WordPress, write `wp-config.php` and create an admin and an `author` user.
- **mariadb**: an init script creates the database and user from environment variables, then runs `mysqld` in the foreground
- **Persistence**: the `mariadb_v` and `wordpress_v` volumes are bind-mounted to `/home/alde-oli/data/{mariadb,wordpress}`
- **Networking**: all containers are on a dedicated `inception` bridge network, and only 443 is published
- **Restart policies**: `unless-stopped` for the database, `on-failure` for the others

## ▸ Usage
Requires `docker` and the standalone `docker-compose` binary. The Makefile copies an env file into `srcs/.env`. It defines these variables:

`DOMAIN_NAME` · `MARIADB_ROOT_PASSWORD` · `MARIADB_DB_NAME` · `MARIADB_USER` · `MARIADB_PASS` · `WP_HOST` · `WP_TITLE` · `WP_ADMIN_USER` · `WP_ADMIN_PASSWORD` · `WP_ADMIN_EMAIL` · `WP_USER` · `WP_USER_EMAIL` · `WP_USER_PASS`

```bash
make ENV_PATH=/path/to/env_file   # prepare dirs + .env, build, start detached
make status                       # containers, images, volumes, networks
make stop | make down             # stop / remove containers
make run                          # start in the foreground (logs attached)
```
Then open `https://<DOMAIN_NAME>` and accept the self-signed certificate.

> `make clean` / `make fclean` run `docker system prune -a`, which removes **all** unused images on the host, not just this project's. `fclean` also deletes the data directories.

## ▸ Structure
```
Makefile
srcs/docker-compose.yml
srcs/requirements/
├── nginx/       Dockerfile · conf/nginx.conf · tools/init-nginx.sh
├── wordpress/   Dockerfile · conf/www.conf   · tools/init-wp.sh
└── mariadb/     Dockerfile · conf/50-server.cnf · tools/init-db.sh
```

## ▸ Notes
- The host paths (`/home/alde-oli/data`, default `ENV_PATH`) are hard-coded for the 42 evaluation VM. Edit the `Makefile` and `docker-compose.yml` before running it anywhere else.
- `debian:buster` / PHP 7.3 were the versions the project required at the time and are now end-of-life.

---
<sub>▸ Archived by UNIT ALDE-OLI · [profile](https://github.com/alde-oli)</sub>
