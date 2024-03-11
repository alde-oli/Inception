NAME = inception
PATH_DOCKER_COMPOSE = srcs/docker-compose.yml
PATH_V_WORDPRESS = /home/alde-oli/data/wordpress
PATH_V_MARIADB = /home/alde-oli/data/mariadb
PATH_TO_ENV_FILE = /home/alde-oli/Desktop/env_file
RESET_COLOR = \033[0m

all : prepare down build run

run:
	docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} up

run-daemon:
	docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} up -d

down:
	docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} down

stop:
	docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} stop

prepare:
	if [ ! -d srcs/.env ]; then \
		cp ${PATH_TO_ENV_FILE} srcs/.env; \
	fi
	if [ ! -d ${PATH_V_WORDPRESS} ]; then \
		mkdir -p ${PATH_V_WORDPRESS}; \
	fi
	if [ ! -d ${PATH_V_MARIADB} ]; then \
		mkdir -p ${PATH_V_MARIADB}; \
	fi

build:
	docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} build

clean: down
	docker system prune -a

fclean: down
	docker system prune -a --volumes
	docker volume rm $(docker volume ls -q) | true
	rm -rf /home/alde-oli/data/*

re: fclean all

delete-volumes :
	docker system prune -a --volumes
	docker volume rm $$(docker volume ls -q)

status :

	@docker-compose -f ${PATH_DOCKER_COMPOSE} -p ${NAME} ps
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