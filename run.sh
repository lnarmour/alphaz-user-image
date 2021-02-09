#!/bin/bash

# if MacOX
if [[ "$(uname)" == "Darwin" ]]; then
	x11="$HOME/.Xauthority:/home/developer/.Xauthority";
fi;

# if Linux
if [[ "$(uname)" == "Linux" ]]; then
	x11="/tmp/.X11-unix:/tmp/.X11-unix";
fi;

if [[ -z "$x11" ]]; then
	echo "Error: could not detect that this is running on MacOS or Linux";
	exit;
fi;

mkdir -p $HOME/alphaz-user-docker/workspace $HOME/alphaz-user-docker/git
xhost + 127.0.0.1;
docker run -ti --rm \
           -e DISPLAY=host.docker.internal:0 \
           -v "$x11" \
           -v $HOME/alphaz-user-docker/workspace:/root/eclipse-workspace \
           -v $HOME/alphaz-user-docker/git:/root/git \
           --name alphaz-user \
           narmour/alphaz-user-image:latest
