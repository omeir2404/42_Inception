docker rm $(docker ps -aq)
docker rmi $(docker images -aq)
docker volume rm $(docker volume ls -q)
sudo rm -rf data
sudo rm -f /var/lib/mysql/aria_log_control
