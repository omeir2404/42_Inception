FROM debian:bullseye


RUN apt -y update && apt install -y nginx && apt install openssl -y

RUN mkdir -p /etc/ssl/certs && mkdir -p /var/run/nginx && \
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=PT/L=LISBON/O=42/OU=42/CN=oharoon.42.fr"

COPY ./tools/conf /etc/nginx/conf.d/conf


CMD [ "nginx", "-g", "daemon off;" ]