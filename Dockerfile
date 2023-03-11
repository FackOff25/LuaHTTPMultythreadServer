FROM ubuntu:20.04

COPY . /server/

WORKDIR /server/

RUN apt-get -y update && apt-get install -y tzdata
RUN ln -snf /usr/share/zoneinfo/Russia/Moscow /etc/localtime && echo Russia/Moscow > /etc/timezone

RUN apt-get install lua5.3 -y
RUN apt-get install luarocks -y

RUN ls

RUN lua main.lua

EXPOSE 80
