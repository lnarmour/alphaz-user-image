#!/bin/bash

# if MacOX
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}');
x11="$HOME/.Xauthority:/home/developer/.Xauthority";

# else
#ip=$DISPLAY;
#x11="/tmp/.X11-unix:/tmp/.X11-unix";

docker run -ti --rm \
           -e DISPLAY=$ip:0 \
           -v "$x11" \
           -v /var/alphaz/workspace:/home/developer/eclipse-workspace \
           -v /var/alphaz/git:/home/developer/git \
           --name alphaz \
           narmour/alphaz-user-image:latest
