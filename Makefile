
all : up

up :
	@if [ ! -e "~/data" ]; then \
		sudo mkdir ~/data; \
	fi
	@if [ ! -e "~/data/wordpress" ]; then \
		sudo mkdir ~/data/wordpress; \
	fi
	@if [ ! -e "~/data/mariadb" ]; then \
		sudo mkdir ~/data/mariadb; \
	fi
	@docker compose -f ./srcs/docker-compose.yml up 

down :
	@docker compose -f ./srcs/docker-compose.yml down -v

stop :
	@docker compose -f ./srcs/docker-compose.yml stop

start :
	@docker compose -f ./srcs/docker-compose.yml start

status :
	@docker ps


clean: down

fclean : clean
	yes | docker system prune -a -f
	yes | docker image prune -a -f
	yes | docker container prune -f
	yes | docker builder prune -a -f
	yes | docker network prune -f
	yes | docker volume prune -f

re : clean all

fre : fclean all 