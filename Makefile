
all : up

up :
	mkdir -p data/wp
	mkdir data/mariadb
	sudo chown -R $(whoami):$(whoami) ./data/mariadb
	sudo chmod -R 755 data/mariadb
	sudo chown -R www-data:www-data ./data/wp
	sudo chmod -R 755 ./data/wp
	# sudo chmod +x srcs/requirements/wordpress/tools/script.sh
	rm -f ./data/mariadb/aria_log_control

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
	./reset.sh	sudo nano /etc/hosts

fclean : clean
	yes | docker system prune -a -f
	yes | docker image prune -a -f
	yes | docker container prune -f
	yes | docker builder prune -a -f
	yes | docker network prune -f
	yes | docker volume prune -f

re : clean all

fre : fclean all 