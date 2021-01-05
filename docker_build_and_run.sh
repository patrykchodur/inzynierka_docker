#!/bin/bash


#IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
#xhost + $IP
#docker build -t patrykchodur:1.0 -f ./Dockerfile .
#docker run -it --rm=true -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix patrykchodur:1.0

function print_usage {
	echo "$0 build|run|kill|clean"
}

CONTAINER_NAME=gemroc:1.0

if [ $# -ne 1 ]; then
	print_usage
	exit 1
fi

if [ "$1" = "build" ]; then
	docker build \
		--build-arg USERNAME=gemroc \
		--build-arg PASSWORD=gemroc1 \
		--build-arg WIRESHARK_VERSION=3.4.2 \
		-t "$CONTAINER_NAME" \
		-f ./Dockerfile \
		.
	exit $?
fi

if [ "$1" = "run" ]; then
	docker run -d -p 22:22 "$CONTAINER_NAME"
	exit $?
fi

if [ "$1" = "kill" ]; then
	docker kill $(docker ps -a | grep "$CONTAINER_NAME" | grep -v Exited | awk '{print $1}')
	exit $?
fi

if [ "$1" = clean ]; then
	docker rm $(docker ps -a | grep "$CONTAINER_NAME" | awk '{print $1}')
	docker rmi $(docker image ls -a | grep "$CONTAINER_NAME" | awk '{print $1}')
	exit 0
fi

echo "Error: unknown parameter"
print_usage
exit 1


