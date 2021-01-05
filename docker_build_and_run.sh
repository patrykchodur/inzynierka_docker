#!/bin/bash


IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
docker build -t patrykchodur:1.0 -f ./Dockerfile .
docker run -it --rm=true -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix patrykchodur:1.0
