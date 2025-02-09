#!/bin/bash

# Remove all containers if any exist
if [ "$(docker ps -aq)" ]; then
    docker rm $(docker ps -aq)
fi

# Remove all images if any exist
if [ "$(docker images -aq)" ]; then
    docker rmi $(docker images -aq)
fi

# Remove all volumes if any exist
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q)
fi

# Remove data directory
sudo rm -rf data
# sudo rm -f /var/lib/mysql/aria_log_control
# sudo rm -f ./srcs/requirements/wordpress/conf/www.conf#!/bin/bash