



all : up

up :
	mkdir -p data/wp
	mkdir data/mariadb
	sudo chown -R $(whoami):$(whoami) ~/inception/data/mariadb
	sudo chmod -R 755 ~/inception/data/mariadb
	rm -f ~/inception/data/mariadb/aria_log_control

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
	./reset.sh