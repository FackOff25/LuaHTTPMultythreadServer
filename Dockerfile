FROM ubuntu:20.04

COPY . /server/

WORKDIR /server/

RUN apt-get -y update

RUN apt install lua5.3 -y

EXPOSE 80

RUN chmod +x ./main.lua

CMD lua ./main.lua
