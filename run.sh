#!/bin/bash

# if MacOX
if [[ "$(uname)" == "Darwin" ]]; then
	ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}');
	x11="$HOME/.Xauthority:/home/developer/.Xauthority";
fi;

# if Linux
if [[ "$(uname)" == "Linux" ]]; then
	ip=$DISPLAY;
	x11="/tmp/.X11-unix:/tmp/.X11-unix";
fi;

if [[ -z "$ip" && -z "$x11" ]]; then
	echo "Error: could not detect that this is running on MacOS or Linux";
	exit;
fi;

docker run -ti --rm \
           -e DISPLAY=$ip:0 \
           -v "$x11" \
           -v /var/alphaz/workspace:/home/developer/eclipse-workspace \
           -v /var/alphaz/git:/home/developer/git \
           --name alphaz \
           narmour/alphaz-user-image:latest
