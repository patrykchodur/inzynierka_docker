#!/bin/bash


#IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
#xhost + $IP
#docker build -t patrykchodur:1.0 -f ./Dockerfile .
#docker run -it --rm=true -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix patrykchodur:1.0


# new with ssh server
docker build \
	--build-arg USERNAME=gemroc \
	--build-arg PASSWORD=gemroc1 \
	--build-arg WIRESHARK_VERSION=3.4.2 \
	-t gemroc:1.0 \
	-f ./Dockerfile \
	.

build_status=$?

if [ $build_status -ne 0 ]; then
	echo "Error: build failed"
	exit 1
else
	echo "Docker built successfully"
	docker run -d -p 22:22 gemroc:1.0
	exit $?
fi
