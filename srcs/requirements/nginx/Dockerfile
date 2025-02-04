FROM debian:bullseye


RUN apt -y update && apt install -y nginx && apt install openssl -y



COPY ./tools/emprestado.conf /etc/nginx/sites-available/

COPY ./tools/script.sh /


CMD [ "/script.sh" ]

#-------------------------
#     FROM debian:bullseye

# RUN apt-get update -y && apt-get upgrade -y && apt install -y nginx openssl

# RUN mkdir -p /etc/nginx/ssl && mkdir -p /var/run/nginx && \
# 	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out /etc/nginx/ssl/ssl.crt \
# 	-keyout /etc/nginx/ssl/ssl.key -subj "/C=PT/ST=Lisbon/L=Lisbon/ON=42Lisboa/CN=oharoon/"

# COPY ./tools/conf /etc/nginx/conf.d/nginx.conf

# CMD [ "nginx", "-g", "daemon off;" ]