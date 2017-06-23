#!/bin/sh

HOST_WORK=/home/user/zephyr
CON_WORK=/opt/zephyr/src
PROXY=
USERNAME=zephyr
CONTAINER=zephyr_work
IMAGE=zephyr/sdk0.9.1
DEVICE="-v /dev/bus/usb:/dev/bus/usb"

docker run --rm --privileged \
	${DEVICE} \
	--name ${CONTAINER} \
	-u ${USERNAME} \
	--volume-driver=local -v=${HOST_WORK}:${CON_WORK} \
	-it \
	${IMAGE} /bin/bash
