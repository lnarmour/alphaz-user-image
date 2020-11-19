#!/bin/bash

P=2151

mkdir -p $HOME/alphaz-user-${P}-docker/workspace $HOME/alphaz-user-${P}-docker/git

NAME="alphaz-user-$P"
if [[ -n "$(docker ps -qf name=$NAME)" ]]; then
  docker stop $NAME
fi
if [[ -n "$(docker ps -a -qf name=$NAME)" ]]; then
  docker rm $NAME
fi

docker run --name $NAME \
  --rm \
  -d \
  -p ${P}:22 \
  -v /root/.ssh/:/root/.ssh/ \
  -v $HOME/alphaz-user-${P}-docker/workspace:/root/eclipse-workspace \
  -v $HOME/alphaz-user-${P}-docker/git:/root/git \
  narmour/alphaz-user-image:latest
