NAME = inception
DOCKER_COMPOSE = srcs/docker-compose.yml
VOLUME_WORDPRESS = /home/alde-oli/data/wordpress
VOLUME_MARIADB = /home/alde-oli/data/mariadb
ENV_PATH = /home/alde-oli/Desktop/env_file

all : prepare down build run-daemon

run:
	docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} up

run-daemon:
	docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} up -d

down:
	docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} down

stop:
	docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} stop

prepare:
	if [ ! -d srcs/.env ]; then \
		cp ${ENV_PATH} srcs/.env; \
	fi
	if [ ! -d ${VOLUME_WORDPRESS} ]; then \
		mkdir -p ${VOLUME_WORDPRESS}; \
	fi
	if [ ! -d ${VOLUME_MARIADB} ]; then \
		mkdir -p ${VOLUME_MARIADB}; \
	fi

build:
	docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} build

clean: down
	docker system prune -a

fclean: down
	docker system prune -a --volumes
	docker volume rm $(docker volume ls -q)
	rm -rf /home/alde-oli/data/*

re: fclean all

delete-volumes :
	docker system prune -a --volumes
	docker volume rm $$(docker volume ls -q)
	rm -rf /home/alde-oli/data/*

status :

	@docker-compose -f ${DOCKER_COMPOSE} -p ${NAME} ps
	@echo ""
	@docker images
	@echo ""
	@docker container ls -a
	@echo ""
	@docker volume ls
	@echo ""
	@docker network ls
	@echo ""


.PHONY: all clean fclean re status stop run run-daemon down build prepare delete-volumes