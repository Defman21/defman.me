FROM ubuntu:16.04

RUN apt-get update --fix-missing

RUN echo "# NGINX latest" >> /etc/apt/sources.list
RUN echo "deb http://nginx.org/packages/ubuntu/ xenial nginx" >> /etc/apt/sources.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ xenial nginx" >> /etc/apt/sources.list

ADD nginx_signing.key /
RUN apt-key add /nginx_signing.key
RUN apt-get update --fix-missing
RUN apt-get -y build-dep nginx
RUN apt-key update

RUN mkdir /tmp/nginx
WORKDIR "/tmp/nginx"
RUN apt-get source nginx
WORKDIR "nginx-1.10.1"
RUN ./configure --prefix=/usr
RUN dpkg-buildpackage -b
WORKDIR "../"
RUN dpkg -i nginx_1.10.1-1~xenial_amd64.deb
RUN rm -rf /tmp/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
