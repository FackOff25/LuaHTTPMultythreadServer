FROM ubuntu:20.04

COPY . /server/

WORKDIR /server/

RUN apt-get -y update && apt-get install -y tzdata
RUN ln -snf /usr/share/zoneinfo/Russia/Moscow /etc/localtime && echo Russia/Moscow > /etc/timezone

RUN apt install liblua5.3-dev -y
RUN apt-get install luarocks -y
RUN luarocks install effil

RUN lua main.lua

EXPOSE 80
