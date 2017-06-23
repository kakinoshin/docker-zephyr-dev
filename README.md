# docker-zephyr-dev

## What's this

Development environment for Zephyr on STM32 which is running on Docker container.
About Zephyr, please refer https://www.zephyrproject.org/

## Basic information

This environment is based on Ubuntu 16.04 LTS and using SDK 0.9.1

## How to use this

To build container

```
$ ./build.sh
```

To build Zephr and your software (example for ST Nucleo L432KC)

```
$ ./run.sh
container$ cd src/
container$ source zephyr-env.sh
container$ cd samples/hello_world/
container$ make BOARD=nucleo_l432kc
```

To flash image to the board

```
container$ sudo /bin/bash
container# cd /opt/zephyr/openocd-stm32
container# source setlocal.sh
container# stm32_flsh l4 /opt/zephyr/src/samples/hello_world/outdir/nucleo_l432kc/zephyr.bin
```
