#!/bin/bash

mkdir -p $HOME/alphaz-user-docker/workspace $HOME/alphaz-user-docker/git

docker run -ti --rm \
           -v $HOME/alphaz-user-docker/workspace:/home/developer/eclipse-workspace \
           -v $HOME/alphaz-user-docker/git:/home/developer/git \
           --name alphaz-user \
           alphaz-user-image-gitlab:latest
