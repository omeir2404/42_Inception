FROM debian:oldstable

RUN apt-get -y update && apt-get upgrade -y && apt install -y nginx openssl

RUN  mkdir -p /etc/nginx/ssl && mkdir -p /var/run/nginx 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out /etc/nginx/ssl/nginx-selfsigned.crt \
-keyout /etc/nginx/ssl/nginx-selfsigned.key -subj "/C=PT/ST=Lisbon/L=Lisbon/ON=42Lisboa/CN=oharoon/"


COPY /emprestado.conf /etc/nginx/conf.d/nginx.conf
# COPY /conf /etc/nginx/sites-available/

# COPY /script.sh /

# CMD [ "/script.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]

#-------------------------
#     FROM debian:bullseye

# RUN apt-get update -y && apt-get upgrade -y && apt install -y nginx openssl

# RUN mkdir -p /etc/nginx/ssl && mkdir -p /var/run/nginx && \
# 	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out /etc/nginx/ssl/ssl.crt \
# 	-keyout /etc/nginx/ssl/ssl.key -subj "/C=PT/ST=Lisbon/L=Lisbon/ON=42Lisboa/CN=oharoon/"

# COPY /conf /etc/nginx/conf.d/nginx.conf

# CMD [ "nginx", "-g", "daemon off;" ]