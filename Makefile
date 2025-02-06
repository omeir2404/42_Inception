
all : up

up :
	@if [ ! -e "~/inception/data" ]; then \
		sudo mkdir ~/inception/data; \
	fi
	@if [ ! -e "~/inception/data/wordpress" ]; then \
		sudo mkdir ~/inception/data/wordpress; \
	fi
	@if [ ! -e "~/inception/data/mariadb" ]; then \
		sudo mkdir ~/inception/data/mariadb; \
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
	docker rm $(docker ps -aq)
	docker rmi $(docker images -aq)
	docker volume rm $(docker volume ls -q)
	sudo rm -rf data

fclean : clean
	yes | docker system prune -a -f
	yes | docker image prune -a -f
	yes | docker container prune -f
	yes | docker builder prune -a -f
	yes | docker network prune -f
	yes | docker volume prune -f

re : clean all

fre : fclean all 