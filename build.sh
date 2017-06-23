#!/bin/sh

if [ $1 -e "init" ]; then
  NO_CACHE="--no-cache"
else
  NO_CACHE=
fi

docker build ${NO_CACHE} --force-rm -t zephyr/sdk0.9.1 .
